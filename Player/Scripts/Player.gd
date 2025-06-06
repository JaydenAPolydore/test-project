class_name Player
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var walkSpeed = 1.0
@export var sprintSpeed = 3.0
var playerSpeed = walkSpeed
@export var cameraSens = .1
@export var jumpForce = 8.0
@export var playerAcceleration =  4.0
@export var canJump = true

@export_category("Headbob")
#--------
@export var headbob_yes = true
@export var rotbob = true
@export var posbob = false

@export_subgroup("Bobbing")
#--------
@export var Y_BOB_FREQ = 2.0
@export var X_BOB_FREQ = 1.0
@export var BOB_AMP = 0.1

@export_subgroup("Rotting")
#--------
@export var X_ROT_FREQ = 7.5
@export var X_ROT_AMP = 0.6
#--------
@export var Y_ROT_FREQ = 6.0
@export var Y_ROT_AMP = 0.4
#--------
@export var Z_ROT_FREQ = 3.0
@export var Z_ROT_AMP = 0.4


@onready var pitch = $Pitch
@onready var roll = $Pitch/Yaw
@onready var yaw = $Pitch/Yaw/Roll
@onready var camera = $Pitch/Yaw/Roll/Camera3D
@onready var state_machine = $state_machine

var y_axis = 0.0
var x_axis = 0.0
var sin_bob = 0.0

var old_rot = Vector3.ZERO 
var new_rot = Vector3.ZERO 

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	state_machine.init(self)

func _physics_process(delta):
	# Sprinting and Walking
	#if Input.is_action_pressed("sprint"):
		#playerSpeed = sprintSpeed
	#else:
		#playerSpeed = walkSpeed
		
	state_machine.process_physics(delta)
	
	# Controls different types of headbob
	if headbob_yes:
		sin_bob += delta * velocity.length() * float(is_on_floor())
		if posbob:
			yaw.transform.origin = _headbob(sin_bob)
		elif rotbob:
			new_rot = _headrot(sin_bob)
			pitch.rotate_x((old_rot.x - new_rot.x) * 0.1)
			roll.rotate_y((old_rot.y - new_rot.y) * 0.1)
			yaw.rotate_z((old_rot.z - new_rot.z) * 0.1)
			old_rot = _headrot(sin_bob)
	
	
	
	# Jumping
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Mouse Controls
	pitch.rotation.x = -deg_to_rad(x_axis)
	rotation.y = -deg_to_rad(y_axis)
	

	pitch.rotation.x = clamp(pitch.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	x_axis = clamp(x_axis, -90, 90)
	
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor() and canJump:
		#velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backward")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = lerp(velocity.x, direction.x * playerSpeed, playerAcceleration * delta)
		#velocity.z = lerp(velocity.z, direction.z * playerSpeed, playerAcceleration * delta)
	#else:
		#velocity.x = lerp(velocity.x, direction.x * 0, (playerAcceleration * 2) * delta)
		#velocity.z = lerp(velocity.z, direction.z * 0, (playerAcceleration * 2) * delta)
		#yaw.rotation.z = lerp(yaw.rotation.z, 0.0, 10.0 * delta)
	#move_and_slide()
	
	

func _process(delta: float):
	state_machine.process_frame(delta)


func _input(event):
	state_machine.process_input(event)
	if event is InputEventMouseMotion:
		y_axis += event.relative.x * cameraSens
		x_axis += event.relative.y * cameraSens
		
func _headbob(time):
	var pos = Vector3.ZERO
	pos.y = sin(time * Y_BOB_FREQ) * BOB_AMP
	pos.x = sin(time * X_BOB_FREQ) * BOB_AMP 
	
	return pos

func _headrot(time):
	var rot = Vector3.ZERO
	
	rot.x = sin(time * X_ROT_FREQ) * X_ROT_AMP 
	rot.y = sin(time * Y_ROT_FREQ) * Y_ROT_AMP 
	rot.z = sin(time * Z_ROT_FREQ) * Z_ROT_AMP 
	
	return rot
