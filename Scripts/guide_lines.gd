extends Node2D

var guide_line_color : Color

# Called when the node enters the scene tree for the first time.
func _ready():
	guide_line_color = Color(1, 1, 1, 0.3)

func _draw():
	draw_line(Vector2(0, -576),  Vector2(0, 576),  guide_line_color, 1)
	draw_line(Vector2(-1024, 0), Vector2(1024, 0), guide_line_color, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
