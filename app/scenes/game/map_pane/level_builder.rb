require 'app/scenes/game/map_pane/room_builder'
require 'app/scenes/game/map_pane/hallway_builder'

module Scenes::Game::MapPane
  module LevelBuilder
    def self.build
      level = LEVEL_SIZE_X.times.map { LEVEL_SIZE_Y.times.map { nil } }

      rooms = Scenes::Game::MapPane::RoomBuilder.build
      hallways = Scenes::Game::MapPane::HallwayBuilder.build(rooms)

      add_rooms(level, rooms)
      add_hallways(level, hallways)

      level
    end

    def self.add_rooms(level, rooms)
      rooms.each do |room|
        x, y, width, height = room

        (x..(x + width)).each do |curr_x|
          (y..(y + height)).each do |curr_y|
            key = if x == curr_x && y == curr_y
                    'wall_bottom_left'
                  elsif x == curr_x && y + height == curr_y
                    'wall_top_left'
                  elsif x + width == curr_x && y == curr_y
                    'wall_bottom_right'
                  elsif x + width == curr_x && y + height == curr_y
                    'wall_top_right'
                  elsif x == curr_x
                    'wall_side'
                  elsif x + width == curr_x
                    'wall_side'
                  elsif y == curr_y
                    'wall_top_bottom'
                  elsif y + height == curr_y
                    'wall_top_bottom'
                  else
                    'floor'
                  end

            add_tile(level, curr_x, curr_y, key)
          end
        end
      end
    end

    def self.add_hallways(level, hallways)
      hallways.each do |hallway|
        hallway_start, hallway_end = hallway
        puts "Hallway: #{hallway_start} -> #{hallway_end}"

        x1, y1 = hallway_start
        x2, y2 = hallway_end
        if x1 == x2
          min_y = [y1, y2].min
          max_y = [y1, y2].max

          (min_y..max_y).each do |y|
            add_tile(level, x1, y, 'hallway')
          end
        elsif y1 == y2
          min_x = [x1, x2].min
          max_x = [x1, x2].max

          (min_x..max_x).each do |x|
            add_tile(level, x, y1, 'hallway')
          end
        end
      end
    end

    def self.add_tile(level, x, y, key)
      level[x][y] = {
        key: key,
        visible: true,
      }
    end
  end
end
