require 'nokogiri'
require 'chipmunk'

file = File.open("lib/world_phusiondev.xml")
xml = Nokogiri::XML(file)
file.close

xml.css('terrain_segment').each do |terrain_segment|
  position = CP::Vec2.new(0,0)
  vertices = []
  friction = 1.0
  texture = nil

  terrain_segment.children.each do |child|
    if child.name == "position"
      position.x = child.attr(:x).to_f
      position.y = child.attr(:y).to_f
    end
    if child.name == "vertex"
      vertices.push(CP::Vec2.new(child.attr(:x).to_f, child.attr(:y).to_f))
    end
    if child.name == "friction"
      friction = child.content
    end
    if child.name == "texture" && !(child.content == "")
      texture = child.content
    end
  end
end