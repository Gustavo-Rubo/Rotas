extends Node

var level_info = {}
var default_level_info = {
	"1_1": {
		"unlocked": true,
		"solved": false,
		"low_score": INF,
		"goal_trace_length": 500,
		"score_goal_met": false,
		"traces": to_json([])
	}
}

onready var path = "user://save.dat"

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_save_data()
	level_info = load_data()

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
