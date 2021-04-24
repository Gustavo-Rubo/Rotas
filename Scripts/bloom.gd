extends Node2D

var bloom = load("res://Materials/bloom.tres")

func _ready():
	set_as_toplevel(true)

func _draw():
	draw_rect(Rect2(0, 0, Globals.DISPLAY_WIDTH, Globals.DISPLAY_HEIGHT), Color(1, 1, 1))

func set_active(active):
	if (active):
		material = bloom
		set_modulate(Color(1, 1, 1))
	else:
		material = null
		set_modulate(Color(1, 1, 1, 0))
