extends KinematicBody2D

export var rotation_speed : float = 4.0


func _physics_process(delta: float) -> void:
	# The reason begind dividing by 2*PI is because 2PI radians is a whole rotation
	rotation += (rotation_speed) / (2*PI) * delta
