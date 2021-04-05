extends Container

# Called when the node enters the scene tree for the first time.
func _ready():
	var level_button_resource = load("res://Scenes/level_button.tscn")
	var i = 0
	for level_code in Globals.levels:
		# Create and configure a level button for each available level
		var level_button = level_button_resource.instance()
		level_button.level_code = level_code
		level_button.level_to_load = "Scenes/levels/level_" + level_code + ".tscn"
		level_button.next_levels = Globals.levels[level_code] # May not be necessary
		level_button.position = Vector2(128 + i*256, 320)
		level_button.scale = Vector2(0.8, 0.8)
		
		i += 1
		add_child(level_button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
