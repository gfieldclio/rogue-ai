module Scenes::Game
  module SpriteLookup
    SPRITE_MAP = {
      '@' => [4, 0],
      'A' => [4, 1],
      'B' => [4, 2],
      'C' => [4, 3],
      'D' => [4, 4],
      'E' => [4, 5],
      'F' => [4, 6],
      'G' => [4, 7],
      'H' => [4, 8],
      'I' => [4, 9],
      'J' => [4, 10],
      'K' => [4, 11],
      'L' => [4, 12],
      'M' => [4, 13],
      'N' => [4, 14],
      'O' => [4, 15],
      'P' => [5, 0],
      'Q' => [5, 1],
      'R' => [5, 2],
      'S' => [5, 3],
      'T' => [5, 4],
      'U' => [5, 5],
      'V' => [5, 6],
      'W' => [5, 7],
      'X' => [5, 8],
      'Y' => [5, 9],
      'Z' => [5, 10],
      'a' => [6, 1],
      'b' => [6, 2],
      'c' => [6, 3],
      'd' => [6, 4],
      'e' => [6, 5],
      'f' => [6, 6],
      'g' => [6, 7],
      'h' => [6, 8],
      'i' => [6, 9],
      'j' => [6, 10],
      'k' => [6, 11],
      'l' => [6, 12],
      'm' => [6, 13],
      'n' => [6, 14],
      'o' => [6, 15],
      'p' => [7, 0],
      'q' => [7, 1],
      'r' => [7, 2],
      's' => [7, 3],
      't' => [7, 4],
      'u' => [7, 5],
      'v' => [7, 6],
      'w' => [7, 7],
      'x' => [7, 8],
      'y' => [7, 9],
      'z' => [7, 10],
      '|' => [7, 12],
      'floor' => [2, 14],
      'wall_side' => [11, 3],
      'wall_top_bottom' => [12, 4],
      'wall_top_left' => [13, 10],
      'wall_top_right' => [11, 15],
      'wall_bottom_left' => [12, 0],
      'wall_bottom_right' => [13, 9],
      'hallway' => [2, 3],
    }

    def self.tile(x, y, key)
      tile_extended(x, y, DESTINATION_TILE_SIZE, DESTINATION_TILE_SIZE, TILE_R, TILE_G, TILE_B, TILE_A, key)
    end

    private def self.tile_extended(x, y, w, h, r, g, b, a, key)
      row, column = lookup(key)

      {
        x: x,
        y: y,
        w: w,
        h: h,
        tile_x: column * SOURCE_TILE_SIZE,
        tile_y: (row * SOURCE_TILE_SIZE),
        tile_w: SOURCE_TILE_SIZE,
        tile_h: SOURCE_TILE_SIZE,
        r: r,
        g: g,
        b: b,
        a: a,
        path: 'sprites/simple-mood-16x16.png'
      }
    end

    private def self.lookup(key)
      SPRITE_MAP[key]
    end
  end
end
