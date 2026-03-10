extends Node

#VARS
#consts
const WINDOW_SIZE = Vector2i(1280, 720)
	#other func's constants
const SHAKE_INTENSITY = 3
const DIFFICULTY_INTERVAL = 3.0
const MAX_DIFFICULTY = 0.2
#locals(for GameManager)/globals(for all nodes)
var node_creation_parent = null
var points = 0
	#UI
var high_score = 0
	#characters/npcs
var player = null
var camera = null


#FUNCS
#action functions
func instance_node(node, location, parent):
	var node_instance = node.instantiate()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
