require 'parallel'

require 'bunka/chef'
require 'bunka/helpers'
require 'bunka/printers'
require 'bunka/bunka'
require 'bunka/ssh'

class Bunka
  class << self
    def test command, query, timeout_interval, verbose_success, invert
      @command = command
      @query = query
      @timeout_interval = timeout_interval
      @verbose_success = verbose_success
      @invert = invert

      Parallel.map(knife_search(@query), in_threads: 15) do |fqdn|
        execute_query fqdn
      end

      print_summary
    end
  end
end
