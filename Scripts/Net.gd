extends Node2D

export var pads = []

onready var solved

# This stores the positions of all points in each subnet.
# If there is no subnet in the index, its value is null.  < - may be false
# The net is solved if there exists only one subnet.
var subnets = []

# Called when the node enters the scene tree for the first time.
func _ready():
	solved = false
	var options_panel = get_tree().get_root().find_node("OptionsPanel",true,false)
	options_panel.connect("change_color", self, "_on_change_color")
	
	for i in (pads.size()):
		subnets.append([get_node(pads[i]).position])
#	print("Subnets: " + String(subnets.size()))
#	print(subnets)
	
func _on_change_color():
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_net_solved(args):
#	print("signal arrived ", args[1])
	if name == args[0]:
		solved = args[1]

# I learned after a lot of trial and error that the _draw() function is set in
# stone when the object loads, and will repeat the same drawing from then on.
# The conditional statements here are useless
func _draw():
	for s1 in subnets.size() - 1:
		var min_dist = INF
		var min_pair
		for s2 in subnets.size() - (s1 + 1):
			s2 = s2 + (s1 + 1)
			for p1 in subnets[s1]:
				for p2 in subnets[s2]:
					if p1.distance_to(p2) < min_dist:
						min_dist = p1.distance_to(p2)
						min_pair = [p1, p2]
		draw_dashed_line(min_pair[0], min_pair[1], Globals.Colors[ConfigManager.color_palette].ratline, 2, 10)


# Credits for the function: https://github.com/juddrgledhill/godot-dashed-line
func draw_dashed_line(from, to, color, width, dash_length = 5, cap_end = false, antialiased = false):
	var length = (to - from).length()
	var normal = (to - from).normalized()
	var dash_step = normal * dash_length
	
	if length < dash_length: #not long enough to dash
		draw_line(from, to, color, width, antialiased)
		return

	else:
		var segment_start = from
		var steps = length/dash_length
		for _start_length in range(0, (steps + 2)/2):
			draw_line(segment_start, segment_start + dash_step, color, width, antialiased)
			segment_start += 2*dash_step
		
		if cap_end:
			draw_line(segment_start, to, color, width, antialiased)
