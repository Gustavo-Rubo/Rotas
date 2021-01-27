extends Node2D

export (int) var level_number

export (float) var goal_trace_length = 1
export (float) var max_trace_length = 1
var used_trace_length = 0

export (Texture) var goal_met
export (Texture) var goal_not_met

export (Texture) var advance_disabled
export (Texture) var advance_enabled

export var nets = []
var traces = []
var trace_resource
var bend_point_resource
var current_trace
var current_bend_point
var trace_is_selected = false
var is_pressed = false
var is_first_section_of_trace = false

# Called when the node enters the scene tree for the first time.
func _ready():
	trace_resource = load("res://Scenes/trace.tscn")
	bend_point_resource = load("res://Scenes/bend_point.tscn")
	
	$LblNumber.set_text(tr("level_w_number") % String(level_number))
	
	for n in nets.size():
		var net = get_node(nets[n])
		for p in net.pads:
			net.get_node(p).net_number = n
			net.get_node(p).get_node("NetNumber").text = String(n)
			
	# Load the traces from previous solution
	for trace_save_data in parse_json(GameDataManager.level_info[level_number].traces):
		var load_trace = trace_resource.instance()
		add_child(load_trace)
		
		for p in trace_save_data.points.size():
			var pos = Vector2(trace_save_data.points[p][0], trace_save_data.points[p][1])
			var load_bend_point = bend_point_resource.instance()
			load_bend_point.position = pos
			load_trace.add_point(pos)
			load_trace.bend_points.append(load_bend_point)
			if p >= 1:
				load_trace.get_node("Area2D").add_child(CollisionPolygon2D.new())
			
#			current_trace.add_point(pos)
#			current_trace.bend_points.append(current_bend_point)

#		load_trace.from_save(trace_save_data)
		load_trace.sync_trace_to_bend_points()
		load_trace.update_collision()
		traces.append(load_trace)
		
	check_nets_solved()
	check_level_solved()
	update_used_trace_length()

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
		
	check_nets_solved()
	check_level_solved()

func check_level_solved():
	var solved = true
	for net in nets:
		if !get_node(net).solved:
			solved = false
	for trace in (traces + [current_trace]):
		if trace != null:
			if trace.nets.size() > 1:
				solved = false
	
	if solved:
		$AdvanceButton.disabled = false
		$AdvanceButton.icon = advance_enabled
		
	else:
		$AdvanceButton.disabled = true
		$AdvanceButton.icon = advance_disabled
		
	
# Helper function for the recursive net checking.
# Also does coloring of the traces.
func check_nets_solved():

	for t in (traces + [current_trace]):
			if t != null:
				t.nets = []

	for n in nets.size():
		var net = get_node(nets[n])
		
		# recursive check reset
		for t in (traces + [current_trace]):
			if t != null:
				t.recursive_checked = false
		for p in net.pads:
			net.get_node(p).recursive_checked = false
		
		var pad_sum
		
#		print("net ", n)
		for p in net.pads:
			var pad = net.get_node(p)
			if !pad.recursive_checked:
				pad.recursive_checked = true
				pad_sum = 1
				for trace_area in pad.get_node("Area2D").get_overlapping_areas():
					pad_sum += recursive_check_net_solved(trace_area.get_parent(), 0, n)
#				print(pad_sum)
			
		if pad_sum == net.pads.size():
			net.solved = true
			net.visible = false
		else:
			net.solved = false
			net.visible = true
	
	for t in (traces + [current_trace]):
		if t != null:
			if t.nets.size() >= 2:
				t.set_color("red")
			else:
				t.set_color("green")
			t.get_node("LabelNets").text = String(t.nets)

# Recursive function for determining which traces belong to which nets,
# and to know if nets are solved
func recursive_check_net_solved(element, pad_sum, net_number):
	if !element.recursive_checked:
		element.recursive_checked = true
		
		if "Pad" in element.name:
			if element.net_number == net_number:
				pad_sum += 1
		if "Trace" in element.name:
			if !element.nets.has(net_number):
				element.nets.append(net_number)
				
		for area in element.get_node("Area2D").get_overlapping_areas():
			var temp_pad_sum = 0
			temp_pad_sum += recursive_check_net_solved(area.get_parent(), pad_sum, net_number)
			pad_sum += temp_pad_sum
		return pad_sum

	return 0

		
func update_used_trace_length():
	used_trace_length = 0
	if current_trace:
		used_trace_length = current_trace.get_length()
	for t in traces:
		used_trace_length += t.get_length()
	get_node("ProgressBar").value = 100*(used_trace_length/goal_trace_length)
	$TraceLength.text = String(used_trace_length)
	if used_trace_length <= goal_trace_length:
		$GoalMet.texture = goal_met
	else:
		$GoalMet.texture = goal_not_met
	
func complete_level():
	# Save the traces state:
	if current_trace != null:
		traces.append(current_trace)
	var traces_save_data = []
	for t in traces:
		traces_save_data.append(t.save())
	GameDataManager.level_info[level_number].traces = to_json(traces_save_data)
	
	# Update if the player met the goal
	if used_trace_length <= goal_trace_length:
		GameDataManager.level_info[level_number].score_goal_met = true
	
	# Update the lowest score, if necessary
	if used_trace_length < GameDataManager.level_info[level_number].low_score:
		GameDataManager.level_info[level_number].low_score = used_trace_length
	
	# Next level is unlocked:
	if !GameDataManager.level_info.has(level_number + 1):
		GameDataManager.level_info[level_number + 1] = {
			"unlocked": true,
			"low_score": INF,
			"score_goal_met": false,
			"traces": to_json([])
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
				
				current_trace = trace_resource.instance()
				current_trace.is_selected = true
				add_child(current_trace)
				
				# Add a label for easier debugging:
				current_trace.get_node("Label").text = String(traces.size())
				
				current_bend_point = bend_point_resource.instance()
				current_bend_point.position = pos
#				add_child(current_bend_point)
				
				current_trace.add_point(pos)	
				current_trace.bend_points.append(current_bend_point)
			
			# If pressed while trace is selected: add new point to the selected trace
			else:
				current_bend_point = bend_point_resource.instance()
				current_bend_point.position = pos
#				add_child(current_bend_point)
				
				current_trace.add_point(pos)
				current_trace.bend_points.append(current_bend_point)
				
				current_trace.get_node("Area2D").add_child(CollisionPolygon2D.new())
				
#				current_trace.$Area2D.add_child(CollisionPolygon2D.new())
				
		else:
			is_pressed = false
	
		update_used_trace_length()


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
	
	update_used_trace_length()

	get_node("TraceEditButtons").visible = false


func _on_BackButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/level_select_scene.tscn")


func _on_AdvanceButton_pressed():
	complete_level()
