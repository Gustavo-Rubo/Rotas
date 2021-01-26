extends Node

var level_info = {}
var default_level_info = {
	1: {
		"unlocked": true,
		"low_score": INF,
		"score_goal_met": false,
		"traces": to_json([])
	}
}

onready var path = "user://save.dat"

# Called when the node enters the scene tree for the first time.
func _ready():
	level_info = load_data()
	reset_save_data()

func save_data():
	var file = File.new()
	var err = file.open(path, File.WRITE)
	
	if err != OK:
		print("Error in writing game data")
		return
	
	file.store_var(level_info)
	file.close()

func load_data():
	var file = File.new()
	var err = file.open(path, File.READ)
	
	if err != OK:
		print("Error in reading game data")
		return default_level_info
	
	var read = {}
	read = file.get_var()
	
	return read
	
func reset_save_data():
	level_info = default_level_info
	save_data()
