extends Node

onready var path = "user://config2.ini"
var audio_on = true
var text_size = 1
var color_palette = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	load_config()

func save_config():
	var config = ConfigFile.new()
	config.set_value("cfg", "audio", audio_on)
	config.set_value("cfg", "text_size", text_size)
	config.set_value("cfg", "color_palette", color_palette)
	
	var err = config.save(path)
	if err != OK:
		print("Config save failed")

func load_config():
	var config = ConfigFile.new()
	var default_options = {
		"audio": true,
		"text_size": 1,
		"color_palette": Globals.PALETTE_DARK
	}
	
	var err = config.load(path)
	if err != OK:
		return default_options
	
#	var options = {}
	audio_on = config.get_value("cfg", "audio")
	text_size = config.get_value("cfg", "text_size")
	color_palette = config.get_value("cfg", "color_palette")
