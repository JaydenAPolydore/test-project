extends Node
class_name FiniteStateMachine

var current_state : State
@export var initial_state : State 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func init(parent: CharacterBody3D) -> void:
	for child in get_children():
		child.parent = parent
		
	

	# Initialize to the default state
	change_state(initial_state)

func process_input(event : InputEvent) -> void:
	var new_state : State = current_state.process_input(event)
	if new_state:
		change_state(new_state)
		

func process_frame(delta: float) -> void:
	var new_state : State = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
	
func process_physics(delta: float) -> void:
	print(current_state.state_name)
	var new_state : State = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func change_state(new_state : State) -> void:
	if current_state:
		current_state.exit()
		

	current_state = new_state
	current_state.enter()
