module Scenes::Game
  module Map
    PANE_RECT = [0, 0, 960, 720, 255, 255, 255]

    def self.tick(args)
      render(args)
    end

    def self.render(args)
      args.outputs.solids << PANE_RECT
    end
  end
end
