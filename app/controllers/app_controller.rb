# frozen_string_literal: true

class AppController < FitApi::Controller
  def root
    json "Minesweeper by Berna"
  end
end
