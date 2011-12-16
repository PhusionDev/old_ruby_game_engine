class Interface
  attr_reader :elements
  attr_reader :offset_x, :offset_y
  
  def initialize(offset_x=0, offset_y=0)
    @elements = []
    @offset_x = offset_x
    @offset_y = offset_y
  end
  
  def add_element(element)
    @elements.push(element)
  end
  
  def remove_element(element)
    @elements.delete(element)
  end
  
  def update
    elements.each do |element|
    end
  end
  
  def draw
    elements.each do |element|
      if not element.is_hidden
      end
    end
  end
end

class InterfaceElement
  attr_reader :position_x, :position_y, :width, :height, :transparency, :is_hidden, :can_move
  
  def initialize(x=0, y=0, width=10, height=10, transparency=0, is_hidden=false, can_move=true)
    @position_x = x
    @position_y = y
    @width = width
    @height = height
    @transparency = transparency
    @is_hidden = is_hidden
    @can_move = can_move
  end
end

class InterfaceFrame < InterfaceElement
  attr_reader :elements
  
  def initialize(x=0, y=0, width=10, height=10, transparency=0, is_hidden=false, can_move=true)
    super(x,y,width,height,transparency,is_hidden,can_move)
    @elements = []
  end
  
  def update
    elements.each do |element|
    end
  end
end