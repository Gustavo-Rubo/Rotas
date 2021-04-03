extends Node2D

export (int) var level_number
onready var options_panel = $OptionsPanel

export (float) var goal_trace_length = 1
export (float) var max_trace_length = 1
var used_trace_length = 0

export var nets = []
var traces = []
var trace_resource
var bend_point_resource
var current_trace
var current_bend_point
var trace_is_selected = false
var is_pressed = false
var is_first_section_of_trace = false
var pos_last_pressed
var last_press_was_on_trace = false

# variable to store states for the undo/redo buttons
var game_states = Array()
var max_states = 20
var state_position = -1

# Called when the node enters the scene tree for the first time.
func _ready():	
	trace_resource = load("res://Scenes/trace.tscn")
	bend_point_resource = load("res://Scenes/bend_point.tscn")
	
	var options_panel = get_tree().get_root().find_node("OptionsPanel",true,false)
	options_panel.connect("change_color", self, "_on_change_color")
	
	$LblNumber.set_text(tr("level_w_number") % Globals.level_number_to_code(level_number))
	$ControlButtons/ConfirmButton.disabled = true
	$ControlButtons/EraseButton.disabled = true
	
	for n in nets.size():
		var net = get_node(nets[n])
		for p in net.pads:
			net.get_node(p).net_number = n
			net.get_node(p).get_node("NetNumber").text = String(n)
			
	# Load the traces from previous solution
	deserialize_and_load_traces(parse_json(GameDataManager.level_info[level_number].traces))
		
	check_nets_solved()
	check_level_solved()
	update_used_trace_length()
	update_game_state()
	_on_change_color()

# Stop playing sounds when the level is unloaded
func _exit_tree():
	AudioManager.stop_loop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_pressed:
		if current_bend_point:
			var pos = get_global_mouse_position()
			# Check if the click was in a pad
			for n in nets:
				var net = get_node(n)
				for p in net.pads:
					var pad = net.get_node(p)
					if pad.check_click(pos):
						pos = pad.position
			pos = snap_coord_to_grid(pos)
			current_bend_point.position = pos
			current_trace.sync_trace_to_bend_points()
			current_trace.update_collision()
			
			$GuideLines.position = pos
			$GuideLines.visible = true
			
	else:
		$GuideLines.visible = false
	
	# Updating and checking the level solution
	update_used_trace_length()
	update_undo_redo_buttons()
	check_nets_solved()
	check_level_solved()
	
	# Logic that chooses which trace sound effect to play
	if trace_is_selected and !is_pressed:
		AudioManager.play_loop("trace_selected")
	elif trace_is_selected and is_pressed:
		AudioManager.play_loop("trace_hold")
	else:
		AudioManager.stop_loop()

func _on_change_color():
	$MenuButton.set_modulate(Globals.Colors[ConfigManager.color_palette].white_button)
	$ProgressBar.set_modulate(Globals.Colors[ConfigManager.color_palette].green_base)
	$LblNumber.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$TraceLength.set_modulate(Globals.Colors[ConfigManager.color_palette].text2)
	$Hint.set_modulate(Globals.Colors[ConfigManager.color_palette].text2)
	
	if trace_is_selected:
		$ControlButtons/EraseButton.set_modulate(Globals.Colors[ConfigManager.color_palette].red_base)
		$ControlButtons/ConfirmButton.set_modulate(Globals.Colors[ConfigManager.color_palette].green_base)
	else:
		$ControlButtons/EraseButton.set_modulate(Globals.Colors[ConfigManager.color_palette].gray_disabled)
		$ControlButtons/ConfirmButton.set_modulate(Globals.Colors[ConfigManager.color_palette].gray_disabled)
		
	if $ControlButtons/AdvanceButton.visible:
		$ControlButtons/AdvanceButton.set_modulate(Globals.Colors[ConfigManager.color_palette].green_base)
	else:
		$ControlButtons/AdvanceButton.set_modulate(Globals.Colors[ConfigManager.color_palette].gray_disabled)
	
	if used_trace_length <= goal_trace_length:
		$GoalMet.set_modulate(Globals.Colors[ConfigManager.color_palette].star_filled)
	else:
		$GoalMet.set_modulate(Globals.Colors[ConfigManager.color_palette].star_blank)
	
