# encoding: utf-8
# Copyright 2013  Jim Cochrane - GNU GPL, verson 2 (See the LICENSE file.)

require 'ruby_contracts'

# Command-line option processing logic
class OptionState
  include Contracts::DSL
  attr_reader :regular_arguments, :report_only, :listfiles, :cl_error,
              :rebuild_db, :showinfo, :editdb

  pre :config do |config| config != nil end
  post :config_set do |result, config| @config == config end
  def initialize(config)
    @report_only, @cl_error, @listfiles, @rebuild_db, @config = false, false,
      false, false, config
    @regular_arguments = []
    (0..ARGV.length - 1).each do |i|
      if is_option(ARGV[i])
        i = process_option(i)
      else
        @regular_arguments << ARGV[i]
      end
    end
  end

  def usage
    result = "Usage: $0 [options] pattern ...\n" + "Options:\n" +
      "  -l      List (and play) all matching files\n" +
      "  -L      List, but don't play, all matching files\n"
    if @config.infotool
      result += "  -i      display Information about each selected file\n"
      result += "  -I      display Information about (but don't play) " +
        "each selected file\n"
    end
    result += '  -f      Force rebuild of database'
    result += "\n  -e      Edit database with $EDITOR"
    result
  end

  private

  def is_option(arg)
    arg =~ /^-/
  end

  type in: [Numeric]
  def process_option(i)
    case ARGV[i]
    when /-l/
      @listfiles = true
    when /-L/
      @listfiles = true
      @report_only = true
    when /-f/
      @rebuild_db = true
    when /-i/
      @showinfo = true
    when /-I/
      @showinfo = true
      @report_only = true
    when /-e/
      @editdb = true
      @report_only = true
    else
      @cl_error = true
    end
    i
  end

end
