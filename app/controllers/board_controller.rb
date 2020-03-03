# frozen_string_literal: true

class BoardController < AppController
  before_action :authenticate!
  before_action :load_game

  def show
    self.serializer_opts = { board: true }

    json @game
  end

  private

  def load_game
    @game = current_user.games.where(id: params.game_id).first

    halt 404, error: "Game not found" unless @game
  end
end
