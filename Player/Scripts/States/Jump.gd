extends State

@export var move_state : State
@export var jump_state : State
@export var fall_state : State

@export var jump_force : float = 5.0




func enter():
	parent.velocity.y = jump_force
	pass
	
func exit():
	
	pass

func process_input(event : InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null
	
	
	
func process_physics(delta: float) -> State:
	parent.velocity.y -= gravity * delta
	
	moving(delta)
	
	if parent.velocity.y < 0:
		return fall_state
	return null
