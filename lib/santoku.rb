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

      ridley.search(:node, @query).peach(5) do |node|
        execute_query node
      end

      print_summary
    end
  end
end
