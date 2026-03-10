extends Node2D

#VARS
#consts
const WINDOW_SIZE = GameManager.WINDOW_SIZE
const ENEMY_SPAWN_OFFSET = 160
#locals
var enemy_1 = preload("res://scenes/enemy.tscn")



#FUNCS
#system overrides
func _ready() -> void:
	GameManager.node_creation_parent = self
	GameManager.points = 0

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
		
	GameManager.instance_node(enemy_1, enemy_position, GameManager.node_creation_parent)
