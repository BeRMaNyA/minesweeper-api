# frozen_string_literal: true

module VirtualBoard
  # Check a board cell (place the mines if it's the first move)
  # Return the game state and the affected cells
  #
  def check(x:, y:)
    cell = load_cell_and_place_mines(x, y)

    return invalid_play unless cell

    if cell.has_mine
      game.fsm.trigger(:lose)
      return { game_over: true }
    end

    history = CellSerializer.new(cell.visit).to_a

    game.fsm.trigger(:win) if self.reload.win?

    return {
      cells: history,
      win: self.win?
    }
  end

  # Flag a board cell
  # Return the cell with updated attributes
  #
  def flag(type:, x:, y:)
    cell = load_cell_and_place_mines(x, y)

    return invalid_play unless cell

    cell.flag(:user_flag, type)

    game.fsm.trigger(:win) if self.reload.win?

    cell = CellSerializer.new(cell).to_h

    return {
      win: self.win?,
      **cell
    }
  end

  # Remove a flag
  # Return the cell with updated attributes
  #
  def unflag(x:, y:)
    cell = load_flagged_cell(x, y)

    return invalid_play unless cell

    cell.fsm.trigger(:unflag)

    return CellSerializer.new(cell).to_h
  end

  private

  def load_cell_and_place_mines(x, y)
    cell = self.cells.where(
      state: :hidden,
      x: x,
      y: y
    ).first

    return unless cell

    unless self.mine_ids
      place_mines(cell) 
      cell.reload
    end

    cell.extend(VirtualCell)
  end

  def load_flagged_cell(x, y)
    self.cells.where(
      state: :flagged_by_user,
      x: x,
      y: y
    ).first
  end

  def place_mines(origin)
    banned_ids = [ origin.id ]
    mine_ids = [ ]

    while mine_ids.count < self.mines
      cell = self.cells.where(
        :id.nin => banned_ids
      ).sample

      cell.has_mine = true
      cell.save

      mine_ids << cell.id.to_s
      banned_ids << cell.id
    end

    self.mine_ids = mine_ids
    self.save
  end

  def invalid_play
    {
      error: 'Invalid play'
    }
  end
end
