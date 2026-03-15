extends Node

#SINALS 
signal enemy_killed(color:String)
signal update_quest_label(new_text: String)
signal start_grace_timer
signal grace_timer_finished

#VARS
#consts
	#limits for a to do
const MAX_ENEMIES_TO_KILL = 10
const MIN_TIME = 5
#locals
var player
var quest_templates = QuestTemplates.quest_templates
var current_template = "kill_enemy"
var is_process_active = false
	#to do for a quest
var enemies_to_kill = 2
var powerups_to_collect = 1
var target_color = "green"
var time_limit = 25
var quest_duration = 0
var side_to_stay = "right"
	#done for a quest
var enemies_killed = 0
#lists/dicts
var enemy_colors = ["green", "blue", "yellow"]
var screen_sides = ["right", "left"]

#FUNCS
#system overrides
func _ready() -> void:
	GameManager.start_quest.connect(generate_random_quest)
	enemy_killed.connect(on_enemy_killed)
	GameManager.reset_level.connect(reset_difficulty)
	
func _process(_delta: float) -> void:
	if is_process_active:
		
		if current_template == "location_play":
			check_side()
	
#action functions
func generate_random_quest():
	if GameManager.player == null:
		player = await GameManager.player_ready
	else:
		player = GameManager.player
		
	enemies_killed = 0
	#HRDCODED FOR TESTING replace with current_template = quest_templates.keys().pick_random()
	current_template = "location_play"
	GameManager.quest_type = current_template
	var template = quest_templates[current_template]
	
	if current_template == "location_play":
		start_location_quest()
		
	populate_quest_vars()
	update_quest_text()
	
func complete_quest():
	print("quest completed!")
	generate_random_quest()
	
func fail_quest():
	print("quest failed, you bastard! - in James May's voice")
	player.die()
	
	is_process_active = false
	set_process(false)
	
func reset_difficulty():
	enemies_to_kill = 2
	powerups_to_collect = 1
	target_color = "green"
	time_limit = 25
	enemies_killed = 0
	
#helper functions
func populate_quest_vars():
	if current_template == "kill_enemy":
		target_color = enemy_colors.pick_random()
		enemies_killed = 0
		if enemies_to_kill <= MAX_ENEMIES_TO_KILL:
			enemies_to_kill += 1
	
	if current_template == "location_play":
		side_to_stay = screen_sides.pick_random()
		quest_duration += 5
		
func update_quest_text():
	var quest_text = quest_templates[current_template]["text"]
	
	if current_template == "kill_enemy":
		quest_text = quest_text.replace("{count}", str(enemies_to_kill))
		quest_text = quest_text.replace("{color}", target_color)
	if current_template == "location_play":
		quest_text = quest_text.replace("{side}", side_to_stay)
		quest_text = quest_text.replace("{time}", str(quest_duration))
			
	update_quest_label.emit(quest_text)
	
	
#quest-specific start functions
func start_location_quest():
	print("Starting grace timer")
	start_grace_timer.emit()
	await grace_timer_finished
	is_process_active = true
	set_process(true)
	
#quest-specific helper functions
func check_side():
	if player.get_current_side() != side_to_stay:
		fail_quest()
		
#player events functions
func on_enemy_killed(color):
	if current_template == "kill_enemy":
		if color == target_color:
			enemies_killed += 1
			
		if enemies_killed >= enemies_to_kill:
			complete_quest()
		
