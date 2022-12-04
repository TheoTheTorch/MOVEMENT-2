extends KinematicBody2D

export var rotation_speed : float = 4.0

func _physics_process(delta: float) -> void:
	rotation += (rotation_speed) / (2*PI) * delta
