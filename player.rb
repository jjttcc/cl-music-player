# encoding: utf-8
require 'ruby_contracts'

class Player
  include Contracts::DSL
  include Process

  pre :path_not_empty do |path| path != nil && ! path.empty? end
  def playfile(path)
    command = "vlc --no-loop --no-repeat '#{path}'"
    pid = fork { exec command }
#    waitpid(pid)
  end

  pre :list_not_empty do |list| list != nil end
  def playfiles(list)
    command = 'vlc --no-loop --no-repeat '
    list.each do |f|
      command += "\"#{f}\" "
    end
    pid = fork { exec command }
# !!!Note: Use waitpid2 to also get/check command's exit status.
#    waitpid(pid)
  end

end
