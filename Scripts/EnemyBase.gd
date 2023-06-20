extends CharacterBody3D

var maxHealth: int = 3
var currentHealth = maxHealth

var moveSpeed: float = 2.0
var turnSpeed: float = 90.0

var gravity: float = 4.0

var justHit: bool = false

enum states {IDLE, TURNING, MOVING, ATTACKING}
var currentState

var forward: Vector3 = Vector3(0, 0, 0)

@onready var animPlayer = get_node("Graphics/AnimationPlayer")
@onready var timer = get_node("Timer")


func _ready():
	currentState = states.IDLE
	timer.start()


func _physics_process(delta):
	forward.y -= gravity * delta
	if (currentState == states.TURNING):
		rotation_degrees.y += turnSpeed * delta
	if (currentState == states.MOVING):
		set_velocity(forward)
		move_and_slide()
		forward = velocity

func ChangeState():
	forward = transform.basis.z * moveSpeed
	#iterate through the states until reaching the end, then loop back
	if(currentState == states.MOVING):
		currentState = states.IDLE
	else:
		currentState = currentState + 1

func GetHit(playerDamage):
	currentHealth -= playerDamage
	timer.paused = true
	animPlayer.play("hurt_test")
	await animPlayer.animation_finished
	checkDeath()
	timer.paused = false

func checkDeath():
	if(currentHealth <= 0):
		queue_free()

func _on_Timer_timeout():
	ChangeState()
