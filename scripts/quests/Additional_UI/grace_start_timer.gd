extends Timer

#VARS
#consts 
const GRACE_TIME = 5
#locals
var time_left_counter := GRACE_TIME
#Godot elements
@onready var start_time_label: Label = $"../StartTimeLabel"
@onready var static_label: Label = $"../StartsInLabel"

#FUNCS
#system overrides
func _ready() -> void:
	set_labels_visibility(false)
	QuestManager.start_grace_timer.connect(start_countdown)
	timeout.connect(_on_timeout) 
	
#action functions
func start_countdown():
	if not is_stopped():
		return
	print("Grace timer has STARTED")
	
	set_labels_visibility(true)
	
	time_left_counter = GRACE_TIME
	wait_time = 1.0
	one_shot = false 
	
	start_time_label.text = str(GRACE_TIME)
	start()
	
#event functions
func _on_timeout():
	time_left_counter -= 1
	start_time_label.text = str(time_left_counter)

	if time_left_counter <= 0:
		stop()
		
		set_labels_visibility(false)
		
		print("Grace timer has finished")
		QuestManager.grace_timer_finished.emit()
		
#helper funcs
func set_labels_visibility(is_visible:bool):
	start_time_label.visible = is_visible
	static_label.visible = is_visible
