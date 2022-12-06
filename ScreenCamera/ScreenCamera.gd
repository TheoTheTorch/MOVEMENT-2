extends Camera2D

export var target : NodePath
export var align_time : float = 0.2
export var screen_size := Vector2(1920, 1080)

onready var Target = get_node_or_null(target)
onready var Twee = $Tween

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(Target):
		var targets: Array = get_tree().get_nodes_in_group("Player")
		if targets: Target = targets[0]
	if not is_instance_valid(Target):
		return
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "global_position", desired_position(), align_time)


func desired_position() -> Vector2:
	return Vector2(floor(Target.global_position.x / screen_size.x), floor(Target.global_position.y / screen_size.y)) * screen_size + screen_size/2
