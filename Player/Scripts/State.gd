class_name State
extends Node

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

signal state_transition

# Hold a reference to the parent so we can control it through state
@export var parent : Player

@export var state_name : String

func enter():
	pass
	
func exit():
	
	pass

func process_input(event : InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null
	
func process_physics(delta: float) -> State:
	return null

func moving(delta : float):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backward")
	var direction = (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		parent.velocity.x = lerp(parent.velocity.x, direction.x * parent.playerSpeed, parent.playerAcceleration * delta)
		parent.velocity.z = lerp(parent.velocity.z, direction.z * parent.playerSpeed, parent.playerAcceleration * delta)
	else:
		parent.velocity.x = lerp(parent.velocity.x, direction.x * 0.0, (parent.playerAcceleration * 2) * delta)
		parent.velocity.z = lerp(parent.velocity.z, direction.z * 0.0, (parent.playerAcceleration * 2) * delta)
		
		
	parent.move_and_slide()
