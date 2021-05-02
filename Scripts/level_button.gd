extends Node2D

export (String) var level_code

export (bool) var enabled
export (Vector2) var select_screen_pos
var score_goal_met = false

var next_path_resource
var next_rat_resource

var next_paths = {}
var next_rats = {}

onready var level_label = $Label
onready var button = $TextureButton
onready var star = $Star

# Called when the node enters the scene tree for the first time.
func _ready():
	
	next_path_resource = load("res://Scenes/next_path.tscn")
	next_rat_resource = load("res://Scenes/next_rat.tscn")
	
	# If the level is unlocked
	if GameDataManager.level_info.has(level_code):
		enabled = GameDataManager.level_info[level_code].unlocked
		score_goal_met = GameDataManager.level_info[level_code].score_goal_met
		
		# If the level is unlocked but not cleared:
		if !GameDataManager.level_info[level_code].solved:
			$Highlight.visible = true
	else:
		enabled = false
	
	for next_level_code in Globals.levels[level_code].next_level_codes:
		# If the next level exists
		if Globals.levels.has(next_level_code):
			
			# Create the "Next" traces and make them go to the location of the next levels
			var next_level_pos = get_parent().get_node(next_level_code).position
			
			var next_path = next_path_resource.instance()
			next_paths[next_level_code] = next_path
			var next_rat = next_rat_resource.instance()
			next_rats[next_level_code] = next_rat
			
			# Position the points so that they start and end on the borders of
			next_path.points[0] = (next_level_pos - position).normalized() * 25
			next_path.points[1] = (next_level_pos - position) - (next_level_pos - position).normalized() * 25
			
#			next_path.points[1] = (next_level_pos - position)
			next_rat.points[1] = (next_level_pos - position)
			
			$PathsLayer.add_child(next_rat)
			$PathsLayer.add_child(next_path)
			
			
			# If the next level is unlocked
			if GameDataManager.level_info.has(next_level_code):
				next_path.visible = true
				# If it's the first time the player sees the menu after the level has been unlocked
				if GameDataManager.level_info[next_level_code].just_unlocked:
					$AnimationPath.play("path_anim")
					GameDataManager.level_info[next_level_code].just_unlocked = false
					GameDataManager.save_data()
			# If the next level exists but isn't unlocked
			else:
				next_rat.visible = true
	
	# If it's the first time the player sees the menu after getting the star
	if GameDataManager.level_info.has(level_code) and GameDataManager.level_info[level_code].just_got_goal:
		$AnimationStar.play("star_anim")
		GameDataManager.level_info[level_code].just_got_goal = false
		GameDataManager.save_data()
			
	level_label.set_text(Globals.level_code_to_text(level_code))
	
	_on_change_color()
	
	var options_panel = get_tree().get_root().find_node("OptionsPanel",true,false)
	options_panel.connect("change_color", self, "_on_change_color")
	
func _on_change_color():
	level_label.set_modulate(Globals.Colors[ConfigManager.color_palette].text2)
	
	if enabled:
		button.set_modulate(Globals.Colors[ConfigManager.color_palette].base[0])
#		previous_path.set_modulate(Globals.Colors[ConfigManager.color_palette].base[0])
	else:
		button.set_modulate(Globals.Colors[ConfigManager.color_palette].gray_disabled)
#		previous_path.set_modulate(Globals.Colors[ConfigManager.color_palette].ratline)
		
	if score_goal_met:
		star.set_modulate(Globals.Colors[ConfigManager.color_palette].star_filled)
	else:
		star.set_modulate(Globals.Colors[ConfigManager.color_palette].star_blank)
	
	for next_level_code in Globals.levels[level_code].next_level_codes:
		next_paths[next_level_code].set_modulate(Globals.Colors[ConfigManager.color_palette].base[0])
		next_rats[next_level_code].set_modulate(Globals.Colors[ConfigManager.color_palette].ratline) 

func _on_TextureButton_pressed():
	if enabled:
		AudioManager.play_button("confirm")
		var _scene = get_tree().change_scene("Scenes/levels/level_" + level_code + ".tscn")

