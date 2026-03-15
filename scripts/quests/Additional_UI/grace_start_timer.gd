extends Timer

#VARS
#consts 
const GRACE_TIME = 4
#locals
var time_left_counter := GRACE_TIME
#Godot elements
@onready var start_time_label: Label = $"../StartTimeLabel"

#FUNCS
#system overrides
func _ready() -> void:
	QuestManager.start_grace_timer.connect(start_countdown)
	timeout.connect(_on_timeout) 
	
#action functions
func start_countdown():
	if not is_stopped():
		return
		
	time_left_counter = GRACE_TIME
	wait_time = 1.0
	one_shot = false 
	
	start_time_label.text = str(GRACE_TIME)
	start()
	
#event functions
func _on_timeout():
	print("In _on_timeout, time_left_counter: " + str(time_left_counter))
	time_left_counter -= 1
	start_time_label.text = str(time_left_counter)

	if time_left_counter <= 0:
		print("In time_left_counter <= 0")
		stop()
		start_time_label.text = "0"
		QuestManager.grace_timer_finished.emit()
