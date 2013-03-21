class Player
  include Process

  def playfile(path)
    puts "I want to play #{path}"
    command = "echo \"ls -li '#{path}'\""
    command = "ls -li '#{path}'"
    command = "vlc '#{path}'"
    pid = fork { exec command }
    waitpid(pid)
  end

  def playfiles(list)
    command = 'vlc '
#command = 'ls -li '
    list.each do |f|
      command += "'#{f}' "
    end
    pid = fork { exec command }
    waitpid(pid)
  end
end
