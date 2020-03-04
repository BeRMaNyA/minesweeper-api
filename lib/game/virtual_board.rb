# frozen_string_literal: true

require 'forwardable'

class VirtualBoard
  extend Forwardable

  def_delegators :@game, :fsm, :board

  def initialize(game)
    @game = game
  end

  # Check a board cell (place the mines if it's the first move)
  # Return game state and the affected cells with updated attrs
  #
  def check(x:, y:)
    cell = load_cell_and_place_mines(x, y)

    return invalid_play unless cell

    if cell.has_mine
      fsm.trigger(:lose)
      return { game_over: true }
    end

    history = cell.visit.map &:attributes

    fsm.trigger(:win) if board.reload.win?

    return {
      cells: history,
      win: board.win?
    }
  end

  # Flag a board cell
  # Return the cell with updated attributes
  #
  def flag(type:, x:, y:)
    cell = load_cell_and_place_mines(x, y)

    return invalid_play unless cell

    cell.flag(:user_flag, type)

    fsm.trigger(:win) if board.reload.win?

    return {
      cells: [ cell.attributes ],
      win:   board.win?
    }
  end

  # Remove a flag
  # Return the cell with updated attributes
  #
  def unflag(x:, y:)
    cell = load_flagged_cell(x, y)

    return invalid_play unless cell

    cell.fsm.trigger(:unflag)
    board.reload

    return {
      cells: [ self.attributes ],
      win:   board.win?
    }
  end

  private

  def load_cell_and_place_mines(x, y)
    cell = board.cells.where(
      state: :covered,
      x: x,
      y: y
    ).first

    return unless cell

    unless board.mines
      place_mines(x, y) 
      cell.reload
    end

    cell.extend(VirtualCell)
  end

  def load_flagged_cell(x, y)
    board.cells.where(
      state: :flagged_by_user,
      x: x,
      y: y
    ).first
  end

  def place_mines(x, y)
    mines = [ ]

    while mines.count < @game.mines
      cell = board.cells.where(
        :x.ne   => x,
        :y.ne   => y,
        :id.nin => mines
      ).sample

      cell.has_mine = true
      cell.save

      mines << cell.id
    end

    board.mines = mines
    board.save
  end

  def invalid_play
    {
      error: 'Invalid play'
    }
  end
end
