require 'app/scenes/game/sprite_lookup.rb'

require 'app/scenes/game/map_pane'
require 'app/scenes/game/message_pane'

module Scenes
  module Game
    def self.tick(args)
      MapPane.tick(args)
      MessagePane.tick(args)
    end
  end
end
