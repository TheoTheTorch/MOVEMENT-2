extends KinematicBody2D

# Basic movement varaiables
var velocity := Vector2(0,0)
var face_direction := 1
var x_dir := 1

export var max_speed: int = 520
export var acceleration: int = 32
export var deceleration: int = 96
export var air_acceleration : int = 48
export var air_deceleration : int = 96

export var gravity_acceleration : int = 7680
export var gravity_max : int = 700

# JUMP VARAIABLES ------------------- #
export var jump_force : int = 1650
export var jump_cut : float = 0.25
export var jump_gravity_max : int = 1020
export var jump_hang_treshold : float = 2.0
export var jump_hang_gravity_mult : float = 0.001
# Timers
export var jump_coyote : float = 0.08
export var jump_buffer : float = 0.1

var jump_coyote_timer : float = 0
var jump_buffer_timer : float = 0
var is_jumping := false
# ----------------------------------- #


# All iputs we want to keep track of
func get_input() -> Dictionary:
	return {
		"horizontal": int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		"vertical": int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")),
		"just_jump": Input.is_action_just_pressed("jump") == true,
		"jump": Input.is_action_pressed("jump") == true,
		"released_jump": Input.is_action_just_released("jump") == true,
	}

func _physics_process(delta: float) -> void:
	x_movement(delta)
	jump_logic(delta)
	timers(delta)
	
	apply_gravity(delta) # apply gravity only after jump_logic
	apply_velocity()


func apply_velocity() -> void:
	if is_jumping:
		velocity = move_and_slide(velocity, Vector2.UP)
	else:
		velocity = move_and_slide_with_snap(velocity, Vector2(0, 16), Vector2.UP)

func x_movement(delta: float) -> void:
	x_dir = get_input()["horizontal"]
	
	var target_speed : float = x_dir * max_speed
	var accel_rate : float = acceleration if (abs(target_speed) > 0.01) else deceleration
	
	# if we aren't grounded, use air acceleration / deceleration instead
	if not is_on_floor():
		accel_rate = air_acceleration if (abs(target_speed) > 0.01) else air_deceleration
	
	# above max speed, don't accelerate nor decelerate (This keeps our momentum gained from outside or slopes)
	if abs(velocity.x) > max_speed and sign(velocity.x) == x_dir and x_dir != 0:
		accel_rate = 0
	
	velocity.x += delta * (target_speed - velocity.x) * accel_rate
	set_direction(x_dir)

func set_direction(hor_direction) -> void:
	# Turning relies on the scale of the player
	# To animate, only scale the sprite
	if hor_direction == 0: return
	apply_scale(Vector2(hor_direction * face_direction, 1)) # flip
	face_direction = x_dir # remember direction

func jump_logic(_delta: float) -> void:
	
	# Reset our jump requirements
	if is_on_floor():
		jump_coyote_timer = jump_coyote
		is_jumping = false
	if get_input()["just_jump"]: jump_buffer_timer = jump_buffer
	
	# Jump if grounded, there is jump input, and we aren't jumping already
	if jump_coyote_timer > 0 and jump_buffer_timer > 0 and not is_jumping:
		is_jumping = true
		jump_coyote_timer = 0
		jump_buffer_timer = 0
		 # if falling, account for that lost speed
		if velocity.y > 0: velocity.y -= velocity.y
		
		velocity.y = -jump_force
	
	# We're not actually interested in checking if the player is holding the jump button
#	if get_input()["jump"]:pass
	
	# Cut the velocity if let go of jump. This means our jumpheight is varaiable
	if get_input()["released_jump"]:
		velocity.y *= jump_cut
	
	# This way we won't start slowly descending / floating once hit a ceiling
	if is_on_ceiling(): velocity.y = jump_hang_treshold + 1.0



func apply_gravity(delta: float) -> void:
	var applied_gravity : float = 0
	
	# No gravity if we are grounded
	if jump_coyote_timer > 0: return
	
	# Normal gravity limit
	if not velocity.y > gravity_max:
		applied_gravity = gravity_acceleration * delta
	
	# If falling, the limit is jump_gravity_max
	if velocity.y > 0 and not velocity.y > jump_gravity_max:
		applied_gravity = gravity_acceleration * delta
	
	# Lower the gravity at the peak of our jump (where velocity is the smallest)
	if is_jumping and abs(velocity.y) < jump_hang_treshold:
		applied_gravity *= jump_hang_gravity_mult
	
	velocity.y += applied_gravity

func timers(delta: float) -> void:
	# Using timer nodes here would mean unnececary functions and node calls
	# This way everything is contained in just 1 script with no node requirements
	jump_coyote_timer -= delta
	jump_buffer_timer -= delta

