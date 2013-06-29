# encoding: utf-8
require 'ruby_contracts'
require_relative './dbfile'
require_relative './exifinfotool'

class Configuration
  include Contracts::DSL
  attr_reader :db, :infotool, :optionstate

  post "attrs_set" do db != nil && optionstate != nil end
  post :info_set_ifavail do implies(infotool_available, infotool != nil) end
  def initialize
    @optionstate = OptionState.new(self)
    @db = DBFile.new(File.join(ENV['HOME'], '.cache', 'playmusic',
      'database'), optionstate.rebuild_db)
    if infotool_available
      @infotool = ExifInfoTool.new
    end
  end

  private

  def infotool_available
    result = false
    etfile = 'exiftool'
    pathparts = ENV['PATH'].split(':')
    i = 0
    while result == false and i < pathparts.length
      result = File.exists?(File.join(pathparts[i], etfile))
      i += 1
    end
    result
  end
end
