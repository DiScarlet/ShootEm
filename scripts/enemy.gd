extends "res://scripts/cores/EnemyCore.gd"

#FUNCS
#system overrides
func _process(delta: float) -> void:
	basic_movement_towards_player(delta)
