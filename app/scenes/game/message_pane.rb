module Scenes::Game
  module MessagePane
    def self.tick(args)
      render(args)
    end

    def self.render(args)
      args.outputs.borders << [960, 0, 1280, 360, 255, 255, 255]

      message_row = 0
      args.state.messages&.reverse&.each do |message|
        message.wrapped_lines(40).reverse.each do |line|
          draw_label(args, message_row, line)
          message_row += 1
        end
      end
    end

    def self.draw_label(args, row, text)
      args.outputs.labels << {
        x: 980,
        y: 340 - row * 20,
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
