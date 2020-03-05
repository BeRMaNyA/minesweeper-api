# frozen_string_literal: true

module StateMachine
  def fsm
    @fsm ||= begin
      fsm = MicroMachine.new(state)

      fsm.when :reveal,    :hidden          => :revealed
      fsm.when :user_flag, :hidden          => :flagged_by_user
      fsm.when :game_flag, :hidden          => :flagged_by_game
      fsm.when :unflag,    :flagged_by_user => :hidden

      fsm.on :any do
        self.state = fsm.state

        if state == :hidden
          flag_value = nil
          board.hidden += 1
        else
          board.hidden -= 1 
        end

        self.save and board.save
      end

      fsm
    end
  end
end
