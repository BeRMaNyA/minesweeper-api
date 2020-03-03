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
    cell.check
  end

  # Flag a board cell
  # Return cell with updated attribute
  #
  def flag(type:, x:, y:)
    cell = load_cell_and_place_mines(x, y)
    return invalid_play unless cell
    cell.flag(type)
  end

  private

  def load_cell_and_place_mines(x, y)
    cell = @board.cells.where(
      state: :uncovered,
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
