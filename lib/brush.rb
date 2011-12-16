require_relative 'actor'

class Brush < Actor
  attr_accessor :vertices, :selected_vertex
  Default_Verts = [CP::Vec2.new(0.0, -16.0), CP::Vec2.new(-16.0, 16.0), CP::Vec2.new(16.0, 16.0)]

  def initialize(position, vertices)
    super(position)

    @selected_vertex = nil
    @vertices = vertices if !(vertices == nil)
    @vertices = Default_Verts if (vertices == nil)
  end
  
  def brush_color?
    return Color::Green if @selected
    return Color::Black if !@selected
  end
  
  def translate(vector)
    @position += vector
  end
  
  def modify_vertex(vertex, vector)
    @vertices[vertex] += vector
  end
  
  def select_vertex(position)
    approx = 4.0
    world = world_coords
    @vertices.each do |vert|
      if (position.x - world[vert].x <= approx) && (position.y - world[vert].y <= approx)
        @selected_vertex = vert
      end
    end
    @selected_vertex = nil
  end
  
  def world_coords
    world_verts = []
    @vertices.length.times do |vert|
      world_verts.push(CP::Vec2.new(vertices[vert].x + position.x, vertices[vert].y + position.y))
    end
    return world_verts
  end
end