module Cpc
  module Util
    module TimeStampUtil
      def hello_time_stamp
        'hello_time_stamp'
      end

      def convert_to_yyyymmdd_hhmmss(time_obj)
        date = time_obj.strftime("%Y-%m-%d")
        time = time_obj.strftime("%H-%M-%S")
        [date, time].join('_')
      end

      def convert_to_ddmmyyyy_hhmmss(time_obj)
        date = time_obj.strftime("%d-%m-%Y")
        time = time_obj.strftime("%H-%M-%S")
        [date, time].join('_')
      end

      def convert_to_strftime(time_obj, ss64 = true, timestamp = nil)
        case
        when ss64 == true && timestamp.nil?
          time_obj.strftime("%Y-%m-%d")
        when ss64 == true && timestamp == true
          convert_to_yyyymmdd_hhmmss(time_obj)
        when ss64 == false && timestamp.nil?
          time_obj.strftime("%d/%m/%Y")
        when ss64 == false && timestamp == true
          convert_to_ddmmyyyy_hhmmss(time_obj)
        end
      end

      def convert_ddmmyyyy_to_yyyymmdd(str, timestamp = nil)
        time_obj = Time.parse(str)
        convert_to_strftime(time_obj, true, nil)
      end

      def convert_yyyymmdd_to_ddmmyyyy(str, timestamp = nil)
        time_obj = Time.parse(str)
        convert_to_strftime(time_obj, false, nil)
      end

      def now_yyyymmdd
        time_obj = Time.now
        convert_to_strftime(time_obj, true, nil)
      end

      def now_yyyymmdd_hhmmss
        time_obj = Time.now
        convert_to_strftime(time_obj, true, true)
      end

      def now_ddmmyyyy
        time_obj = Time.now
        convert_to_strftime(time_obj, false, nil)
      end

      def now_ddmmyyyy_hhmmss
        time_obj = Time.now
        convert_to_strftime(time_obj, false, true)
      end

      def now_jekyll
        time_obj = Time.now
        convert_to_strftime(time_obj, true, nil) + "-"
      end
    end
  end
end
