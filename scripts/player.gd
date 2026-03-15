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
var damage = 1
var default_damage = damage
#Godot elements
@onready var timer_reload: Timer = $TimerReload


#FUNCS
#system overrides
func _ready() -> void:
	GameManager.player = self
	GameManager.player_ready.emit()
	
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
		var bullet_instance = GameManager.instance_node(bullet, global_position, GameManager.node_creation_parent)
		bullet_instance.damage = damage
		start_reload()

#action functions
func start_reload():
	timer_reload.start()
	can_shoot = false
	
func die():
	is_dead = true
	visible = false
		
	save_highscore()
	GameManager.save_game()
	GameManager.reset_level.emit()
	await(get_tree().create_timer(RESPAWN_TIME).timeout)
			
	get_tree().reload_current_scene()
	
#event functions
func _on_timer_reload_timeout() -> void:
	can_shoot = true
	timer_reload.wait_time = reload_speed

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		die()

func _on_timer_power_up_timeout() -> void:
	if powerup_array.find("PowerUpReload") != null:
		reload_speed = GameManager.DEFAULT_RELOAD_SPEED
		powerup_array.erase("PowerUpReload")
	elif powerup_array.find("PowerUpDamage") != null:
		damage = default_damage
		powerup_array.erase("PowerUpDamage")
		
#helper functions
func save_highscore():
	if GameManager.high_score < GameManager.points:
			GameManager.high_score = GameManager.points
			
#quest functions
func get_current_side():
	if position.x < GameManager.WINDOW_SIZE.x / 2:
		return "left"
	else:
		return "right"
