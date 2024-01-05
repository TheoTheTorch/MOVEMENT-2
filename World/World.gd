extends Node2D
# Switching between fullscreen and not fullscreen by pressing esc



func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
