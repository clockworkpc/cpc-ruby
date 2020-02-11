require 'active_support/core_ext/hash'
require 'bundler/setup'
require 'clipboard'
require 'cpc'
require 'csv'
require 'dotenv'
require 'docker'
require 'fileutils'
require 'pry'
require 'time'

require 'cpc/codewars/codewars'
require 'cpc/codewars/drying_potatoes'
require 'cpc/codewars/five_number_summary'
require 'cpc/codewars/minecraft_furnace_fuel'
require 'cpc/codewars/order'

require 'cpc/toolkit/har_harvester'
require 'cpc/toolkit/isbn_fetcher'

require 'cpc/api/bitly'
require 'cpc/api/google_sheets'
require 'cpc/api/httpbin'
require 'cpc/api/http_cat'
require 'cpc/api/json_placeholder'
require 'cpc/api/my_restful_api'

require 'cpc/util/api_util'
require 'cpc/util/case_util'
require 'cpc/util/collection_util'
require 'cpc/util/file_parse_util'
require 'cpc/util/generate_data_util'
require 'cpc/util/google_util'
require 'cpc/util/maths_util'
require 'cpc/util/pleasing_print_util'
require 'cpc/util/string_util'
require 'cpc/util/time_stamp_util'
require 'cpc/util/util'

require 'cpc/pact/animal_service_client'
require 'cpc/pact/animal_service/alligator'

require 'cpc/study/my_blocks'

def hello_spec_helper
  puts Rainbow("Hello, Spec Helper!").green
end

def process_running_on_port?(port_int)
  lsof_cmd = `lsof -t -i:#{port_int}`
  lsof_cmd.match?(/\d+/)
end

def npm_package_installed?(package_str)
  puts Rainbow("Checking whether #{package_str} is installed").yellow
  npm_cmd = `npm list -g | grep "#{package_str}"`
  npm_cmd.match?(/#{package_str}@\d+\.\d+\.\d+/)
end

RSpec.configure do |config|
  # Require all files in lib folder

 # Make sensitive variables from Dotenv available
  Dotenv.load

  # Make sensitive variables from Figaro available
  # Figaro.application = Figaro::Application.new(environment: "development", path: "config/application.yml")
  # Figaro.load

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
