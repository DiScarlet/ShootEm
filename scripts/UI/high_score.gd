extends Label

#FUNCS
#system overrides
func _ready() -> void:
	GameManager.load_game()
	text = str(GameManager.high_score)
