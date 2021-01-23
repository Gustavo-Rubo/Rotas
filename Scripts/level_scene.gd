extends Node2D

export (int) var level_number

export (float) var goal_trace_length
export (float) var max_trace_length
var used_trace_length

export var nets = []
var traces = []
var trace
var bend_point
var current_trace
var current_bend_point
var trace_is_selected = false
var is_pressed = false
var is_first_section_of_trace = false

onready var level_label = $EditorButtons/LblNumber

# Defining the trace editing mode.
enum { create, move, delete }
var mode

# Called when the node enters the scene tree for the first time.
func _ready():
	mode = create
	
	goal_trace_length = 10
	used_trace_length = 0
	
	trace = load("res://Scenes/trace.tscn")
	bend_point = load("res://Scenes/bend_point.tscn")
	
	level_label.text = String(level_number)
	
#	traces = GameDataManager.level_info[level_number].traces

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_pressed:
		if current_bend_point:
			var pos = Vector2(get_global_mouse_position().x - fmod(get_global_mouse_position().x, 20),
			get_global_mouse_position().y - fmod(get_global_mouse_position().y, 20))
			current_bend_point.position = pos
			current_trace.sync_trace_to_bend_points()
			
			$GuideLines.position = pos
			$GuideLines.visible = true
	else:
		$GuideLines.visible = false
		
		
func calculate_used_trace_length():
	used_trace_length = 0
	if current_trace:
		used_trace_length = current_trace.get_length()
	for t in traces:
		used_trace_length += t.get_length()
#		print(used_trace_length)
	get_node("ProgressBar").value = 100*(used_trace_length/max_trace_length)
	pass
	

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
	
	get_tree().change_scene("res://Scenes/level_select_scene.tscn")

func _on_BtnPassar_pressed():
	used_trace_length = goal_trace_length + 1
	complete_level()

func _on_BtnGanhar_pressed():
	used_trace_length = goal_trace_length - 1
	complete_level()


func _on_BtnVoltar_pressed():
	get_tree().change_scene("res://Scenes/level_select_scene.tscn")


func _on_AddButton_pressed():
	mode = create


func _on_MoveButton_pressed():
	mode = move


func _on_DeleteButton_pressed():
	mode = delete


# Manage inputs
func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton:
		var pos = Vector2(event.position.x - fmod(event.position.x, 20),
			event.position.y - fmod(event.position.y, 20))
		if event.pressed:
			is_pressed = true
			
			# If pressed while trace is not selected: create new trace
			if (!trace_is_selected):
				is_first_section_of_trace = true
				trace_is_selected = true
				get_node("TraceEditButtons").visible = true
				
				current_trace = trace.instance()
				add_child(current_trace)
				
				current_bend_point = bend_point.instance()
				current_bend_point.position = pos
#				add_child(current_bend_point)
				
				current_trace.add_point(pos)	
				current_trace.bend_points.append(current_bend_point)
				
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
				
		else:
			is_pressed = false
			
			# If released while trace is selected: confirm position of new bend point
			if(trace_is_selected):
				if(is_first_section_of_trace):
					current_bend_point = bend_point.instance()
					current_bend_point.position = pos
	#				add_child(current_bend_point)
					
					current_trace.add_point(pos)
					current_trace.bend_points.append(current_bend_point)
					
					is_first_section_of_trace = false
				# Is confirmation really necessary?
#				current_trace.add_point(event.position)
				pass
			
			# If released while trace is not selected: this shouldn't happen
			else:
				print("I shouldn't have gotten here")
		
		calculate_used_trace_length()


func _on_TraceButton_pressed():
	trace_is_selected = false
	current_trace.default_color = current_trace.un_selected_color_trace
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
