Given("HTML reports with CSS are generated in {string}") do |string|
  @source_folder_str = string
  @path_ary = Dir["#{@reports_folder}/**/*.html"] + Dir["#{@reports_folder}/**/*.css"]
end

Given("the target folder is {string}") do |string|
  @target_folder_str = string
end

Given("the temp folder is {string}") do |string|
  @temp_folder_str = string
end

When("the files in the temp folder are recursively deleted") do
  FileUtils.rm_rf(Dir.glob("#{@temp_folder_str}/*"))
end

When("a datestamp has been generated") do
  @file_timestamp_str = Cpc::Util::TimeStampUtil.now_jekyll
end

When("the report files are recursively copied from source to temp") do
  puts "Copying from #{@source_folder_str} to #{@temp_folder_str}"
  FileUtils.cp_r(@source_folder_str, @temp_folder_str, verbose: true)
  @temp_html_files_ary = Dir["#{@temp_folder_str}/**/*.html"]
  @temp_css_files_ary = Dir["#{@temp_folder_str}/**/*.css"]
end

When("the {string} basenames are prepended with a datestamp") do |string|
  case string
  when 'html'
    files_ary = @temp_html_files_ary
  when 'css'
    files_ary = @temp_css_files_ary
  end

  files_ary.each do |f|
    dirname_str = File.dirname(f)
    basename_str = File.basename(f)
    stamped_basename_str = [@file_timestamp_str, basename_str].join
    stamped_path_str = [dirname_str, stamped_basename_str].join('/')
    File.rename(f, stamped_path_str)
  end
end

When("all files not prepended with a datestamp are deleted from the temp folder") do
  temp_files_ary = Dir["#{@temp_folder_str}/**/*.*"]
  temp_files_included_ary = Dir["#{@temp_folder_str}/**/*.html"] + Dir["#{@temp_folder_str}/**/*.css"]
  temp_files_excluded_ary = temp_files_ary - temp_files_included_ary

  temp_files_excluded_ary.each do |f|
    abs_path = File.expand_path(f)
    File.delete(abs_path)
  end

  temp_files_ary = Dir["#{@temp_folder_str}/**/*.*"]
  temp_files_included_ary = Dir["#{@temp_folder_str}/**/*.html"] + Dir["#{@temp_folder_str}/**/*.css"]
  deleted_temp_files_excluded_ary = temp_files_ary - temp_files_included_ary
  puts "original number: #{temp_files_excluded_ary.count}"
  expect(deleted_temp_files_excluded_ary.count).to eq(0)
end

When("all the empty folders are deleted from the temp folder") do
  running = true
  while running
    folder_ary = Dir["#{@temp_folder_str}/**/*"].select { |d| File.directory?(d) }
    empty_folder_ary = folder_ary.select { |d| (Dir.entries(d) - %w[ . ..]).empty?}
    running = false if empty_folder_ary.count == 0
    empty_folder_ary.each do |d|
      puts d
      Dir.rmdir(d)
    end
  end

  folder_ary = Dir["#{@temp_folder_str}/**/*"].select { |d| File.directory?(d) }
  empty_folder_ary = folder_ary.select { |d| (Dir.entries(d) - %w[ . ..]).empty?}
  expect(empty_folder_ary.count).to eq(0)
end

Then("the datestamped HTML and CSS files should be recursively copied from temp to target") do
  puts "Copying from #{@temp_folder_str} to #{@target_folder_str}"
  FileUtils.cp_r(@temp_folder_str, @target_folder_str, verbose: true)

  temp_files_ary = Dir["#{@temp_folder_str}/**/*.*"].map {|f| File.basename(f)}
  target_files_ary = Dir["#{@target_folder_str}/**/*.*"].map {|f| File.basename(f)}

  expect(temp_files_ary).to eq(target_files_ary)
end
