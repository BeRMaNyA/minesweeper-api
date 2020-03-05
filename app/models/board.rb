# frozen_string_literal: true

require 'forwardable'

class Board
  include Mongoid::Document
  extend Forwardable

  def_delegators :virtual_board, :check, :flag, :unflag

  field :rows,     type: Integer
  field :cols,     type: Integer
  field :mines,    type: Integer
  field :hidden,   type: Integer
  field :mine_ids, type: Array

  belongs_to  :game, index: true
  embeds_many :cells

  index("cells.x": 1, "cells.y": 1)

  def win?
    hidden.zero?
  end

  def reset
    update(mine_ids: nil, hidden: cells.count)

    cells.update_all(
      state:    :hidden,
      has_mine: false
    )

    self
  end
end
