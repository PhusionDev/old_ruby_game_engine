require 'rubygems'
require 'gosu'
require 'chipmunk'
require_relative 'lib/debugger'
require_relative 'lib/friction'
require_relative 'lib/numeric'
require_relative 'lib/properties'
require_relative 'lib/zorder'
require_relative 'lib/color'
require_relative 'lib/collisionbox'
require_relative 'lib/camera'
require_relative 'lib/gamewindow'
require_relative 'lib/player'
require_relative 'lib/world'
require_relative 'lib/terrainsegment'
require_relative 'lib/zone'

$version = "World Editor v003"

$debug = Debugger.new
#$debug.velocity = true
#$debug.position = true
#$debug.camera_position = true

$window = GameWindow.new
$window.show