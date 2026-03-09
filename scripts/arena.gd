extends Node2D


#FUNCS
#system overrides
func _ready() -> void:
	GameManager.node_creation_parent = self

func _exit_tree() -> void:
	GameManager.node_creation_parent = null
