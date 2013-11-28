require 'bunka/printers'

class Bunka
  class << self
    def failed(reason)
      failed_output_stream.push reason
      print_fail
    end

    def succeeded(reason)
      success_output_stream.push reason
      print_success
    end

    def timed_out(reason)
      timeout_output_stream.push reason
      print_timeout
    end

    def timeout_output_stream
      @timeout_output_stream ||= Array.new
    end

    def failed_output_stream
      @failed_output_stream ||= Array.new
    end

    def success_output_stream
      @success_output_stream ||= Array.new
    end

    def verbose_success?
      @verbose_success
    end

    def invert?
      @invert
    end
  end
end
