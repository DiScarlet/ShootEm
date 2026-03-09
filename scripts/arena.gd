extends Node2D

#VARS
#consts
const WINDOW_SIZE = Vector2i(1280, 720)
const ENEMY_SPAWN_OFFSET = 160
#locals
var enemy_1 = preload("res://scenes/enemy.tscn")



#FUNCS
#system overrides
func _ready() -> void:
	GameManager.node_creation_parent = self

func _exit_tree() -> void:
	GameManager.node_creation_parent = null

#event functions
func _on_enemy_spawn_timer_timeout() -> void:

	var enemy_position = Vector2(
		randi_range(-ENEMY_SPAWN_OFFSET, WINDOW_SIZE.x + ENEMY_SPAWN_OFFSET), 
		randi_range(-ENEMY_SPAWN_OFFSET, WINDOW_SIZE.y + ENEMY_SPAWN_OFFSET))

	while (
		enemy_position.x > 0 and enemy_position.x < WINDOW_SIZE.x and
		enemy_position.y > 0 and enemy_position.y < WINDOW_SIZE.y
	):
		enemy_position = Vector2(
			randi_range(-ENEMY_SPAWN_OFFSET, WINDOW_SIZE.x + ENEMY_SPAWN_OFFSET),
			randi_range(-ENEMY_SPAWN_OFFSET, WINDOW_SIZE.y + ENEMY_SPAWN_OFFSET)
		)
		
		GameManager.instance_node(enemy_1, enemy_position, GameManager.node_creation_parent)
