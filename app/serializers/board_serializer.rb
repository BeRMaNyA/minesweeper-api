# frozen_string_literal: true

class BoardSerializer < AppSerializer
  def serialize(board)
    cells = serialize_cells(board.cells)

    {
      mines:   board.mines,
      covered: board.covered,
      cells:   cells
    }
  end

  private

  def serialize_cells(cells)
    cells.map do |cell|
      {
        id:         cell.id.to_s,
        y:          cell.y,
        x:          cell.x,
        state:      cell.state,
        has_mine:   cell.has_mine,
        flag_value: cell.flag_value
      }
    end
  end
end
