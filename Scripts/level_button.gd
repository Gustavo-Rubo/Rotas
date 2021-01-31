extends Node2D

export (int) var level_number
export (String) var level_to_load

export (Texture) var blocked_texture
export (Texture) var open_texture
export (bool) var enabled
var score_goal_met = false
export (Texture) var goal_met
export (Texture) var goal_not_met

export (Texture) var previous_clear
export (Texture) var previous_rat
export (Texture) var previous_trace

onready var level_label = $Label
onready var button = $TextureButton
onready var star = $Sprite
onready var previous_path = $PreviousPath

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameDataManager.level_info.has(level_number):
		enabled = GameDataManager.level_info[level_number].unlocked
		score_goal_met = GameDataManager.level_info[level_number].score_goal_met
	else:
		enabled = false
	
	if level_number == 1:
		previous_path.texture = previous_clear
	elif enabled:
		previous_path.texture = previous_trace
	else:
		previous_path.texture = previous_rat
		
	setup()

func setup():
	level_label.text = Globals.level_number_to_code(level_number)
	if enabled:
		button.texture_normal = open_texture
	else:
		button.texture_normal = blocked_texture
		
	if score_goal_met:
		star.texture = goal_met
	else:
		star.texture = goal_not_met

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_TextureButton_pressed():
	if enabled:
		var _scene = get_tree().change_scene(level_to_load)
