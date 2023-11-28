extends Resource
class_name QuizQuestion

enum QuestionType { TEXT, IMAGE, AUDIO}

export(String) var quesiton_info
export(QuestionType) var type
export(Texture) var question_image
export(AudioStream) var question_audio
export(Array,String) var options
export(String) var correct
