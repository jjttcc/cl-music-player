Command-Line Music Player (CLMP)
===============

A simple, command-line-based music player

Synopsis
===============

    playmusic -h

    Usage: $0 [options] pattern ...
    Options:
      -l      List (and play) all matching files
      -L      List, but don't play, all matching files
      -i      display Information about each selected file
      -I      display Information about (but don't play) each selected file
      -f      Force rebuild of database
      -e      Edit database with $EDITOR

    playmusic -l mozart        # List matches for 'mozart'

    playmusic mozart.*figaro   # Play, e.g., .../mozart/le-nozze-di-figaro/Track*.wav

Description
===============

The playmusic script will, when run for the first time, search for all
music files (currently, files with the 3-letter suffixes: wav, flac, mp3, ogg)
on the file system of the computer the script is run on and build a simple
database with the path to each file found.  (The database is currently a
text file that can be edited by the user to remove unwanted entries, such as
sample sounds.)  The database is used to quickly search for a file or set
of files, based on the patterns (regular expressions) specified on the
command line.

Portability
===============

Command-Line Music Player currently only runs on Linux, although it may be
straightforward to port it to other UNIXes, including OS X.  A Windows port
is probably possible with some work, especially if cygwin is used.


Dependencies
===============

### Components
Contracts::DSL

### External programs
vlc  
locate  
vi      (Note: The EDITOR environment variable can be set to override this.)  
more    (Note: The PAGER environment variable can be set to override this.)  
exiftool  

#### Notes
Although vlc is hard-coded as a dependency, it would probably not be
difficult to make the media player configurable - so that, for example,
mplayer could be used instead.
