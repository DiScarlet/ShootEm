extends Camera2D

#VARS
#consts
#locals
var is_screen_shaking = false
var shake_intensity = 0
#Godot elements
@onready var shake_timer: Timer = $ScreenShakeTimer


#FUNCS
#system overrides
func _ready() -> void:
	GameManager.camera = self
	
func _exit_tree() -> void:
	GameManager.camera = null
	
func _process(delta: float) -> void:
	zoom = lerp(zoom, Vector2(1, 1), 0.3)
	
	if is_screen_shaking:
		global_position += Vector2(randi_range(-shake_intensity, shake_intensity), randi_range(-shake_intensity, shake_intensity)) * delta
		
#action functions
func screen_shake(intensity, time):
	zoom = Vector2(1, 1) - Vector2(intensity * 0.002, intensity * 0.02)
	shake_intensity = intensity
	shake_timer.wait_time = time
	shake_timer.start()
	is_screen_shaking = true
	
#event functions
func _on_screen_shake_timer_timeout() -> void:
	is_screen_shaking = false
	global_position = GameManager.WINDOW_SIZE / 2
