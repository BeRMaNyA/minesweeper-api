# frozen_string_literal: true

class TimeEntry
  include Mongoid::Document

  field :start_time, type: Time
  field :end_time,   type: Time
  field :duration,   type: Float

  embedded_in :game

  def set_duration
    self.duration = (end_time - start_time).round(2)
  end
end
