class OptionState
  attr_reader :regular_arguments, :report_only, :listfiles, :cl_error

  def initialize
    @report_only = false
    @cl_error = false
    @listfiles = false
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
    "Usage: $0 [-l] pattern ..."
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
    else
      @cl_error = true
    end
    i
  end
end
