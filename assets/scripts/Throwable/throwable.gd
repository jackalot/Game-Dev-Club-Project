class_name Throwable
extends RigidBody3D

@export var PICKUP_SPEED : float = 100

# Code obtained from @MrElipteach on youtube
@onready var original_parent = get_parent()
@onready var origional_collision_layer = collision_layer
@onready var origional_collision_mask = collision_mask

var picked_up_by : Marker3D
var orig_transform : Transform3D

func _ready() -> void:
	freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC

func _physics_process(delta: float) -> void:
	if !picked_up_by: return
	
	global_transform.origin = global_transform.origin.lerp(picked_up_by.global_transform.origin, PICKUP_SPEED * delta)

func pick_up(body : Marker3D) -> void:
	freeze = true
	collision_layer = 0
	collision_mask = 0
	
	orig_transform = global_transform
	picked_up_by = body
	
	# Switch owner to whatever picked it up
	original_parent.remove_child(self)
	picked_up_by.add_child(self)
	
	global_transform = orig_transform

func throw(impulse: Vector3 = Vector3.ZERO) -> void:
	if picked_up_by:
		var t = global_transform
		
		picked_up_by.remove_child(self)
		original_parent.add_child(self)
		global_transform = t
		
		picked_up_by = null
		freeze = false
		
		collision_layer = origional_collision_layer
		collision_mask = origional_collision_mask
		
		await get_tree().physics_frame
		apply_impulse(Vector3.ZERO, impulse)
