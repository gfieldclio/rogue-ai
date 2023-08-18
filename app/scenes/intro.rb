module Scenes
  module Intro
    def self.tick(args)
      return skip_to_game(args) if false

      if args.state.tick_count == 0
        prompt_for_game_details(args)
      end

      handle_prompt_results(args)
      handle_input(args)

      render(args)
    end

    def self.skip_to_game(args)
      args.state.game_details = {
        "genre" => "sci-fi",
        "mcguffin" => "The Amulet of Yendor",
        "hero" => "The Last Unicorn",
        "dungeon" => "The Pits of Despair",
        "backstory" => "A long time ago in a galaxy far, far away..."
      }
      args.state.scene = :game
    end

    def self.prompt_for_game_details(args)
      prompt = <<-PROMPT
      Choose a genre for your game (eg. sci-fi, steam-punk, horror). Then, based on the genre, pick a McGuffin (eg.
      The Amulet of Yendor, the last peanut). Then pick a type of dungeon where the McGuffin would be stored (The Pits
      of Despair, The Tower of Eternity). Finally write a backstory for why someone would be on a quest to retrieve said
      item.

      Respond using a JSON object with the following format:
      {
        "genre": "sci-fi",
        "mcguffin": "The Amulet of Yendor",
        "hero": "The Last Unicorn",
        "dungeon": "The Pits of Despair",
        "backstory": "A long time ago in a galaxy far, far away..."
      }
      PROMPT
      args.state.game_details_request = args.state.chat_gpt_client.completions(args, prompt, max_tokens: 500)
    end

    def self.handle_prompt_results(args)
      if args.state.game_details_request[:complete]
        data = args.gtk.parse_json(args.state.game_details_request[:response_data])
        args.state.game_details = args.gtk.parse_json(data["choices"][0]["message"]["content"])

        if args.state.game_details.nil?
          prompt_for_game_details(args)
        else
          puts args.state.game_details
          args.state.game_details_request = nil
        end
      end
    end

    def self.handle_input(args)
      if args.inputs.keyboard.key_down.enter && !args.state.game_details.nil?
        args.state.scene = :game
      end
    end

    def self.render(args)
      if args.state.game_details.nil?
        render_label(args, "Loading...", 640, 360)
      else
        render_label(args, args.state.game_details["backstory"], 640, 600)
        render_label(args, "[ Press Enter to continue ]", 640, 100)
      end
    end

    private def self.render_label(args, text, x, y)
      text.wrapped_lines(80).map_with_index do |line, i|
        args.outputs.labels << {
          x: x,
          y: y - (i * 30),
          text: line,
          alignment_enum: ALIGNMENT_ENUM[:center],
          r: 255,
          g: 255,
          b: 255,
          a: 255,
        }
      end
    end
  end
end
