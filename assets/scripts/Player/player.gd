class_name Player
extends CharacterBody3D

# --- Movement settings ---
@export var speed: float = 14
@export var fall_acceleration: float = 75

# --- Climbing settings ---
@export var climb_speed: float = 20  # Default climb speed
var current_climb_speed: float = 0
var can_climb: bool = false

# --- Noise system ---
var current_noise_level: float = 0

# --- Throwing ---
@export var THROW_FORCE : float = 100
@export var throw_hand : Marker3D
var throw_object : Throwable


func _physics_process(delta: float) -> void:
	move_and_slide()	# All of the changes happen in the state. This just updates if changes has occured
	
	for i in get_slide_collision_count():
		var coll = get_slide_collision(i)
		if coll.get_collider() is Throwable:
			_on_throwable_pickup(coll.get_collider())
	
	# Noise feedback
	handle_noise(delta)
	
	# Throwing
	if Input.is_action_just_pressed("throw") and throw_object:
		#throw_object.look_at( throw_object.global_transform.origin + (-global_transform.basis.z))
		throw_object.throw(-global_transform.basis.z * THROW_FORCE)
		throw_object = null


# --- Noise system ---
func add_noise(amount: float) -> void:
	current_noise_level += amount

func handle_noise(delta: float) -> void:
	if current_noise_level > 0:
		#print("Noisy! Current noise level: ", current_noise_level)	#NOTE: Commented out due to 
		current_noise_level = max(current_noise_level - delta * 2, 0)

func _on_throwable_pickup(throwable_body : Throwable) -> void:
	if throw_object: return
	
	throwable_body.pick_up(throw_hand)
	throw_object = throwable_body
