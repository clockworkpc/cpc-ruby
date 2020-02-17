module Cpc
  module Study
    class ExecuteAround
      def with_timing
        start = Time.now
        if block_given?
          yield
          time_taken = Time.now - start
          puts "Time taken: #{time_taken}"
        end
        { start: start, time_taken: time_taken }
      end
    end
  end
end
