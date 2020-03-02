# frozen_string_literal: true

class Cell
  include Mongoid::Document

  field :state,      type: Symbol
  field :has_bomb,   type: Boolean
  field :flag_type,  type: Boolean
  field :flag_value, type: Boolean
  field :x,          type: Integer
  field :y,          type: Integer

  embedded_in :board
end
