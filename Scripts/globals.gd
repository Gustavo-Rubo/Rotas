extends Node

# Dictionary with all levels, and what is their following level
var levels = {
	"1_1": { "next_level_code": "1_2" },
	"1_2": { "next_level_code": "1_3" },
	"1_3": { "next_level_code": "1_4" },
	"1_4": { "next_level_code": "2_1" },
	"2_1": { "next_level_code": "2_2" },
	"2_2": { "next_level_code": null },
}

# Colors

enum {
	PALETTE_DARK,
	PALETTE_LIGHT,
	PALETTE_MONOKAI
}

var Colors = [
	# Base colors (DARK_PALETTE)
	{
		green_base = Color(0, 0.8, 0),
		bend_color = Color(0, 0.8, 0),
#		green_selected = Color(0.15, 1, 0.15),
		red_base = Color(0.8, 0, 0),
#		red_selected = Color(1, 0.1, 0.15),
		blue_base = Color(0, 0, 0.8),
		blue_selected = Color(0.4, 0.4, 1),
	#	gray_menu : Color,
		gray_dots = Color(0.3, 0.3, 0.3),
		white_highlight = Color(1, 1, 1, 0.5),
		blue_background = Color(0.05, 0.08, 0.15),
		white_button = Color(1, 1, 1),
		gray_disabled = Color(0.3, 0.3, 0.3),
		star_filled = Color(0.94, 0.81, 0.29),
		star_blank = Color(0.61, 0.61, 0.61),
		text1 = Color(0.95, 0.95, 0.95),
		text2 = Color(0.66, 0.66, 0.66)
	},

	# Alternative Colors (PALETTE_LIGHT)
	{
		green_base = Color(0.2, 0.8, 0.4),
		bend_color = Color(0.2, 0.8, 0.4),
#		green_selected = Color(0.15, 0.9, 0.15),
		red_base = Color(0.8, 0.4, 0.2),
#		red_selected = Color(0.9, 0.1, 0.15),
		blue_base = Color(0, 0, 0.8),
		blue_selected = Color(0.4, 0.4, 1),
	#	gray_menu : Color,
		gray_dots = Color(0.7, 0.7, 0.7),
		white_highlight = Color(0.2, 0.2, 0.2, 0.5),
		blue_background = Color(0.9, 0.9, 0.9),
		white_button = Color(0.3, 0.3, 0.3),
		gray_disabled = Color(0.7, 0.7, 0.7),
		star_filled = Color(0.85, 0.85, 0.00),
		star_blank = Color(0.61, 0.61, 0.61),
		text1 = Color(0.3, 0.3, 0.3),
		text2 = Color(0.5, 0.5, 0.5)
	},
	
	# Monokai (PALETTE_MONOKAI)
	{
		green_base = Color(0.65, 0.89, 0.18),
		bend_color = Color(0.65, 0.89, 0.18),
#		green_selected = Color(0.15, 0.9, 0.15),
		red_base = Color(0.98, 0.15, 0.45),
#		red_selected = Color(0.9, 0.1, 0.15),
		blue_base = Color(0.40, 0.84, 0.94),
		blue_selected = Color(0.40, 0.84, 0.94),
	#	gray_menu : Color,
		gray_dots = Color(0.7, 0.7, 0.7),
		white_highlight = Color(1, 1, 1, 0.5),
		blue_background = Color(0.15, 0.16, 0.13),
		white_button = Color(1, 1, 1),
		gray_disabled = Color(0.3, 0.3, 0.3),
		star_filled = Color(0.99, 0.59, 0.12),
		star_blank = Color(0.61, 0.61, 0.61),
		text1 = Color(0.95, 0.95, 0.95),
		text2 = Color(0.66, 0.66, 0.66)
		# orange FD971F
		# purple ae81ff
	},
]

# Sizes
var GRID_SIZE = 32
var DISPLAY_WIDTH = ProjectSettings.get("display/window/size/width")
var DISPLAY_HEIGHT = ProjectSettings.get("display/window/size/height")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func level_number_to_code(level_number):
	return String(ceil(float(level_number)/4)) + " - " + String((level_number-1)%4 + 1)

func level_code_to_text(level_code):
	return level_code[0] + " - " + level_code[2]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
