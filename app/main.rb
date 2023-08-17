require 'app/chat_gpt/client.rb'
require 'app/constants.rb'
require 'app/sprite_lookup.rb'
require 'app/legend.rb'
require 'data/config.rb'

require "app/scenes/intro"
require "app/scenes/game"

def tick(args)
  args.state.chat_gpt_client ||= ChatGPT::Client.new(config[:chat_gpt_key])

  args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]

  if args.state.scene.nil?
    args.state.scene = :intro
  end

  case args.state.scene
  when :intro
    Scenes::Intro.tick(args)
  when :game
    Scenes::Game.tick(args)
  end
  # tick_game(args)
  # tick_legend(args) if SHOW_LEGEND && false
end

# McGuffin

def tick_game(args)
  # setup the grid
  args.state.grid.padding = 104
  args.state.grid.size = 512

  # set up your game
  # initialize the game/game defaults. ||= means that you only initialize it if
  # the value isn't alread initialized
  args.state.player.x ||= 0
  args.state.player.y ||= 0

  args.state.enemies ||= [
    { x: 10, y: 10, type: :goblin, tile_key: :G },
    { x: 15, y: 30, type: :rat,    tile_key: :R }
  ]

  args.state.info_messages ||= ["Use arrow keys to move around."]

  # handle keyboard input
  # keyboard input (arrow keys to move player)
  new_player_x = args.state.player.x
  new_player_y = args.state.player.y
  player_direction = ""
  player_moved = false
  if args.inputs.keyboard.key_down.up
    new_player_y += 1
    player_direction = "north"
    player_moved = true
  elsif args.inputs.keyboard.key_down.down
    new_player_y -= 1
    player_direction = "south"
    player_moved = true
  elsif args.inputs.keyboard.key_down.right
    new_player_x += 1
    player_direction = "east"
    player_moved = true
  elsif args.inputs.keyboard.key_down.left
    new_player_x -= 1
    player_direction = "west"
    player_moved = true
  end

  if args.inputs.mouse.click
    args.state.chat_gpt_client.completions(args, "If you were a fruit, which one would you be and why? Respond in haiku.")
  end

  #handle game logic
  # determine if there is an enemy on that square,
  # if so, don't let the player move there
  if player_moved
    found_enemy = args.state.enemies.find do |e|
      e[:x] == new_player_x && e[:y] == new_player_y
    end

    if !found_enemy
      args.state.player.x = new_player_x
      args.state.player.y = new_player_y
      args.state.info_messages << "You moved #{player_direction}."
    else
      args.state.info_messages << "You cannot move into a square an enemy occupies."
    end
  end

  args.outputs.sprites << tile_in_game(args.state.player.x,
                                       args.state.player.y, '@')

  # render game
  # render enemies at locations
  args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]

  args.outputs.sprites << args.state.enemies.map do |e|
    tile_in_game(e[:x], e[:y], e[:tile_key])
  end

  # render label stuff
  message_pane(args)

  draw_label args, 0, 0, "Response:", args.state.request_response_body

  if !args.state.openai_request.nil? && args.state.openai_request[:complete]
    data = args.gtk.parse_json(args.state.openai_request[:response_data])
    args.state.request_response_body = data["choices"][0]["message"]["content"]

    args.state.openai_request = nil
  end
end

def tile_in_game(x, y, tile_key)
  tile($gtk.args.state.grid.padding + x * DESTINATION_TILE_SIZE,
       $gtk.args.state.grid.padding + y * DESTINATION_TILE_SIZE,
       tile_key)
end

def message_pane(args)
  args.outputs.borders << [960, 0, 1280, 360, 255, 255, 255]
  args.state.info_messages.last(10).reverse.each_with_index do |message, index|
    draw_label args, 10 - index, 18, nil, message
  end
end

def draw_label(args, row, col, header, text)
  label_pos = args.layout.rect(row: row, col: col, w: 0, h: 0)
  output_text = header ? "#{header}\n\n#{text}" : text
  args.outputs.labels << output_text.wrapped_lines(80).map_with_index do |l, i|
    { x: label_pos.x, y: label_pos.y - (i * 15), text: l, size_enum: -2,
      r: 255,
      g: 255,
      b: 255,
      a: 255,
    }
  end
end
