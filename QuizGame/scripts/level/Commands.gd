extends Control

func _ready():
	$return_button.grab_focus()

func _on_return_button_pressed():
	$button_sound.play()
	get_tree().change_scene("res://scenes/Menu.tscn")
