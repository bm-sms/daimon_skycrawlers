module DaimonSkycrawlers
  class Processor
    class Default
      def call(message)
        puts "URL: #{message[:url]}"
        puts "Body: #{message[:body].bytesize} bytes"
        puts "Headers:"
        messages[:headers].each do |key, value|
          puts "  #{key}: #{value}"
        end
      end
    end
  end
end
