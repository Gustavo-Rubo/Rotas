extends Node2D

export (int) var grid_x
export (int) var grid_y

var connected_to_net = false
var net_number = null

var recursive_checked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Globals.GRID_SIZE * Vector2(grid_x, grid_y)
	$Area2D/CollisionShape2D.shape.set("radius", Globals.GRID_SIZE)
	
func _draw():
	draw_circle(Vector2(0, 0), Globals.GRID_SIZE, Globals.green_base)
	draw_circle(Vector2(0, 0), Globals.GRID_SIZE / 2, Globals.blue_background)

#func _on_Area2D_input_event(_viewport, event, _shape_idx):
#	if event is InputEventMouseButton:
#		if event.pressed:
#			print("press on pad")
