# REV: Looks good, your methods are short and to the point.
# Good that you're raising the errors too. 
# If you keep working on this, you'll want to think about where you're going to use rescue.
# In my own code, I raised a bunch of errors in the piece class (when moves were invalid),
# then I rescued in the player class when the move was attempted.
# Obviously our code is different, so this is all just food for thought.
# Also important to note: in whichever files you raise an InvalidMoveError,
# you'll need to require this file so that the error class is included.

class Player

	POSITIONS = Hash[('a'..'h').to_a.zip((0..7).to_a)]

	attr_reader :name, :color

	def initialize(name, color)
		@name = name
		@color = color
	end

  # REV: Might be good to print an example of the format you want the user to use when entering coordinates
	def input_move
		puts "#{@color}'s turn: "
		input = gets.chomp.split(" ")
		process_move(input)
	end

	def process_move(input)
		raise InvalidMoveError.new "That is not a valid move." if input.length < 2

		moves = []
		input.each {|e| moves << e.split('')}
		if moves.all? {|pos| is_valid_position?(pos)}
			moves.map {|y,x| [(x.to_i - POSITIONS.length).abs, POSITIONS[y]]}
    end
  end

	def is_valid_position?(position)
    y, x = position
    if !('a'..'h').include?(y) || !(1..8).include?(x.to_i)
      raise InvalidMoveError.new "You entered a position that is not on the "\
      "board.\nEnter two tiles in the range of [a-h] and [1-8]."
    end
    # REV: Had extra end here, just commented it out and moved 4 lines above back one tab.
    # end
    return true
  end

end

class InvalidMoveError < StandardError
end