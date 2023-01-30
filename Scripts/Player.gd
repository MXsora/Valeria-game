extends KinematicBody


var curHP : int = 10
var maxHP : int = 10
var damage : int = 1

var gold : int = 0

var attackSpeed : float = 1
var comboNumber : int = 0

var moveSpeed : float = 7.0

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
enum weapons {SwordAndBoard, GreatSword, Daggers, Scythe, Caestus, SwordWhip, Mace, PunchClaws, BasicLongSword}
var currentJumpState
var isMoving: bool = false
var currentActionState
var currentWeapon
var attackCount: int = 0

var gravity : float = 60.0

var LJoystick: Vector2 = Vector2(0,0)
var RJoystick: Vector2 = Vector2(0,0)
var weaponWheel: Vector2 = Vector2(0,0)
var direction: Vector3 = Vector3(0,0,0)
var snapVector: Vector3 = Vector3.DOWN

var enemyList = []

onready var cameraOrbit = get_node("CameraOrbit")
onready var model = get_node("Graphics/model")
onready var attackAnimPlayer = get_node("Graphics/AttackAnimationPlayer")
onready var movementAnimPlayer = get_node("Graphics/MovementAnimationPlayer")
onready var userInterface = find_node("Player_UI")
onready var hitBox = get_node("WeaponHolder/HitBox")
onready var recoveryTimer = get_node("Timer")
onready var moveTween = get_node("Tween")

onready var basicSwordModel = get_node("WeaponHolder/Weapons/basic long sword")
onready var punchDaggerModel = get_node("WeaponHolder/Weapons/punching dagger")
onready var daggerModel = get_node("WeaponHolder/Weapons/dagger")
onready var saberModel = get_node("WeaponHolder/Weapons/saber")
onready var rapierModel = get_node("WeaponHolder/Weapons/rapier")
onready var scytheModel = get_node("WeaponHolder/Weapons/scythe")
onready var greatSwordModel = get_node("WeaponHolder/Weapons/greatsword")
onready var maceModel = get_node("WeaponHolder/Weapons/mace")
onready var caestusModel = get_node("WeaponHolder/Weapons/caestus")
var currentWeaponModel = Mesh

func _ready():
	cameraOrbit.set_as_toplevel(true)
	currentJumpState = jumpStates.READY
	currentActionState = actionStates.READY
	isMoving = false
	currentWeapon = weapons.BasicLongSword
	recoveryTimer.one_shot = true
	currentWeaponModel = basicSwordModel
	currentWeaponModel.visible = true

func _physics_process(delta):
	cameraFollow()

	#removes stick control while performing an action
	if(currentActionState == actionStates.READY):
		getStickInput()
		getRightStickInput()
	
	#change the raw stick input into a proportional move speed
	direction.x = LJoystick.x * moveSpeed
	direction.z = LJoystick.y * moveSpeed

	#check if the right stick has been touched and if so, change to the weapon specified
	if(RJoystick.x or RJoystick.y != 0):
		match RJoystick:
			Vector2(0,1):
				SwitchWeapon(0)
			Vector2(1,1):
				SwitchWeapon(1)
			Vector2(1,0):
				SwitchWeapon(2)
			Vector2(1,-1):
				SwitchWeapon(3)
			Vector2(0,-1):
				SwitchWeapon(4)
			Vector2(-1,-1):
				SwitchWeapon(5)
			Vector2(-1,0):
				SwitchWeapon(6)
			Vector2(-1,1):
				SwitchWeapon(7)
	
	
	#rotate the direction so that movement relates to the position of the camera
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

	if(Input.is_action_just_pressed("ig_dodge") and is_on_floor() and recoveryTimer.is_stopped()):
		comboNumber = 0
		currentActionState = actionStates.DODGE
		attackAnimPlayer.play("Dodge")
		moveTween.interpolate_property(self, "moveSpeed", 35, moveSpeed, 0.5, Tween.TRANS_EXPO,Tween.EASE_OUT )
		moveTween.start()
		recoveryTimer.start(0.4)


		
	if(currentActionState == actionStates.DODGE and recoveryTimer.is_stopped()):
		ResetActionState()

	#changes the player to the READY state after landing from a jump
	if(is_on_floor() and currentJumpState == jumpStates.FALLING):
		currentJumpState = jumpStates.READY
		snapVector = Vector3.DOWN
		
	#switch from a jumping state to a falling state
	if(getGravity() == fallGravity and currentJumpState != jumpStates.FALLING):
		currentJumpState = jumpStates.FALLING
	

	


	#check whether an attack is happening or not, if so, stop the moveing/idle animations, and reset attack state if not
	if(attackAnimPlayer.is_playing() and movementAnimPlayer.is_playing()):
		movementAnimPlayer.stop(true)
	elif(!attackAnimPlayer.is_playing() and currentActionState != actionStates.READY):
		attackAnimPlayer.play("RESET")
		attackAnimPlayer.stop()
		ResetActionState()



	#start playing the appropriate movement animation
	if(isMoving and currentActionState == actionStates.READY and movementAnimPlayer.current_animation != "Moving"):
		movementAnimPlayer.play("Moving")
	if(!isMoving and currentActionState == actionStates.READY and movementAnimPlayer.current_animation != "Idle"):
		movementAnimPlayer.play("Idle")


	#rotate the model so its looking in the direction of movement and set whether the player is moving based on stick input
	if(LJoystick.x or LJoystick.y != 0):
		rotation.y = lerp_angle( rotation.y, atan2( direction.x, direction.z ), 1 )
		isMoving = true
	else:
		isMoving = false
	#move the player
	direction = move_and_slide_with_snap(direction, snapVector, Vector3.UP, true)	


