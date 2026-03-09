extends Sprite2D

#VARS
#consts
const SPEED = 150
#locals
	#player
var velocity = Vector2()
	#bullet
var bullet = preload("res://scenes/bullet.tscn")
var can_shoot = true
#Godot elements
@onready var timer_reload: Timer = $Timer_Reload


#FUNCS
#system overrides
func _ready() -> void:
	GameManager.player = self
	
func _exit_tree() -> void:
	GameManager.player = null
	
func _process(delta: float) -> void:
	velocity.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))	
	velocity.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))	
	
	velocity = velocity.normalized()
	global_position += SPEED * velocity * delta
	
	if Input.is_action_pressed("click") and GameManager.node_creation_parent != null and can_shoot:
		GameManager.instance_node(bullet, global_position, GameManager.node_creation_parent)
		start_reload()

#action functions
func start_reload():
	timer_reload.start()
	can_shoot = false
	
	
#event functions
func _on_timer_reload_timeout() -> void:
	can_shoot = true