func check_level_solved():
	var solved = true
	
	# If more than the max trace length is used:
	if used_trace_length > 2*goal_trace_length:
		solved = false
	# If not all nets are solved
	for net in nets:
		if !get_node(net).solved:
			solved = false
	# If nets intersect each other
	for trace in (traces + [current_trace]):
		if trace != null:
			if trace.nets.size() > 1:
				solved = false
	
	if solved:
		$ControlButtons/AdvanceButton.disabled = false
		$ControlButtons/AdvanceButton.visible = true
		$ControlButtons/AdvanceButton.set_modulate(Globals.Colors[ConfigManager.color_palette].green_base)
		$ControlButtons/ConfirmButton.visible = false
		
	else:
		$ControlButtons/AdvanceButton.disabled = true
		$ControlButtons/AdvanceButton.visible = false
		$ControlButtons/AdvanceButton.set_modulate(Globals.Colors[ConfigManager.color_palette].red_base)
		$ControlButtons/ConfirmButton.visible = true
		
	
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
		for ne in nets: # I'm uncertain if this is a ok way of doing this
			for p in get_node(ne).pads:
				get_node(ne).get_node(p).recursive_checked = false
		
		var pad_sum = 0
		
		for p in net.pads:
			var pad = net.get_node(p)
			if !pad.recursive_checked:
				pad.recursive_checked = true
				pad_sum = 1
				for trace_area in pad.get_node("Area2D").get_overlapping_areas():
					pad_sum += recursive_check_net_solved(trace_area.get_parent(), 0, n)
				pad.get_node("PadSum").set_text(String(pad_sum))
			
		if pad_sum == net.pads.size():
			net.solved = true
			net.visible = false
		else:
			net.solved = false
			net.visible = true
	
	for t in (traces + [current_trace]):
		if t != null:
			if t.nets.size() >= 2:
				# Play the "wrong" sound effect on the moment it becomes wrong
				if (!t.is_wrong):
					AudioManager.play_connection("connection_wrong")
				t.is_wrong = true
			else:
				t.is_wrong = false
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
				
		var temp_pad_sum = 0
		for area in element.get_node("Area2D").get_overlapping_areas():
			temp_pad_sum += recursive_check_net_solved(area.get_parent(), 0, net_number)
		pad_sum += temp_pad_sum
		return pad_sum

	return 0

func serialize_traces():
	var traces_serial = []
	for t in (traces + [current_trace]):
		if t != null:
			traces_serial.append(t.save())
	return traces_serial

func deserialize_and_load_traces(traces_serial):
	for trace_serial_data in traces_serial:
		var load_trace = trace_resource.instance()
		add_child(load_trace)
		
		for p in trace_serial_data.points.size():
			var pos = Vector2(trace_serial_data.points[p][0], trace_serial_data.points[p][1])
			var load_bend_point = bend_point_resource.instance()
			load_bend_point.position = pos
			load_trace.add_point(pos)
			load_trace.bend_points.append(load_bend_point)
			if p >= 1:
				load_trace.get_node("Area2D").add_child(CollisionPolygon2D.new())
			
		load_trace.sync_trace_to_bend_points()
		load_trace.update_collision()
		traces.append(load_trace)

		
func update_used_trace_length():
	used_trace_length = 0
	if current_trace:
		used_trace_length = current_trace.get_length()
	for t in traces:
		used_trace_length += t.get_length()
		
	get_node("ProgressBar").value = 100*(1 - used_trace_length/(2*goal_trace_length))
	
	# Update the star color according to wether or not the goal has been reached
	$TraceLength.text = String(used_trace_length)
	if used_trace_length <= goal_trace_length:
		$GoalMet.set_modulate(Globals.Colors[ConfigManager.color_palette].star_filled)
	else:
		$GoalMet.set_modulate(Globals.Colors[ConfigManager.color_palette].star_blank)
	
	
