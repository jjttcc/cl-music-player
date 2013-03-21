# InfoTool implemented using the exiftool program

require './infotool'

class ExifInfoTool < InfoTool
  def initialize
  end

  def info_for(file)
    stream = IO.popen(command)
    @file.write(stream.read)
  end
end
