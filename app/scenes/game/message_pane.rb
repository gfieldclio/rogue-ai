module Scenes::Game
  module MessagePane
    PANE_RECT = [960, 0, 1280, 360, 255, 255, 255]

    def self.tick(args)
      init(args)
      handle_input(args)
      render(args)
    end

    def self.init(args)
      args.state.message_offset ||= 0
      args.state.messages ||= [
        "You, #{args.state.game_details["hero"]}, have finally arrived at the entrance to #{args.state.game_details["dungeon"]} and begin your quest to retrieve #{args.state.game_details["mcguffin"]}.",
      ]
    end

    def self.handle_input(args)
      return unless args.inputs.mouse.point.inside_rect?(PANE_RECT)
      return if args.inputs.mouse.wheel.nil?

      args.state.message_offset += args.inputs.mouse.wheel.y
      args.state.message_offset = args.state.messages.length - 1 if args.state.message_offset >= args.state.messages.length
      args.state.message_offset = 0 if args.state.message_offset < 0
    end

    def self.render(args)
      args.outputs.borders << PANE_RECT

      message_row = 0
      args.state.messages.reverse.drop(args.state.message_offset).each do |message|
        "> #{message}".wrapped_lines(35).reverse.each do |line|
          draw_label(args, message_row, line)
          message_row += 1

          return if message_row > 16
        end
      end
    end

    def self.draw_label(args, row, text)
      args.outputs.labels << {
        x: 980,
        y: 30 + row * 20,
        text: text,
        size_enum: -2,
        r: 255,
        g: 255,
        b: 255,
        a: 255,
      }
    end
  end
end
