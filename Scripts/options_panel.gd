extends CanvasLayer

func slide_in():
	$AnimationPlayer.play("slide_in_options")
	
func slide_out():
	$AnimationPlayer.play_backwards("slide_in_options")


func _on_TextureButton_pressed():
	slide_out()
