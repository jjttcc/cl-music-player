# Abstraction of encapsulation of tool used to extract file metadata
# information.

require 'ruby_contracts'

class InfoTool
  include Contracts::DSL

  def initialize
    raise NotImplementedError.new, 'Attempted instantiation of abstract class'
  end

  # Metadata information for the specified file
  pre "path-not-empty" do |fpth| fpth != nil && ! fpth.empty? end
  def info_for(filepath)
    stream = IO.popen(extraction_command(filepath))
    stream.read
  end
end
