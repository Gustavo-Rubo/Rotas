extends Node2D

var pad_color : Color
var background_color : Color

# Called when the node enters the scene tree for the first time.
func _ready():
	pad_color = Color(0, 0.78, 0)
	background_color = Color(0, 0, 0)

func _draw():
	draw_circle(Vector2(0, 0), 20, pad_color)
	draw_circle(Vector2(0, 0), 10, background_color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	print("input on pad")
