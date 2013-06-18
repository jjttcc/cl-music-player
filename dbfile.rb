# encoding: utf-8
require 'ruby_contracts'

class DBFile
  include Contracts::DSL

  attr_reader :path, :audio_files, :db_newly_created

  private

  AUDIO_EXTENSIONS = %w[wav flac mp3 ogg]
  AUDIO_EXT_EXPR = '\.' + AUDIO_EXTENSIONS.join('$|\.') + '$'
  DEFAULT_EDITOR = 'vi'

  pre "path-not-empty" do |path| path != nil && ! path.empty? end
  post "audio_files exists" do audio_files != nil end
  def initialize(path, rebuild = false)
    @db_newly_created = false
    @path = path
    if rebuild || ! File.exists?(path)
      @db_newly_created = true
      dirpath = File.dirname(path)
      if ! File.exists?(dirpath)
        begin
          Dir.mkdir(dirpath)
        rescue SystemCallError => e
          puts "Fatal error: Failed to create database file:\n" + e.message
          exit 24
        end
      elsif ! File.directory?(dirpath)
        $stderr.puts "Fatal error: #{dirpath} exists but is not a directory."
        exit 23
      end
      @file = File.new(path, 'w')
      basecommand = "locate -r '\\."
      AUDIO_EXTENSIONS.each do |extension|
        command = "#{basecommand}#{extension}$'"
        stream = IO.popen(command)
        @file.write(stream.read)
      end
    end
    load_in_memory_db
  end

  public

  # Append any files found matching the specified patterns to the database
  # file.
  pre 'patterns not nil' do |patterns| patterns != nil end
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
        list = input.split("\n").grep(/#{AUDIO_EXT_EXPR}/)
        f.write(list.join("\n"))
      end
    end
    load_in_memory_db
  end

  # First file path found that matches `pattern'
  pre 'pattern not nil' do |pattern| pattern != nil end
  def matchfor(pattern)
    result = nil
    matches = @audio_files_in_ascii.grep(/#{pattern}/i)
    if matches.length > 0
      result = matches[0]
    end
    result
  end

  # All file paths found that match `pattern'
  pre 'pattern not nil' do |pattern| pattern != nil end
  def matchesfor(pattern)
    result = []
    j = 0
    r = Regexp.new(/#{pattern}/i)
    (0 .. @audio_files_in_ascii.length - 1).each do |i|
      if r.match(@audio_files_in_ascii[i])
        result[j] = @audio_files[i]
        j += 1
      end
    end
    result
  end

  # Provide user-editing of the database.
  def edit
    editor = ENV['EDITOR']
    if ! editor
      editor = DEFAULT_EDITOR
    end
    system("#{editor} #{path()}")
  end

  private

  # Load @audio_files and @audio_files_in_ascii arrays
  def load_in_memory_db
    @file = File.new(self.path, 'r')
    files = @file.readlines
    @audio_files = files.map { |s| s.chomp }
    # Searching (potentially) UTF-8-encoded file names doesn't work very
    # well, so a converted list (in @audio_files_in_ascii) will be used
    # instead.
    @audio_files_in_ascii = []
    (0 .. @audio_files.length - 1).each do |i|
      @audio_files_in_ascii[i] =
        @audio_files[i].encode('US-ASCII', undef: :replace,
                               invalid: :replace)
    end
  end
end
