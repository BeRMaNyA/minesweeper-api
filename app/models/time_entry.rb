# frozen_string_literal: true

class TimeEntry
  include Mongoid::Document

  field :start_time, type: Time
  field :end_time,   type: Time
  field :duration,   type: Float

  embedded_in :game

  def finish
    self.end_time = Time.now.utc
    self.duration = (end_time - start_time).round(2)
  end

  def duration
    super || (Time.now.utc - start_time).round(2)
  end
end
