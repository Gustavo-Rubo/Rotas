extends CanvasLayer

onready var toggle_audio = $CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Audio/ToggleAudio 

signal change_color

func _ready():
	
	# Palette stuff
	_on_change_color()
	
	toggle_audio.pressed = !ConfigManager.audio_on
	
	# Position the select boxes in their last placed location
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Language/HBoxContainer/SelectBox.position = ConfigManager.language_position
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Color/HBoxContainer/SelectBox.position = ConfigManager.palette_position
	
	var _con = connect("change_color", self, "_on_change_color")
	
func _on_change_color():
	$CenterContainer/PanelContainer/ColorPanel.set_modulate(Globals.Colors[ConfigManager.color_palette].background)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/HBoxContainer/Menu.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/HBoxContainer/CloseButton.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Language/Language.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Color/Color.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Audio/Text.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Audio/ToggleAudio.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Color/Color.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Tutu.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Github.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/PanelContainer/ColorPanel.set_modulate(Globals.Colors[ConfigManager.color_palette].background)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/PanelContainer/MenuButton.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Language/HBoxContainer/SelectBox.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	$CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Color/HBoxContainer/SelectBox.set_modulate(Globals.Colors[ConfigManager.color_palette].text1)
	
func slide_in():
	$AnimationPlayer.play("slide_in_options")
	
func slide_out():
	$AnimationPlayer.play_backwards("slide_in_options")

func _on_CloseButton_pressed():
	AudioManager.play_button("close")
	slide_out()

# Country Flags Icon Pack
# https://iconscout.com/icon-pack/country-flags
func _on_en_GB_pressed():
	$Tween.interpolate_property($CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Language/HBoxContainer/SelectBox, "position", $CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Language/HBoxContainer/SelectBox.position, $CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Language/HBoxContainer/en_GB.rect_position, 0.2, Tween.TRANS_QUAD)
	$Tween.start()
	ConfigManager.language_position = $CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Language/HBoxContainer/en_GB.rect_position
	ConfigManager.save_config()
	TranslationServer.set_locale("en_GB")

func _on_pt_BR_pressed():
	$Tween.interpolate_property($CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Language/HBoxContainer/SelectBox, "position", $CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Language/HBoxContainer/SelectBox.position, $CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Language/HBoxContainer/pt_BR.rect_position, 0.2, Tween.TRANS_QUAD)
	$Tween.start()
	ConfigManager.language_position = $CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Language/HBoxContainer/pt_BR.rect_position
	ConfigManager.save_config()
	TranslationServer.set_locale("pt_BR")

# Palette change buttons
func _on_PaletteButton_pressed(palette_code, palette_position):
	$Tween.interpolate_property($CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Color/HBoxContainer/SelectBox, "position", $CenterContainer/PanelContainer/MarginContainer2/VBoxContainer/ScrollContainer/VBoxContainer/Color/HBoxContainer/SelectBox.position, palette_position, 0.2, Tween.TRANS_QUAD)
	$Tween.start()
	ConfigManager.color_palette = palette_code
	ConfigManager.palette_position = palette_position
	ConfigManager.save_config()
	emit_signal("change_color")


# Audio toggle button
func _on_HSlider_toggled(_button_pressed):
	ConfigManager.audio_on = !toggle_audio.pressed
	ConfigManager.save_config()
	AudioServer.set_bus_mute(0, !ConfigManager.audio_on)
	if ConfigManager.audio_on:
		AudioManager.play_button("audio_on")
		
		
# If clicked outside of the border, slide out
func _on_CenterContainer_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			slide_out()
