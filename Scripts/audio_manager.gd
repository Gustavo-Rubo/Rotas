extends Node

var ConnectionPlayer
var LoopPlayer
var ButtonPlayer

# Audio preloads
var Audio = {
	connection_complete = preload("res://Audio/connection_complete.wav"),
	connection_wrong = preload("res://Audio/connection_wrong.wav"),
	trace_selected = preload("res://Audio/trace_selected.tres"),
	trace_hold = preload("res://Audio/trace_hold.tres")
}

func play_connection(con):
	ConnectionPlayer.set_stream(Audio[con])
	ConnectionPlayer.play()

func play_button(button):
	ButtonPlayer.set_stream(Audio[button])
	ButtonPlayer.play()
	
func play_loop(loop):
	if LoopPlayer.get_stream() != Audio[loop] or !LoopPlayer.playing:
		LoopPlayer.set_stream(Audio[loop])
		LoopPlayer.play()

func stop_loop():
	LoopPlayer.stop()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	ConnectionPlayer = AudioStreamPlayer.new()
	ConnectionPlayer.set_bus("Connections")
	LoopPlayer = AudioStreamPlayer.new()
	LoopPlayer.set_bus("Traces")
	ButtonPlayer = AudioStreamPlayer.new()
	ButtonPlayer.set_bus("Buttons")

	add_child(ConnectionPlayer)
	add_child(LoopPlayer)
	add_child(ButtonPlayer)	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(ConnectionPlayer.playing)
