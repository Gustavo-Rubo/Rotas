extends Node2D

export (int) var level
export (String) var level_to_load

export (Texture) var blocked_texture
export (Texture) var open_texture
export (bool) var enabled
export (bool) var score_goal_met
export (Texture) var goal_met
export (Texture) var goal_not_met
export (String) var connection_previous

onready var level_label = $Label
onready var button = $TextureButton
onready var star = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameDataManager.level_info.has(level):
		enabled = GameDataManager.level_info[level].unlocked
	else:
		enabled = false
	setup()

func setup():
	level_label.text = String(level)
	if enabled:
		button.texture_normal = open_texture
	else:
		button.texture_normal = blocked_texture
		
	if score_goal_met:
		star.texture = goal_met
	else:
		star.texture = goal_not_met
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_TextureButton_pressed():
	if enabled:
		get_tree().change_scene(level_to_load)
