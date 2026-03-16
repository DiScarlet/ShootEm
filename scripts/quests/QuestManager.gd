extends Node

#SINALS 
signal enemy_killed(color:String)
signal powerup_collected
signal powerup_skipped
signal bullet_missed
signal update_quest_label(new_text: String)
signal start_grace_timer
signal grace_timer_finished
signal player_moved
signal cursor_moved

#VARS
#consts
	#limits for a to do
const MAX_ENEMIES_TO_KILL = 10
const MIN_TIME = 35
#locals
var player
var quest_templates = QuestTemplates.quest_templates
var current_template = "kill_enemy"
var is_process_active = false
var time_left_in_quest = 0
var quest_state
	#to do for a quest
var enemies_to_kill = 2
var powerups_to_collect = 1
var target_color = "green"
var time_limit = 55
var quest_duration = 0
var side_to_stay = "right"
var time_cursor_to_be_stationary = 2
	#done for a quest
var enemies_killed = 0
var powerups_collected = 0
#lists/dicts/enums
var enemy_colors = ["green", "blue", "yellow"]
var screen_sides = ["right", "left"]
enum QuestState {
	PREPARING,
	ACTIVE,
	FINISHED
}
#Godot elements
var quest_timer: Timer

#FUNCS
#system overrides
func _ready() -> void:
	#create new elements
	quest_timer = Timer.new()
	add_child(quest_timer)
	quest_timer.one_shot = true
	
	#connect to signals
	GameManager.start_quest.connect(generate_random_quest)
	GameManager.reset_level.connect(reset_difficulty)
	
	enemy_killed.connect(on_enemy_killed)
	powerup_collected.connect(on_powerup_collected)
	powerup_skipped.connect(on_powerup_skipped)
	bullet_missed.connect(on_bullet_missed)
	player_moved.connect(on_player_moved)
	cursor_moved.connect(on_cursor_moved)
	
func _process(delta: float) -> void:
	if is_process_active and quest_state == QuestState.ACTIVE:
		if current_template == "location_play":
			check_side(delta)
	
#action functions
func generate_random_quest():
	quest_state = QuestState.PREPARING
	
	if GameManager.player == null:
		player = await GameManager.player_ready
	else:
		player = GameManager.player
		
	#HRDCODED FOR TESTING replace with current_template = quest_templates.keys().pick_random()
	current_template = "cursor_hold"
	GameManager.quest_type = current_template
	var template = quest_templates[current_template]
	
	enemies_killed = 0
	powerups_collected = 0
	
	populate_quest_vars()
	update_quest_text()
	
	if current_template == "location_play":
		start_location_quest()
	elif current_template == "timed_no_kill" or current_template == "timed_only_kill" or current_template == "accuracy":
		start_base_timer(quest_duration)	
	elif current_template == "combo_kill":
		start_base()
	elif current_template == "multi_kill":
		start_multi_kill()
	elif current_template == "no_move_kill":
		start_base()
	elif current_template == "cursor_hold":
		start_base_timer(time_cursor_to_be_stationary)
	
func complete_quest():
	quest_state = QuestState.FINISHED
	print("quest completed!")
	stop_timer_and_disconnect()
	
	generate_random_quest()
	
func fail_quest():
	quest_state = QuestState.FINISHED
	stop_timer_and_disconnect()
	print("quest failed, you bastard! - in James May's voice")
	player.die()
	
	is_process_active = false
	set_process(false)
	
func reset_difficulty():
	quest_state = QuestState.PREPARING
	enemies_to_kill = 2
	powerups_to_collect = 1
	target_color = "green"
	time_limit = 55
	quest_duration = 0
	enemies_killed = 0
	time_cursor_to_be_stationary = 2
	
#helper functions
func populate_quest_vars():
	if current_template == "kill_enemy":
		target_color = enemy_colors.pick_random()
		enemies_killed = 0
		increment_enemies_to_kill()
		
		quest_state = QuestState.ACTIVE
	
	elif current_template == "location_play":
		side_to_stay = screen_sides.pick_random()
		quest_duration += 5
		time_left_in_quest = quest_duration
		
	elif current_template == "timed_no_kill" or current_template == "accuracy":
		quest_duration += 5
	elif current_template == "timed_only_kill":
		target_color = enemy_colors.pick_random()
		quest_duration += 5
	elif current_template == "powerup_collect":
		powerups_to_collect += 1
		quest_state = QuestState.ACTIVE
	elif current_template == "powerup_skip":
		quest_state = QuestState.ACTIVE
	elif current_template == "combo_kill" or current_template == "no_move_kill":
		increment_enemies_to_kill()
	elif current_template == "multi_kill":
		increment_enemies_to_kill()
		time_limit -= 5
	elif current_template == "cursor_hold":
		time_cursor_to_be_stationary += 3
		
