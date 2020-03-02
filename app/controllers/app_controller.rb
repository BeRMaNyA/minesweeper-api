# frozen_string_literal: true

class AppController < FitApi::Controller
  def root
    json "Minesweeper by Berna"
  end

  private

  def json(status = 200, data)
    if [ Hash, Array ].include?(data)
      return super(status, data)
    end

    klass      = Array(data).first.class
    serializer = Object.const_get("#{klass}Serializer") rescue nil
    data       = serializer.new(data) if serializer

    super(status, data)
  end
end
