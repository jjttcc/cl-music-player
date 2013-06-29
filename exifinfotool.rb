# encoding: utf-8
# InfoTool implemented using the exiftool program

require 'ruby_contracts'
require_relative './infotool'

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
