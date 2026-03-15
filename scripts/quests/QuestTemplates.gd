extends Node

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
		"text": "Play only on the {side} part of the screen for {time} seconds" 
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
