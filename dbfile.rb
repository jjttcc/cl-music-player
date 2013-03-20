class DBFile
  include Process
#  include Handshake::ClassMethods
  attr_reader :file, :audio_files

  def initialize(path)
    if File.exists?(path)
      @file = File.new(path, 'r')
    else
      dirpath = File.dirname(path)
      if not File.exists?(dirpath)
        begin
          Dir.mkdir(dirpath)
        rescue SystemCallError => e
          puts "Fatal error: Failed to create database file:\n" + e.message
          exit 24
        end
      elsif not File.directory?(dirpath)
        $stderr.puts "Fatal error: #{dirpath} exists but is not a directory."
        exit 23
      end
      @file = File.new(path, 'w')
      basecommand = "locate -r '\\."
      ['wav', 'flac', 'mp3', 'ogg'].each do |extension|
        command = "#{basecommand}#{extension}$'"
puts "executing <#{command}>"
        outstream = IO.popen(command)
        puts outstream.inspect
        @file.write(outstream.read)
      end
      @file = File.new(@file.path)
    end
    raise '@file must be open' unless not @file.closed?

puts "file pos: #{@file.pos}"
    @audio_files = @file.readlines
    @audio_files_in_ascii = []
    for i in 0 .. @audio_files.length - 1 do
      @audio_files_in_ascii[i] = @audio_files[i].encode('US-ASCII',
        :undef => :replace, :invalid => :replace)
    end
dbx = @audio_files[5957]
puts dbx.encoding
dbx2 = @audio_files_in_ascii[5957]
puts dbx2.encoding
foodog = 'foo'
puts foodog.encoding
  end

  def path
    if @file
      @file.path
    else
      ''
    end
  end

  # First file path found that matches `pattern'
  def matchfor(pattern)
puts "in file database of size #{@audio_files.length}, looking for #{pattern}"
puts "first path in audio_files: " + @audio_files[0].to_s
    result = ''
#    matches = @audio_files_in_ascii.grep '/' + pattern + '/i'
matches = @audio_files_in_ascii.grep /#{pattern}/i
#matches = @audio_files_in_ascii.grep /bomb/
    if matches.length > 0
      result = matches[0]
    else
      puts "no matches found for #{pattern}"
    end
x = ['a', 'b', '77', 'foobar', 'dog'].grep /o/
puts "x: #{x}"
#y = @audio_files.grep /o/
#puts "y: #{y}"
    result
  end

  # All file paths found that match `pattern'
  def matchesfor(pattern)
  end
end
