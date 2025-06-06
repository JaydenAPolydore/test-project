extends State
class_name Move

@export var sprint_state : State
@export var fall_state : State
@export var idle_state : State
@export var jump_state : State


func enter():
	parent.playerSpeed = parent.walkSpeed
	pass
	
func exit():
	pass

func process_input(event : InputEvent) -> State:
	if !Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backward"):
		return idle_state
	if Input.is_action_pressed("sprint"):
		return sprint_state
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	return null

func process_frame(delta: float) -> State:
	return null
	
func process_physics(delta: float) -> State:
	parent.velocity.y -= gravity * delta
	moving(delta)
	if !parent.is_on_floor():
		return fall_state
	return null
