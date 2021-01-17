extends Node2D

export (int) var level_number

export (float) var goal_trace_length
export (float) var used_trace_length

onready var level_label = $LblNumber

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func complete_level():
	get_tree().change_scene("res://Scenes/level__select_scene.tscn")

func _on_BtnPassar_pressed():
	used_trace_length = goal_trace_length + 1
	complete_level()

func _on_BtnGanhar_pressed():
	used_trace_length = goal_trace_length - 1
	complete_level()


func _on_BtnVoltar_pressed():
	get_tree().change_scene("res://Scenes/level__select_scene.tscn")
