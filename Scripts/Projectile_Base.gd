extends Spatial


var projectileSpeed: float = 3.0
var projectileDamage: int = 1

onready var projectileTimer = get_node("Timer")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	queue_free()
