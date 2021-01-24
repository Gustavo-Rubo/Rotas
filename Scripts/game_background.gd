extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _draw():
	draw_rect(Rect2(0, 0, Globals.DISPLAY_WIDTH, Globals.DISPLAY_HEIGHT), Globals.blue_background)
	for i in (1 + Globals.DISPLAY_WIDTH/Globals.GRID_SIZE):
		for j in (1 + Globals.DISPLAY_HEIGHT/Globals.GRID_SIZE):
			draw_circle(Vector2(Globals.GRID_SIZE * i, Globals.GRID_SIZE * j), 1, Globals.gray_dots)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
