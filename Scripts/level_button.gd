extends Node2D

# Legacy
export (int) var level_number
export (String) var level_to_load

export (String) var level_code
export (Array) var next_levels

export (bool) var enabled
var score_goal_met = false

export (Texture) var previous_clear
export (Texture) var previous_rat
export (Texture) var previous_trace

onready var level_label = $Label
onready var button = $TextureButton
onready var star = $Star
onready var previous_path = $PreviousPath

# Called when the node enters the scene tree for the first time.
func _ready():
	# If the level is unlocked
	if GameDataManager.level_info.has(level_code):
		enabled = GameDataManager.level_info[level_code].unlocked
		score_goal_met = GameDataManager.level_info[level_code].score_goal_met
		
		# If the level is unlocked but not cleared:
		if !GameDataManager.level_info[level_code].solved:
			$Highlight.visible = true
	else:
		enabled = false
		
	# If the next level exists
	if Globals.levels.has(Globals.levels[level_code].next_level_code):
		# If the next level is unlocked
		if GameDataManager.level_info.has(Globals.levels[level_code].next_level_code):
			$NextPath.visible = true
			# If it's the first time the player sees the menu after the level has been unlocked
			if GameDataManager.level_info[Globals.levels[level_code].next_level_code].just_unlocked:
				$AnimationPath.play("path_anim")
				GameDataManager.level_info[Globals.levels[level_code].next_level_code].just_unlocked = false
				GameDataManager.save_data()
		# If the next level exists but isn't unlocked
		else:
			$NextRat.visible = true
	
	# If it's the first time the player sees the menu after getting the star
	if GameDataManager.level_info.has(level_code) and GameDataManager.level_info[level_code].just_got_goal:
		$AnimationStar.play("star_anim")
		GameDataManager.level_info[level_code].just_got_goal = false
		GameDataManager.save_data()
		
	if level_code == "1_1":
		previous_path.texture = previous_clear
	elif enabled:
		previous_path.texture = previous_trace
	else:
		previous_path.texture = previous_rat
			
	level_label.set_text(Globals.level_code_to_text(level_code))
	
	_on_change_color()
	
	var options_panel = get_tree().get_root().find_node("OptionsPanel",true,false)
	options_panel.connect("change_color", self, "_on_change_color")
	
func _on_change_color():
	level_label.set_modulate(Globals.Colors[ConfigManager.color_palette].text2)
	
	if enabled:
		button.set_modulate(Globals.Colors[ConfigManager.color_palette].base1)
		previous_path.set_modulate(Globals.Colors[ConfigManager.color_palette].base1)
	else:
		button.set_modulate(Globals.Colors[ConfigManager.color_palette].gray_disabled)
		previous_path.set_modulate(Globals.Colors[ConfigManager.color_palette].ratline)
		
	if score_goal_met:
		star.set_modulate(Globals.Colors[ConfigManager.color_palette].star_filled)
	else:
		star.set_modulate(Globals.Colors[ConfigManager.color_palette].star_blank)
	
	$NextPath.set_modulate(Globals.Colors[ConfigManager.color_palette].base1)
	$NextRat.set_modulate(Globals.Colors[ConfigManager.color_palette].ratline) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_TextureButton_pressed():
	if enabled:
		AudioManager.play_button("confirm")
		var _scene = get_tree().change_scene(level_to_load)

