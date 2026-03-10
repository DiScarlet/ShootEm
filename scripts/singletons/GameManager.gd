extends Node

#VARS
#consts
const WINDOW_SIZE = Vector2i(1280, 720)
#locals(for GameManager)/globals(for all nodes)
var node_creation_parent = null
var points = 0
	#characters/npcs
var player = null


#FUNCS
#action functions
func instance_node(node, location, parent):
	var node_instance = node.instantiate()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
