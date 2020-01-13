require 'bundler/setup'
require 'clipboard'
require 'cpc'
require 'csv'
require 'dotenv'
require 'fileutils'
require 'pry'

require 'cpc/codewars/camel_case'
require 'cpc/codewars/drying_potatoes'
require 'cpc/codewars/five_number_summary'
require 'cpc/codewars/fixed_point_permutations'
require 'cpc/codewars/minecraft_furnace_fuel'
require 'cpc/codewars/order'

require 'cpc/toolkit/isbn_fetcher'
require 'cpc/toolkit/json_tool'

require 'cpc/util/api_util'
require 'cpc/util/case_util'
require 'cpc/util/collection_util'
require 'cpc/util/file_parse_util'
require 'cpc/util/generate_data_util'
require 'cpc/util/pleasing_print_util'
require 'cpc/util/string_util'
require 'cpc/util/time_stamp_util'

Dotenv.load

# Figaro.application = Figaro::Application.new(environment: 'development', path: File.expand_path('../config/application.yml', __FILE__))
# Figaro.load

include Cpc::Util::ApiUtil
include Cpc::Util::CaseUtil
include Cpc::Util::CollectionUtil
include Cpc::Util::FileParseUtil
include Cpc::Util::GenerateDataUtil
include Cpc::Util::PleasingPrintUtil
include Cpc::Util::StringUtil
include Cpc::Util::TimeStampUtil

include Cpc::Codewars::DryingPotatoes
include Cpc::Codewars::Order
include Cpc::Codewars::CamelCase
include Cpc::Codewars::FiveNumberSummary
include Cpc::Codewars::MinecraftFurnaceFuel
include Cpc::Codewars::FixedPointPermutations
