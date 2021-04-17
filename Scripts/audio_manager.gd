extends Node

var ConnectionPlayer
var LoopPlayer
var ButtonPlayer

# Audio preloads
var Audio = {
	# Connections
	connection_complete = preload("res://Audio/connection_complete.wav"),
	connection_wrong = preload("res://Audio/connection_wrong.wav"),
	
	# Traces
	trace_selected = preload("res://Audio/trace_selected.tres"),
	trace_hold = preload("res://Audio/trace_hold.tres"),
	
	# Buttons
	advance = preload("res://Audio/advance.wav"),
	cancel = preload("res://Audio/cancel.wav"),
	confirm = preload("res://Audio/confirm.wav"),
	undo = preload("res://Audio/undo.wav"),
	options = preload("res://Audio/options.wav"),
	close = preload("res://Audio/close.wav"),
	menu = preload("res://Audio/menu.wav"),
	audio_on = preload("res://Audio/audio_on.wav"),
	audio_off = preload("res://Audio/audio_off.wav")
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
