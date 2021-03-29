extends Node2D

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass

func _draw():
	draw_line(Vector2(0, -576),  Vector2(0, 576),  Globals.white_highlight, 1.5)
	draw_line(Vector2(-1024, 0), Vector2(1024, 0), Globals.white_highlight, 1.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
