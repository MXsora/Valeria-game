extends KinematicBody


var curHp : int = 10
var maxHp : int = 10
var damage : int = 1

var gold : int = 0

var attackSpeed : float = 1
var lastAttackTime : int = 0

var moveSpeed : float = 5.0

var jumpForce : float = 120.0

var jumpHeight: float = 3.5
var jumpTimetoPeak: float = 0.5
var jumpTimetoDescent: float = 0.4

var jumpVelocity: float = ((2.0 * jumpHeight) / jumpTimetoPeak)
var jumpGravity: float = (-2.0 * jumpHeight) / (jumpTimetoPeak * jumpTimetoPeak)
var fallGravity: float = (-2.0 * jumpHeight) / (jumpTimetoDescent * jumpTimetoDescent)

var justLanded: bool = false
var isJumping: bool = false

enum jumpStates {READY, JUMPING, FALLING}
enum attackStates {DODGING, ATTACK1, TTACK2, ATTACK3, SPECIAL}
enum weapons {SwordAndBoard, GreatSword, Daggers, Scythe, Caestus, SwordWhip, BallAndChain, PunchClaws, BasicLongSword}
var currentJumpState
var curWeapon

var attackCount: int = 0

var gravity : float = 60.0

var horizontal: float = 0
var vertical: float = 0
var direction: Vector3 = Vector3(0,0,0)
var snapVector: Vector3 = Vector3.DOWN

onready var cameraOrbit = get_node("CameraOrbit")
onready var model = get_node("model")

func _ready():
	cameraOrbit.set_as_toplevel(true)
	currentJumpState = jumpStates.READY
	
	pass

func _physics_process(delta):
	cameraFollow()
	getStickInput()
	direction = direction.rotated(Vector3.UP, cameraOrbit.rotation.y)
	direction.y += getGravity() * delta
	direction = move_and_slide_with_snap(direction, snapVector, Vector3.UP, true)
	if(Input.is_action_just_pressed("ig_jump") and currentJumpState == jumpStates.READY):
		jump()
	if(is_on_floor() and currentJumpState == jumpStates.FALLING):
		currentJumpState = jumpStates.READY
		snapVector = Vector3.DOWN
	if(getGravity() == fallGravity and currentJumpState == jumpStates.JUMPING):
		currentJumpState = jumpStates.FALLING
	#rotate the model so its looking in the direction of movement
	if(horizontal or vertical != 0):
		rotation.y = lerp_angle( rotation.y, atan2( direction.x, direction.z ), 1 )

func getGravity():
	return jumpGravity if direction.y < 0.0 else fallGravity

func jump():
	direction.y = jumpVelocity
	currentJumpState = jumpStates.JUMPING
	snapVector = Vector3.ZERO


func getStickInput():
	horizontal = Input.get_axis("ig_move_left", "ig_move_right")
	vertical = Input.get_axis("ig_move_up", "ig_move_down")
	direction.x = horizontal * moveSpeed
	direction.z = vertical * moveSpeed

func cameraFollow():
	cameraOrbit.translation.x = lerp(cameraOrbit.translation.x, translation.x, .2)
	cameraOrbit.translation.z = lerp(cameraOrbit.translation.z, translation.z, .2)
	cameraOrbit.translation.y = lerp(cameraOrbit.translation.y, translation.y, .1)

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
	
