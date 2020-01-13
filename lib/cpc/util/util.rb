module Cpc
  module Util
    def split_join(str, split_str, delimiter_str)
      sans_split_str = str.split.join(delimiter_str)
      with_split_str = str.split(split_str).join(delimiter_str)
      split_str.nil? ? sans_split_str : with_split_str
    end
  end
end
