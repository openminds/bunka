class Bunka
  class << self
    def ssh_exec!(ssh, command)
      # I am not awesome enough to have made this method myself
      # Originally submitted by 'flitzwald' over here: http://stackoverflow.com/a/3386375
      stdout_data = ''
      stderr_data = ''
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

          channel.on_request('exit-status') do |ch,data|
            exit_code = data.read_long
          end
        end
      end
      ssh.loop
      [stdout_data, stderr_data, exit_code]
    end
  end
end
