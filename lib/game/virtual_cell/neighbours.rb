# frozen_string_literal: true

module VirtualCell
  module Neighbours
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
end
