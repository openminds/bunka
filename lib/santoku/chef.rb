require 'ridley'

class Santoku
  class << self
    def ridley
      @ridley ||= Ridley.new(
        server_url: knife_config.chef_server_url,
        client_name: knife_config.node_name,
        client_key: knife_config.client_key
      )
    end

  private
    def knife_config
      if ::File.exist?(File.expand_path("../knife.rb", __FILE__))
        Ridley::Chef::Config.from_file(File.expand_path("../knife.rb", __FILE__))
      elsif ::File.exist?("#{ENV['HOME']}/.chef/knife.rb")
        Ridley::Chef::Config.from_file("#{ENV['HOME']}/.chef/knife.rb")
      else
        raise 'Could not find knife.rb in current directory or home '
      end
    end
  end
end
