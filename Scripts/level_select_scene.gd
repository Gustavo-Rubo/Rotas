extends CanvasLayer

onready var options_panel = $OptionsPanel
onready var low_score_panel = $LowScorePanel

var stars

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

func _enter_tree():
	stars = 0
	for level in GameDataManager.level_info:
		if GameDataManager.level_info[level].score_goal_met:
			stars += 1
	
	$StarCounter.set_text(String(stars) + "/5")
	
	# Mute the master bus according to the current config
	AudioServer.set_bus_mute(1, !ConfigManager.audio_on)

func _ready():
	# Palette coloring
	_on_change_color()
	
	# Position the scroll container in the last position
	yield(get_tree(), "idle_frame");
	$ScrollContainer.set_h_scroll(ConfigManager.select_position)
	
	options_panel = get_tree().get_root().find_node("OptionsPanel",true,false)
	options_panel.connect("change_color", self, "_on_change_color")

func _exit_tree():
	ConfigManager.select_position = $ScrollContainer.get_h_scroll()
	ConfigManager.save_config()
	
func _on_change_color():
	$Label.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$Star.set_modulate(Globals.Colors[ConfigManager.color_palette].star_filled)
	$ScoreButton.set_modulate(Globals.Colors[ConfigManager.color_palette].white_button)
	$OptionsButton.set_modulate(Globals.Colors[ConfigManager.color_palette].white_button)

func _on_OptionsButton_pressed():
	AudioManager.play_button("options")
	options_panel.slide_in()

func _on_ScoreButton_pressed():
	AudioManager.play_button("menu")
	low_score_panel.slide_in()


# Uncomment this function when you release for web
func _on_ScrollContainer_gui_input(event):
	pass
#	if (event is InputEventScreenDrag):
#		$ScrollContainer.scroll_horizontal -= event.relative.x #speed.x/100
