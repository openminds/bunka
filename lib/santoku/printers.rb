require 'colorize'

class Santoku
  class << self
    def print_fail
      print 'F'.red
    end

    def print_success
      print '.'.green
    end

    def print_timeout
      print '*'.yellow
    end

    def print_timeout_stream
      timeout_output_stream.each do |output|
        puts output.yellow
      end
    end

    def print_failed_stream
      failed_output_stream.each do |output|
        puts output.red
      end
    end

    def print_success_stream
      success_output_stream.each do |output|
        puts output.green
      end
    end

    def print_summary
      print "\n"
      print_timeout_stream
      print_failed_stream
      print_success_stream if verbose_success?

      puts "\n---------------------------------------\n"

      puts "#{'Success'.green}: #{success_output_stream.count}"
      puts "#{'Timed out or does not resolve'.yellow}: #{timeout_output_stream.count}"
      puts "#{'Failed'.red}: #{failed_output_stream.count}"
      puts "#{'Total'.blue}: #{success_output_stream.count + timeout_output_stream.count + failed_output_stream.count}"
    end
  end
end
