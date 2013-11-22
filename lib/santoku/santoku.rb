require 'net/ssh'

class Santoku
  class << self
    def execute_query chef_id
      begin
        timeout @timeout_interval do
          Net::SSH.start(chef_id, 'root', paranoid: false, forward_agent: true) do |ssh|
            output = ssh_exec!(ssh, @command)
            parse_output output, chef_id
          end
        end
      rescue TimeoutError, Errno::ETIMEDOUT, SocketError, Errno::EHOSTUNREACH => e
        timed_out "#{chef_id}: #{e.message}"
      rescue Exception => e
        timed_out "#{chef_id}: #{e.inspect}"
      end
    end

    def parse_output output, chef_id
      if output[2] == 0 && !invert?
        succeeded "#{chef_id}: #{output[0]}"
      elsif output[2] != 0 && invert?
        succeeded "#{chef_id} returned #{output[2]}: #{output[1]} #{output[0]}"
      else
        failed "#{chef_id} returned #{output[2]}: #{output[1]} #{output[0]}"
      end
    end
  end
end
