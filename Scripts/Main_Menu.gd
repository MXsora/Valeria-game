extends Control


@onready var cursor = get_node("monstrosity")

var menuNumber: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicManager.changeSong("res://Sound/Music/Placeholder Main Menu Theme.mp3")


func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		menuNumber -= 1
		changeCursor()
	if Input.is_action_just_pressed("ui_down"):
		menuNumber += 1
		changeCursor()
	if Input.is_action_just_pressed("ui_accept"):
		menuSelection()

func changeCursor():
	match menuNumber:
		0:
			cursor.position.y = 480
		1:
			cursor.position.y = 575
		2:
			cursor.position.y = 673
		3:
			cursor.position.y = 769

func menuSelection():
	match menuNumber:
		0:
			get_tree().change_scene_to_file("res://Scenes/Test.tscn")
		1:
			pass
		2:
			pass
		3:
			get_tree().quit()
