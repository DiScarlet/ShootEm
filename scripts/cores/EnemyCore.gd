extends Sprite2D

#VARS
#exports
@export var SPEED = 80
@export var MAX_HP = 3
@export var KNOCKBACK = 600
#locals
var velocity = Vector2()
var stun = false
@onready var hp = MAX_HP
var blood_particles = preload("res://scenes/blood_particles.tscn")
#Godot elements
@onready var stun_timer: Timer = $StunTimer
@onready var current_color = modulate

#FUNCS
#system overrides
func _process(_delta: float) -> void:
	if hp <= 0:
		if GameManager.camera != null:
			GameManager.camera.screen_shake(GameManager.SHAKE_INTENSITY, 0.1)
			
		GameManager.points += 10
		if GameManager.node_creation_parent != null:
			var blood_part_instance = GameManager.instance_node(blood_particles, global_position, GameManager.node_creation_parent)
			blood_part_instance.rotation = velocity.angle()
			blood_part_instance.modulate = Color.from_hsv(current_color.h, GameManager.BLOOD_SATURATION, GameManager.BLOOD_VALUE)
		queue_free()
		
#action items
func basic_movement_towards_player(delta: float) -> void:
	if GameManager.player != null and stun == false:
		velocity = global_position.direction_to(GameManager.player.global_position)
		global_position += velocity * SPEED * delta
	elif stun:
		velocity = lerp(velocity, Vector2(0, 0), 0.3)
		global_position += velocity * delta
	
#event functions
	#custom 
func on_damaged(stun_timer: Timer):
		modulate = Color(1, 1, 1)
		velocity = -velocity * KNOCKBACK
		hp -= 1
		stun = true
		stun_timer.start()

	#system
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyDamager") and !stun:
		on_damaged(stun_timer)
		area.get_parent().queue_free()
		
func _on_stun_timer_timeout() -> void:
	modulate = Color(current_color)
	stun = false
	
