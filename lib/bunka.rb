require 'peach'

require 'bunka/chef'
require 'bunka/helpers'
require 'bunka/printers'
require 'bunka/bunka'
require 'bunka/ssh'

class Bunka
  class << self
    def test query, command, timeout_interval, verbose_success, invert
      @query = query
      @command = command
      @timeout_interval = timeout_interval
      @verbose_success = verbose_success
      @invert = invert

      knife_search(@query).peach(5) do |fqdn|
        execute_query fqdn
      end

      print_summary
    end
  end
end
