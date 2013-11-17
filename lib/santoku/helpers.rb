require 'ridley'
require 'net/ssh'
require 'santoku/printers'

class Santoku
  class << self
    def failed(reason)
      failed_output_stream.push reason
      print_fail
    end

    def succeeded(reason)
      success_output_stream.push reason
      print_success
    end

    def timed_out(reason)
      timeout_output_stream.push reason
      print_timeout
    end

    def timeout_output_stream
      @timeout_output_stream ||= Array.new
    end

    def failed_output_stream
      @failed_output_stream ||= Array.new
    end

    def success_output_stream
      @success_output_stream ||= Array.new
    end

    def verbose_success?
      @verbose_success
    end

    def invert?
      @invert
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

    def ridley
      @ridley ||= Ridley.new(
        server_url: knife_config.chef_server_url,
        client_name: knife_config.node_name,
        client_key: knife_config.client_key
      )
    end

    def ssh_exec!(ssh, command)
      # I am not awesome enough to have made this method myself
      # Originally submitted by 'flitzwald' over here: http://stackoverflow.com/a/3386375
      stdout_data = ""
      stderr_data = ""
      exit_code = nil

      ssh.open_channel do |channel|
        channel.exec(command) do |ch, success|
          unless success
            abort "FAILED: couldn't execute command (ssh.channel.exec)"
          end
          channel.on_data do |ch,data|
            stdout_data+=data
          end

          channel.on_extended_data do |ch,type,data|
            stderr_data+=data
          end

          channel.on_request("exit-status") do |ch,data|
            exit_code = data.read_long
          end
        end
      end
      ssh.loop
      [stdout_data, stderr_data, exit_code]
    end
  end
end
