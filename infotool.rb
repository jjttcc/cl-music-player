# encoding: utf-8
# Copyright 2013  Jim Cochrane - GNU GPL, verson 2 (See the LICENSE file.)

require 'ruby_contracts'

# Abstraction of encapsulation of tool used to extract file metadata
# information.
class InfoTool
  include Contracts::DSL

  def initialize
    raise NotImplementedError.new, 'Attempted instantiation of abstract class'
  end

  # Metadata information for the specified file
  pre :path_not_empty do |fpth| fpth != nil && ! fpth.empty? end
  def info_for(filepath)
    stream = IO.popen(extraction_command(filepath))
    stream.read
  end
end
