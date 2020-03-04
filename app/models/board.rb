# frozen_string_literal: true

require 'forwardable'

class Board
  include Mongoid::Document
  extend Forwardable

  def_delegators :virtual_board, :check, :flag, :unflag

  field :mines,   type: Array
  field :covered, type: Integer

  belongs_to  :game, index: true
  embeds_many :cells

  index("cells.x": 1, "cells.y": 1)

  def virtual_board
    @virtual_board ||= VirtualBoard.new(game)
  end

  def win?
    covered.zero?
  end

  def reset
    update(mines: nil, covered: cells.count)

    cells.update_all(
      state:    :covered,
      has_mine: false
    )

    self
  end
end
