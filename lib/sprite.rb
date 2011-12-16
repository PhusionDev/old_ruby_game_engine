require_relative 'actor'

class Sprite < Actor
  attr_reader :file, :image

  def initialize(window, position, file)
    super(position)
    @window = window
    @file = file
    @image = nil
  end
  
  def enable
    @image = Gosu::Image.new(@window, @file, false)
  end
  
  def disable
    @image = nil
  end
  
  def update
    disable
    enable
  end
end