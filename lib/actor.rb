class Actor
  attr_accessor :position, :can_teleport, :is_hidden, :selected

  def initialize(position, can_teleport=true, is_hidden=false)
    @position = position if position.is_a?(CP::Vec2)
    @position = CP::Vec2.new(0.0, 0.0) if !(position.is_a?(CP::Vec2))
    @can_teleport = can_teleport if !(can_teleport == nil)
    @can_teleport = true if can_teleport == nil
    @is_hidden = is_hidden if !(is_hidden == nil)
    @is_hidden = false if is_hidden == nil
    @selected = false
  end
end