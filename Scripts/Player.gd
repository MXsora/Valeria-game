extends KinematicBody


var curHP : int = 10
var maxHP : int = 10
var damage : int = 1

var gold : int = 0

var attackSpeed : float = 1
var comboNumber : int = 0

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
enum actionStates {READY, ATTACK, SPECIAL, DODGE}
enum weapons {SwordAndBoard, GreatSword, Daggers, Scythe, Caestus, SwordWhip, BallAndChain, PunchClaws, BasicLongSword}
var currentJumpState
var isMoving: bool = false
var currentAttackState
var currentWeapon
var attackCount: int = 0

var gravity : float = 60.0

var horizontal: float = 0
var vertical: float = 0
var direction: Vector3 = Vector3(0,0,0)
var snapVector: Vector3 = Vector3.DOWN

var enemyList = []

onready var cameraOrbit = get_node("CameraOrbit")
onready var model = get_node("Graphics/model")
onready var attackAnimPlayer = get_node("Graphics/AttackAnimationPlayer")
onready var movementAnimPlayer = get_node("Graphics/MovementAnimationPlayer")
onready var userInterface = find_node("Player_UI")
onready var hitBox = get_node("WeaponHolder/HitBox")
onready var comboWaitTimer = get_node("Timer")

func _ready():
	cameraOrbit.set_as_toplevel(true)
	currentJumpState = jumpStates.READY
	isMoving = false
	currentWeapon = weapons.BasicLongSword
	comboWaitTimer.one_shot = true

func _physics_process(delta):
	cameraFollow()

	#removes stick control while performing an action
	if(currentAttackState == actionStates.READY):
		getStickInput()
		direction = direction.rotated(Vector3.UP, cameraOrbit.rotation.y)

	#apply gravity
	direction.y += getGravity() * delta


	#process inputs
	if(Input.is_action_just_pressed("ig_jump") and currentJumpState == jumpStates.READY):
		jump()
	
	if(Input.is_action_just_pressed("ig_attack") and is_on_floor()):
		basicAttackString()
	
	if(Input.is_action_just_pressed("ig_heavy_attack") and is_on_floor()):
		pass

	if(Input.is_action_just_pressed("ig_special_attack") and is_on_floor()):
		pass

	if(Input.is_action_just_pressed("ig_dodge") and is_on_floor()):
		pass


	#changes the player to the READY state after landing from a jump
	if(is_on_floor() and currentJumpState == jumpStates.FALLING):
		currentJumpState = jumpStates.READY
		snapVector = Vector3.DOWN
		
	#switch from a jumping state to a falling state
	if(getGravity() == fallGravity and currentJumpState != jumpStates.FALLING):
		currentJumpState = jumpStates.FALLING
	



	#rotate the model so its looking in the direction of movement and set whether the player is moving based on stick input
	if(horizontal or vertical != 0):
		rotation.y = lerp_angle( rotation.y, atan2( direction.x, direction.z ), 1 )
		isMoving = true
	else:
		isMoving = false
	


	#check whether an attack is happening or not, if so, stop the moveming/idle animations, and reset attack state if not
	if(attackAnimPlayer.is_playing() and movementAnimPlayer.is_playing()):
		movementAnimPlayer.stop(true)
	elif(!attackAnimPlayer.is_playing() and currentAttackState != actionStates.READY):
		attackAnimPlayer.play("RESET")
		attackAnimPlayer.stop()
		currentAttackState = actionStates.READY
		comboNumber = 0



	#start playing the appropriate movement animation
	if(isMoving and currentAttackState == actionStates.READY and movementAnimPlayer.current_animation != "Moving"):
		movementAnimPlayer.play("Moving")
	if(!isMoving and currentAttackState == actionStates.READY and movementAnimPlayer.current_animation != "Idle"):
		movementAnimPlayer.play("Idle")


	#move the player
	direction = move_and_slide_with_snap(direction, snapVector, Vector3.UP, true)	


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
	cameraOrbit.translation = lerp(cameraOrbit.translation, translation, .1)

func basicAttackString():
	if (!comboWaitTimer.is_stopped()):
		return
	enemyList.clear()
	currentAttackState = actionStates.ATTACK
	match currentWeapon:
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
			match comboNumber:
				0:
					direction = transform.basis.z * 1
					attackAnimPlayer.play("attack_Test1")
					comboWaitTimer.start(0.45)
					comboNumber += 1
				1:
					direction = transform.basis.z * 1
					attackAnimPlayer.play("attack_Test2")
					comboWaitTimer.start(0.45)
					comboNumber += 1
				2:
					direction = transform.basis.z * 4
					attackAnimPlayer.play("attack_Test3")
					comboWaitTimer.start(0.45)
					comboNumber += 1
					

func heavyAttack():
	match currentWeapon:
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
	match currentWeapon:
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

func SwitchWeapon(wepNumber):
	currentWeapon = weapons.wepNumber
	match currentWeapon:
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
			damage = 2


func GetHit(enemyDamage):
	curHP -= enemyDamage
	userInterface.UpdateHealth()

#checks if the enemy that has just been hit has alIDLE been hit by this attack
func CheckEnemy(enemy):
	if(!enemyList.has(enemy)):
		enemyList.append(enemy)
		return true
	else:
		return false

func _on_HitBox_area_entered(area):
	if (CheckEnemy(area)):
		if (area.get_parent().has_method("GetHit")):
			area.get_parent().GetHit(damage)

func _on_HurtBox_area_entered(area):
	GetHit(1)
