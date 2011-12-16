class GameWindow < Gosu::Window
  def initialize
    super(Properties::SCREEN_WIDTH, Properties::SCREEN_HEIGHT, false, 16)
    self.caption = "#{$version}"
    $font = Gosu::Font.new(self, Gosu::default_font_name, 14)
    $font_color = Color::Black
    @image_grid = Gosu::Image.new(self, "media/grid.png", false)
    @image_xhair = Gosu::Image.new(self, "media/xhair.bmp", false)
    $image_vertex = Gosu::Image.new(self, "media/vertex.bmp", false)
    $image_actor_icon = Gosu::Image.new(self, "media/actor.bmp", false)
    $editor_enabled = false
    @dt = (1.0/60.0)
    @space = CP::Space.new
    @world = World.new(@space)
    @camera = Camera.new(self, @world)
    define_space_properties
    define_collision_funcs
  end
  
  def define_collision_funcs
    @space.add_collision_func(:sprite, :terrain) do |sprite, terrain|
      @player.last_touched_shape = terrain
    end
      
    @space.add_collision_func(:terrain, :terrain, &nil)
  end
  
  def define_space_properties
    @space.gravity = Properties::GRAVITY
    @space.damping = Properties::DAMPING
  end
  
  def enable_editor
    @camera.change_style(CameraStyle::FREE)
    $editor_enabled = true
  end
  
  def disable_editor
    @camera.change_style(CameraStyle::CHASE)
    $editor_enabled = false
  end
  
  def check_input_physics
    if !$editor_enabled
      if button_down? Gosu::KbLeft
        #@player.move_backward
      end
      if button_down? Gosu::KbRight
        #@player.move_forward
      end
    end
  end
  
  def check_input
    if $editor_enabled
      check_input_editor
    else
      check_input_game
    end
  end
  
  def check_input_game
  end
  
  def check_input_editor
    speed_mod = 1.0
    if button_down? Gosu::KbLeftShift
      speed_mod *= 3.0
      if button_down? Gosu::KbLeftControl
        speed_mod *= 5.0
      end
    end
    if button_down? Gosu::KbLeft
      @camera.pan_left(Properties::CAMERA_PAN_DEFAULT * speed_mod)
    end
    if button_down? Gosu::KbRight
      @camera.pan_right(Properties::CAMERA_PAN_DEFAULT * speed_mod)
    end
    if button_down? Gosu::KbUp
      @camera.pan_up(Properties::CAMERA_PAN_DEFAULT * speed_mod)
    end
    if button_down? Gosu::KbDown
      @camera.pan_down(Properties::CAMERA_PAN_DEFAULT * speed_mod)
    end
  end
  
  def update 
    # Update Chipmunk Physics objects
    Properties::SUBSTEPS.times do
      #needs a method to reset forces on all players and npcs
      check_input_physics
      @space.step(@dt)
    end
    
    check_input
    @camera.update
  end

  def draw
    @image_grid.draw(0, 0, ZOrder::Background)
    @image_xhair.draw(Properties::SCREEN_WIDTH/2 - 8, Properties::SCREEN_HEIGHT/2 - 8, ZOrder::UI) 
    @camera.draw
    draw_debug
  end
  
  def draw_debug
    if $debug.position?
      $font.draw("Player Position: #{@player.shape.body.p}", 10, 10, ZOrder::UI, 1.0, 1.0, $font_color)
    end
    if $debug.velocity?
      $font.draw("Velocity: #{@player.shape.body.v}", 10, 30, ZOrder::UI, 1.0, 1.0, $font_color)
    end
    if $debug.camera_position?
      $font.draw("Camera Target: #{@camera.position}", 0, Properties::SCREEN_HEIGHT - 14,
                 ZOrder::UI, 1.0, 1.0, $font_color)
    end
    $font.draw("FPS: #{Gosu::fps()}", 500, 0, ZOrder::UI, 1.0, 1.0, $font_color)
  end
  
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
    if id == Gosu::KbE
      if !$editor_enabled
        enable_editor
      else
        disable_editor
      end
    end
    
    if !$editor_enabled
      if id == Gosu::KbSpace
        @player.jump
      end
    else
      if id == Gosu::KbNumpad8
        @camera.pan_up(Properties::CAMERA_PAN_SLOW)
      end
      if id == Gosu::KbNumpad2
        @camera.pan_down(Properties::CAMERA_PAN_SLOW)
      end
      if id == Gosu::KbNumpad4
        @camera.pan_left(Properties::CAMERA_PAN_SLOW)
      end
      if id == Gosu::KbNumpad6
        @camera.pan_right(Properties::CAMERA_PAN_SLOW)
      end
      if id == Gosu::KbSpace
        @camera.select_actor
      end
      if id == Gosu::KbM
        if !(@camera.edit_mode == EditMode::OBJECT)
          @camera.change_edit_mode(EditMode::OBJECT)
        else
          @camera.change_edit_mode(EditMode::NONE)
        end
      end
      if id == Gosu::KbV
        if !(@camera.edit_mode == EditMode::VERTEX)
          @camera.change_edit_mode(EditMode::VERTEX)
        else
          @camera.change_edit_mode(EditMode::NONE)
        end
      end
      if id == Gosu::KbL
        @world.load_from_xml
      end
      if id == Gosu::KbTab
        @camera.next_vertex
      end
      if id == Gosu::KbA
        @camera.insert_terrain_segment
      end
      if id == Gosu::KbP
        @camera.insert_sprite
      end
      if id == Gosu::KbS
        @world.save_to_xml
      end
      if id == Gosu::KbDelete
        @camera.delete_actor
      end
    end
  end
end