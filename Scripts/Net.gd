extends Node2D

export var pads = []

onready var solved

# Called when the node enters the scene tree for the first time.
func _ready():
	solved = false
	var options_panel = get_tree().get_root().find_node("OptionsPanel",true,false)
	options_panel.connect("change_color", self, "_on_change_color")
	
func _on_change_color():
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_net_solved(args):
#	print("signal arrived ", args[1])
	if name == args[0]:
		solved = args[1]

# I learned after a lot of trial and error that the _draw() function is set in stone
# when the object loads, and will repeat the same drawing from then on.
# The conditional statements here are useless
func _draw():
	if pads.size() >= 2:
		for i in (pads.size() - 1):
			if !solved:
				draw_dashed_line(get_node(pads[i]).position, get_node(pads[i+1]).position, Globals.Colors[ConfigManager.color_palette].blue_selected, 2, 10)
			else:
				print("net solved")

# Credits for the function: https://github.com/juddrgledhill/godot-dashed-line
func draw_dashed_line(from, to, color, width, dash_length = 5, cap_end = false, antialiased = false):
	var length = (to - from).length()
	var normal = (to - from).normalized()
	var dash_step = normal * dash_length
	
	if length < dash_length: #not long enough to dash
		draw_line(from, to, color, width, antialiased)
		return

	else:
		var draw_flag = true
		var segment_start = from
		var steps = length/dash_length
		for _start_length in range(0, steps + 1):
			var segment_end = segment_start + dash_step
			if draw_flag:
				draw_line(segment_start, segment_end, color, width, antialiased)

			segment_start = segment_end
			draw_flag = !draw_flag
		
		if cap_end:
			draw_line(segment_start, to, color, width, antialiased)
