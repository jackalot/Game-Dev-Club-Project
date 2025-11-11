extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("Move_Right"):
		direction.x += 1 * delta
	if Input.is_action_pressed("Move_Left"):
		direction.x -= 1 * delta
	if Input.is_action_pressed("Move_Backward"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z += 1 * delta
	if Input.is_action_pressed("Move_Forward"):
		direction.z -= 1 * delta
