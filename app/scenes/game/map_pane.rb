require 'app/scenes/game/map_pane/level_builder'

module Scenes::Game
  module MapPane
    PANE_RECT = [0, 0, 960, 720, 255, 255, 255]
    MAX_X = (960 / DESTINATION_TILE_SIZE).to_i
    MAX_Y = (720 / DESTINATION_TILE_SIZE).to_i

    def self.tick(args)
      init(args)
      handle_input(args)

      render(args)
    end

    def self.init(args)
      args.state.current_level ||= 0
      args.state.levels ||= []

      args.state.levels[args.state.current_level] = LevelBuilder.build if args.state.levels[args.state.current_level].nil?
    end

    def self.handle_input(args)
      if args.inputs.keyboard.key_down.up
        args.state.y_pos += 1
      elsif args.inputs.keyboard.key_down.down
        args.state.y_pos -= 1
      elsif args.inputs.keyboard.key_down.left
        args.state.x_pos -= 1
      elsif args.inputs.keyboard.key_down.right
        args.state.x_pos += 1
      end

      args.state.x_pos = [0, args.state.x_pos].max
      args.state.y_pos = [0, args.state.y_pos].max
      args.state.x_pos = [args.state.x_pos, 100 - MAX_X].min
      args.state.y_pos = [args.state.y_pos, 100 - MAX_Y].min
    end

    def self.render(args)
      MAX_X.times do |x|
        x_pos = x + args.state.x_pos
        MAX_Y.times do |y|
          y_pos = y + args.state.y_pos
          next unless args.state.levels[args.state.current_level].dig(x_pos, y_pos)

          tile = args.state.levels[args.state.current_level][x_pos][y_pos]
          if tile[:visible]
            args.outputs.sprites << SpriteLookup.tile(x * DESTINATION_TILE_SIZE, y * DESTINATION_TILE_SIZE, tile[:key])
          end

          args.outputs.sprites << tile
        end
      end
    end
  end
end
