# frozen_string_literal: true

module StateMachine
  def fsm
    @fsm ||= begin
      fsm = MicroMachine.new(state)

      fsm.when :uncover,   :covered         => :uncovered
      fsm.when :user_flag, :covered         => :flagged_by_user
      fsm.when :game_flag, :covered         => :flagged_by_game
      fsm.when :unflag,    :flagged_by_user => :covered

      fsm.on :any do
        self.state = fsm.state

        if state == :covered
          board.covered += 1
        else
          board.covered -= 1 
        end

        self.save and board.save
      end

      fsm
    end
  end
end
