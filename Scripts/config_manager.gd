extends Node

onready var path = "user://config2.ini"
var audio_on = true
var text_size = 1
var color_palette = 0
var palette_position = Vector2.ZERO
var language_position = Vector2.ZERO
var select_position = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	load_config()

func save_config():
	var config = ConfigFile.new()
	config.set_value("cfg", "audio", audio_on)
	config.set_value("cfg", "color_palette", color_palette)
	config.set_value("cfg", "palette_position", palette_position)
	config.set_value("cfg", "language_position", language_position)
	config.set_value("cfg", "select_position", select_position)
	
	var _err = config.save(path)
#	if err != OK:
#		print("Config save failed")

func load_config():
	var config = ConfigFile.new()
	
	var _err = config.load(path)
#	if err != OK:
#		pass
	
	audio_on = config.get_value("cfg", "audio", true)
	color_palette = config.get_value("cfg", "color_palette", Globals.PALETTE_DARK)
	palette_position = config.get_value("cfg", "palette_position", Vector2.ZERO)
	language_position = config.get_value("cfg", "language_position", Vector2.ZERO)
	select_position = config.get_value("cfg", "select_position", 0)
