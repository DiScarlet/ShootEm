extends Control

#VARS
@onready var ui: Node2D = $"../UI"

#FUNCS
#event funcs(buttons)
func _on_play_button_pressed() -> void:
	visible = false
	ui.visible = true
	GameManager.start_quest.emit()
	GameManager.start_game.emit()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
