extends Spatial


onready var enemy = get_node("Enemy")
onready var enemySpawn = get_node("EnemySpawn")

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy.transform = enemySpawn.transform


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
