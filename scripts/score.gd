extends Label


#FUNCS
#system overrides
func _process(delta: float) -> void:
	text = str(GameManager.points)
