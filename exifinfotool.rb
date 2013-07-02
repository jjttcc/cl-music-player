# encoding: utf-8
# Copyright 2013  Jim Cochrane - GNU GPL, verson 2 (See the LICENSE file.)

require 'ruby_contracts'
require_relative './infotool'

# InfoTool implemented using the exiftool program
class ExifInfoTool < InfoTool
  include Contracts::DSL

  def initialize
  end

  pre :path_not_empty do |filepath| filepath != nil && ! filepath.empty? end
  def extraction_command(filepath)
    if filepath.include?("'")
      "exiftool \"#{filepath}\""
    else
      "exiftool '#{filepath}'"
    end
  end
end
