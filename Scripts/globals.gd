extends Node

# Colors
var green_base = Color(0, 0.8, 0)
var green_selected = Color(0.4, 1, 0.4)
var red_base = Color(0.8, 0, 0)
var red_selected = Color(1, 0.4, 0.4)
var blue_base = Color(0, 0, 0.8)
var blue_selected = Color(0.4, 0.4, 1)
var gray_menu : Color
var gray_dots = Color(0.3, 0.3, 0.3)
var blue_background = Color(0.05, 0.08, 0.15)

# Sizes
var GRID_SIZE = 32
var DISPLAY_WIDTH = ProjectSettings.get("display/window/size/width")
var DISPLAY_HEIGHT = ProjectSettings.get("display/window/size/height")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
