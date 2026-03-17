extends EntityState

@export_category("Climbing Raycasts")
@export var upper_raycast : RayCast3D
@export var lower_raycast : RayCast3D
# Where the player will be after the ledge
@export var landing_raycast : RayCast3D

var player : Player

func _setup_state(entity : CharacterBody3D) -> void:
	player = entity
	state_id = "Climbing"


func _enable_state() -> void:
	set_process(true)


func _disable_state() -> void:
	set_process(false)


func _process(delta: float) -> void:
	# Climbing
	var new_vertical_velocity : Vector3 = Vector3.ZERO# Zero out the other two directions to avoid residual velocity.
	if Input.is_action_pressed("Move_Forward"):
		new_vertical_velocity.y = player.current_climb_speed * delta
		player.add_noise(5)
	elif Input.is_action_pressed("Move_Backward"):
		new_vertical_velocity.y = -player.current_climb_speed * delta
		player.add_noise(5)
	
	if is_ledge_detected():
		landing_raycast.enabled = true
		landing_raycast.force_raycast_update()
		if landing_raycast.is_colliding():
			# TODO: Replace the teleport with an actual animation
			player.position = landing_raycast.get_collision_point()
			SignalBus.changed_state.emit(state_machine_id, "IDLE")
		landing_raycast.enabled = false
			
	# If after the move, the player is on the floor and is trying to climb down
	if not player.can_climb or player.is_on_floor() and sign(new_vertical_velocity.y) == -1:
		SignalBus.changed_state.emit(state_machine_id, "IDLE")
	
	player.velocity = new_vertical_velocity

# Returns if the character is on a ledge.
func is_ledge_detected() -> bool:
	if !upper_raycast.is_colliding() and lower_raycast.is_colliding():
		return true
	return false
