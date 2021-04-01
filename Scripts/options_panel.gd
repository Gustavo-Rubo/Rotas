extends CanvasLayer

onready var toggle_audio = $CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Audio/ToggleAudio 
onready var slider_text = $CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/TextSize/SliderText

func _ready():
	toggle_audio.pressed = !ConfigManager.audio_on
	slider_text.value = ConfigManager.text_size
	pass
	
func slide_in():
	$AnimationPlayer.play("slide_in_options")
	
func slide_out():
	$AnimationPlayer.play_backwards("slide_in_options")

func _on_TextureButton_pressed():
	slide_out()

# Country Flags Icon Pack
# https://iconscout.com/icon-pack/country-flags


func _on_HSlider_toggled(_button_pressed):
	ConfigManager.audio_on = !toggle_audio.pressed
	ConfigManager.save_config()
	AudioServer.set_bus_mute(0, !ConfigManager.audio_on)


func _on_HSlider_value_changed(_value):
	ConfigManager.text_size = slider_text.value
	ConfigManager.save_config()

func _on_en_GB_pressed():
	TranslationServer.set_locale("en_GB")

func _on_pt_BR_pressed():
	TranslationServer.set_locale("pt_BR")


func _on_CenterContainer_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			slide_out()


func _on_Dark_pressed():
	Globals.set_colors(Globals.Colors_base)
#	get_tree().get_current_scene().update()


func _on_Light_pressed():
	Globals.set_colors(Globals.Colors_alt1)
#	get_tree().get_current_scene().update()