func getGravity():
	return jumpGravity if direction.y < 0.0 else fallGravity

func jump():
	direction.y = jumpVelocity
	currentJumpState = jumpStates.JUMPING
	snapVector = Vector3.ZERO


func getStickInput():
	LJoystick = Vector2(Input.get_axis("ig_move_left", "ig_move_right"), Input.get_axis("ig_move_up", "ig_move_down"))
	LJoystick = LJoystick.normalized()
	

func getRightStickInput():
	if(Input.get_axis("ig_weapon_wheel_left", "ig_weapon_wheel_right") > 0.15):
		RJoystick.x = 1
	elif(Input.get_axis("ig_weapon_wheel_left", "ig_weapon_wheel_right") < -0.15):
		RJoystick.x = -1
	else:
		RJoystick.x = 0
		
	if(Input.get_axis("ig_weapon_wheel_up", "ig_weapon_wheel_down") > 0.15):
		RJoystick.y = 1
	elif(Input.get_axis("ig_weapon_wheel_up", "ig_weapon_wheel_down") < -0.15):
		RJoystick.y = -1
	else:
		RJoystick.y = 0

func cameraFollow():
	cameraOrbit.translation = lerp(cameraOrbit.translation, translation, .1)

func basicAttackString():
	if (!recoveryTimer.is_stopped()):
		return
	enemyList.clear()
	currentActionState = actionStates.ATTACK
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
		weapons.Mace:
			pass
		weapons.PunchClaws:
			pass
		weapons.BasicLongSword:
			match comboNumber:
				0:
					basicAttack(0.2, 15, 5, 0.2, "attack_Test1")
				1:
					basicAttack(0.26, 10, 5, 0.3, "attack_Test2")
				2:
					basicAttack(0.4, 35, 2, 0.5, "attack_Test3")

func basicAttack(recoveryTime, newMoveSpeed, endMoveSpeed, tweenTime, attackName):
	attackAnimPlayer.play(attackName)
	moveTween.interpolate_property(self, "moveSpeed", newMoveSpeed, endMoveSpeed, tweenTime, Tween.TRANS_EXPO,Tween.EASE_OUT )
	moveTween.start()
	recoveryTimer.start(recoveryTime)
	comboNumber += 1
	

func heavyAttack():
	if (!recoveryTimer.is_stopped()):
		return
	enemyList.clear()
	currentActionState = actionStates.ATTACK
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
		weapons.Mace:
			pass
		weapons.PunchClaws:
			pass
		weapons.BasicLongSword:
			pass

func specialAttack():
	if (!recoveryTimer.is_stopped()):
		return
	enemyList.clear()
	currentActionState = actionStates.SPECIAL
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
		weapons.Mace:
			pass
		weapons.PunchClaws:
			pass
		weapons.BasicLongSword:
			pass

func SwitchWeapon(wepNumber):
	if (currentWeapon == wepNumber):
		return
	else:
		currentWeaponModel.visible = false
		currentWeapon = wepNumber
		userInterface.UpdateWeapon(wepNumber)
	match currentWeapon:
		weapons.SwordAndBoard:
			damage = 2
			currentWeaponModel = saberModel
		weapons.GreatSword:
			damage = 4
			currentWeaponModel = greatSwordModel
		weapons.Daggers:
			damage = 1
			currentWeaponModel = daggerModel
		weapons.Scythe:
			damage = 3
			currentWeaponModel = scytheModel
		weapons.Caestus:
			damage = 4
			currentWeaponModel = caestusModel
		weapons.SwordWhip:
			damage = 2
			currentWeaponModel = rapierModel
		weapons.Mace:
			damage = 3
			currentWeaponModel = maceModel
		weapons.PunchClaws:
			damage = 1
			currentWeaponModel = punchDaggerModel
		weapons.BasicLongSword:
			damage = 2
			currentWeaponModel = basicSwordModel
	currentWeaponModel.visible = true


func ResetActionState():
	currentActionState = actionStates.READY
	comboNumber = 0
	moveSpeed = 7.0

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
