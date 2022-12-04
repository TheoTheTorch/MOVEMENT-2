extends Node2D
tool

export var move_to := Vector2(0, -256) setget set_move_to
func set_move_to(n: Vector2) -> void:
	move_to = n
	if Engine.editor_hint and is_instance_valid(Platform):
		Platform.position = move_to

export var speed: int = 64
export var delay: float = 0.4

onready var Platform : KinematicBody2D = $ActualPlatform

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
	Platform.position = move_to
	var time = move_to.length() / float(speed)
	var tween: SceneTreeTween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD) # warning-ignore:return_value_discarded
	tween.tween_property(Platform, "position", -move_to, time).set_delay(delay) # warning-ignore:return_value_discarded
	tween.tween_property(Platform, "position", move_to, time).set_delay(delay) # warning-ignore:return_value_discarded
	tween.set_loops() # warning-ignore:return_value_discarded
