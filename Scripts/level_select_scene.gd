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
	$Label.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$Star.set_modulate(Globals.Colors[ConfigManager.color_palette].star_filled)
	
	options_panel = get_tree().get_root().find_node("OptionsPanel",true,false)
	options_panel.connect("change_color", self, "_on_change_color")
	
func _on_change_color():
	$Label.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$Star.set_modulate(Globals.Colors[ConfigManager.color_palette].star_filled)

func _on_OptionsButton_pressed():
	options_panel.slide_in()

func _on_ScoreButton_pressed():
	low_score_panel.slide_in()
