extends Node

#SINALS 
signal enemy_killed(color:String)
signal update_quest_label(new_text: String)

#VARS
#consts
	#limits for a to do
const MAX_ENEMIES_TO_KILL = 10
const MIN_TIME = 5
#locals
var current_template = "kill_enemy"
	#to do for a quest
var enemies_to_kill = 2
var powerups_to_collect = 1
var target_color = "red"
var time_limit = 25
	#done for a quest
var enemies_killed = 0
#lists/dicts
var enemy_colors = ["red", "blue", "yellow"]
var screen_sides = ["right", "left"]
var quest_templates = {
	"kill_enemy": {
		"type": "kill",
		"text": "Kill {count} {color} enemies"
	},

	"avoid_kill": {
		"type": "future",
		"text": "Avoid killing {color} enemies while completing the next task"
	},

	"location_play": {
		"type": "location",
		"text": "Play only on the {side} part of the screen"
	},

	"timed_no_kill": {
		"type": "timed",
		"text": "Do not kill any enemies for {time} seconds"
	},

	"timed_only_kill": {
		"type": "timed",
		"text": "Kill only {color} enemies for {time} seconds"
	},

	"powerup_collect": {
		"type": "powerup",
		"text": "Collect {count} powerups"
	},

	"powerup_skip": {
		"type": "powerup",
		"text": "Skip collecting the next powerup"
	},

	"combo_kill": {
		"type": "skill",
		"text": "Kill {count} enemies in a row without missing"
	},

	"multi_kill": {
		"type": "skill",
		"text": "Kill {count} enemies within {time} seconds"
	},

	"no_move_kill": {
		"type": "skill",
		"text": "Kill {count} enemies without moving"
	},

	"accuracy": {
		"type": "skill",
		"text": "Miss no shots for {time} seconds"
	},

	"cursor_hold": {
		"type": "cursor",
		"text": "Do not move the cursor for {time} seconds"
	},

	"center_only": {
		"type": "movement",
		"text": "Stay near the center of the screen for {time} seconds"
	},

	"border_only": {
		"type": "movement",
		"text": "Stay near the borders of the screen for {time} seconds"
	}
}

#FUNCS
#system overrides
func _ready() -> void:
	GameManager.start_quest.connect(generate_random_quest)
	enemy_killed.connect(on_enemy_killed)
	
#action functions
func generate_random_quest():
	print("generate_random_quest")
	#HRDCODED FOR TESTING replace with current_template = quest_templates.keys().pick_random()
	current_template = "kill_enemy"
	GameManager.quest_type = current_template
	var template = quest_templates[current_template]
	
	populate_quest_vars()
	update_quest_text()
	
func complete_quest():
	print("quest completed!")
	
	
#helper functions
func populate_quest_vars():
	if current_template == "kill_enemy":
		target_color = enemy_colors.pick_random()
		enemies_killed = 0
		if enemies_to_kill <= MAX_ENEMIES_TO_KILL:
			enemies_to_kill += 1

func update_quest_text():
	print("update_quest_text")
	var quest_text = quest_templates[current_template]["text"]
	
	quest_text = quest_text.replace("{count}", str(enemies_to_kill))
	quest_text = quest_text.replace("{color}", target_color)
	print(quest_text)
	
	update_quest_label.emit(quest_text)
	
#player events functions
func on_enemy_killed(color):
	if current_template == "kill_enemy":
		if color == target_color:
			enemies_killed += 1
			
		if enemies_killed >= enemies_to_kill:
			complete_quest()
