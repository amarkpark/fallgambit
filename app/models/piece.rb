class Piece < ActiveRecord::Base
	belongs_to :user
	belongs_to :game

	# Lines 6-16 all part of STI: to break it disable line 6 or give it fake field name ~AMP
	self.inheritance_column = :piece_type
	scope :pawns, -> { where(piece_type: "pawn")}
	scope :queens, -> { where(piece_type: "queen")}
	scope :kings, -> { where(piece_type: "king")}
	scope :rooks, -> { where(piece_type: "rook")}
	scope :knights, -> { where(piece_type: "knight")}
	scope :bishops, -> { where(piece_type: "bishop")}

	def self.piece_types
		%w(Pawn Queen King Rook Knight Bishop)
	end

	def is_captured? 
		# do we need this or can we just query piece.captured and if it evals to true it's done
		where(captured: "true")
	end

	def is_obstructed?
		# test for pieces adjacent to current position
	end

	def check_defend
		# get between king and threat
	end
end

