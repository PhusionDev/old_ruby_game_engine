# This class needs a major overhaul!
# Any task not specifically related to displaying the contents
# of the world in which the camera is placed in and pointing
# at should be relocated to it's proper class or classes.
class Camera
  attr_reader :position
  attr_reader :window, :world
  attr_reader :style, :edit_mode
  attr_reader :current_zone, :last_known_zone, :zone_tag
  attr_reader :nearby_actor, :selected_actor, :selected_vertex
  
  def initialize(window, world)
    @window = window
    @world = world
    @position = CP::Vec2.new(0.0, 0.0)
    @style = CameraStyle::FREE
    @edit_mode = EditMode::NONE # *FIX* Edit mode should be within the controller
    get_current_zone
  end
  
  def change_style(style)
    @style = style
  end
  
  # The logic below should be handled by the controller, not the camera
  def change_edit_mode(mode)
    previous_mode = @edit_mode
    @edit_mode = mode
    if !(@selected_actor == nil)
      if mode == EditMode::VERTEX
        if @selected_actor.is_a?(Brush)
          @selected_vertex = 0
        else
          @edit_mode = previous_mode
        end
      else
        @selected_vertex = nil
      end
      look_at_selected
    end
  end
  
  # The logic below should be handled by the controller, not the camera
  def next_vertex
    if @edit_mode == EditMode::VERTEX && !(@selected_actor == nil)
      if !(@selected_vertex + 1 > @selected_actor.vertices.length - 1)
        @selected_vertex += 1
        look_at_selected
      else
        @selected_vertex = 0
        look_at_selected
      end
    end
  end
  
  def look_at_actor(actor)
    @position.x = actor.position.x
    @position.y = actor.position.y
  end
  
  def chase_actor!(actor)
    @position = actor.position
  end
  
  def look_at(vector)
    @position.x = vector.x
    @position.x = vector.y
  end
  
  def look_at_selected
    if @edit_mode == EditMode::OBJECT && !(@selected_actor == nil)
      @position = CP::Vec2.new(@selected_actor.position.x, @selected_actor.position.y)
    end
    
    if @edit_mode == EditMode::VERTEX && !(@selected_actor == nil)
      @position = CP::Vec2.new(@selected_actor.position.x + @selected_actor.vertices[@selected_vertex].x,
                               @selected_actor.position.y + @selected_actor.vertices[@selected_vertex].y)
    end
  end
  
  def pan_up(increment=Properties::CAMERA_PAN_DEFAULT)
    @position.y -= increment
    # The logic below should be handled by the controller, not the camera
    if !(@selected_actor == nil)
      if @edit_mode == EditMode::OBJECT 
        @selected_actor.position.y -= increment 
      elsif @edit_mode == EditMode::VERTEX
        @selected_actor.vertices[@selected_vertex].y -= increment
        @selected_actor.vertices[@selected_vertex].y += increment if !(CP::Shape::Poly.valid?(@selected_actor.vertices))
      end
      @selected_actor.update
    end
  end
 
  def pan_down(increment=Properties::CAMERA_PAN_DEFAULT)
  # The logic below should be handled by the controller, not the camera
    @position.y += increment
    if !(@selected_actor == nil)
      if @edit_mode == EditMode::OBJECT 
        @selected_actor.position.y += increment 
      elsif @edit_mode == EditMode::VERTEX
        @selected_actor.vertices[@selected_vertex].y += increment
        @selected_actor.vertices[@selected_vertex].y -= increment if !(CP::Shape::Poly.valid?(@selected_actor.vertices))
      end
      @selected_actor.update
    end
  end
 
  def pan_left(increment=Properties::CAMERA_PAN_DEFAULT)
    @position.x -= increment
    # The logic below should be handled by the controller, not the camera
     if !(@selected_actor == nil)
      if @edit_mode == EditMode::OBJECT 
        @selected_actor.position.x -= increment 
      elsif @edit_mode == EditMode::VERTEX
        @selected_actor.vertices[@selected_vertex].x -= increment
        @selected_actor.vertices[@selected_vertex].x += increment if !(CP::Shape::Poly.valid?(@selected_actor.vertices))
      end
      @selected_actor.update
    end
  end
 
  def pan_right(increment=Properties::CAMERA_PAN_DEFAULT)
    @position.x += increment
    # The logic below should be handled by the controller, not the camera
    if !(@selected_actor == nil)
      if @edit_mode == EditMode::OBJECT 
        @selected_actor.position.x += increment 
      elsif @edit_mode == EditMode::VERTEX
        @selected_actor.vertices[@selected_vertex].x += increment
        @selected_actor.vertices[@selected_vertex].x -= increment if !(CP::Shape::Poly.valid?(@selected_actor.vertices))
      end
      @selected_actor.update
    end
  end
 
  # The logic below should be handled by the controller, not the camera
  def translate_selected_actor(vector)
    @selected_actor.position += vector
  end
  
  # The logic below should be handled by the controller, not the camera
  def select_actor
    @selected_actor.selected = false if !(@selected_actor == nil)
    if !(@nearby_actor == nil)
      if nearby_actor?(@nearby_actor)
        @selected_actor = @nearby_actor
        @selected_actor.selected = true
      else
        @selected_actor = nil
        change_edit_mode(EditMode::NONE)
      end
    end
  end
  
  # The logic below should be handled by the controller, not the camera
  def delete_actor
    if @selected_actor.is_a?(TerrainSegment)
      @world.remove_terrain_segment(@selected_actor)
      @selected_actor = nil
    end
  end
  
  # The logic below should be handled by the controller, not the camera
  def nearby_actor?(actor)
    approx = 8.0
    dist_x = (@position.x - actor.position.x).abs
    dist_y = (@position.y - actor.position.y).abs
    if (dist_x <= approx) && (dist_y <= approx)
      return true
    else
      return false
    end
  end
  
  # The logic below should be handled by the controller, not the camera
  def translate_vector(vector)
    trans_vector = CP::Vec2.new(vector.x, vector.y)
    trans_x = @position.x - Properties::SCREEN_WIDTH/2
    trans_y = @position.y - Properties::SCREEN_HEIGHT/2
    trans_vector.x -= trans_x
    trans_vector.y -= trans_y
    return trans_vector
  end

  # The logic below should be handled by the controller, not the camera
  def translate_vectors(poly)
    trans_verts = []
    vertex = 0
    poly.shape.num_verts.times do
      trans_vert = translate_vector(poly.shape.vert(vertex))
      trans_verts.push(trans_vert)
      vertex += 1
    end
    return trans_verts
  end
  
  # The logic below should be handled by the controller, not the camera
  def near_actor?(actor)
    if actor.is_a?(TerrainSegment)
      return near_poly?(actor.shape)
    elsif actor.is_a?(Sprite)
      return near_sprite?(actor)
    end
    return false
  end
  
  # The logic below should be handled by the controller, not the camera
  def near_poly?(poly)
    poly_width = (poly.bb.l - poly.bb.r).abs
    poly_height = (poly.bb.t - poly.bb.b).abs
    poly_center = CP::Vec2.new(poly.bb.l + poly_width/2, poly.bb.b + poly_height/2)
    if (@position.x - poly_center.x).abs - poly_width/2 <= Properties::SCREEN_WIDTH/2
      if (@position.y - poly_center.y).abs - poly_height/2 <= Properties::SCREEN_HEIGHT/2
        return true
      end
    end
    return false
  end

  # The logic below should be handled by the controller, not the camera
  def near_sprite?(sprite)
    if (@position.x - sprite.position.x).abs <= Properties::SCREEN_WIDTH/2 + sprite.image.width/2
      if (@position.y - sprite.position.y).abs <= Properties::SCREEN_HEIGHT/2 + sprite.image.height/2
        return true
      end
    end
    return false
  end
  
  # The logic below should be handled by the controller, not the camera
  def near_zone?(zone)
    dist_threshold = CP::Vec2.new(0.0, 0.0)
    if (@position.x - zone.position.x).abs <= Properties::SCREEN_WIDTH/2 + zone.width/2 + dist_threshold.x
      if (@position.y - zone.position.y).abs <= Properties::SCREEN_HEIGHT/2 + zone.height/2 + dist_threshold.y
        return true
      end
    end
    return false
  end
  
  def in_zone?(zone)
    if (@position.x >= (zone.position.x - zone.width/2)) && (@position.x <= (zone.position.x + zone.width/2))
      if (@position.y >= (zone.position.y - zone.height/2)) && (@position.y <= (zone.position.y + zone.height/2))
        return true
      end
    end
    return false
  end
  
  def get_current_zone
    @world.zones.each do |zone|
      if in_zone?(zone)
        @current_zone = zone
        break
      end
    end
  end
  
  def in_which_adjacent_zone?
    @current_zone.adjacent_zones.each do |zone|
      if (@position.x >= (zone.position.x - zone.width/2)) && (@position.x <= (zone.position.x + zone.width/2))
        if (@position.y >= (zone.position.y - zone.height/2)) && (@position.y <= (zone.position.y + zone.height/2))  
          return zone
        end
      end
    end
    return nil
  end

  # The logic below should be handled by the controller, not the camera
  def insert_terrain_segment
    @world.create_segment(@position)
  end
  
  # The logic below should be handled by the controller, not the camera
  def insert_sprite
    @world.create_sprite(@position)
  end
  
  def draw_player
    trans_player = translate_vector(@player.shape.body.p)
    @player.image.draw_rot(trans_player.x, trans_player.y, ZOrder::Player,
                           @player.shape.body.a.radians_to_gosu)
    @polys_on_screen += 1
  end
  
  def draw_sprite(sprite)
    trans_vect = translate_vector(sprite.position)
    sprite.image.draw(trans_vect.x - sprite.image.width/2, trans_vect.y - sprite.image.height/2, ZOrder::Sprite)
  end
  
  def draw_selected_position
    $font.draw("#{@selected_actor.position.x.round.to_i},#{@selected_actor.position.y.round.to_i}",
               Properties::SCREEN_WIDTH/2 - 32, Properties::SCREEN_HEIGHT/2 - 50,
               ZOrder::UI, 1.0, 1.0, $font_color)
  end
  
  def draw_selected_vertex_position
    $font.draw("#{@selected_actor.vertices[@selected_vertex].x.round.to_i},#{@selected_actor.vertices[@selected_vertex].y.round.to_i}",
               Properties::SCREEN_WIDTH/2 - 32, Properties::SCREEN_HEIGHT/2 - 30,
               ZOrder::UI, 1.0, 1.0, $font_color)
  end
  
  def draw_zones
    draw_current_zone
    draw_adjacent_zones
    draw_all_zone_boundaries if $editor_enabled
  end
  
  def draw_zone(zone)
    zone.terrain_segments.each do |segment|
      if near_actor?(segment)
        @nearby_actor = segment if nearby_actor?(segment) && $editor_enabled
        draw_segment_collisions(segment)
        draw_actor_icon(segment) if $editor_enabled
        #draw_segment_texture(segment) if !(segment.texture == nil) && !(segment.texture == "")
        @polys_on_screen += 1
      end
    end
    zone.sprites.each do |sprite|
      if near_actor?(sprite)
        @nearby_actor = sprite if nearby_actor?(sprite) && $editor_enabled
        draw_sprite(sprite)
        draw_actor_icon(sprite) if $editor_enabled
      end
    end
  end
  
  def draw_current_zone
    #draw_zone_boundaries(@current_zone) if $editor_enabled
    if !(@current_zone == nil)
      if in_zone?(@current_zone) && @current_zone.active
        @zone_tag = @current_zone.tag
        draw_zone(@current_zone)
      elsif in_zone?(@current_zone) && !@current_zone.active
        @current_zone.activate
      elsif !in_zone?(@current_zone) && @current_zone.active
        @last_known_zone = @current_zone
        new_current_zone = in_which_adjacent_zone?
        if !(new_current_zone == nil)
          @current_zone = new_current_zone
          @last_known_zone == nil
        else
          # If the camera enters an non-zoned segment of space, draw the last known current zone
          draw_zone(@last_known_zone)
          @zone_tag = "Empty Space/No Zone"
        end
      end
    end
  end
  
  def draw_adjacent_zones
    @current_zone.adjacent_zones.each do |zone|
      if near_zone?(zone) and zone.active
        draw_zone(zone)
        #draw_zone_boundaries(zone) if $editor_enabled
      elsif near_zone?(zone) and !zone.active
        zone.activate
      elsif !near_zone?(zone) and zone.active
        zone.deactivate
      end
    end
  end
 
  #
  # Editor Draw Methods
  # 

  def draw_all_zone_boundaries
    @world.zones.each do |zone|
      draw_zone_boundaries(zone)
    end
  end
  
  def draw_zone_boundaries(zone)
    zone_left = zone.position.x - (zone.width/2.0)
    zone_right = zone.position.x + (zone.width/2.0)
    zone_top = zone.position.y - (zone.height/2.0)
    zone_bottom = zone.position.y + (zone.height/2.0)
    zone_verts = [CP::Vec2.new(zone_left, zone_top),
                  CP::Vec2.new(zone_right, zone_top),
                  CP::Vec2.new(zone_left, zone_bottom),
                  CP::Vec2.new(zone_right, zone_bottom)]
    trans_verts = []
    
    zone_verts.each do |vector|
      trans_vect = translate_vector(vector)
      
      # If any of the edges of a zone boundary are off-screen, we need to set their
      # positions to valid screen positions.
      trans_vect.x = 0.0 if trans_vect.x < 0.0
      trans_vect.x = Properties::SCREEN_WIDTH if trans_vect.x > Properties::SCREEN_WIDTH
      trans_vect.y = 0.0 if trans_vect.y < 0.0
      trans_vect.y = Properties::SCREEN_HEIGHT if trans_vect.y > Properties::SCREEN_HEIGHT
      
      # Add the translated vertex
      trans_verts.push(trans_vect)
    end
    
    # Assign a random color to the zone
    if zone.color == nil
      zone.color = Gosu::Color.new(192, 20 + rand(235), 40 + rand(20), 10 + rand(245))
    end
    
    # Draw the zone boundary on the screen
    @window.draw_quad(trans_verts[0].x, trans_verts[0].y, zone.color,
                      trans_verts[1].x, trans_verts[1].y, zone.color,
                      trans_verts[2].x, trans_verts[2].y, zone.color,
                      trans_verts[3].x, trans_verts[3].y, zone.color,
                      ZOrder::Zone)
  end
  
  # Debug Collisions
  def draw_segment_collisions(segment)
    vertex = 0
    segment.shape.num_verts.times do
    trans_start_vertex = translate_vector(segment.shape.vert(vertex))
      if !(vertex == segment.shape.num_verts - 1)
        trans_end_vertex = translate_vector(segment.shape.vert(vertex + 1))
      else
        trans_end_vertex = translate_vector(segment.shape.vert(0))
      end
      @window.draw_line(trans_start_vertex.x, trans_start_vertex.y, segment.brush_color?,
                        trans_end_vertex.x, trans_end_vertex.y, segment.brush_color?,
                        ZOrder::Terrain)
      vertex += 1
    end
  end
  
  def draw_actor_icon(actor)
    trans_vect = translate_vector(actor.position)
    $image_actor_icon.draw(trans_vect.x - 4, trans_vect.y - 4, ZOrder::UI)
  end
  
  def draw_brush_vertex
    trans_vect = translate_vector(CP::Vec2.new(@selected_actor.position.x + @selected_actor.vertices[@selected_vertex].x,
                                  @selected_actor.position.y + @selected_actor.vertices[@selected_vertex].y))
    $image_vertex.draw(trans_vect.x - 4, trans_vect.y - 4, ZOrder::UI)
  end
  
  def draw_segment_texture(segment)
    trans_verts = translate_vectors(segment)
    segment.image.draw_as_quad(trans_verts[3].x, trans_verts[3].y, Color::White,
                               trans_verts[0].x, trans_verts[0].y, Color::White,
                               trans_verts[1].x, trans_verts[1].y, Color::White,
                               trans_verts[2].x, trans_verts[2].y, Color::White,
                               ZOrder::UI)
  end
  
  def update
    if @style == CameraStyle::CHASE
      look_at_player
    end
    if !(@last_known_zone == nil)
      get_current_zone
    end
  end
  
  def draw
    @polys_on_screen = 0
    trans_start_vertex = CP::Vec2.new(0,0)
    trans_end_vertex = CP::Vec2.new(0,0)
    #draw_player
    draw_zones
    draw_debug  # *FIX* World and UI need to be separated
    draw_selected_position if (@edit_mode == EditMode::OBJECT) && !(@selected_actor == nil)
    if (@edit_mode == EditMode::VERTEX) && !(@selected_actor == nil)
      draw_selected_vertex_position 
      draw_brush_vertex
    end
  end
  
  # The logic below should be handled by the controller, not the camera
  # *FIX* World and UI need to be separated
  def draw_debug
    # Draw debugging information
    $font.draw("Objects on screen: #{@polys_on_screen}", 0, Properties::SCREEN_HEIGHT - 30, ZOrder::UI, 1.0, 1.0, $font_color)
    $font.draw("Camera Target: #{@position}", 0, Properties::SCREEN_HEIGHT - 14, ZOrder::UI, 1.0, 1.0, $font_color)
    $font.draw("Editing: #{$editor_enabled}", Properties::SCREEN_WIDTH/2, 10, ZOrder::UI, 1.0, 1.0, $font_color)
    #$font.draw("Current Zone: #{@current_zone}", 420, 10, ZOrder::UI, 1.0, 1.0, $font_color)
    $font.draw("Adjacent Zones: #{@current_zone.adjacent_zones.length}", 200, 30, ZOrder::UI, 1.0, 1.0, $font_color)
    #$font.draw("#{@zone_tag}", Properties::SCREEN_WIDTH/2 + 18, Properties::SCREEN_HEIGHT/2 - 2, ZOrder::UI, 1.0, 1.0, $font_color)
    $font.draw("Active Zones: #{@world.num_active_zones?}", 200, 50, ZOrder::UI, 1.0, 1.0, $font_color)
  end
end

module CameraStyle
  CHASE, FREE = *0..2
end

# The logic below should be handled by the controller, not the camera
# *FIX* EditMode should be a constant/property within the controller
module EditMode
  NONE, OBJECT, EDGE, VERTEX = *0..4
end
