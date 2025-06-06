extends State

@export var move_state : State
@export var jump_state : State
@export var fall_state : State

func enter():
	pass
	
func exit():
	pass

func process_input(event : InputEvent) -> State:
	if Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backward"):
		return move_state
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	return null
func process_frame(delta: float) -> State:
	return null
	
func process_physics(delta: float) -> State:
	print(parent.velocity)
	parent.velocity.x = lerp(parent.velocity.x, 0.0, (parent.playerAcceleration * 2) * delta)
	parent.velocity.z = lerp(parent.velocity.z, 0.0, (parent.playerAcceleration * 2) * delta)
	parent.velocity.y -= gravity * delta 
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
