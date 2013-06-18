# encoding: utf-8
# InfoTool implemented using the exiftool program

require_relative './infotool'

class ExifInfoTool < InfoTool
  def initialize
  end

    def extraction_command(filepath)
      if filepath.include?("'")
        "exiftool \"#{filepath}\""
      else
        "exiftool '#{filepath}'"
      end
    end
end
