# frozen_string_literal: true

class Board
  include Mongoid::Document

  field :mines,     type: Array
  field :uncovered, type: Integer

  belongs_to  :game, index: true
  embeds_many :cells

  index({ "cells.x": 1, "cells.y": 1 })

  # TODO: need to be implemented
  def virtual_board
    @virtual_board ||= VirtualBoard.new(self)
  end
end
