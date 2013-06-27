# encoding: UTF-8

# REV: When requiring files in the same directory, you can use require_relative.
# In this case, you could just write require_relative 'piece'
require 'colorize'
require './piece.rb'

# REV: Your board class looks good and clean. Smart to use the array setter method.

class Board

	# REV: Do you need BOARD_LENGTH? It looks like it's only used once (line 54)
	BOARD_LENGTH = 8
	BLANK_ROWS = [3, 4]

	def initialize
		@board = Array.new(8) {Array.new(8)}
		@moves = []
		fill_board
	end

	def [](y,x)
		@board[y][x]
	end

	def []=(y, x, piece)
		@board[y][x] = piece
	end

	def make_move(move)
		start, finish = move
		piece = self[*start]
		piece.position = finish
		# REV: Had self.[*start] here, I just deleted the period
		self[*start] = nil
		self[*finish]= piece
		
		captured = nil
		if (start[0] - finish[0]).abs > 1
			captured = self[(start[0] - finish[0]).abs, (start[1] - finish[1]).abs]
		end
		moves << Move.new(start, finish, captured)
	end

	def undo_move

	end

	def display
		print "   "
		('a'..'h').each {|col| print " #{col} "}
		puts ""
		@board.each_with_index do |row, row_i|
			print "#{(row_i - BOARD_LENGTH).abs}  "
			row.each_with_index do |tile, col_i|
				bckgrnd_color = ((row_i + col_i).even? ? :white : :black)
				if tile.nil?
					print "   ".colorize(:background => bckgrnd_color)
				else
					print " #{tile.symbol} ".colorize(:color => tile.color, :background => bckgrnd_color)
				end
			end
			puts ""
		end
	end

	def fill_board
		@board.each_index do |row|
			next if BLANK_ROWS.include?(row)
			if row < 3 
				@board[row] = fill_row(row, :red)
			else
				@board[row] = fill_row(row, :black)
			end
		end
	end

	def fill_row(row_i, color)
		row = []
		8.times do |col_i|
			if row_i.even?
				row << (col_i.even? ? Piece.new(self, [row_i, col_i], color) : nil)
			else
				row << (col_i.odd? ? Piece.new(self, [row_i, col_i], color) : nil)
			end
		end
		row
	end

end

class Move

	def initialize(start, finish, captured)
		@start = start
		@finish = finish
		@captured = captured
	end

end