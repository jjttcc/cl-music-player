# InfoTool implemented using the exiftool program

require_relative './infotool'

class ExifInfoTool < InfoTool
  def initialize
  end

    def extraction_command(file)
      "exiftool #{file}"
    end
end
