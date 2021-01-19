extends CanvasLayer

onready var options_panel = $OptionsPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_OptionsButton_pressed():
	options_panel.slide_in()
