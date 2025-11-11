extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

# Variable to store vertical velocity
var vertical_velocity = 0

func _physics_process(delta):
	# Create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# Check for each move input and update the direction accordingly.
	if Input.is_action_pressed("Move_Right"):
		direction.x += 1
	if Input.is_action_pressed("Move_Left"):
		direction.x -= 1
	if Input.is_action_pressed("Move_Backward"):
		direction.z += 1
	if Input.is_action_pressed("Move_Forward"):
		direction.z -= 1

	# Normalize the direction vector to ensure consistent speed when moving diagonally.
	direction = direction.normalized()

	# Calculate the target velocity based on input direction and speed.
	var target_velocity = direction * speed 

	# Manage vertical velocity for falling
	if(!is_on_floor()):
		vertical_velocity -= fall_acceleration * delta  # Apply falling acceleration
	target_velocity.y = vertical_velocity  # Set vertical velocity

	# Move the character.
	velocity = target_velocity  # Assign the target velocity to the character's velocity
	move_and_slide()  # Call without parameters
