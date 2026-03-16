extends Sprite2D


#VARS
#CONSTS
const LIFESPAN = 8.0
#exports
@export var player_var_modify: String
@export var player_var_set: float
@export var powerup_cooldown_time: float = 2
#Godot elements
@onready var lifespan_timer: Timer = $LifespanTimer


#FUNCS
#system overwrites
func _ready() -> void:
	lifespan_timer.wait_time = LIFESPAN
	lifespan_timer.start()
	lifespan_timer.timeout.connect(on_lifespan_timeout)
	
#event functions
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		print("POWERUP COLLECTED!")
		var player = area.get_parent()
		var timer = player.get_node("TimerPowerUp")
		
		QuestManager.powerup_collected.emit()
		
		player.set(player_var_modify, player_var_set)
		timer.wait_time = powerup_cooldown_time
		timer.start()
		player.powerup_array.append(name)
		queue_free()
		
func on_lifespan_timeout():
	QuestManager.powerup_skipped.emit()
	queue_free()
