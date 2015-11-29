require 'rails_helper'

RSpec.describe Piece, type: :model do

# Jeff this is what you had I tweaked it a little so as not to muck with my tests ~AMP
#   let(:game) { create(:game) }
#   describe "instantiation" do
#     it "sets the white queen image correctly" do
#       expect(game.queens.where(color: true).first.image_name)
#         .to eq('white-queen.png')
#     end

  describe "instantiation" do
    let(:game) { create(:game) }
    it "sets the white queen image correctly" do
      expect(game.queens.where(color: true).first.image_name)
        .to eq('white-queen.png')
    end
  end # You only ended your assertion, you didn't end your test so I added an end ~AMP

  describe 'is_obstructed?' do
    before :all do
      # @user = FactoryGirl.create(:user)
      # sign_in @user
      @game = FactoryGirl.create(:game)
      @game.pieces.delete
      @white_queen = Queen.create(
        x_position: 0,
        y_position: 2,
        color: true,
        game_id: @game.id,
        captured: false
      )
      @white_knight = Knight.create(
        x_position: 0,
        y_position: 1,
        color: true,
        game_id: @game.id,
        captured: false
      )
      @white_pawn = Pawn.create(
        x_position: 1,
        y_position: 1,
        color: true,
        game_id: @game.id,
        captured: false
      )
      @white_bishop = Bishop.create(
        x_position: 4,
        y_position: 2,
        color: true,
        game_id: @game.id,
        captured: false
      )
      @white_rook = Rook.create(
        x_position: 7,
        y_position: 2,
        color: true,
        game_id: @game.id,
        captured: false
      )
      @black_pawn = Pawn.create(
        x_position: 4,
        y_position: 6,
        color: false,
        game_id: @game.id,
        captured: false
      )
      @black_queen = Queen.create(
        x_position: 6,
        y_position: 4,
        color: false,
        game_id: @game.id,
        captured: false
      )
    end

    it 'will be false when SE diag path is clear' do
      expect(@white_queen.is_obstructed?(2, 4)).to be_falsey
    end

    it 'will be true when SW diag path has block, neg direction' do
      expect(@black_queen.is_obstructed?(3, 7)).to eq true
    end

    it 'will be false when NW diag path is clear, piece at endpoint' do
      expect(@black_queen.is_obstructed?(4, 2)).to eq false
    end

    it 'will be true when NW diag path blocked' do
      expect(@black_queen.is_obstructed?(3, 1)).to be_truthy
    end

    it 'will be false when horizontal axis path is clear' do
      expect(@white_queen.is_obstructed?(3, 2)).to be_falsey
    end

    it 'will be false when horiz axis path clear neg direction' do
      expect(@black_queen.is_obstructed?(1, 4)).to eq false
    end

    it 'will be false when vertical axis path is clear' do
      expect(@white_queen.is_obstructed?(0, 5)).to be_falsey
    end

    it 'will be false when vertical axis path clear neg direction' do
      expect(@black_queen.is_obstructed?(6, 1)).to eq false
    end

    it 'will be true when there is a block in horizontal axis' do
      expect(@white_queen.is_obstructed?(5, 2)).to be_truthy
    end

    it 'will be true when there is a block in vertical axis' do
      expect(@white_queen.is_obstructed?(0, 0)).to be_truthy
    end

    it 'will be true with block in vertical axis, neg direction' do
      expect(@white_rook.is_obstructed?(3, 2)).to be_truthy
    end

    it 'ewill be true when there is a block in the diagonal' do
      expect(@white_queen.is_obstructed?(2, 0)).to be_truthy
    end

    it 'will raise an Error Message with invalid input' do
      expect(@white_queen.is_obstructed?(3, 4)).to raise_exception
    end

    it 'will be false with clear path if destination contains piece' do
      # this also tests single space movement evaluation by method
      expect(@white_queen.is_obstructed?(1, 1)).to be_falsey
    end

    # it 'evaluates true w/ clear path, destination piece same-color' do
    #   expect(@white_queen.is_obstructed?(4,2)).to be_truthy
    # end # this will probably be covered by is_valid
  end
end
