class Player

	POSITIONS = Hash[('a'..'h').to_a.zip((0..7).to_a)]

	attr_reader :name, :color

	def initialize(name, color)
		@name = name
		@color = color
	end

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
    end
    return true
  end

end

class InvalidMoveError < StandardError
end