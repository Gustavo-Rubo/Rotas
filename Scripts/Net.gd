extends Node2D

export var pads = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()

func _draw():
	if pads.size() >= 2:
		for i in (pads.size() - 1):
			#Check if node is not already connected to the net
			draw_line(get_node(pads[i]).position, get_node(pads[i+1]).position, Color(0, 0, 255), 2)
