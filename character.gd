extends CharacterBody3D

# --- Movement Variables ---
@export var speed = 5.0
@export var jump_velocity = 4.5
@export var acceleration = 4.0
@export var air_acceleration = 1.0
@export var friction = 5.0
@export var air_friction = 0.5

# --- Mouse Look Variables ---
@export var mouse_sensitivity = 0.002 # Radians per pixel

# --- Node References ---
@export var head: Node3D
@export var camera: Camera3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Rotate body (left/right)
		rotate_y(-event.relative.x * mouse_sensitivity)
		# Rotate head (up/down), clamped
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clampf(head.rotation.x, deg_to_rad(-89.9), deg_to_rad(89.9))

	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get movement direction relative to camera
	var input_dir = Input.get_vector("left", "right", "down", "up")
	var cam_basis = head.global_transform.basis
	var forward = -cam_basis.z.normalized()
	var right = cam_basis.x.normalized()
	var direction = (right * input_dir.x + forward * input_dir.y).normalized()

	# Choose accel/friction depending on grounded
	var current_accel = acceleration if is_on_floor() else air_acceleration
	var current_friction = friction if is_on_floor() else air_friction

	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, current_accel * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, current_accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, current_friction * delta)
		velocity.z = move_toward(velocity.z, 0, current_friction * delta)

	# Execute the movement
	move_and_slide()
