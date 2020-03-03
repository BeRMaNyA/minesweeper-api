# frozen_string_literal: true

class Game
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include ActiveModel::Validations

  field :name,  type: String
  field :state, type: Symbol
  field :rows,  type: Integer
  field :cols,  type: Integer
  field :mines, type: Integer

  belongs_to :user, index: true
  has_one    :board, dependent: :destroy

  embeds_many :time_entries

  validates :name, :user, :state, :rows, :cols, :mines, presence: true

  def total_duration
    time_entries.sum &:duration
  end

  def fsm
    @fsm ||= begin
      fsm = MicroMachine.new(state)

      fsm.when :pause,  :started => :paused
      fsm.when :resume, :paused  => :started
      fsm.when :win,    :started => :won
      fsm.when :lose,   :started => :lost

      fsm.on :any do
        self.state = fsm.state
        self.save
      end

      fsm
    end
  end
end
