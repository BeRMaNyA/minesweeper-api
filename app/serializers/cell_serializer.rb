# frozen_string_literal: true

class CellSerializer < AppSerializer
  def serialize(cell)
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
