# Dustin Chang
# Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.
class MyPiece < Piece
  Cheat_Piece = [[[[0, 0]]]]

  All_My_Pieces = [[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
	               rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
	               [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
	               [[0, 0], [0, -1], [0, 1], [0, 2]]],
	               rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
	               rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
	               rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
	               rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]), # Z
	               #Added 3 more
	               [[[0, 0], [-1, 0], [1, 0], [-2, 0], [2, 0]], #2 for --
	               [[0, 0], [0, -1], [0, 1], [0, 2], [0, -2]]], # |
	               rotations([[0, 0], [0, 1], [1, 0]]), # Short L
	               rotations([[0, 0], [1, 0], [-1, 0], [0, 1], [-1, 1]]), # sq with extra 1
	               rotations([[0, 0], [1, 0], [-1, 0], [0, 1], [1, 1]])] # inverted sq with extra 1

	def self.next_piece_cheat (board)
		puts 'In next_piece2.1.cheat'
		MyPiece.new(Cheat_Piece.sample, board)
	end

	def self.next_piece (board)
		puts 'In next_piece2.1'
		MyPiece.new(All_My_Pieces.sample, board)
	end
end	#End of MyPiece

class MyBoard < Board
  def initialize(game)
  	@grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500
    @board_cheat_status = false
  end
  
  def next_piece
  	if @board_cheat_status
  		@current_block = MyPiece.next_piece_cheat(self)
  		@current_pos = nil
  		@board_cheat_status = false #To reset the cheat flag
  	else
  		@current_block = MyPiece.next_piece(self)
  		@current_pos = nil
  	end
  end

  def store_current
  	locations = @current_block.current_rotation
  	block_size_index = locations.size - 1 #Gets current block size
  	puts block_size_index
    displacement = @current_block.position
    (0..block_size_index).each{|index|
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end

  def update_cheat_score
    if @board_cheat_status
      puts 'Already cheated'
    else  #Haven't cheated yet
      if @score >= 100
        @board_cheat_status = true
        @score = @score - 100
      end
    end
  end #End of update_cheat_score
end #End of MyBoard

class MyTetris < Tetris
  def key_bindings
  	super
  	@root.bind('u', lambda {@board.rotate_clockwise	#Binds 'u' to rotate 180 deg
                            @board.rotate_clockwise})
  	@root.bind('c', lambda {@board.update_cheat_score}) #For cheat piece
  end

  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end
end #End of MyTetris


