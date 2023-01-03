extends KinematicBody

var maxHealth: int = 3
var currentHealth = maxHealth

var moveSpeed: float = 2.0
var turnSpeed: float = 90.0

var gravity: float = 4.0

var justHit: bool = false

enum states {IDLE, TURNING, MOVING, ATTACKING}
var currentState

var forward: Vector3 = Vector3(0, 0, 0)

onready var animPlayer = get_node("Graphics/AnimationPlayer")
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
	#iterate through the states until reaching the end, then loop back
	if(currentState == states.MOVING):
		currentState = states.IDLE
	else:
		currentState = currentState + 1

func getHit():
	if(justHit):
		pass
	currentHealth -= 1
	timer.paused = true
	animPlayer.play("hurt_test")
	yield(animPlayer, "animation_finished")
	checkDeath()
	timer.paused = false
	justHit = true

func checkDeath():
	if(currentHealth >= 0):
		queue_free()

func _on_Timer_timeout():
	changeState()

func _on_hurtBox_area_entered(area):
	getHit()
