extends Node

enum QuestionType { TEXT, IMAGE, VIDEO, AUDIO }

export(Resource) var bd_quiz
export(Color) var color_right
export(Color) var color_wrong
export(Texture) var button_icon

var buttons := []
var index := 0
var tempo_restante = 60
var minutos = 0
var segundos = 0
var tempo_formatado = null
var numero_pergunta_atual = 1

onready var question_texts := $txt_question

func _ready() -> void:
	bd_quiz.bd.shuffle()
	for _button in $question_holder.get_children():
		buttons.append(_button)

	$Timer.connect("timeout", self, "_on_timer_timeout")
	$Timer.start()
	load_quiz()
	$help_half_awnser.disabled = false
	$help_university.disabled = false
	$help_public.disabled = false

func load_quiz() -> void:
	if index >= bd_quiz.bd.size():
		print("Fim do Quiz!")
		return

	$lbl_question_number.text = "QUESTION NUMBER: " + str(numero_pergunta_atual).pad_zeros(2)
	question_texts.text = str(bd_quiz.bd[index].question_info)

	for i in buttons.size():
		buttons[i].text = str(bd_quiz.bd[index].options[i])
		buttons[i].connect("pressed", self, "buttons_answer", [buttons[i]])

func buttons_answer(button) -> void:
	if bd_quiz.bd[index].correct == button.text:
		# Resposta Certa
		button.modulate = color_right
		numero_pergunta_atual += 1
		if numero_pergunta_atual == 16:
			$win_game.play()
			$Timer.stop()
			$win_screen.visible = true
		tempo_restante = 60
		$right_answer.play()
	else:
		# Resposta Errada
		button.modulate = color_wrong
		$wrong_answer.play()
		$lose_screen/causa_perca.text = "Escolheu a resposta errada!"
		$lose_screen/high_question.text = "Você chegou até a questão: " + str(numero_pergunta_atual).pad_zeros(2) +" /15"
		$lose_screen.visible = true
		
	yield(get_tree().create_timer(1), "timeout")
	for bt in buttons:
		bt.modulate = Color.white
		bt.disconnect("pressed", self, "buttons_answer")
	index += 1
	load_quiz()

func _on_timer_timeout():
	tempo_restante -= 1
	if tempo_restante > 0:
		minutos = tempo_restante / 60
		segundos = tempo_restante % 60
		tempo_formatado = String("%02d:%02d" % [minutos, segundos])
		$timer_sprite/lbl_timer.text = tempo_formatado
		if tempo_restante > 40:
			$timer_sprite.animation = "green_time"
		elif tempo_restante > 20 && tempo_restante <= 40:
			$timer_sprite.animation = "yellow_time"
		elif tempo_restante <= 20:
			$timer_sprite.animation = "red_time"
	else:
		$Timer.stop()
		$timer_sprite/lbl_timer.text = "00:00"
		$wrong_answer.play()
		$lose_screen/causa_perca.text = "Seu tempo acabou!"
		$lose_screen.visible = true

func _on_help_half_awnser_pressed():
	$audio_click_button.play()
	var respostas_erradas = []

	for option in bd_quiz.bd[index].options:
		if option != bd_quiz.bd[index].correct:
			respostas_erradas.append(option)

	if respostas_erradas.size() >= 2:
		respostas_erradas.shuffle()

		var respostas_a_mudar_cor = [respostas_erradas[0], respostas_erradas[1]]

		for bt in buttons:
			if bt.text in respostas_a_mudar_cor:
				bt.modulate = color_wrong

		$help_half_awnser.texture_normal = load("res://assets_sprites/lifelines_x2_used.png")
		$help_half_awnser.disabled = true
	else:
		print("Não há respostas suficientes para aplicar a dica 50:50.")

func _on_exit_button_pressed():
	$audio_click_button.play()
	get_tree().change_scene("res://scenes/Menu.tscn")


func _on_hint_ok_bttn_pressed():
	if $hints.visible == true:
		$hints.visible = false

func _on_help_university_pressed():
	$audio_click_button.play()
	var resposta_correta = bd_quiz.bd[index].correct		
	$hints/lbl_awnser.text = resposta_correta
	$hints/lbl_aux.text = "A resposta escolhida pelo universitário foi:"		
	$hints.visible = true
	$help_university.disabled = true
	$help_university.texture_normal = load("res://assets_sprites/lifelines_expert_used.png")

func _on_help_public_pressed():
	$audio_click_button.play()
	var resposta_correta = bd_quiz.bd[index].correct
	$hints/lbl_awnser.text = resposta_correta
	$hints/lbl_aux.text = "O público acha que é:"
	$hints.visible = true
	$help_public.disabled = true
	$help_public.texture_normal = load("res://assets_sprites/lifelines_aud_used.png")


func _on_btn_lose_pressed():
	$audio_click_button.play()
	$lose_screen.visible = false
	$win_screen.visible = false
	get_tree().change_scene("res://scenes/Menu.tscn")
