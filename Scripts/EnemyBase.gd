extends KinematicBody


var moveSpeed: float = 2.0
var turnSpeed: float = 90.0

var gravity: float = 4.0

enum states {IDLE, TURNING, MOVING, ATTACKING}
var currentState

var forward: Vector3 = Vector3(0, 0, 0)

onready var animPlayer = get_node("AnimationPlayer")
onready var timer = get_node("Timer")


func _ready():
	currentState = states.IDLE
	timer.start()


func _physics_process(delta):
	forward.y -= gravity * delta
	if (currentState == states.TURNING):
		rotation_degrees.y += turnSpeed * delta
	if (currentState == states.MOVING):
		forward = move_and_slide(forward)

func changeState():
	forward = transform.basis.z * moveSpeed
	if(currentState == states.MOVING):
		currentState = states.IDLE
	else:
		currentState = currentState + 1

func _on_Timer_timeout():
	changeState()
