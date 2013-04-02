class DBFile
#  include Handshake::ClassMethods
  attr_reader :path, :audio_files, :db_newly_created
  @@audio_extensions = ['wav', 'flac', 'mp3', 'ogg']
  @@audio_ext_expr = '\.' + @@audio_extensions.join('$|\.') + '$'

  def initialize(path, rebuild = false)
    @db_newly_created = false
#!!!!!puts 'axtexpr: ' + @@audio_ext_expr.to_s
    @path = path
    if rebuild or not File.exists?(path)
      @db_newly_created = true
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
      @@audio_extensions.each do |extension|
        command = "#{basecommand}#{extension}$'"
        stream = IO.popen(command)
        @file.write(stream.read)
      end
    end
    load_in_memory_db
  end

  # Append any files found matching the specified patterns to the database
  # file.
  def append_to_database(patterns)
    basecommand = "locate -r '"
    open(self.path, 'a') do |f|
      patterns.each do |p|
        char1 = p[0]
        if char1 =~ /[A-Za-z]/
          # Allow locate to look for both init cap and init lowercase.
          ptrn = "[#{char1.upcase}#{char1.downcase}]" + p[1..-1]
        else
          ptrn = p
        end
        command = "#{basecommand}#{ptrn}'"
        stream = IO.popen(command)
        input = stream.read
        list = input.split("\n").grep(/#{@@audio_ext_expr}/)
        f.write(list.join("\n"))
      end
    end
    load_in_memory_db
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
  def matchesfor(pattern)
    result = []; j = 0
    r = Regexp.new(/#{pattern}/i)
    for i in 0 .. @audio_files_in_ascii.length - 1 do
      if r.match(@audio_files_in_ascii[i])
        result[j] = @audio_files[i]
        j += 1
      end
    end
    result
  end

  private

  # Load @audio_files and @audio_files_in_ascii arrays
  def load_in_memory_db
    @file = File.new(self.path, 'r')
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
end