func increment_enemies_to_kill():
	if enemies_to_kill <= MAX_ENEMIES_TO_KILL:
		enemies_to_kill += 1
		
func update_quest_text():
	var quest_text = quest_templates[current_template]["text"]
	
	if current_template == "kill_enemy":
		quest_text = quest_text.replace("{count}", str(enemies_to_kill))
		quest_text = quest_text.replace("{color}", target_color)
	elif current_template == "location_play":
		quest_text = quest_text.replace("{side}", side_to_stay)
		quest_text = quest_text.replace("{time}", str(quest_duration))
	elif current_template == "timed_no_kill" or current_template == "accuracy":
		quest_text = quest_text.replace("{time}", str(quest_duration))
	elif current_template == "timed_only_kill":
		quest_text = quest_text.replace("{color}", target_color)
		quest_text = quest_text.replace("{time}", str(quest_duration))
	elif current_template == "powerup_collect":
		quest_text = quest_text.replace("{count}", str(powerups_to_collect))
	elif current_template == "combo_kill" or current_template == "no_move_kill":
		quest_text = quest_text.replace("{count}", str(enemies_to_kill))
	elif current_template == "multi_kill":
		quest_text = quest_text.replace("{count}", str(enemies_to_kill))
		quest_text = quest_text.replace("{time}", str(time_limit))
	elif current_template == "cursor_hold":
		quest_text = quest_text.replace("{time}", str(time_cursor_to_be_stationary))
		
	update_quest_label.emit(quest_text)
	
	
#quest-specific start functions
func start_base():
	start_grace_timer.emit()
	await grace_timer_finished
	quest_state = QuestState.ACTIVE
	
func start_base_timer(time):
	start_base()
	quest_timer.wait_time = time
	if !quest_timer.timeout.is_connected(complete_quest):
		quest_timer.timeout.connect(complete_quest)
	quest_timer.start()
	
	
func start_location_quest():
	start_base()
	is_process_active = true
	set_process(true)
	
func start_multi_kill():
	start_base()
	quest_timer.wait_time = time_limit
	if !quest_timer.timeout.is_connected(fail_quest):
		quest_timer.timeout.connect(fail_quest)
		
#quest-specific helper functions
func check_side(delta):
	if player.get_current_side() != side_to_stay:
		fail_quest()
	else:
		time_left_in_quest -= delta
		
	if time_left_in_quest <= 0:
		complete_quest()
		
#player events functions
func on_enemy_killed(color):
	if quest_state != QuestState.ACTIVE:
		return
		
	if current_template == "kill_enemy":
		if color == target_color:
			enemies_killed += 1
			
		if enemies_killed >= enemies_to_kill:
			complete_quest()
			
	elif current_template == "timed_no_kill":
		fail_quest()
		
	elif current_template == "timed_only_kill":
		if color != target_color:
			fail_quest()
			
	elif current_template == "combo_kill" or current_template == "multi_kill" or current_template == "no_move_kill":
			enemies_killed += 1
			
			if enemies_killed >= enemies_to_kill:
				complete_quest()
				
				
func on_powerup_collected():
	if quest_state != QuestState.ACTIVE:
		return
		
	if current_template == "powerup_collect":
		powerups_collected += 1
		if powerups_collected == powerups_to_collect:
			complete_quest()
	
	elif current_template == "powerup_skip":
		fail_quest()
		

func on_powerup_skipped():
	if quest_state != QuestState.ACTIVE:
		return
		
	if current_template == "powerup_skip":
		complete_quest()
		

func on_bullet_missed():
	if quest_state != QuestState.ACTIVE:
		return
		
	if current_template == "combo_kill" or current_template == "accuracy":
		fail_quest()
		
func on_player_moved():
	if quest_state != QuestState.ACTIVE:
		return
		
	if current_template == "no_move_kill":
		fail_quest()
		
func on_cursor_moved():
	if quest_state != QuestState.ACTIVE:
		return
		
	if current_template == "cursor_hold":
		fail_quest()
		
#system helper functions
func stop_timer_and_disconnect():
	if !quest_timer.is_stopped():
		quest_timer.stop()
		
	if quest_timer.timeout.is_connected(complete_quest):
		quest_timer.timeout.disconnect(complete_quest)
		
	if quest_timer.timeout.is_connected(fail_quest):
		quest_timer.timeout.disconnect(fail_quest)
	
