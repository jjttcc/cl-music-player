require './dbfile'

class Configuration
  attr_reader :dbfile

  def initialize
    @dbfile = DBFile.new(ENV['HOME'] + '/.cache/playmusic/database')
#    @dbfile = DBFile.new('/home/jtc/.cache/playmusic/database')
  end
end
