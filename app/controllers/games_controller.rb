# frozen_string_literal: true

class GamesController < AppController
  before_action :authenticate!
  before_action :check_scope!, only: :create

  # GET /games
  def index
    self.serializer_opts = { paginate: true }

    json paginate(current_user.games)
  end

  # POST /games
  def create
    game = Games::CreationService.call(current_user, game_params)

    self.serializer_opts = { board: true }

    if game.persisted?
      json 201, game
    else
      json 422, errors: game.errors.to_h
    end
  end

  # DELETE /games/:id
  def destroy
    game = current_user.games.find(params.id)
    game.destroy

    json id: game.id.to_s
  end

  private

  def game_params
    params.game.permit(:name, :rows, :cols, :mines)
  end

  def check_scope!
    halt 401 unless scopes.include?('create_game')
  end
end
