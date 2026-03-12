extends Sprite2D


#VARS
#exports
@export var player_var_modify: String
@export var player_var_set: float
@export var powerup_cooldown_time: float = 2

#FUNCS
#event functions
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		var player = area.get_parent()
		var timer = player.get_node("TimerPowerUp")

		player.set(player_var_modify, player_var_set)
		timer.wait_time = powerup_cooldown_time
		timer.start()
		player.powerup_array.append(name)
		queue_free()
