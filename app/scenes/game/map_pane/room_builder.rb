module Scenes::Game::MapPane
  module RoomBuilder
    def self.build
      rooms = []

      (5..10).to_a.sample.times do
        room = nil
        loops = 0
        loop do
          loops += 1
          width = 4 + (rand * 10).round
          height = 5 + (rand * 10).round
          max_x = LEVEL_SIZE_X - width
          max_y = LEVEL_SIZE_Y - height
          x = (rand * max_x).round
          y = (rand * max_y).round

          room = [
            x,
            y,
            width,
            height,
          ]

          break unless rooms.any? { |r| r.intersect_rect?([x - 2, y - 2, width + 4, height + 4]) }
          if loops > 100
            puts "Failed to find a room after 100 tries"
            break
          end
        end

        rooms << room
      end

      rooms
    end
  end
end
