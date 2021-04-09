extends CanvasLayer

onready var list = $CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer

func _ready():
	
	# Update the list with current scores
	for level_code in GameDataManager.level_info:
		var info = GameDataManager.level_info[level_code]
		# Only put the level in the list if it has been cleared
		if info["solved"] == true:
			var list_item = list.get_node("Level").duplicate()
			
			list_item.get_node("Text").set_text(Globals.level_code_to_text(level_code))
			list_item.get_node("LevelScore").set_text(String(info["low_score"]).pad_decimals(1))
			list_item.get_node("ProgressBar").value = 100*(1 - info["low_score"]/(2*info["goal_trace_length"]))
			list_item.visible = true
			
			list.add_child(list_item)
	
	# Palette stuff
	_on_change_color()
	
	var options_panel = get_tree().get_root().find_node("OptionsPanel",true,false)
	options_panel.connect("change_color", self, "_on_change_color")
	
func _on_change_color():
	$CenterContainer/PanelContainer/ColorPanel.set_modulate(Globals.Colors[ConfigManager.color_palette].background)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/HBoxContainer/LowScoreTitle.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/HBoxContainer/CloseButton.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/PanelContainer/ColorPanel.set_modulate(Globals.Colors[ConfigManager.color_palette].background)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/PanelContainer/MenuButton.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	

	for item in list.get_children():
		item.get_node("Text").set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
		item.get_node("LevelScore").set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
		item.get_node("ProgressBar").set_modulate(Globals.Colors[ConfigManager.color_palette].base1)
		if item.get_node("ProgressBar").value >= 50:
			item.get_node("GoalMet").set_modulate(Globals.Colors[ConfigManager.color_palette].star_filled)
		else:
			item.get_node("GoalMet").set_modulate(Globals.Colors[ConfigManager.color_palette].star_blank)
	
func slide_in():
	$AnimationPlayer.play("slide_in_options")
	
func slide_out():
	$AnimationPlayer.play_backwards("slide_in_options")

func _on_CloseButton_pressed():
	AudioManager.play_button("close")
	slide_out()

func _on_CenterContainer_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			slide_out()
