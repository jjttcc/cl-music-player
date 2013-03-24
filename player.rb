class Player
  include Process

  def playfile(path)
    command = "vlc '#{path}'"
    pid = fork { exec command }
#    waitpid(pid)
  end

  def playfiles(list)
    command = 'vlc '
    list.each do |f|
      command += "\"#{f}\" "
    end
    pid = fork { exec command }
#!!!Note: Use waitpid2 to also get/check command's exit status.
#    waitpid(pid)
  end

end
