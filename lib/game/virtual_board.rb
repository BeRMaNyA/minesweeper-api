# frozen_string_literal: true

class VirtualBoard
  def initialize(game)
    @game  = game
    @board = game.board
  end

  # Check a board cell (place the mines if it's the first move)
  # Return game state and the affected cells with updated attrs
  #
  def check(x:, y:)
    cell = load_cell_and_place_mines(x, y)

    return invalid_play unless cell

    if cell.has_mine
      @board.game.fsm.trigger(:lose)
      return { game_over: true }
    end

    history = cell.visit.map(&:attributes)

    @board.game.fsm.trigger(:win) if @board.win?

    return {
      cells: history,
      win: @board.win?
    }
  end

  # Flag a board cell
  # Return the cell with updated attributes
  #
  def flag(type:, x:, y:)
    cell = load_cell_and_place_mines(x, y)

    return invalid_play unless cell

    cell.flag(:user_flag, type)

    if cell.board.win?
      @board.game.fsm.trigger(:win)
    end

    return {
      cells: [ cell.attributes ],
      win:   @board.win?
    }
  end

  # Remove a flag
  # Return the cell with updated attributes
  #
  def unflag(x:, y:)
    cell = load_flagged_cell(x, y)

    return invalid_play unless cell

    cell.fsm.trigger(:unflag)
    cell.flag_value = nil

    cell.save and cell.board.save

    return {
      cells: [ self.attributes ],
      win:   board.win?
    }
  end

  private

  def load_cell_and_place_mines(x, y)
    cell = @board.cells.where(
      state: :covered,
      x: x,
      y: y
    ).first

    return unless cell

    unless @board.mines
      place_mines(x, y) 
      cell.reload
    end

    cell.extend(VirtualCell)
  end

  def load_flagged_cell(x, y)
    @board.cells.where(
      state: :flagged,
      x: x,
      y: y
    ).first
  end

  def place_mines(x, y)
    mines = [ ]

    while mines.count < @game.mines
      cell = @board.cells.where(
        :x.ne   => x,
        :y.ne   => y,
        :id.nin => mines
      ).sample

      cell.has_mine = true
      cell.save

      mines << cell.id
    end

    @board.mines = mines
    @board.save
  end

  def invalid_play
    {
      error: 'Invalid play'
    }
  end
end
