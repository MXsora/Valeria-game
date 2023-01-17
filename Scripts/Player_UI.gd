extends Control


export var playerPath: NodePath
onready var player: Node
onready var healthBar = get_node("HealthBar")


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(playerPath)
	healthBar.max_value = player.maxHP

func UpdateHealth():
	healthBar.value = player.curHP


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
