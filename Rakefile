# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'nokogiri'
require 'rspec/core/rake_task'
require 'pry'
require 'cpc/util/file_parse_util'
require 'cpc/util/time_stamp_util'
require 'cpc/toolkit/blog_converter'

# task :default => :spec
namespace :test do
  desc "Execute all Specs and Cucumber Features"
  task :all_tests do
    Rake::Task['test:offline_tests'].invoke
    Rake::Task['test:online_tests'].invoke
    Rake::Task['test:online_extra_tests'].invoke
  end

  desc "Execute all Specs and Cucumber Features tagged @offline"
  task :offline_tests do
    Rake::Task['test:offline_specs'].invoke
    Rake::Task['test:offline_specs_html'].invoke
    Rake::Task["test:offline_features"].invoke
  end

  desc "Execute all Specs and Cucumber Features tagged @online"
  task :online_tests do
    Rake::Task['test:online_specs'].invoke
    Rake::Task['test:online_specs_html'].invoke
    Rake::Task["test:online_features"].invoke
  end

  desc "Execute all Specs and Cucumber Features tagged @online_extra"
  task :online_extra_tests do
    Rake::Task['test:online_extra_specs'].invoke
    Rake::Task['test:online_extra_specs_html'].invoke
    Rake::Task["test:online_extra_features"].invoke
  end

  desc "Execute all Specs tagged @offline, output to terminal"
  RSpec::Core::RakeTask.new(:offline_specs) do |t|
    t.rspec_opts = "--tag offline"
  end

  desc "Execute all Specs tagged @offline, output to HTML"
  RSpec::Core::RakeTask.new(:offline_specs_html) do |t|
    time_stamp = Cpc::Util::TimeStampUtil.now_yyyymmdd_hhmmss
    reports_dir = 'reports/offline_specs'
    basename = ['offline_specs', "#{time_stamp}.html"].join('_')
    filepath = [reports_dir, basename].join('/')
    t.rspec_opts = "--tag offline --format html > #{filepath}"
  end

  desc "Execute all Specs tagged @online, output to terminal"
  RSpec::Core::RakeTask.new(:online_specs) do |t|
    t.rspec_opts = "--tag online"
  end

  desc "Execute all Specs tagged @online, output to HTML"
  RSpec::Core::RakeTask.new(:online_specs_html) do |t|
    time_stamp = Cpc::Util::TimeStampUtil.now_yyyymmdd_hhmmss
    reports_dir = 'reports/online_specs'
    basename = ['online_specs', "#{time_stamp}.html"].join('_')
    filepath = [reports_dir, basename].join('/')
    t.rspec_opts = "--tag online --format html > #{filepath}"
  end

  desc "Execute all Specs tagged @online_extra, output to terminal"
  RSpec::Core::RakeTask.new(:online_extra_specs) do |t|
    t.rspec_opts = "--tag online_extra"
  end

  desc "Execute all Specs tagged @online_extra, output to HTML"
  RSpec::Core::RakeTask.new(:online_extra_specs_html) do |t|
    time_stamp = Cpc::Util::TimeStampUtil.now_yyyymmdd_hhmmss
    reports_dir = 'reports/online_extra_specs'
    basename = ['online_extra_specs', "#{time_stamp}.html"].join('_')
    filepath = [reports_dir, basename].join('/')
    t.rspec_opts = "--tag online_extra --format html > #{filepath}"
  end


  desc "Execute Cucumber features tagged @offline"
  task :offline_features do
    time_stamp = Cpc::Util::TimeStampUtil.now_yyyymmdd_hhmmss
    reports_dir = 'reports/offline_features'
    basename = ['offline_features', "#{time_stamp}.html"].join('_')
    filepath = [reports_dir, basename].join('/')
    sh "cucumber --tags @offline --format html --out #{filepath}"
    # sh "chromium-browser #{filepath}"
  end

  desc "Execute Cucumber features tagged @online"
  task :online_features do
    time_stamp = Cpc::Util::TimeStampUtil.now_yyyymmdd_hhmmss
    reports_dir = 'reports/online_features'
    basename = ['online_features', "#{time_stamp}.html"].join('_')
    filepath = [reports_dir, basename].join('/')
    sh "cucumber --tags @online --format html --out #{filepath}"
    # sh "chromium-browser #{filepath}"
  end

  desc "Execute Cucumber features tagged @online_extra"
  task :online_extra_features do
    time_stamp = Cpc::Util::TimeStampUtil.now_yyyymmdd_hhmmss
    reports_dir = 'reports/online_extra_features'
    basename = ['online_extra_features', "#{time_stamp}.html"].join('_')
    filepath = [reports_dir, basename].join('/')
    sh "cucumber --tags @online_extra --format html --out #{filepath}"
    # sh "chromium-browser #{filepath}"
  end
end

namespace :cpc do
  include Cpc::Util::FileParseUtil
  include Cpc::Util::TimeStampUtil
  namespace :toolkit do
    desc 'Fetch ISBNs'
    task :fetch_isbns do
      # ISBNs of books to fetch
      isbn_list_filepath = 'data/isbn_books/books_for_sale.json'
      isbn_hsh_ary = Cpc::Util::FileParseUtil.parse_json_file(isbn_list_filepath)

      # Ensure that output file is clear
      csv_filepath = 'data/isbn_books/books_details.csv'
      File.delete(csv_filepath) if File.exist?(csv_filepath)

      isbn_fetcher = Cpc::Toolkit::IsbnFetcher.new('ISBN_DB_API_KEY')
      isbn_fetcher.batch_fetch_save_to_csv(isbn_hsh_ary, csv_filepath)
    end

    desc 'Pre-publish files for Jekyll'
    task :pre_publish_files_for_jekyll do
      jekyll_path = "#{File.expand_path("~/")}/Development/company/company-test-jekyll"
      src_dir = [jekyll_path, 'src', "concordion"].join('/')
      tmp_dir = [jekyll_path, 'tmp'].join('/')
      target_dir = [jekyll_path, '_posts'].join('/')
      FileUtils.rm_rf(Dir.glob("#{tmp_dir}/*"))
      j = Cpc::Toolkit::Concordion::Concordion.new
      j.export_html_reports_to_jekyll(src_dir, tmp_dir, target_dir, Time.now)
    end

    desc 'Export blog posts'
    task :export_blog_posts do
      dir = "#{Dir.home}/Development/publish/clockworkpc.github.io/_posts"
      feed_path = "#{Dir.home}/Development/publish/clockworkpc.github.io/_archive/feed.html"
      bc = Cpc::Toolkit::BlogConverter.new(feed_path)
      xml_ary = bc.post_divs
      bc.save_posts(xml_ary, dir)
    end
  end
end
