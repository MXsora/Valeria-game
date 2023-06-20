extends Node3D


var enemyBase = preload("res://Scenes/InGame/Enemies/Enemy_Base.tscn")
var enemy
@onready var enemySpawn = get_node("EnemySpawn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_instance_valid(enemy) == false):
		enemy = enemyBase.instantiate()
		add_child(enemy)
		enemy.transform = enemySpawn.transform
