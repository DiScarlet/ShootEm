extends Sprite2D

#VARS
#consts
const SPEED = 150
#locals
var velocity = Vector2()
var bullet = preload("res://scenes/bullet.tscn")


#FUNCS
#system overrides
func _process(delta: float) -> void:
	velocity.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))	
	velocity.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))	
	
	velocity = velocity.normalized()
	global_position += SPEED * velocity * delta
	
	if Input.is_action_just_pressed("click") and GameManager.node_creation_parent != null:
		GameManager.instance_node(bullet, global_position, GameManager.node_creation_parent)
