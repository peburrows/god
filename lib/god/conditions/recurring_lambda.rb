module God
  module Conditions
    
    # a lambda condition that may be met x out of y times
    class RecurringLambda < PollCondition
      attr_accessor :times, :lambda
      
      def initialize
        super
        self.times = [1, 1]
      end
      
      def prepare
        if self.times.kind_of?(Integer)
          self.times = [self.times, self.times]
        end
        
        @timeline = Timeline.new(self.times[1])
      end
      
      def valid?
        valid = true
        valid &= complain("Attribute 'lambda' must be specified", self) if self.lambda.nil?
        valid
      end
      
      def test
        if self.lambda.call()
          @timeline.push("true*")
          history = "[" + @timeline.map {|x| "#{x}" }.join(", ") + "]"
          self.info = "lambda condition was satisfied, yo #{history}"
          if @timeline.select { |x| x == "true*" }.size >= self.times.first
            return true
          else
            return false
          end
        else
          @timeline.push("false")
          history = "[" + @timeline.map {|x| "#{x}" }.join(", ") + "]"
          self.info = "lambda condition was not satisfied, brotha #{history}"
          return false
        end
      end

    end

  end
end