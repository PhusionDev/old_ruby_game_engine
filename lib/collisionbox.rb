module CollisionBox
  PLAYER_FULL = [CP::Vec2.new(-Properties::PLAYER_HEIGHT/2.0, -Properties::PLAYER_WIDTH/2.0),
                 CP::Vec2.new(-Properties::PLAYER_HEIGHT/2.0, Properties::PLAYER_WIDTH/2.0),
                 CP::Vec2.new(Properties::PLAYER_HEIGHT/2.0, Properties::PLAYER_WIDTH/2.0),
                 CP::Vec2.new(Properties::PLAYER_HEIGHT/2.0, -Properties::PLAYER_WIDTH/2.0)]
            
  PLAYER_OFFSET = [CP::Vec2.new(-(Properties::PLAYER_HEIGHT/2.0 - Properties::PLAYER_OFFSET_Y),
                                -(Properties::PLAYER_WIDTH/2.0 - Properties::PLAYER_OFFSET_X)),
                   CP::Vec2.new(-(Properties::PLAYER_HEIGHT/2.0 - Properties::PLAYER_OFFSET_Y),
                                Properties::PLAYER_WIDTH/2.0 - Properties::PLAYER_OFFSET_X),
                   CP::Vec2.new(Properties::PLAYER_HEIGHT/2.0 - Properties::PLAYER_OFFSET_Y,
                                Properties::PLAYER_WIDTH/2.0 - Properties::PLAYER_OFFSET_X),
                   CP::Vec2.new(Properties::PLAYER_HEIGHT/2.0 - Properties::PLAYER_OFFSET_Y,
                                -(Properties::PLAYER_WIDTH/2.0 - Properties::PLAYER_OFFSET_X))]
            
  TILE = [CP::Vec2.new(-Properties::TILE_HEIGHT/2.0, -Properties::TILE_WIDTH/2.0),
          CP::Vec2.new(-Properties::TILE_HEIGHT/2.0, Properties::TILE_WIDTH/2.0),
          CP::Vec2.new(Properties::TILE_HEIGHT/2.0, Properties::TILE_WIDTH/2.0),
          CP::Vec2.new(Properties::TILE_HEIGHT/2.0, -Properties::TILE_WIDTH/2.0)]
          
  SPRITE_SMALL = []
  SPRITE_MEDIUM = []
  SPRITE_LARGE = []
end