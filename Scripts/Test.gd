extends Spatial


var enemyBase = preload("res://Scenes/InGame/Enemy_Base.tscn")
var enemy
onready var enemySpawn = get_node("EnemySpawn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_instance_valid(enemy) == false):
		enemy = enemyBase.instance()
		add_child(enemy)
		enemy.transform = enemySpawn.transform
