# frozen_string_literal: true

module VirtualCell
  def check
    if has_mine
      board.game.fsm.trigger(:lose)
      return { game_over: true }
    end

    mines = count_mines

    if mines.zero?
      fsm.trigger(:free) and save
      cells = visit_neighbours([ self.id.to_s ])
    else
      cells = [ self.id.to_s ]
      fsm.trigger(:game_flag)
      self.flag_value = mines
      save
    end

    board.uncovered -= cells.count
    board.save

    board.game.fsm.trigger(:win) if board.win?

    # TODO: use serializer
    #cells = cells.map &:attributes

    return { cells: cells, win: board.win? }
  end

  def flag(type)
    fsm.trigger(:flag)
    self.flag_value = type

    save and board.save

    game.fsm.trigger(:win) if board.win?

    return { cells: [ self.attributes ], win: board.win? }
  end

  def unflag
    fsm.trigger(:unflag)
    self.flag_value = nil
    save and board.save
    self
  end

  def count_mines
    get_neighbours.compact.select do |cell|
      cell.has_mine
    end.count
  end

  def visit_neighbours(visited = [])
    neighbours = get_neighbours[0..3].compact.reject do |neighbour|
      visited.include?(neighbour.id.to_s)
    end

    byebug

    neighbours.each do |neighbour|
      visited << neighbour.id.to_s

      next if neighbour.has_mine

      if neighbour.count_mines > 0
        neighbour.fsm.trigger(:game_flag)
        neighbour.flag_value = neighbour.count_mines
        neighbour.save
      else
        neighbour.fsm.trigger(:free)
        neighbour.save

        new_visits = neighbour.visit_neighbours(visited)
        byebug
        visited.concat(new_visits)
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
