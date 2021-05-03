extends Button

export (int) var palette_code

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_change_color()
	
	var options_panel = get_tree().get_root().find_node("OptionsPanel",true,false)
	options_panel.connect("change_color", self, "_on_change_color")
	
	self.connect("pressed", options_panel, "_on_PaletteButton_pressed", [palette_code, rect_position])

func _on_change_color():
	update()
		
func _draw():
	draw_rect(Rect2(0, 0, 25, 25), Globals.Colors[palette_code].base[0])
	draw_rect(Rect2(25, 0, 25, 25), Globals.Colors[palette_code].wrong)
	draw_rect(Rect2(0, 25, 25, 25), Globals.Colors[palette_code].star_filled)
	draw_rect(Rect2(25, 25, 25, 25), Globals.Colors[palette_code].background)
#	draw_rect(Rect2(0, 0, 50, 50), Globals.Colors[ConfigManager.color_palette].text1, false, 4)
