# encoding: utf-8
# Copyright 2013  Jim Cochrane - GNU GPL, verson 2 (See the LICENSE file.)

require 'ruby_contracts'
require_relative './dbfile'
require_relative './exifinfotool'

# Application configuration state/logic
class Configuration
  include Contracts::DSL
  attr_reader :db, :infotool, :optionstate

  public

  type out: DBFile
  def db
    # (lazy initialization of @db)
    @db ||= DBFile.new(File.join(ENV['HOME'], '.cache', 'playmusic',
                                 'database'), optionstate.rebuild_db)
  end

  private

  post :attrs_set do optionstate != nil end
  post :info_set_ifavail do implies(infotool_available, infotool != nil) end
  def initialize
    @optionstate = OptionState.new(self)
    if infotool_available
      @infotool = ExifInfoTool.new
    end
  end

  def infotool_available
    result = false
    etfile = 'exiftool'
    pathparts = ENV['PATH'].split(':')
    i = 0
    while result == false && i < pathparts.length
      result = File.exists?(File.join(pathparts[i], etfile))
      i += 1
    end
    result
  end
end
