module Properties
  SUBSTEPS = 6

  # Screen properties
  SCREEN_WIDTH = 640
  SCREEN_HEIGHT = 480
  
  # Player properties
  PLAYER_WIDTH = 16
  PLAYER_HEIGHT = 22
  PLAYER_OFFSET_X = 0
  PLAYER_OFFSET_Y = 0
  PLAYER_MASS = 2.0
  PLAYER_MOI = CP::INFINITY # Moment of inertia (infinity prevents body from rotating)
  PLAYER_SPRITE = "media/ropeman.bmp"
  
  # Sprite properties
  SPRITE_SMALL_WIDTH = 16
  SPRITE_SMALL_HEIGHT = 16
  SPRITE_SMALL_MASS = 0.5
  SPRITE_MEDIUM_WIDTH = 32
  SPRITE_MEDIUM_HEIGHT = 32
  SPRITE_MEDIUM_MASS = 2.0
  SPRITE_LARGE_WIDTH = 64
  SPRITE_LARGE_HEIGHT = 64
  SPRITE_LARGE_MASS = 8.0

  # Tile properties, all values are in pixel amounts
  TILE_WIDTH = 32
  TILE_HEIGHT = 32
  
  # Space properties
  GRAVITY = CP::Vec2.new(0.0, 0.8)
  DAMPING = 1.0
  
  # Force and velocity properties
  MAX_VELOCITY_X = 8.0
  MAX_VELOCITY_Y = 24.0
  MOVEMENT_FORCE = 64.0
  MOVEMENT_IMPULSE = 0.3
  JUMP_IMPULSE = 384.0
  
  # Camera properties
  CAMERA_PAN_SLOW = 1
  CAMERA_PAN_DEFAULT = 2
  CAMERA_PAN_FAST = 4
end 
