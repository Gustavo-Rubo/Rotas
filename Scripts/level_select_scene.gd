extends CanvasLayer

onready var options_panel = $OptionsPanel

var stars

# Called when the node enters the scene tree for the first time.
func _ready():
#	$OptionsButton.modulate = Globals.red_base
	pass # Replace with function body.

func _enter_tree():
	stars = 0
	for level in GameDataManager.level_info:
		if GameDataManager.level_info[level].score_goal_met:
			stars += 1
	
	$StarCounter.set_text(String(stars) + "/5")
	
	AudioServer.set_bus_mute(0, !ConfigManager.audio_on)

func _on_OptionsButton_pressed():
	options_panel.slide_in()
