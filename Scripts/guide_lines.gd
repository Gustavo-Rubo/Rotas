extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var options_panel = get_tree().get_root().find_node("OptionsPanel",true,false)
	options_panel.connect("change_color", self, "_on_change_color")
	
func _on_change_color():
	update()

func _draw():
	draw_line(Vector2(0, -576),  Vector2(0, 576),  Globals.Colors[ConfigManager.color_palette].white_highlight, 1.5)
	draw_line(Vector2(-1024, 0), Vector2(1024, 0), Globals.Colors[ConfigManager.color_palette].white_highlight, 1.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
