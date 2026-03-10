extends Sprite2D

#VARS
#consts
const SPEED = 80
const MAX_HP = 3
#locals
var velocity = Vector2()
var stun = false
var hp = MAX_HP
var blood_particles = preload("res://scenes/blood_particles.tscn")
#Godot elements
@onready var stun_timer: Timer = $StunTimer


#FUNCS
#system overrides
func _process(delta: float) -> void:
	if GameManager.player != null and stun == false:
		velocity = global_position.direction_to(GameManager.player.global_position)
	elif stun:
		velocity = lerp(velocity, Vector2(0, 0), 0.3)
		
	global_position += velocity * SPEED * delta
	
	if hp <= 0:
		GameManager.points += 10
		if GameManager.node_creation_parent != null:
			var blood_part_instance = GameManager.instance_node(blood_particles, global_position, GameManager.node_creation_parent)
			blood_part_instance.rotation = velocity.angle()
		queue_free()


#event functions
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyDamager"):
		modulate = Color(1, 1, 1)
		velocity = -velocity * 4
		hp -= 1
		stun = true
		stun_timer.start()
		area.get_parent().queue_free()

func _on_stun_timer_timeout() -> void:
	modulate = Color("14a718")
	stun = false
