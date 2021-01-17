extends CanvasLayer

onready var toggle_audio = $MarginContainer/CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/Audio/ToggleAudio 
onready var slider_text = $"MarginContainer/CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/Tam Texto/SliderText"

func _ready():
	toggle_audio.pressed = ConfigManager.audio_on
	slider_text.value = ConfigManager.text_size
	pass
	
func slide_in():
	$AnimationPlayer.play("slide_in_options")
	
func slide_out():
	$AnimationPlayer.play_backwards("slide_in_options")

func _on_TextureButton_pressed():
	slide_out()

func _on_HSlider_toggled(button_pressed):
	ConfigManager.audio_on = toggle_audio.pressed
	ConfigManager.save_config()
	pass


func _on_HSlider_value_changed(value):
	ConfigManager.text_size = slider_text.value
	ConfigManager.save_config()
	pass # Replace with function body.
