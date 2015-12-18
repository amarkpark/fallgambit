require 'rails_helper'
RSpec.describe GamesController, type: :controller do
  describe "GET new" do
    it "creates new game" do
      get :new
      expect(assigns(:game)).to be_a_new(Game)
    end
    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "GET show" do
    let(:game) { create(:game) }
    context 'with valid params' do
      it "assigns the requested game to @game" do
        get :show, id: game
        expect(assigns(:game)).to eq(game)
      end
      it "has a 200 status code for an existing game" do
        get :show, id: game.id
        (expect(response.status).to eq(200))
      end
      it "renders the show view" do
        get :show, id: game.id
        expect(response).to render_template("show")
      end
      it "shows whose turn it is" do
        pending "to be implemented"
        this_should_not_get_executed
      end
      it "has current turn set to either white or black user" do
        pending "to be implemented"
        this_should_not_get_executed
      end
    end
    context 'with invalid params' do
      it "has a 404 status code for an non-existant game" do
        get :show, id: "LOL"
        (expect(response.status).to eq(404))
      end
    end
  end

  describe 'POST #create' do
    context 'with logged in user' do
      login_user
      context 'with valid params' do
        context 'with white player creating the game' do
          it 'redirects to show page' do
            post :create, game: { game_name: "Test White",
                                  creator_plays_as_black: "0" }
            expect(response).to redirect_to(Game.last)
          end
          it 'sets all white pieces to be owned by white player' do
            post :create, game: { game_name: "Test White",
                                  white_user_id: subject.current_user.id }
            expect(Game.last.pieces.where(user_id: subject.current_user.id)
              .count).to eq 16
            expect(Game.last.pieces.where(user_id: nil)
              .count).to eq 16
          end
        end
        context 'with black player creating the game' do
          it 'redirects to show page' do
            post :create, game: { game_name: "Test Black",
                                  creator_plays_as_black: "1" }
            expect(response).to redirect_to(Game.last)
          end
          it 'sets all black pieces to be owned by black player' do
            post :create, game: { game_name: "Test Black",
                                  creator_plays_as_black: "1" }
            expect(Game.last.pieces.where(user_id: subject.current_user.id)
              .count).to eq 16
            expect(Game.last.pieces.where(user_id: nil)
              .count).to eq 16
          end
          it "sets the current user's turn if they are the white player" do
            pending "to be implemented"
            this_should_not_get_executed
          end
          it "does not set the user's turn if they are black player" do
            pending "to be implemented"
            this_should_not_get_executed
          end
        end
      end
      context 'with invalid params' do
        it 're-renders #new form' do
          post :create, game: { game_name: "" }
          expect(response).to render_template(:new)
        end
      end
    end
    context 'without being logged in' do
      it 'redirects to sign-in page' do
        post :create, game: attributes_for(:game)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with logged in user' do
      login_user
      context 'with white player joining game' do
        let(:black_player) { create(:user) }
        let(:game_to_update) do
          Game.create(game_name: "Test",
                      black_user_id: black_player.id, user_turn: black_player.id)
        end
        it 'redirects to show page' do
          put :update, id: game_to_update.id, game: {
            white_user_id: subject.current_user.id }
          expect(response).to redirect_to(game_to_update)
        end
        it 'sets all white pieces to be owned by white player' do
          put :update, id: game_to_update.id, game: {
            white_user_id: subject.current_user.id }
          expect(game_to_update.pieces.where(user_id: subject.current_user.id)
            .count).to eq 16
        end
        it "sets the current user's turn" do
          pending "to be implemented"
          this_should_not_get_executed
        end
      end
      context 'with black player joining game' do
        let(:white_player) { create(:user) }
        let(:game_to_update) do
          Game.create(game_name: "Test",
                      white_user_id: white_player.id, user_turn: white_player.id)
        end
        it 'redirects to show page' do
          put :update, id: game_to_update.id, game: {
            black_user_id: subject.current_user.id }
          expect(response).to redirect_to(game_to_update)
        end
        it 'sets all black pieces to be owned by black player' do
          put :update, id: game_to_update.id, game: {
            white_user_id: subject.current_user.id }
          expect(game_to_update.pieces.where(user_id: subject.current_user.id)
            .count).to eq 16
        end
        it "does not set the current user's turn" do
          pending "to be implemented"
          this_should_not_get_executed
        end
      end
      it 'won\'t let player join full game' do
        game = create(:game)
        put :update, id: game.id, game: {
          white_user_id: subject.current_user.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
        expect(flash[:alert]).to eq('Game is full!')
      end
    end
    context 'without being logged in' do
      it 'redirects to sign-in page' do
        game_to_update = create(:game)
        put :update, id: game_to_update.id, game: attributes_for(:game)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
