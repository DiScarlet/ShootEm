extends Label

#FUNCS
#system overrides
func _ready() -> void:
	text = str(GameManager.high_score)