func snap_coord_to_grid(coord):
	coord = coord + Vector2(Globals.GRID_SIZE/2, Globals.GRID_SIZE/2)
	return Vector2(coord.x - fmod(coord.x, Globals.GRID_SIZE),
			coord.y - fmod(coord.y, Globals.GRID_SIZE))

# Manage inputs
func _on_Background_gui_input(event):
	if event is InputEventMouseButton:
		
		if event.pressed:
			last_press_was_on_trace = false
			pos_last_pressed = event.position
		
		# Check if the input was made in a trace
		if !trace_is_selected:
			for i in traces.size():
				if (traces[i].check_click(event.position)):
					last_press_was_on_trace = true
					trace_is_selected = true
					current_trace = traces[i]
					current_trace.is_selected = true
					$ControlButtons/ConfirmButton.disabled = false
					$ControlButtons/ConfirmButton.set_modulate(Globals.Colors[ConfigManager.color_palette].green_base)
					$ControlButtons/EraseButton.disabled = false
					$ControlButtons/EraseButton.set_modulate(Globals.Colors[ConfigManager.color_palette].red_base)
					traces.remove(i)
					current_bend_point = current_trace.bend_points[-1]
					current_bend_point.is_selected = true
					return
		
		# Check if the input was in a pad
		for n in nets:
			var net = get_node(n)
			for p in net.pads:
				var pad = net.get_node(p)
				if pad.check_click(event.position):
					event.position = pad.position
				
		var pos = snap_coord_to_grid(event.position)
		if event.pressed:
			pos_last_pressed = pos
			
			is_pressed = true
			is_first_section_of_trace = false
				
			# If pressed while trace is not selected: create new trace
			if (!trace_is_selected):
				
				trace_is_selected = true
				is_first_section_of_trace = true
				$ControlButtons/ConfirmButton.disabled = false
				$ControlButtons/ConfirmButton.set_modulate(Globals.Colors[ConfigManager.color_palette].green_base)
				$ControlButtons/EraseButton.disabled = false
				$ControlButtons/EraseButton.set_modulate(Globals.Colors[ConfigManager.color_palette].red_base)
				
				current_trace = trace_resource.instance()
				current_trace.is_selected = true
				add_child(current_trace)
				
				# Add a label for easier debugging:
				current_trace.get_node("Label").text = String(traces.size())
				
				add_bend_point(pos)
				add_bend_point(pos)
				
				current_trace.get_node("Area2D").add_child(CollisionPolygon2D.new())
			
			# If pressed while trace is selected: add new point to the selected trace
			else:
				add_bend_point(pos)
				current_trace.get_node("Area2D").add_child(CollisionPolygon2D.new())
			
			current_trace.update_collision()
		
		# When the press is released
		else:
			# This is to control the flow of game states
			if (!last_press_was_on_trace):
				update_game_state()
				last_press_was_on_trace = false
				
			is_pressed = false
			
			# If the press is released on a pad different from the first, finish the trace
			if trace_is_selected:
				# The distance between the pressing event and the releasing event
				var dist_travelled = pos_last_pressed.distance_to(pos)
				
				if (!is_first_section_of_trace) or (is_first_section_of_trace and dist_travelled > Globals.GRID_SIZE):
					for n in nets.size():
						var net = get_node(nets[n])
						for p in net.pads:
							var pad = net.get_node(p)
							if pad.check_click(pos):
								# TODO: logic if this is a correct connection or not
								AudioManager.play_connection("connection_complete")
								_on_TraceButton_pressed()
	
		update_used_trace_length()

