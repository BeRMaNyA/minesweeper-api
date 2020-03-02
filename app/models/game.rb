# frozen_string_literal: true

class Game
  include Mongoid::Document
  include ActiveModel::Validations

  field :name,     type: String
  field :state,    type: Symbol
  field :settings, type: Hash

  belongs_to  :user, index: true
  has_one     :board
  embeds_many :time_entries

  validates :name, :user, :state, :settings, presence: true

  def total_duration
    time_entries.sum &:duration
  end
end
