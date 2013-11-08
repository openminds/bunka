require 'colorize'
require 'net/ssh'
require 'peach'
require 'ridley'
require 'yaml'

class Santoku
  def self.run(command='uptime')
    output_stream = Array.new
    failed_output_stream = Array.new
    timeout_output_stream = Array.new

    ridley.node.all.peach(4) do |node|
      begin
        timeout 10 do
          Net::SSH.start(node.chef_id, 'root', paranoid: false, forward_agent: true) do |ssh|
            output = ssh_exec!(ssh, command)
            if output[2] != 0
              failed_output_stream.push "#{node.chef_id}: #{output[1]} (error #{output[2]})"
              print 'F'.red
            else
              output_stream.push output[0]
              print '.'.green
            end
          end
        end

      rescue TimeoutError
        timeout_output_stream.push "#{node.chef_id}: connection timed out"
        print '*'.yellow
      rescue SocketError
        timeout_output_stream.push "#{node.chef_id}: node does not resolve"
        print '*'.yellow
      rescue Errno::EHOSTUNREACH
        timeout_output_stream.push "#{node.chef_id}: no route to host"
        print '*'.yellow
      rescue Exception => e
        failed_output_stream.push "#{node.chef_id}: #{e.inspect}"
        print 'F'.red
      end
    end

    puts "\n---------------------------------------\n"

    timeout_output_stream.each do |output|
      puts output.yellow
    end

    failed_output_stream.each do |output|
      puts output.red
    end

    puts "\n---------------------------------------\n"

    puts "#{'Success'.green}: #{output_stream.count}"
    puts "#{'Timed out or does not resolve'.yellow}: #{timeout_output_stream.count}"
    puts "#{'Failed'.red}: #{failed_output_stream.count}"
  end

private
  def self.knife_config
    if ::File.exist?(File.expand_path("../knife.rb", __FILE__))
      Ridley::Chef::Config.from_file(File.expand_path("../knife.rb", __FILE__))
    elsif ::File.exist?("#{ENV['HOME']}/.chef/knife.rb")
      Ridley::Chef::Config.from_file("#{ENV['HOME']}/.chef/knife.rb")
    else
      raise 'Could not find knife.rb in current directory or home '
    end
  end

  def self.ridley
    @ridley ||= Ridley.new(
      server_url: knife_config.chef_server_url,
      client_name: knife_config.node_name,
      client_key: knife_config.client_key
    )
  end
end

def ssh_exec!(ssh, command)
  # I am not awesome enough to have made this method myself
  # I've just modified it a bit
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
