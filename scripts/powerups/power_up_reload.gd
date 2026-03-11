extends Sprite2D

#FUNCS
#event functions
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		var player = area.get_parent()
		print(str(player))
		var timer = player.get_node("$TimerPowerUp")
		print(str(timer))
		player.reload_speed = 0.07
		timer.get_node("$TimerPowerUp").wait_time = 1
		timer.start()
		player.powerup_array.append("PowerUpReload")
		queue_free()
