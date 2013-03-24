class OptionState
  attr_reader :regular_arguments, :report_only, :listfiles, :cl_error,
    :rebuild_db, :showinfo

  def initialize(config)
    @report_only = false
    @cl_error = false
    @listfiles = false
    @rebuild_db = false
    @config = config
    @regular_arguments = []
    i = 0
    while i < ARGV.length do
      if is_option(ARGV[i])
        i = process_option(i)
      else
        @regular_arguments << ARGV[i]
      end
      i += 1
    end
  end

  def usage
    result = "Usage: $0 [options] pattern ...\n" + "Options:\n" +
      "  -l      List (Don't play) all matching files\n" +
      "  -L      List (and play) all matching files\n"
    if @config.infotool
      result += "  -i      display Information about each selected file\n"
    end
    result += "  -f      Force rebuild of database"
    result
  end

  private

  def is_option(arg)
    arg =~ /^-/
  end

  def process_option(i)
    case ARGV[i]
    when /-l/
      @listfiles = true
      @report_only = true
    when /-L/
      @listfiles = true
    when /-f/
      @rebuild_db = true
    when /-i/
      @showinfo = true
    else
      @cl_error = true
    end
    i
  end

end
