require 'chef/knife'

class Bunka
  class << self
    def knife_search query
      # Monkey patch Chef::Knife::UI to hide stdout
      Chef::Knife::UI.class_eval do
        def stdout
          @stdout_hack ||= ::File.new('/dev/null', 'w')
        end
      end

      Chef::Knife.run(['search', 'node', query]).map { |node| node[:fqdn] }
    end
  end
end
