extends Node

#SIGNALS
signal start_quest
signal reset_level
signal player_ready

#VARS
#consts
	#system
const WINDOW_SIZE = Vector2i(1280, 720)
	#powerups
const DEFAULT_RELOAD_SPEED = 0.15
	#enemies
const BLOOD_SATURATION = 0.9
const BLOOD_VALUE = 0.25
	#other func's constants
const SHAKE_INTENSITY = 3
const DIFFICULTY_INTERVAL = 3.0
const MAX_DIFFICULTY = 0.2
#locals(for GameManager)/globals(for all nodes)
var node_creation_parent = null
var points = 0
	#UI
var high_score: int = 0
	#characters/npcs
var player = null
var camera = null
	#quests
var quest_type

#FUNCS
#action functions
func instance_node(node, location, parent):
	var node_instance = node.instantiate()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
	
func init_save_dict():
	var save_dict = {
		"highscore" : high_score
	}
	return save_dict
	
func save_game():
	var file = FileAccess.open_encrypted_with_pass("user://savegame.save", FileAccess.WRITE, get_save_key())
	file.store_line(JSON.stringify(init_save_dict()))
	file.close()
	
func load_game():
	var file_path = "user://savegame.save"
	
	if not FileAccess.file_exists(file_path):
		print("Ooopsie~! Save file not found.")
		return
		
	var file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, get_save_key())
	if not file:
		print("Ooopsie~! Can't open a save file.")
		return
		
	var json_string = file.get_as_text()
	var current_line = JSON.parse_string(json_string)
	
	high_score = current_line["highscore"]
	file.close() 
	
#helper functions
func get_save_key():
	var base = "k92!dL"
	var os = OS.get_name()
	var project = ProjectSettings.get_setting("application/config/name")
	return (base + os + project).sha256_text()
