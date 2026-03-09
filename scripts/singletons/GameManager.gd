extends Node

#VARS
#locals(for GameManager)/globals(for all nodes)
var node_creation_parent = null



#FUNCS
#action functions
func instance_node(node, location, parent):
	var node_instance = node.instantiate()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
