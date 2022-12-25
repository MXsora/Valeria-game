extends KinematicBody


var curHp : int = 10
var maxHp : int = 10
var damage : int = 1

var gold : int = 0

var attackRate : float = 0.3
var lastAttackTime : int = 0

var moveSpeed : float = 5.0
var jumpForce : float = 10.0

var gravity : float = 15.0
var vel : Vector3 = Vector3()

var horizontal: float = 0
var vertical: float = 0
var direction: Vector3 = Vector3(0,0,0)

onready var camera = get_node("CameraOrbit")

func _ready():
	pass

func _physics_process(delta):
	horizontal = Input.get_axis("ig_move_left", "ig_move_right")
	vertical = Input.get_axis("ig_move_up", "ig_move_down")
	direction.x = horizontal
	direction.z = vertical
	direction.normalized()
	direction = direction.rotated(Vector3.UP, camera.rotation.y).normalized() * moveSpeed
	move_and_slide(direction)
