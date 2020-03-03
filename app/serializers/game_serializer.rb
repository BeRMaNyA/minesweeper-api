# frozen_string_literal: true

class GameSerializer < AppSerializer
  def serialize(game)
    board = get_board(game)

    {
      id:    game.id.to_s,
      name:  game.name,
      state: game.state,
      mines: game.mines,
      rows:  game.rows,
      cols:  game.cols,
      **board
    }
  end

  private

  def get_board(game)
    return {} unless options[:show_board]

    cells = get_cells(game.board)

    {
      board: {
        id:        game.board.id.to_s,
        mines:     game.board.mines,
        uncovered: game.board.uncovered,
        cells:     cells
      }
    }
  end

  def get_cells(board)
    board.cells.map do |cell|
      {
        id:         cell.id.to_s,
        y:          cell.y,
        x:          cell.x,
        state:      cell.state,
        has_bomb:   cell.has_bomb,
        flag_type:  cell.flag_type,
        flag_value: cell.flag_value
      }
    end
  end
end
