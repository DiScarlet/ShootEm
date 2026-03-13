extends Label


#FUNCS
#system overrides
func _ready() -> void:
	QuestManager.update_quest_label.connect(on_label_update)
	
#event functions
func on_label_update(new_text: String):
	text = new_text
