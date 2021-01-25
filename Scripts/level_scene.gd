extends Node2D

export (int) var level_number

export (float) var goal_trace_length = 1
export (float) var max_trace_length = 1
var used_trace_length = 0

export var nets = []
var traces = []
var trace
var bend_point
var current_trace
var current_bend_point
var trace_is_selected = false
var is_pressed = false
var is_first_section_of_trace = false

onready var level_label = $LblNumber

# Called when the node enters the scene tree for the first time.
func _ready():
	
	goal_trace_length = 10
	used_trace_length = 0
	
	trace = load("res://Scenes/trace.tscn")
	bend_point = load("res://Scenes/bend_point.tscn")
	
	level_label.text = String(level_number)
	
#	traces = GameDataManager.level_info[level_number].traces

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	
	if is_pressed:
		if current_bend_point:
			var pos = Vector2(get_global_mouse_position().x - fmod(get_global_mouse_position().x, Globals.GRID_SIZE),
			get_global_mouse_position().y - fmod(get_global_mouse_position().y, Globals.GRID_SIZE))
			current_bend_point.position = pos
			current_trace.sync_trace_to_bend_points()
			current_trace.update_collision()
			
			$GuideLines.position = pos
			$GuideLines.visible = true
			
	else:
		$GuideLines.visible = false
	update_solve()


# Here i iterate through all the pads to find what traces belong to which nets
# This solution is wrong, and won't handle complex cases correctly
# But the correct solution is recursive, so i'll leave that for later
func update_solve():
	if (traces + [current_trace]).size() >= 2:
		for t in (traces + [current_trace]):
			if t != null:
				t.nets = []
		for n in nets.size():
			var net = get_node(nets[n])
			for p in net.pads:
				var pad = net.get_node(p)
				for trace_area in pad.get_node("Area2D").get_overlapping_areas():
					if !trace_area.get_parent().nets.has(n):
						trace_area.get_parent().nets.append(n)
		for t in (traces + [current_trace]):
			if t != null:
				for trace_area in t.get_node("Area2D").get_overlapping_areas():
					# Only check for other traces, not pads:
					if trace_area.get_parent().name == "Trace":
						t.nets += not_repeated(t.nets, trace_area.get_parent().nets)
						trace_area.get_parent().nets += not_repeated(trace_area.get_parent().nets, t.nets)
		for t in (traces + [current_trace]):
			if t != null:
				if t.nets.size() >= 2:
					t.set_color("red")
				else:
					t.set_color("green")
				t.get_node("LabelNets").text = String(t.nets)


# Auxiliary function that return valus in array b that don't appear in array a
func not_repeated(old, new):
	var dif = []
	for n in new:
		if !old.has(n):
			dif.append(n)
	return dif
		
func calculate_used_trace_length():
	used_trace_length = 0
	if current_trace:
		used_trace_length = current_trace.get_length()
	for t in traces:
		used_trace_length += t.get_length()
	get_node("ProgressBar").value = 100*(used_trace_length/max_trace_length)
	
func complete_level():
	if used_trace_length < GameDataManager.level_info[level_number].low_score:
		GameDataManager.level_info[level_number].low_score = used_trace_length
	
	# Next level is unlocked:
	if !GameDataManager.level_info.has(level_number + 1):
		GameDataManager.level_info[level_number + 1] = {
			"unlocked": true,
			"low_score": INF,
			"star": false
#			"traces": traces
		}
		
	GameDataManager.save_data()
	
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/level_select_scene.tscn")

func _on_BtnPassar_pressed():
	used_trace_length = goal_trace_length + 1
	complete_level()

func _on_BtnGanhar_pressed():
	used_trace_length = goal_trace_length - 1
	complete_level()

func _on_BtnVoltar_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/level_select_scene.tscn")

# Manage inputs
func _on_Background_gui_input(event):
	if event is InputEventMouseButton:
		
		if !trace_is_selected:
			for i in traces.size():
				if (traces[i].check_click(event.position)):
					trace_is_selected = true
					current_trace = traces[i]
					current_trace.is_selected = true
					current_trace.default_color = Globals.green_selected
					get_node("TraceEditButtons").visible = true
					traces.remove(i)
					return
		

		var pos = Vector2(event.position.x - fmod(event.position.x, 20),
			event.position.y - fmod(event.position.y, 20))
		if event.pressed:
			
			is_pressed = true
				
			# If pressed while trace is not selected: create new trace
			if (!trace_is_selected):
				
				trace_is_selected = true
				get_node("TraceEditButtons").visible = true
				
				current_trace = trace.instance()
				add_child(current_trace)
				
				# Add a label for easier debugging:
				current_trace.get_node("Label").text = String(traces.size())
				
				current_bend_point = bend_point.instance()
				current_bend_point.position = pos
#				add_child(current_bend_point)
				
				current_trace.add_point(pos)	
				current_trace.bend_points.append(current_bend_point)
			
			# If pressed while trace is selected: add new point to the selected trace
			else:
				current_bend_point = bend_point.instance()
				current_bend_point.position = pos
#				add_child(current_bend_point)
				
				current_trace.add_point(pos)
				current_trace.bend_points.append(current_bend_point)
				
				current_trace.get_node("Area2D").add_child(CollisionPolygon2D.new())
				
#				current_trace.$Area2D.add_child(CollisionPolygon2D.new())
				
		else:
			is_pressed = false
	
		calculate_used_trace_length()


func _on_TraceButton_pressed():
	trace_is_selected = false
	current_trace.is_selected = false
	current_trace.default_color = Globals.green_base
	traces.append(current_trace)
	current_trace = null
	current_bend_point = null
	get_node("TraceEditButtons").visible = false
	
func _on_EraseButton_pressed():
	trace_is_selected = false
	current_trace.get_parent().remove_child(current_trace)
	current_trace = null
	current_bend_point = null
	
	calculate_used_trace_length()

	get_node("TraceEditButtons").visible = false
