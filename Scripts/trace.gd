extends Line2D

onready var collision: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D

var bend_points = []

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

func _on_StaticBody2D_input_event(_viewport, event, _shape_idx):
	if event.pressed:
		pass


func _on_Trace_draw():
	for p in points:
		draw_circle(p, width/2, Color(Globals.green_base))
