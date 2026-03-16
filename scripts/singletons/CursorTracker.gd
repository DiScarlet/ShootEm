extends Node

#VARS
#consts
const MOVE_THRESHHOLD = 10.0
#locals
var last_mouse_position: Vector2
var viewport 

#FUNCS
#system overrides
func _ready() -> void:
	viewport = get_viewport()
	if viewport == null:
		print("Viewport is null")
		
	last_mouse_position = viewport.get_mouse_position()
	
func _process(delta: float) -> void:
	var current_position = viewport.get_mouse_position()
	if current_position.distance_to(last_mouse_position) > MOVE_THRESHHOLD:
		QuestManager.cursor_moved.emit()
		last_mouse_position = current_position
	
