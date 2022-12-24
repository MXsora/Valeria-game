extends Spatial


# Declare member variables here. Examples:
# var a = 2
var turnSpeed: float = 2.0
var L2Strength: float = 0
var R2Strength: float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	R2Strength = Input.get_action_strength("ig_rotate_cam_left")
	L2Strength = Input.get_action_strength("ig_rotate_cam_right")
	if(L2Strength > 0):
		rotation_degrees.y += (turnSpeed * L2Strength)
	if(R2Strength > 0):
		rotation_degrees.y -= (turnSpeed * R2Strength)

