module Cpc
  module Util
    module GoogleUtil
      def extract_spreadsheetId(url)
        url.scan(/spreadsheets\/d\/[a-zA-z0-9]+/).first.split("/")[2]
      end
    end
  end
end
