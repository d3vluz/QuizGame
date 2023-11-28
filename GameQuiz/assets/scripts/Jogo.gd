extends Control

export(Resource) var bd_quiz
export(Color) var color_right
export(Color) var color_wrong

var buttons := []
var index := 0
var score := 0

onready var question_texts := $question_info/txt_question
onready var question_image := $question_info/Panel/question_image
onready var question_audio := $question_info/Panel/question_audio

func _ready() -> void:
	for _button in $question_holder.get_children():
		buttons.append(_button)
		
	load_quiz()

func load_quiz() -> void:
	question_texts.text = str(bd_quiz.bd[index].question_info)
	for i in buttons.size():
		buttons[i].text = str(bd_quiz.bd[index].options[i])
		buttons[i].connect("pressed", self, "buttons_answer", [buttons[i]] )

func buttons_answer(button) -> void:
	if bd_quiz.bd[index].correct == button.text:
		button.modulate = color_right
	else:
		button.modulate = color_wrong
