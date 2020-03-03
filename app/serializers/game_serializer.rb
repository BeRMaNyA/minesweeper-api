# frozen_string_literal: true

class GameSerializer < AppSerializer
  def serialize(game)
    board        = serialize_board(game.board)
    time_entries = serialize_time_entries(game.time_entries)

    {
      id:           game.id.to_s,
      name:         game.name,
      state:        game.state,
      mines:        game.mines,
      rows:         game.rows,
      cols:         game.cols,
      time_entries: time_entries,
      **board
    }
  end

  private

  def serialize_board(board)
    return {} unless options[:show_board]

    BoardSerializer.new(board).to_h
  end

  def serialize_time_entries(time_entries)
    time_entries.map do |time_entry|
      {
        id:         time_entry.id.to_s,
        start_time: time_entry.start_time,
        end_time:   time_entry.end_time,
        duration:   time_entry.duration
      }
    end
  end
end
