class Player
#  attr_reader :dbfile

  def initialize
puts 'player created'
  end

  def playaudio(path)
    puts "I want to play #{path}"
  end
end
