# frozen_string_literal: true

class GamesController < AppController
  before_action :authenticate!
  before_action :load_game, only: %i(destroy pause resume)

  # GET /games
  def index
    check_scope! :list_games

    self.serializer_opts = { paginate: true }

    json paginate(current_user.games)
  end

  # POST /games
  def create
    check_scope! :create_game

    params["board"] ||= {} # set board with default params

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
    check_scope! :delete_game

    @game.state = "deleted"
    @game.destroy

    json @game
  end

  # POST /games/:id/action
  %i(pause resume).each do |action|
    define_method action do
      check_scope! :play_game

      @game.fsm.trigger action

      json success: true
    end
  end

  private

  def load_game
    @game = current_user.games.where(id: params.id).first

    halt 404, error: "Game not found" unless @game
  end

  def game_params
    params.permit(:name, :board)
  end
end
