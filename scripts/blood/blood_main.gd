extends Node2D


#VARS
#locals
var is_fading = false
var alpha = 1.0


#FUNCS
#system overrides
func _process(_delta) -> void:
	if is_fading:
		alpha = lerp(alpha, 0.0, 0.1)
		modulate.a = alpha
		
		if alpha < 0.005:
			queue_free()

#event functions
func _on_fade_out_timer_timeout() -> void:
	is_fading = true
