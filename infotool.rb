# Abstraction of encapsulation of tool used to extract file metadata
# information.

class InfoTool
  def initialize
    raise NotImplementedError.new, 'Attempted instantiation of abstract class'
  end

  # Metadata information for the specified file
  def info_for(file)
    stream = IO.popen(extraction_command(file))
    stream.read
  end
end
