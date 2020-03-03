# frozen_string_literal: true

class BoardSerializer < AppSerializer
  def serialize(board)
    cells = serialize_cells(game.board)

    {
      id:        game.board.id.to_s,
      mines:     game.board.mines,
      uncovered: game.board.uncovered,
      cells:     cells
    }
  end

  private

  def serialize_cells(board)
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
