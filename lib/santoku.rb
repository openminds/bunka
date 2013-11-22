require 'peach'

require 'santoku/chef'
require 'santoku/helpers'
require 'santoku/printers'
require 'santoku/santoku'
require 'santoku/ssh'

class Santoku
  class << self
    def test command, query, timeout_interval, verbose_success, invert
      @command = command
      @query = query
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
