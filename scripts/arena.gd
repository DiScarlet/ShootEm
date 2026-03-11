extends Node2D

#VARS
#consts
const WINDOW_SIZE = GameManager.WINDOW_SIZE
const ENEMY_SPAWN_OFFSET = 160
#exports
@export var enemies: Array [PackedScene]
#locals
#Godot elements
@onready var interval_timer: Timer = $IntervalTimer
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer


#FUNCS
#system overrides
func _ready() -> void:
	GameManager.node_creation_parent = self
	GameManager.points = 0
	interval_timer.wait_time = GameManager.DIFFICULTY_INTERVAL

func _exit_tree() -> void:
	GameManager.node_creation_parent = null

#event functions
func _on_enemy_spawn_timer_timeout() -> void:
	var x
	var y
	var x_inside = randi_range(0, 2)
	
	if x_inside:
		var first_x = randi_range(0, 2)
		if first_x:
			x = randi_range(-ENEMY_SPAWN_OFFSET, 0)
		else:
			x = randi_range(WINDOW_SIZE.x, WINDOW_SIZE.x + ENEMY_SPAWN_OFFSET)
			
		y = randi_range(-ENEMY_SPAWN_OFFSET, WINDOW_SIZE.y + ENEMY_SPAWN_OFFSET)
	else:
		var first_y = randi_range(0, 2)
		if first_y:
			y = randi_range(-ENEMY_SPAWN_OFFSET, 0)
		else:
			y = randi_range(WINDOW_SIZE.y, WINDOW_SIZE.y + ENEMY_SPAWN_OFFSET)
		
		x = randi_range(-ENEMY_SPAWN_OFFSET, WINDOW_SIZE.x + ENEMY_SPAWN_OFFSET)
		
	var enemy_position = Vector2(x ,y)		
	var enemy_ind = randi_range(0, enemies.size() - 1)
	
	GameManager.instance_node(enemies[enemy_ind], enemy_position, GameManager.node_creation_parent)

func _on_interval_timer_timeout() -> void:
	if enemy_spawn_timer.wait_time >= GameManager.MAX_DIFFICULTY:
		var new_time = enemy_spawn_timer.wait_time * 0.95
		enemy_spawn_timer.wait_time = round(new_time * 1000.0) / 1000.0
