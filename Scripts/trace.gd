extends Line2D

var is_selected = true

var bend_color = Globals.green_base

var recursive_checked = false

var bend_points = []
export onready var nets = []

# Called when the node enters the scene tree for the first time.
func _ready():
	default_color = Globals.green_selected
	width = Globals.GRID_SIZE * 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func sync_trace_to_bend_points():
	for i in bend_points.size():
		points[i] = bend_points[i].position

func get_length():
	var length = 0
	if points.size() >= 2:
		for i in (points.size() - 1):
			length += points[i].distance_to(points[i+1])

	return length

func set_color(color):
	if color == "red":
		bend_color = Globals.red_base
		if is_selected:
			default_color = Globals.red_selected
		else:
			default_color = Globals.red_base
			
	elif color == "green":
		bend_color = Globals.green_base
		if is_selected:
			default_color = Globals.green_selected
		else:
			default_color = Globals.green_base
		


func _on_Trace_draw():
	$Label.set_global_position(points[0])
	$LabelNets.set_global_position(points[0] + Vector2(0, -50))
	for p in points:
		draw_circle(p, width/2, bend_color)
		
		
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
			# Do something on click
			# To our offset we add the position of the click, relative to the first point of the click, closest click is global space, points local space, so we need to transform it again
			offset += closest_point.distance_to(global_position + points[i])
			
			on_click(i, mouse_click, offset)
			return true
		else:
			# The click didn't happen here, meaning the entire line segmet is added to the offset
			offset += points[i].distance_to(points[i+1])
	
	return false
			
func on_click(segment : int, global_position : Vector2, offset : float) -> void:
	print("The Line was clicked in segment %s (offset: %s) and global position - %s" % [segment, offset, global_position])
