require 'app/scenes/game/map'
require 'app/scenes/game/message_pane'

module Scenes
  module Game
    def self.tick(args)
      Map.tick(args)
      MessagePane.tick(args)
    end
  end
end
