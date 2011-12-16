require_relative 'brush'

class TerrainSegment < Brush
  attr_reader :shape, :friction, :texture, :image
  Default_Friction = 0.5
  
  def initialize(position, vertices, friction, texture)
    super(position, vertices)
    
    @friction = friction if !(friction == nil)
    @friction = Default_Friction if (friction == nil)
    if !(texture == nil)
      @texture = texture
    else
      @texture = "media/tex_default.bmp"
    end
  end
  
  def brush_color?
    return Color::Green if @selected
    return Color::Blue if !@selected
  end
  
  def enable
    @shape = CP::Shape::Poly.new(CP::StaticBody.new, @vertices, @position)
    @shape.u = friction
    @shape.collision_type = :terrain
    @image = Gosu::Image.new($window, texture, false)
  end
  
  def update
    disable
    enable
  end
  
  def disable
    @shape = nil
    @body = nil
    @image = nil
  end
end
