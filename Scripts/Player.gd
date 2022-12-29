extends KinematicBody


var curHp : int = 10
var maxHp : int = 10
var damage : int = 1

var gold : int = 0

var attackSpeed : float = 1
var lastAttackTime : int = 0

var moveSpeed : float = 5.0
var jumpForce : float = 120.0

enum states {IDLE,JUMPING,FALLING,MOVING,DODGING,ATTACK1,ATTACK2,ATTACK3,SPECIAL}
enum weapons {SwordAndBoard, GreatSword, Daggers, Scythe, Caestus, SwordWhip, BallAndChain, PunchClaws, BasicLongSword}
var currentState
var curWeapon

var attackCount: int = 0

var gravity : float = 60.0

var horizontal: float = 0
var vertical: float = 0
var direction: Vector3 = Vector3(0,0,0)

onready var camera = get_node("CameraOrbit")
onready var model = get_node("model")

func _ready():
	camera.set_as_toplevel(true)
	currentState = states.IDLE
	
	pass

func _physics_process(delta):
	cameraFollow()
	getStickInput()
	direction.x = direction.x * moveSpeed
	direction.z = direction.z * moveSpeed
	direction = direction.rotated(Vector3.UP, camera.rotation.y)
	if(is_on_floor() and Input.is_action_just_pressed("ig_jump")):
		direction.y += jumpForce
	processGravity(delta)
	direction = move_and_slide(direction, Vector3.UP)
	if(horizontal or vertical != 0):
		rotation.y = lerp_angle( rotation.y, atan2( direction.x, direction.z ), 1 )

func processGravity(delta):
	direction.y -= gravity * delta


func getStickInput():
	horizontal = Input.get_axis("ig_move_left", "ig_move_right")
	vertical = Input.get_axis("ig_move_up", "ig_move_down")
	direction.x = horizontal
	direction.z = vertical
	direction = direction.normalized()

func cameraFollow():
	camera.translation.x = lerp(camera.translation.x, translation.x, .2)
	camera.translation.z = lerp(camera.translation.z, translation.z, .2)
	camera.translation.y = lerp(camera.translation.y, translation.y, .1)

func basicAttackString():
	match curWeapon:
		weapons.SwordAndBoard:
			pass
		weapons.GreatSword:
			pass
		weapons.Daggers:
			pass
		weapons.Scythe:
			pass
		weapons.Caestus:
			pass
		weapons.SwordWhip:
			pass
		weapons.BallAndChain:
			pass
		weapons.PunchClaws:
			pass
		weapons.BasicLongSword:
			pass

func heavyAttack():
	match curWeapon:
		weapons.SwordAndBoard:
			pass
		weapons.GreatSword:
			pass
		weapons.Daggers:
			pass
		weapons.Scythe:
			pass
		weapons.Caestus:
			pass
		weapons.SwordWhip:
			pass
		weapons.BallAndChain:
			pass
		weapons.PunchClaws:
			pass
		weapons.BasicLongSword:
			pass

func specialAttack():
	match curWeapon:
		weapons.SwordAndBoard:
			pass
		weapons.GreatSword:
			pass
		weapons.Daggers:
			pass
		weapons.Scythe:
			pass
		weapons.Caestus:
			pass
		weapons.SwordWhip:
			pass
		weapons.BallAndChain:
			pass
		weapons.PunchClaws:
			pass
		weapons.BasicLongSword:
			pass
	
