tool
extends Node2D
# Script controlling a moving platform.
# Updating the move_to varaiable works in editor to speed up level design
# This code can work with moving spikes and alike, all you need is swap out the reference to MovedObject.
# And also Make the child an Area2D that reacts to the player collisions.

export var move_to := Vector2(0, -256) setget set_move_to
export var speed: int = 64
export var stop_time: float = 0.4

onready var MovedObject : KinematicBody2D = $ActualPlatform


func set_move_to(n: Vector2) -> void:
	move_to = n
	if Engine.editor_hint and is_instance_valid(MovedObject):
		MovedObject.position = move_to


func _ready() -> void:
	set_move_to(move_to)
	if not Engine.editor_hint:
		set_process(false)
		start_tween()


func _process(_delta: float) -> void:
	update()


func _draw() -> void:
	draw_line(move_to, -move_to, Color.white, 4.0, false)


func start_tween() -> void:
	MovedObject.position = move_to
	var time = move_to.length() / float(speed)
	var tween: SceneTreeTween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD) # warning-ignore:return_value_discarded
	tween.tween_property(MovedObject, "position", -move_to, time).set_delay(stop_time) # warning-ignore:return_value_discarded
	tween.tween_property(MovedObject, "position", move_to, time).set_delay(stop_time) # warning-ignore:return_value_discarded
	tween.set_loops() # warning-ignore:return_value_discarded
