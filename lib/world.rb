require 'nokogiri'

class World
  attr_reader :zones
 
  def initialize(space)
    @zones = []
    @space = space
    #create_default_zone
    create_uniform_zones
  end
  
  def create_default_zone
    zone = Zone.new(@space, CP::Vec2.new(0.0, 0.0),
                    Properties::SCREEN_WIDTH,
                    Properties::SCREEN_HEIGHT)
    add_zone(zone)
  end
  
  def num_active_zones?
    num = 0
    @zones.each do |zone|
      if zone.active == true
        num += 1
      end
    end
    return num
  end
  
  def clear_world
    @zones.each do |zone|
      zone.clear_content!
    end
  end
  
  def save_to_xml
    res_textures = []
    res_audio_tracks = []
    res_audio_effects = []
    terrain_segments = []
    sprites = []
    
    zones.each do |zone|
      zone.terrain_segments.each do |terrain_segment|
        terrain_segments.push(terrain_segment)
      end
      zone.sprites.each do |sprite|
        sprites.push(sprite)
      end
    end
    
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.world {
      xml.actors {
        xml.brushes {
          xml.terrain_segments {
            terrain_segments.each do |terrain_segment|
              xml.terrain_segment {
                xml.position(:x => terrain_segment.position.x, :y => terrain_segment.position.y)
                terrain_segment.vertices.each do |vert|
                  xml.vertex(:x => vert.x, :y => vert.y)
                end
                xml.friction_ terrain_segment.friction
                if !res_textures.include?(terrain_segment.texture)
                  res_textures.push(terrain_segment.texture)
                end
                xml.texture(:id => res_textures.index(terrain_segment.texture))
              }
            end
          }
          xml.volumes {
            xml.water_volumes {
            }
            xml.slime_volumes {
            }
            xml.lava_volumes {
            }
          }
        }
        xml.sprites {
          sprites.each do |sprite|
            xml.sprite(:x => sprite.position.x, :y => sprite.position.y, :file => sprite.file)
          end
        }
        xml.decorations {
        }
        xml.lights {
          xml.static_lights {
          }
          xml.dynamic_lights {
          }
        }
        xml.navigation_points {
          xml.player_starts {
          }
          xml.teleporters {
          }
        }
        xml.pickups {
        }
        xml.triggers {
        }
      }
      xml.resources {
        xml.textures {
          res_textures.each do |texture|
            xml.texture(:id => res_textures.index(texture), :file => texture)
          end
        }
        xml.audio {
          xml.effects {
          }
          xml.tracks {
          }
        }
      }
    }
    end
    filename = "phusiondev"
    File.open("lib/world_" << filename << '.xml', 'w') {|f| f.write(builder.to_xml) }
  end
  
  def load_from_xml
    clear_world
    file = File.open("lib/world_phusiondev.xml")
    xml = Nokogiri::XML(file)
    file.close

    res_textures = []
    res_audio_effects = []
    res_audio_tracks = []
    
    #puts xml.css('textures').methods.sort
    xml.css('textures').children.each do |res_texture|
      res_textures.push(res_texture.attr(:file))
    end
    
    xml.css('terrain_segment').each do |terrain_segment|
      vertices = []
      friction = 1.0
      texture = nil
      position = CP::Vec2.new(0,0)
      
      terrain_segment.children.each do |child|
        if child.name == "position"
          position.x = child.attr(:x).to_f
          position.y = child.attr(:y).to_f
        end
        if child.name == "vertex"
          vertices.push(CP::Vec2.new(child.attr(:x).to_f, child.attr(:y).to_f))
        end
        if child.name == "friction"
          friction = child.content.to_f
        end
        if child.name == "texture"
          texture = res_textures[child.attr(:id).to_i]
        end
      end
      add_actor(TerrainSegment.new(position, vertices, friction, texture))
    end
    
    xml.css('sprite').each do |sprite|
      position = CP::Vec2.new(sprite.attr(:x).to_f, sprite.attr(:y).to_f)
      file = sprite.attr(:file)
      add_actor(Sprite.new($window, position, file))
    end
  end
  
  def create_uniform_zones
    zone_width = Properties::SCREEN_WIDTH * 3.0
    zone_height = Properties::SCREEN_HEIGHT * 3.0
    rows = 4
    columns = 20

    rows.times do |row|
      columns.times do |col|
        zone = Zone.new(@space, CP::Vec2.new((col * zone_width) - (zone_width * columns/2),
                                            (row * zone_height) - (zone_height * rows/2)),
                        zone_width, zone_height, "#{row},#{col}")
        add_zone(zone)
      end
    end  
  end
  
  def add_zone(zone)
    @zones.push(zone)
    clear_zone_adjacency
    calculate_zone_adjacency
  end
  
  def move_object_to_zone(object, zone)
  end
  
  def rezone_sprite(sprite)
    
  end
  
  
  def remove_sprite(sprite)
    
  end
  
  def create_segment(position)
    position = CP::Vec2.new(position.x, position.y)
    verts = [CP::Vec2.new(-16.0, -16.0), CP::Vec2.new(-16.0, 16.0), CP::Vec2.new(16.0, 16.0), CP::Vec2.new(16.0, -16.0)]
    friction = nil
    texture = nil
    segment = TerrainSegment.new(position, verts, friction, texture)
    add_actor(segment)
  end
  
  def create_sprite(position, file="media/sprite_default.bmp")
    position = CP::Vec2.new(position.x, position.y)
    sprite = Sprite.new($window, position, file)
    add_actor(sprite)
  end
  
  def add_actor(actor)
    actor.enable
    if !(@zones.length == 0)
      @zones.each do |zone|
        if zone.contains_actor?(actor)
          zone.add_actor(actor)
          break
        end
      end
    end  
  end
  
  def remove_terrain_segment(segment)
    @zones.each do |zone|
      if zone.contains_segment?(segment) || zone.terrain_segments.include?(segment)
        zone.remove_terrain_segment(segment)
        break
      end
    end
  end
  
  def deactivate_all_zones
    zones.each do |zone|
      zone.deactivate
    end
  end
  
  def clear_zone_adjacency
    @zones.each do |zone|
      zone.clear_adjacent_zones
    end
  end
  
  def calculate_zone_adjacency
    @zones.each do |zone_a|
      @zones.each do |zone_b|
        if !(zone_a == zone_b)
          if zone_a.adjacent_to?(zone_b)
            zone_a.add_adjacent_zone(zone_b)
          end
        end
      end
    end
  end
  
  def update
    
  end
end