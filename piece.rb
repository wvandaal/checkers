# encoding: UTF-8

class Piece

	SLIDES = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
	JUMPS = [[2, 2], [2, -2], [-2, 2], [-2, -2]]

	attr_accessor :pos
	attr_reader :color, :symbol

	def initialize(board, pos, color, king = false, symbol = '●')
		@board = board
		@pos = pos
		@color = color
		@king = king
		@symbol = symbol
	end

	def is_king?
		@king
	end

	def make_king
		@symbol = '♛'
		@king = true
	end

	def slide_moves
		slides = (@king ? SLIDES : SLIDES.select {|y, x| (@color == :red ? y > 0 : y < 0)})
		slides.map do |y, x| 
			[y + @pos[0], x + @pos[1]]
		end.select {|pos| valid?(pos) && !occupied?(pos)}
	end

	def jump_moves(moves, pos = @pos)
		# REV: The following 2 lines are fairly complex to read since there are
		# blocks including ternary operators within a ternary operator itself.
		# Splitting the first ternary into multiple lines might make them easier to read.
		jump_dirs = (@king ? JUMPS : JUMPS.select {|y, x| (@color == :red ? y > 0 : y < 0)})
		slide_dirs = (@king ? SLIDES : SLIDES.select {|y, x| (@color == :red ? y > 0 : y < 0)})
		jumps = jump_dirs.map! {|y, x| [y + pos[0], x + pos[1]]} # jump move positions
		slides = slide_dirs.map! {|y, x| [y + pos[0], x + pos[1]]} # slide move positions

		slide_jumps = jumps.zip(slides).reject {|jump, slide| !valid?(slide) || !valid?(jump)}

	  valid_jumps = slide_jumps.reject do |jump, slide|
			@board[*slide].nil? || @board[*slide].color == @color || !@board[*jump].nil?
		end.flatten(1) - slides 

		if valid_jumps.flatten.empty?
			p m = moves.flatten(1)
			return m
		else
			moves << valid_jumps
			valid_jumps.each do |jump_pos|
				jump_moves(moves, jump_pos)
			end
		end
	end

	def valid?(pos)
		pos.all? {|c| c >= 0 && c <= 7}
	end

	def occupied?(pos)
		!@board[*pos].nil?
	end

end