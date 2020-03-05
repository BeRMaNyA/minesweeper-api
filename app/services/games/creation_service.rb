# frozen_string_literal: true

module Games
  module CreationService
    extend self

    def call(user, params)
      game = user.games.build(params.merge(
        state: :playing
      ))

      if game.save
        create_empty_board(game, params.board)
      end

      game
    end

    private

    def create_empty_board(game, params)
      params["rows"]  ||= 6
      params["cols"]  ||= 6
      params["mines"] ||= 3

      cells = build_cells(params)

      Board.create(
        game:   game,
        rows:   params.rows,
        cols:   params.cols,
        mines:  params.mines,
        cells:  cells,
        hidden: cells.count
      )
    end

    def build_cells(params)
      params.rows.to_i.times.map do |row|
        params.cols.to_i.times.map do |col|
          Cell.new(
            x:        col,
            y:        row, 
            state:    :hidden,
            has_mine: false
          )
        end
      end.flatten
    end
  end
end
