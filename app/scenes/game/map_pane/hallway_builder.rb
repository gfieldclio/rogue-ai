module Scenes::Game::MapPane
  module HallwayBuilder
    def self.build(rooms)
      hallways = []
      unconnected_rooms = rooms.dup
      connected_rooms = [unconnected_rooms.shift]

      unconnected_rooms.each do |room|
        connected_room = connected_rooms.sample
        connected_rooms << room

        room_door_direction = door_direction(from: room, to: connected_room)
        connected_room_door_direction = door_direction(from: connected_room, to: room)

        room_door_location = door_location(room, room_door_direction)
        connected_room_door_location = door_location(connected_room, connected_room_door_direction)

        connect_rooms(
          hallways: hallways,
          from: room_door_location,
          from_direction: room_door_direction,
          to: connected_room_door_location,
          to_direction: connected_room_door_direction,
        )
      end

      hallways
    end

    def self.door_direction(from:, to:)
      from_x, from_y, from_width, from_height = from
      to_x, to_y, to_width, to_height = to

      [:left, :right, :above, :below].shuffle.find do |direction|
        case direction
        when :left
          from_x > to_x + to_width
        when :right
          from_x + from_width < to_x
        when :above
          from_y + from_height < to_y
        when :below
          from_y > to_y + to_height
        end
      end
    end

    def self.door_location(room, direction)
      x, y, width, height = room

      case direction
      when :left
        [x, y + 1 + (rand * (height - 2)).round]
      when :right
        [x + width, y + 1 + (rand * (height - 2)).round]
      when :above
        [x + 1 + (rand * (width - 2)).round, y + height]
      when :below
        [x + 1 + (rand * (width - 2)).round, y]
      end
    end

    def self.connect_rooms(hallways:, from:, from_direction:, to:, to_direction:)
      from_x, from_y = from
      to_x, to_y = to
      min_x = [from_x, to_x].min
      max_x = [from_x, to_x].max
      min_y = [from_y, to_y].min
      max_y = [from_y, to_y].max

      if from_direction == :left && to_direction == :right || from_direction == :right && to_direction == :left
        connection_x = min_x + ((max_x - min_x) * rand).round
        connection_x = [min_x + 1, connection_x].max
        connection_x = [max_x - 1, connection_x].min

        hallways << [[from_x, from_y], [connection_x, from_y]]
        hallways << [[connection_x, from_y], [connection_x, to_y]]
        hallways << [[connection_x, to_y], [to_x, to_y]]
      elsif from_direction == :above && to_direction == :below || from_direction == :below && to_direction == :above
        connection_y = min_y + ((max_y - min_y) * rand).round
        connection_y = [min_y + 1, connection_y].max
        connection_y = [max_y - 1, connection_y].min

        hallways << [[from_x, from_y], [from_x, connection_y]]
        hallways << [[from_x, connection_y], [to_x, connection_y]]
        hallways << [[to_x, connection_y], [to_x, to_y]]
      else
        if from_direction == :left || from_direction == :right
          hallways << [[from_x, from_y], [to_x, from_y]]
        else
          hallways << [[from_x, from_y], [from_x, to_y]]
        end

        if to_direction == :left || to_direction == :right
          hallways << [[to_x, to_y], [from_x, to_y]]
        else
          hallways << [[to_x, to_y], [to_x, from_y]]
        end
      end
    end
  end
end
