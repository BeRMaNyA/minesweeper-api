# frozen_string_literal: true

require_relative 'virtual_cell/neighbours'
require_relative 'virtual_cell/state_machine'

module VirtualCell
  include Neighbours
  include StateMachine

  def visit(history = [])
    mines = count_mines
    history << self

    if mines.zero?
      fsm.trigger(:reveal)
      visit_neighbours(history)
    else
      flag(:game_flag, mines)
    end

    history
  end

  def visit_neighbours(history)
    neighbours = get_neighbours[0..3].compact

    available = neighbours.select do |neighbour|
      neighbour.hidden?
    end

    available.each do |neighbour|
      neighbour.visit(history)
    end
  end

  def count_mines
    get_neighbours.compact.select do |cell|
      cell.has_mine
    end.count
  end

  def flag(type, value)
    self.flag_value = value
    fsm.trigger(type)
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
end
