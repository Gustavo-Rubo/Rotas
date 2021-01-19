extends Node2D

export (int) var level_number

export (float) var goal_trace_length
var used_trace_length

export var nets = []

onready var level_label = $EditorButtons/LblNumber

# Defining the trace editing mode.
enum { create, move, delete }
var mode

# Called when the node enters the scene tree for the first time.
func _ready():
	mode = create
	
	goal_trace_length = 10
	used_trace_length = 0
	
	level_label.text = String(level_number)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func calculate_used_trace_length():
#	if tracos.size() >= 2:
#		tam_traco = 0
#		for i in (tracos.size() - 1):
#			tam_traco = tam_traco + sqrt(pow((tracos[i][0] - tracos[i+1][0])/100, 2)
#				+ pow((tracos[i][1] - tracos[i+1][1])/100, 2))
#			print(sqrt(pow((tracos[i][0] - tracos[i+1][0])/100, 2)
#				+ pow((tracos[i][1] - tracos[i+1][1])/100, 2)))
#			print(tam_traco)
#		get_node("../UI/ProgressBar").value = 100*(tam_traco/max_tam_traco)
	pass
	

func complete_level():
	if used_trace_length < GameDataManager.level_info[level_number].low_score:
		GameDataManager.level_info[level_number].low_score = used_trace_length
	
	# Next level is unlocked:
	if !GameDataManager.level_info.has(level_number + 1):
		GameDataManager.level_info[level_number + 1] = {
			"unlocked": true,
			"low_score": INF,
			"star": false
		}
		
	GameDataManager.save_data()
	
	get_tree().change_scene("res://Scenes/level_select_scene.tscn")

func _on_BtnPassar_pressed():
	used_trace_length = goal_trace_length + 1
	complete_level()

func _on_BtnGanhar_pressed():
	used_trace_length = goal_trace_length - 1
	complete_level()


func _on_BtnVoltar_pressed():
	get_tree().change_scene("res://Scenes/level_select_scene.tscn")


func _on_AddButton_pressed():
	mode = create


func _on_MoveButton_pressed():
	mode = move


func _on_DeleteButton_pressed():
	mode = delete
