require_relative './dbfile'

class Configuration
  attr_reader :dbfile

  def initialize(optionstate)
    @dbfile = DBFile.new(ENV['HOME'] + '/.cache/playmusic/database',
      optionstate.rebuild_db)
  end
end
