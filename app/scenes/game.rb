require 'app/scenes/game/message_pane'

module Scenes
  module Game
    def self.tick(args)
      MessagePane.tick(args)

      render(args)
    end

    def self.render(args)
    end
  end
end
