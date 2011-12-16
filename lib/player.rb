require_relative "sprite"

class Player < Sprite
  attr_accessor :last_touched_shape
  attr_accessor :can_jump
  
  def initialize(window, position=CP::Vec2(0.0, 0.0), vertices=CollisionBox::PLAYER_FULL,
                 mass=Properties::PLAYER_MASS, moi=Properties::PLAYER_MOI, friction=Friction::PLAYER,
                 v_limit=Properties::MAX_VELOCITY_Y, image_name=Properties::PLAYER_SPRITE)
    @window = window
    @position = position
    @vertices = vertices
    @mass = mass
    @moi = moi
    @friction = friction.to_f
    @v_limit = v_limit
    @image_name = image_name
    @image = nil
    @shape = nil
    @active = false
  end
end