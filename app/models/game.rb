# frozen_string_literal: true

class Game
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include ActiveModel::Validations

  field :name,  type: String
  field :state, type: Symbol

  belongs_to :user, index: true
  has_one    :board, dependent: :destroy

  embeds_many :time_entries

  validates :name, :user, :state, presence: true

  before_save :set_time_entries

  def fsm
    @fsm ||= begin
      fsm = MicroMachine.new(state)

      fsm.when :pause,  :playing => :paused
      fsm.when :resume, :paused  => :playing
      fsm.when :win,    :playing => :won
      fsm.when :lose,   :playing => :lost

      fsm.on :any do
        self.state = fsm.state
        save!
      end

      fsm
    end
  end

  def playing?
    state == :playing
  end

  def duration
    time_entries.sum &:duration
  end

  private

  def set_time_entries
    if playing?
      time_entries << TimeEntry.new(start_time: Time.now.utc)
    else
      time_entries.last.finish
    end
  end
end
