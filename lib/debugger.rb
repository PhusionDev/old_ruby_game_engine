class Debugger
  attr_accessor :collision_sprites
  attr_accessor :collision_terrain
  attr_accessor :velocity
  attr_accessor :position
  attr_accessor :camera_position
  
  def initialize
    @collision_sprites = false
    @collision_tiles = false
    @collision_terrain = false
    @velocity = false
    @position = false
    @camera_position = false
  end
  
  def collision_sprites?
    @collision_sprites
  end
  
  def collision_terrain?
    @collision_terrain
  end
  
  def velocity?
    @velocity
  end
  
  def position?
    @position
  end
  
  def camera_position?
    @camera_position
  end
end