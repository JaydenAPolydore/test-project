extends State

@export var idle_state : State
@export var sprint_state : State
@export var move_state : State
func enter():
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
	
	if parent.is_on_floor():
		if Input.is_action_pressed("sprint"):
			return sprint_state
		elif Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backward"):
			return move_state
		else:
			return idle_state
	return null
