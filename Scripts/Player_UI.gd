extends Control


export var playerPath: NodePath
onready var player: Node
onready var healthBar = get_node("MarginContainer/HealthBar")
onready var weaponIcon = get_node("CurrentWeapon")


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(playerPath)
	healthBar.max_value = player.maxHP

func UpdateHealth():
	healthBar.value = player.curHP

func UpdateWeapon(weaponNum):
	weaponIcon.frame = weaponNum
