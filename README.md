Command-Line Music Player
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
