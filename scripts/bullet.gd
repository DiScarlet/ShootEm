extends Sprite2D

#VARS
#consts
const VELOCITY = Vector2(1, 0)
const SPEED = 250
#locals
var look_once = true
var damage


#FUNCS
func _process(delta: float) -> void:
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false 
		
	global_position += VELOCITY.rotated(rotation) * SPEED * delta


#event functions
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	QuestManager.bullet_missed.emit()
	queue_free()
