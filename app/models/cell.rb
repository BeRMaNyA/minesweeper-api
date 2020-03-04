# frozen_string_literal: true

class Cell
  include Mongoid::Document

  field :state,      type: Symbol
  field :has_mine,   type: Boolean
  field :flag_value, type: String
  field :x,          type: Integer
  field :y,          type: Integer

  embedded_in :board

  def covered?
    state == :covered
  end
end
