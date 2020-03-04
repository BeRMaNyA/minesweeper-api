# frozen_string_literal: true

class BoardController < AppController
  before_action :authenticate!
  before_action :load_game_and_board!

  # GET /games/:game_id/board
  def show
    self.serializer_opts = { board: true }

    json @game
  end

  # POST /games/:game_id/board/check
  def check 
    json @board.check(
      x: params.x,
      y: params.y
    )
  end

  # POST /games/:game_id/board/flag
  def flag
    json @board.flag(
      x:    params.x,
      y:    params.y,
      type: params.type
    )
  end

  # POST /games/:game_id/board/unflag
  def unflag 
    json @board.unflag(
      x: params.x,
      y: params.y
    )
  end

  private

  def load_game_and_board!
    query = { id: params.game_id }

    query[:state] = :started unless action == :show

    @game = current_user.games.where(query).first

    halt 404, error: "Game not found or not started" unless @game

    @board = @game.board
  end
end
