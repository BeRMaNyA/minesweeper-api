# frozen_string_literal: true

class BoardController < AppController
  before_action :authenticate!
  before_action :load_game_and_board!

  def show
    self.serializer_opts = { board: true }

    json @game
  end

  def check 
    json @board.check(**check_params)
  end

  def flag
    json @board.flag(**flag_params)
  end

  private

  def load_game_and_board!
    params = { id: params.game_id }

    params[:state] = :started unless action == :show

    @game = current_user.games.where(params).first

    halt 404, error: "Game not found or not started" unless @game

    @board = game.board
  end

  def check_params
    params.permit(:x, :y)
  end

  def flag_params
    params.permit(:x, :y, :type)
  end
end
