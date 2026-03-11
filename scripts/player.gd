extends Sprite2D

#VARS
#consts
const SPEED = 150
const RESPAWN_TIME = 1.0
const WINDOW_SIZE = GameManager.WINDOW_SIZE
const PLAYER_SIZE = Vector2i(24, 24)
#locals
	#player
var velocity = Vector2()
var reload_speed = GameManager.DEFAULT_RELOAD_SPEED
	#bullet
var bullet = preload("res://scenes/bullet.tscn")
var can_shoot = true
var is_dead = false
	#powerup
var powerup_array = []
#Godot elements
@onready var timer_reload: Timer = $TimerReload


#FUNCS
#system overrides
func _ready() -> void:
	GameManager.player = self
	
func _exit_tree() -> void:
	GameManager.player = null
	
func _process(delta: float) -> void:
	velocity.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))	
	velocity.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))	
	
	var half_size = PLAYER_SIZE / 2
	global_position.x = clamp(global_position.x, PLAYER_SIZE.x, WINDOW_SIZE.x - PLAYER_SIZE.x)
	global_position.y = clamp(global_position.y, PLAYER_SIZE.y, WINDOW_SIZE.y - PLAYER_SIZE.y)
	
	velocity = velocity.normalized()
	global_position += SPEED * velocity * delta
	
	if Input.is_action_pressed("click") and GameManager.node_creation_parent != null and can_shoot and !is_dead:
		GameManager.instance_node(bullet, global_position, GameManager.node_creation_parent)
		start_reload()

#action functions
func start_reload():
	timer_reload.start()
	can_shoot = false
	
	
#event functions
func _on_timer_reload_timeout() -> void:
	can_shoot = true
	timer_reload.wait_time = reload_speed

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		is_dead = true
		visible = false
		await(get_tree().create_timer(RESPAWN_TIME).timeout)
		
		if GameManager.high_score < GameManager.points:
			GameManager.high_score = GameManager.points
			
		get_tree().reload_current_scene()

func _on_timer_power_up_timeout() -> void:
	if powerup_array.find("PowerUpReload") != null:
		reload_speed = GameManager.DEFAULT_RELOAD_SPEED
		powerup_array.erase("PowerUpReload")
