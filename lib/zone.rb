class Zone
  attr_reader :space
  attr_reader :position, :width, :height
  attr_reader :terrain_segments, :sprites
  attr_reader :adjacent_zones
  attr_reader :active
  attr_accessor :tag, :color
  
  def initialize(space, position=CP::Vec2.new(0,0), width=Properties::SCREEN_WIDTH, height=Properties::SCREEN_HEIGHT, tag="new_zone")
    @space = space
    @position = position
    @width = width
    @height = height
    clear_content!
    #@terrain_segments = []
    #@sprites = []
    @adjacent_zones = []
    @active = false
    @tag = tag
  end
  
  def clear_content!
    @terrain_segments = []
    @sprites = []
  end
  
  def adjacent_to?(zone)
    if (@position.x - zone.position.x).abs <= @width/2.0 + zone.width/2.0
      if (@position.y - zone.position.y).abs <= @height/2.0 + zone.height/2.0
        return true
      end
    end
    return false
  end
  
  def clear_adjacent_zones
    @adjacent_zones.clear
  end
  
  def add_sprite(sprite)
    @sprites.push(sprite)
  end

  def add_actor(actor)
    if actor.is_a?(Sprite)
      add_sprite(actor)
    elsif actor.is_a?(TerrainSegment)
      add_terrain_segment(actor)
    end
  end
  
  def remove_sprite(sprite)
    @sprites.delete(sprite)
  end
  
  def add_terrain_segment(segment)
    @terrain_segments.push(segment)
  end
  
  def remove_terrain_segment(segment)
    @terrain_segments.delete(segment)
  end
  
  def add_adjacent_zone(zone)
    @adjacent_zones.push(zone)
  end
  
  def activate
    enable_sprites
    enable_terrain_segments
    @active = true
  end
  
  def enable_sprites
    @sprites.each do |sprite|
      sprite.enable
    end
  end
  
  def enable_terrain_segments
    @terrain_segments.each do |segment|
      segment.enable
      add_to_space(segment)
    end
  end
  
  def deactivate
    disable_sprites
    disable_terrain_segments
    @active = false
  end
  
  def disable_sprites
    @sprites.each do |sprite|
      sprite.disable
    end
  end
  
  def disable_terrain_segments
    @terrain_segments.each do |segment|
      remove_from_space(segment)
      segment.disable
    end
  end
  
  def add_to_space(object)
    if object.is_a?(TerrainSegment)
      @space.add_shape(object.shape)
    end
  end
  
  def remove_from_space(object)
    if object.is_a?(TerrainSegment)
      @space.remove_shape(object.shape)
    end
  end
  
  def contains_actor?(actor)
    if actor.is_a?(Sprite)
      return contains_sprite?(actor)
    elsif actor.is_a?(TerrainSegment)
      return contains_segment?(actor)
    end
    return false
  end
  
  def contains_sprite?(sprite)
    if (@position.x - sprite.position.x).abs <= (@width/2 + sprite.image.width/2)
      if (@position.y - sprite.position.y).abs <= (@height/2 + sprite.image.height/2)
        return true
      end
    end
    return false
  end
  
  def contains_segment?(segment)
    #segment_width = (segment.shape.bb.l - segment.shape.bb.r).abs
    #segment_height = (segment.shape.bb.t - segment.shape.bb.b).abs
    #segment_center = CP::Vec2.new(segment.shape.bb.l + segment_width/2, segment.shape.bb.b + segment_height/2)
    if (@position.x - @width/2) <= segment.shape.bb.l
      if (@position.x + @width/2) >= segment.shape.bb.r
        if (@position.y - @height/2) <= segment.shape.bb.b
          if (@position.y + @height/2) >= segment.shape.bb.t
            return true
          end
        end
      end
    end
    return false
  end
end