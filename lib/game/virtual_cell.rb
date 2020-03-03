# frozen_string_literal: true

module VirtualCell
  def check
    return { game_over: true } if has_mine

    mines = count_mines

    if mines.zero?
      fsm.trigger(:free)
      save
      cells = visit_neighbours([ self ])
    else
      cells = [ self ]
      fsm.trigger(:game_flag)
      self.flag_value = mines
      save
    end

    board.uncovered -= cells.count
    board.save

    game.fsm.trigger!(:win) if board.win?

    return { cells: cells, win: board.win? }
  end

  def count_mines
    get_neighbours.compact.select do |cell|
      cell.has_mine
    end.count
  end

  def visit_neighbours(visited = [])
    neighbours = get_neighbours[0..3].compact

    neighbours.each do |neighbour|
      byebug
      next if visited.include?(neighbour)

      visited << neighbour

      next if neighbour.has_mine

      if neighbour.count_mines > 0
        neighbour.fsm.trigger(:game_flag)
        neighbour.flag_value = neighbour.count_mines
        neighbour.save
      else
        neighbour.fsm.trigger(:free)
        neighbour.save

        visited << neighbour.visit_neighbours(visited)
      end
    end

    visited
  end

  private

  def get_neighbours
    [
      left,
      right,
      top,
      bottom,
      top_left,
      top_right,
      bottom_left,
      bottom_right
    ]
  end

  def left
    get_neighbour x: x - 1
  end

  def right
    get_neighbour x: x + 1
  end

  def top
    get_neighbour y: y - 1
  end

  def bottom
    get_neighbour y: y + 1
  end

  def top_right
    get_neighbour y: y - 1, x: x + 1
  end

  def top_left
    get_neighbour y: y - 1, x: x - 1
  end

  def bottom_right
    get_neighbour y: y + 1, x: x + 1
  end

  def bottom_left
    get_neighbour y: y + 1, x: x - 1
  end

  def get_neighbour(x: self.x, y: self.y)
    cell = board.cells.where(x: x, y: y).first
    cell.extend(VirtualCell) if cell
    cell
  end
end
