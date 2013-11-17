require 'peach'

require 'santoku/helpers'
require 'santoku/printers'

class Santoku
  class << self
    def test(command, query, timeout_interval, verbose_success, invert)
      @verbose_success = verbose_success
      @invert = invert

      ridley.search(:node, query).peach(5) do |node|
        begin
          timeout timeout_interval do
            Net::SSH.start(node.chef_id, 'root', paranoid: false, forward_agent: true) do |ssh|
              output = ssh_exec!(ssh, command)
              if output[2] == 0 && !invert?
                succeeded "#{node.chef_id}: #{output[0]}"
              elsif output[2] != 0 && invert?
                succeeded "#{node.chef_id} returned #{output[2]}: #{output[1]} #{output[0]}"
              else
                failed "#{node.chef_id} returned #{output[2]}: #{output[1]} #{output[0]}"
              end
            end
          end
        rescue TimeoutError
          timed_out "#{node.chef_id}: connection timed out"
        rescue Errno::ETIMEDOUT
          timed_out "#{node.chef_id}: Operation timed out - connect(2)"
        rescue SocketError
          timed_out "#{node.chef_id}: node does not resolve"
        rescue Errno::EHOSTUNREACH
          timed_out "#{node.chef_id}: no route to host"
        rescue Exception => e
          timed_out "#{node.chef_id}: #{e.inspect}"
        end
      end

      print_summary
    end
  end
end
