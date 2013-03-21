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

    files = @file.readlines
    @audio_files = files.collect {|s| s.chomp}
    # Searching (potentially) UTF-8-encoded file names doesn't work very
    # well, so a converted list (in @audio_files_in_ascii) will be used
    # instead.
    @audio_files_in_ascii = []
    for i in 0 .. @audio_files.length - 1 do
      @audio_files_in_ascii[i] = @audio_files[i].encode('US-ASCII',
        :undef => :replace, :invalid => :replace)
    end
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
    result = nil
    matches = @audio_files_in_ascii.grep /#{pattern}/i
    if matches.length > 0
      result = matches[0]
    end
    result
  end

  # All file paths found that match `pattern'
  def matchesforold(pattern)
    result = @audio_files_in_ascii.grep /#{pattern}/i
    result
  end
  def matchesfor(pattern)
    result = []; j = 0
puts "afia size: #{@audio_files_in_ascii.length}"
puts "afia[1]: #{@audio_files_in_ascii[1]}"
puts "pattern: #{pattern}"
    r = Regexp.new(/#{pattern}/i)
puts "r: #{r}"
    for i in 0 .. @audio_files_in_ascii.length - 1 do
      if r.match(@audio_files_in_ascii[i])
        result[j] = @audio_files[i]
        j += 1
      end
    end
    result
  end
end
