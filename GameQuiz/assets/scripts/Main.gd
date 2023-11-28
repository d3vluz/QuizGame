extends Control

func _ready():
	$VBoxContainer/startBtn.grab_focus()

func _on_startBtn_pressed():
	get_tree().change_scene("res://assets/scenes/Jogo.tscn")

func _on_exitBtn_pressed():
	get_tree().quit()
