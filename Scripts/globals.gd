extends Node

# Colors
var Colors_base = {
	green_base = Color(0, 0.8, 0),
	green_selected = Color(0.15, 1, 0.15),
	red_base = Color(0.8, 0, 0),
	red_selected = Color(1, 0.1, 0.15),
	blue_base = Color(0, 0, 0.8),
	blue_selected = Color(0.4, 0.4, 1),
#	gray_menu : Color,
	gray_dots = Color(0.3, 0.3, 0.3),
	white_highlight = Color(1, 1, 1, 0.5),
	blue_background = Color(0.05, 0.08, 0.15),
	white_button = Color(1, 1, 1),
	gray_disabled = Color(0.3, 0.3, 0.3)
}

# Alternative Colors
var Colors_alt1 = {
	green_base = Color(0.2, 0.8, 0.4),
	green_selected = Color(0.15, 0.9, 0.15),
	red_base = Color(0.8, 0.4, 0.2),
	red_selected = Color(0.9, 0.1, 0.15),
	blue_base = Color(0, 0, 0.8),
	blue_selected = Color(0.4, 0.4, 1),
#	gray_menu : Color,
	gray_dots = Color(0.7, 0.7, 0.7),
	white_highlight = Color(0.2, 0.2, 0.2, 0.5),
	blue_background = Color(0.9, 0.9, 0.9),
	white_button = Color(1, 1, 1),
	gray_disabled = Color(0.3, 0.3, 0.3)
}

var Colors = Colors_base

func set_colors(x):
	Colors = x

# Sizes
var GRID_SIZE = 32
var DISPLAY_WIDTH = ProjectSettings.get("display/window/size/width")
var DISPLAY_HEIGHT = ProjectSettings.get("display/window/size/height")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func level_number_to_code(level_number):
	return String(ceil(float(level_number)/4)) + " - " + String((level_number-1)%4 + 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
