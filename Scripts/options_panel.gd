extends CanvasLayer

onready var toggle_audio = $CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Audio/ToggleAudio 
onready var slider_text = $CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/TextSize/SliderText

signal change_color

func _ready():
	
	# Palette stuff
	_on_change_color()
	
	toggle_audio.pressed = !ConfigManager.audio_on
	slider_text.value = ConfigManager.text_size
	
	var _con = connect("change_color", self, "_on_change_color")
	
func _on_change_color():
	$CenterContainer/PanelContainer/ColorPanel.set_modulate(Globals.Colors[ConfigManager.color_palette].blue_background)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/HBoxContainer/Menu.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/HBoxContainer/BackButton.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Language/Language.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Color/Color.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/TextSize/Text.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Audio/Text.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Audio/ToggleAudio.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Color/Color.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Tutu.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Github.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	
func slide_in():
	$AnimationPlayer.play("slide_in_options")
	
func slide_out():
	$AnimationPlayer.play_backwards("slide_in_options")

func _on_TextureButton_pressed():
	slide_out()

# Country Flags Icon Pack
# https://iconscout.com/icon-pack/country-flags


# Audio toggle button
func _on_HSlider_toggled(_button_pressed):
	ConfigManager.audio_on = !toggle_audio.pressed
	ConfigManager.save_config()
	AudioServer.set_bus_mute(0, !ConfigManager.audio_on)
	if ConfigManager.audio_on:
		AudioManager.play_button("audio_on")


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
	ConfigManager.color_palette = Globals.PALETTE_DARK
	ConfigManager.save_config()
	emit_signal("change_color")


func _on_Light_pressed():
	ConfigManager.color_palette = Globals.PALETTE_LIGHT
	ConfigManager.save_config()
	emit_signal("change_color")


func _on_Monokai_pressed():
	ConfigManager.color_palette = Globals.PALETTE_MONOKAI
	ConfigManager.save_config()
	emit_signal("change_color")


func _on_CloseButton_pressed():
	pass # Replace with function body.