func add_bend_point(pos):
	if (current_bend_point):
		current_bend_point.is_selected = false
	current_bend_point = bend_point_resource.instance()
	current_bend_point.position = pos
	current_bend_point.is_selected = true
	add_child(current_bend_point)

	current_trace.add_point(pos)	
	current_trace.bend_points.append(current_bend_point)


func _on_TraceButton_pressed():
	trace_is_selected = false
	current_bend_point.is_selected = false
	is_first_section_of_trace = false
	current_trace.is_selected = false
	current_trace.default_color = Globals.Colors[ConfigManager.color_palette].green_base
	traces.append(current_trace)
	current_trace = null
	current_bend_point = null
	$ControlButtons/ConfirmButton.disabled = true
	$ControlButtons/ConfirmButton.set_modulate(Globals.Colors[ConfigManager.color_palette].gray_disabled)
	$ControlButtons/EraseButton.disabled = true
	$ControlButtons/EraseButton.set_modulate(Globals.Colors[ConfigManager.color_palette].gray_disabled)
	
func _on_EraseButton_pressed():
	
	trace_is_selected = false
	is_first_section_of_trace = false
	for bp in current_trace.bend_points:
		get_node(".").remove_child(bp)
	current_trace.get_parent().remove_child(current_trace)
	current_trace = null
	current_bend_point = null
	
	update_used_trace_length()

	$ControlButtons/ConfirmButton.disabled = true
	$ControlButtons/ConfirmButton.set_modulate(Globals.Colors[ConfigManager.color_palette].gray_disabled)
	$ControlButtons/EraseButton.disabled = true
	$ControlButtons/EraseButton.set_modulate(Globals.Colors[ConfigManager.color_palette].gray_disabled)
	
	update_game_state()

func _on_BackButton_pressed():
	options_panel.slide_in()

func _on_MenuButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/level_select_scene.tscn")

func _on_AdvanceButton_pressed():
	complete_level()

func complete_level():
	# Save the traces state:
	GameDataManager.level_info[level_number].traces = to_json(serialize_traces())
	
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
	
#	slide_out()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/level_select_scene.tscn")


# From here on, everything is related to state management for the undofunction

# Called when an action (that is not undo) updates the state of the game
func update_game_state():
	
	game_states.resize(state_position + 1)
	
	game_states.push_back(to_json(serialize_traces()))
	if (game_states.size() <= max_states):
		state_position += 1
	else:
		game_states.pop_front()
	
# Controls wether or not you can click on the undo and redo buttons	
func update_undo_redo_buttons():
	if (state_position == 0):
		$ControlButtons/UndoButton.disabled = true
		$ControlButtons/UndoButton.set_modulate(Globals.Colors[ConfigManager.color_palette].gray_disabled)
	else:
		$ControlButtons/UndoButton.disabled = false
		$ControlButtons/UndoButton.set_modulate(Globals.Colors[ConfigManager.color_palette].white_button)
	
	# The Redo button was dropped because players don't use it.
	# Well, i'm keeping this just in case.
#	if (state_position == game_states.size() - 1):
#		$ControlButtons/RedoButton.disabled = true
#	else:
#		$ControlButtons/RedoButton.disabled = false
		
func _on_UndoButton_pressed():
	state_position -= 1
	change_state()

#func _on_RedoButton_pressed():
#	state_position += 1
#	change_state()

# Makes the traces sync to the current state
func change_state():
	if trace_is_selected:
		_on_TraceButton_pressed()
	
	for t in (traces + [current_trace]):
		if (t != null):
			remove_child(t)
#	I still don't know if it is better or not to remove the bend points here
#	if (current_bend_point != null):
#		remove_child(current_bend_point)
	traces = []
	current_trace = null
	deserialize_and_load_traces(parse_json(game_states[state_position]))
	
# Syncronize the traces on screen to the data stored in traces[].
# Is necessary for using the undo/redo buttons
#func sync_trace_objects():
#	get_children()
