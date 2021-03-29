extends Node2D

var being_dragged = false
var is_selected = false

# Called when the node enters the scene tree for the first time.
#func _ready():


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_node(".").visible = is_selected

func _draw():
	for n in range(0, 20):
		draw_arc(Vector2(0, 0), Globals.GRID_SIZE*3/2, 2*PI*n/20, 2*PI*(n+0.5)/20, 30, Globals.white_highlight, 2)
