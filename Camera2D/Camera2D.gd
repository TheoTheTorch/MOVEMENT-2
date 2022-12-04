extends Camera2D

export var to_follow : NodePath
var To_Follow
export var weight : float = 0.2

enum FOLLOW_AXIS {NONE, X, Y, XY}
export(FOLLOW_AXIS) var follow_axis

func _ready() -> void:
	To_Follow = get_node(to_follow)

func _process(_delta):
	match follow_axis:
		FOLLOW_AXIS.X: global_position.x = lerp(global_position.x, To_Follow.global_position.x, weight)
		FOLLOW_AXIS.Y: global_position.y = lerp(global_position.y, To_Follow.global_position.y, weight)
		FOLLOW_AXIS.XY:
			global_position.x = lerp(global_position.x, To_Follow.global_position.x, weight)
			global_position.y = lerp(global_position.y, To_Follow.global_position.y, weight)
		FOLLOW_AXIS.NONE: pass
