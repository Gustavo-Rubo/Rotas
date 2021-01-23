extends Line2D

export var un_selected_color_trace: Color
export var un_selected_color_bend: Color
export var selected_color_trace: Color
export var selected_color_bend: Color

var bend_color: Color

onready var collision: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D

var bend_points = []

# Called when the node enters the scene tree for the first time.
func _ready():
	default_color = selected_color_trace
	bend_color = selected_color_bend

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

func _on_StaticBody2D_input_event(viewport, event, shape_idx):
	if event.pressed:
		pass
#		print(event.position)


func _on_Trace_draw():
	for p in points:
		draw_circle(p, width/2, Color(bend_color))
