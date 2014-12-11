require 'parallel'

require 'bunka/chef'
require 'bunka/helpers'
require 'bunka/printers'
require 'bunka/bunka'
require 'bunka/ssh'

class Bunka
  class << self
    def test command, query, timeout_interval, verbose_success, invert, sequential, threads
      @command = command
      @invert = invert
      @query = query
      @sequential = sequential
      @threads = threads
      @timeout_interval = timeout_interval
      @verbose_success = verbose_success

      if sequential
        knife_search(@query).each do |fqdn|
          execute_query fqdn
        end
      else
        Parallel.map(knife_search(@query), in_threads: @threads) do |fqdn|
          execute_query fqdn
        end
      end

      print_summary
    end
  end
end
