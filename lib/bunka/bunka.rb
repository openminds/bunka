require 'net/ssh'

class Bunka
  class << self
    def nodes
      if @file
        File.readlines(@file).collect(&:strip)
      else
        knife_search(@query)
      end
    end

    def execute_query fqdn
      begin
        Timeout.timeout @timeout_interval do
          Net::SSH.start(fqdn, 'root', paranoid: false, forward_agent: true) do |ssh|
            output = ssh_exec!(ssh, @command)
            parse_output output, fqdn
          end
        end
      rescue TimeoutError, Errno::ETIMEDOUT, SocketError, Errno::EHOSTUNREACH => e
        timed_out "#{fqdn}: #{e.message}"
      rescue Exception => e
        timed_out "#{fqdn}: #{e.inspect}"
      end
    end

    def parse_output output, fqdn
      if output[2] == 0 && !invert?
        succeeded "#{fqdn}: #{output[0]}"
      elsif output[2] != 0 && invert?
        succeeded "#{fqdn} returned #{output[2]}: #{output[1]} #{output[0]}"
      else
        failed "#{fqdn} returned #{output[2]}: #{output[1]} #{output[0]}"
      end
    end
  end
end
