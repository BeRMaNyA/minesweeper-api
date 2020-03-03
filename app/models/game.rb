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

  def fsm
    @fsm ||= begin
      fsm = MicroMachine.new(state)

      fsm.when :pause,  :started => :paused
      fsm.when :resume, :paused  => :started
      fsm.when :win,    :started => :won
      fsm.when :lose,   :started => :lost

      fsm.on :any do
        self.state = fsm.state
        check_time_entries
        save!
      end

      fsm
    end
  end

  def check_time_entries
    if playing?
      time_entries << TimeEntry.new(start_time: Time.now.utc)
    else
      time_entries.last.finish
    end
  end

  def playing?
    state == :started
  end

  def total_duration
    time_entries.sum &:duration
  end
end
