extends Control

var color_palettes = [
	[Color(0.098039, 0.094118, 0.815686), Color(0.078431, 0.470588, 0.901961), Color(0.984314, 0.984314, 0.984314)],  # Padrão de cor 1
	[Color(0.976471, 0.062745, 0.062745), Color(0.933333, 0.67451, 0.058824), Color(0.929412, 0.956863, 0.066667)]   # Padrão de cor 2
]
var current_palette_index = 0

func _ready():
	change_label_colors()
	$Timer.start()
	$Container/btn_start_game.grab_focus()

func _on_btn_start_game_pressed():
	$btn_audio.play()
	get_tree().change_scene("res://scenes/Level_game.tscn")

func _on_btn_commands_pressed():
	$btn_audio.play()
	get_tree().change_scene("res://scenes/Commands.tscn")

func _on_btn_quit_game_pressed():
	$btn_audio.play()
	get_tree().quit()

func _on_Timer_timeout():
	change_label_colors()
	$Timer.start()

func change_label_colors():
	var current_palette = color_palettes[current_palette_index]

	$Game_name.modulate = current_palette[0]
	$Game_name2.modulate = current_palette[1]
	$Game_name3.modulate = current_palette[2]

	current_palette_index = (current_palette_index + 1) % len(color_palettes)
