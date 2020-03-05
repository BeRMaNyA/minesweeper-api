# frozen_string_literal: true

class BoardSerializer < AppSerializer
  def serialize(board)
    serializer = CellSerializer.new(board.cells)
    cells = serializer.to_a.each_slice(board.cols).to_a

    {
      mines:    board.mines,
      rows:     board.rows,
      cols:     board.cols,
      hidden:   board.hidden,
      mine_ids: board.mine_ids,
      cells:    cells
    }
  end

  private

  def serialize_cells(cells)
    cells
  end
end
