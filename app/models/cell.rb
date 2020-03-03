# frozen_string_literal: true

class Cell
  include Mongoid::Document

  field :state,      type: Symbol
  field :has_mine,   type: Boolean
  field :flag_value, type: String
  field :x,          type: Integer
  field :y,          type: Integer

  embedded_in :board

  def fsm
    @fsm ||= begin
      fsm = MicroMachine.new(state)

      fsm.when :free,      :uncovered => :free
      fsm.when :flag,      :uncovered => :flagged
      fsm.when :unflag,    :flagged   => :uncovered
      fsm.when :game_flag, :uncovered => :game_flagged

      fsm.on :any do
        self.state = fsm.state
      end

      fsm.on :flag do
        board.uncovered -= 1
      end

      fsm.on :uncover do
        board.uncovered += 1
      end

      fsm
    end
  end
end
