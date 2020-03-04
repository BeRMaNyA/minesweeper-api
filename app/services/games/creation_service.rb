# frozen_string_literal: true

module Games
  module CreationService
    extend self

    def call(user, params)
      game = user.games.build(params.merge(
        state: :started
      ))

      game.check_time_entries

      if game.save
        create_empty_board(game)
      end

      game
    end

    private

    def create_empty_board(game)
      cells = build_cells(game)

      Board.create(
        game:    game,
        cells:   cells,
        covered: cells.count
      )
    end

    def build_cells(game)
      game.rows.times.map do |row|
        game.cols.times.map do |col|
          Cell.new(
            x:        col,
            y:        row, 
            state:    :covered,
            has_mine: false
          )
        end
      end.flatten
    end
  end
end
