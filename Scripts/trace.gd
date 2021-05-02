extends Line2D

var is_selected = false
var is_wrong = false

var recursive_checked = false

var bend_points = []
var nets = []
var trace
var grad = Gradient.new()
var layer_number = 0

onready var highlight = get_node("Highlight")
onready var wrong = get_node("Wrong")

# Highlight animation variables
var hi : float = 0.5
var count : float = 0.0
var loop : float = 300.0
var time : float = 0.0

var wrong_shader
var wrong_material

var circle_points = PoolVector2Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_on_change_color()
	
	# put the trace in the right collision layer according to its layer number
	$Area2D.set_collision_layer_bit(layer_number, true)
	$Area2D.set_collision_mask_bit(layer_number, true)
	
	width = Globals.GRID_SIZE * 0.5
	highlight.width = width
	wrong.width = width
	if points:
		highlight.points = points
		wrong.points = points
	
	grad.offsets = PoolRealArray([-1, -0.5, 0, 0.5, 1])
	grad.colors = PoolColorArray([Color(1,1,1,hi), Color(1,1,1,0), Color(1,1,1,hi), Color(1,1,1,0), Color(1,1,1,hi)])
	highlight.texture.set_gradient(grad)
	
	wrong.visible = is_wrong
	wrong_shader = load("res://Shaders/wrong_trace.shader")
	wrong_material = load("res://Materials/wrong_material.tres")
	
	for i in range(0, 20):
		circle_points.append(Vector2(sin(i*PI/10), cos(i*PI/10)))
	
	var options_panel = get_tree().get_root().find_node("OptionsPanel",true,false)
	options_panel.connect("change_color", self, "_on_change_color")
	
func _on_change_color():
	default_color = Globals.Colors[ConfigManager.color_palette].base[layer_number]
	$Wrong.default_color = Globals.Colors[ConfigManager.color_palette].wrong
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Wrong.material.set_shader_param("length_line", get_length())	
	if is_selected:
		time += delta
		highlight.points = points
		wrong.points = points
		grad.offsets = PoolRealArray([-1 + fmod(time, 1.0), -0.5 + fmod(time, 1.0), 0 + fmod(time, 1.0), 0.5 + fmod(time, 1.0), 1 + fmod(time, 1.0)])
		highlight.texture.set_gradient(grad)
	
	highlight.visible = is_selected
	
	if is_wrong:
#		material = wrong_material
		$Wrong.visible = true
	else:
		$Wrong.visible = false
#		material = null

func sync_trace_to_bend_points():
	for i in bend_points.size():
		points[i] = bend_points[i].position

func get_length():
	var length = 0
	if points.size() >= 2:
		for i in (points.size() - 1):
			length += points[i].distance_to(points[i+1])

	return length

# Serializes the trace data for saving
func save():
	var points_save = []
	for point in points:
		points_save.append([point.x, point.y])
	var save_dict = {
		"points": points_save,
		"layer_number": layer_number
	}
	
	return save_dict

func _on_Trace_draw():
	$Label.set_global_position(points[0])
	$LabelNets.set_global_position(points[0] + Vector2(0, -50))
	for p in points:
		draw_circle_aa(p, width/2, Globals.Colors[ConfigManager.color_palette].base[layer_number])
		
func update_collision():
	if $Area2D.get_child_count() >= 1:
		for i in $Area2D.get_child_count():
			var poly = []
			
			var line = (points[i+1] - points[i]).normalized()
			var normal = Vector2(line.y, -line.x)
			var h_width = width / 2
			
			poly.append(points[i] + normal * h_width)
			poly.append(points[i] - normal * h_width)
			poly.append(points[i+1] - normal * h_width)
			poly.append(points[i+1] + normal * h_width)
			
			$Area2D.get_child(i).polygon = poly
#			var collision = CollisionPolygon2D.new()
#			collision.polygon = poly
#
#			$Area2D.add_child(collision)

# We use this because draw_circle has no anti-aliasing 
func draw_circle_aa(center, radius, color):
	var circle_points_radius = PoolVector2Array()
	for c in circle_points:
		circle_points_radius.append(center + c * radius)
	draw_colored_polygon(circle_points_radius, color, PoolVector2Array(), null, null, true)
	

# Thanks for the user Jack_5515 for the code at:
# https://www.reddit.com/r/godot/comments/f3dr76/how_to_make_clickable_line2d/
# Handle Input events
func check_click(mouse_click):

	# We calculate the squared distance, so we don't need to calculate the root for the distance of multiple vectors
	# If you want to increase the detection click range, you would do it here
	var squared_width : float = width*width
	
	# Because you also requested the offset, we can also calculate it
	var offset : float = 0
	
	# Iterate every section (points - 1 sections)
	for i in range(points.size()-1):
		# We get 2 points of the Line2D (essentialy a line) and get the closest point on that line to our mouse click
		# Don't forget to also translate the local points to the global position where the click is
		var closest_point : Vector2 = Geometry.get_closest_point_to_segment_2d(mouse_click, global_position + points[i], global_position + points[i+1])
		# If the distance of the closest point and the mouse click is smaller or equal the mouse position, it was clicked within the line
		if closest_point.distance_squared_to(mouse_click) <= squared_width:
			# To our offset we add the position of the click, relative to the first point of the click, closest click is global space, points local space, so we need to transform it again
			offset += closest_point.distance_to(global_position + points[i])
			
#			on_click(i, mouse_click, offset)
			return true
		else:
			# The click didn't happen here, meaning the entire line segmet is added to the offset
			offset += points[i].distance_to(points[i+1])
	
	return false
			
#func on_click(segment : int, global_position : Vector2, offset : float) -> void:
#	print("The Line was clicked in segment %s (offset: %s) and global position - %s" % [segment, offset, global_position])
#	pass
