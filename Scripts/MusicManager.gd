extends Node

@onready var musicPlayer = get_node("AudioStreamPlayer")
var currentSong: AudioStreamMP3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func changeSong(path):
	musicPlayer.stop()
	currentSong = load(path)
	musicPlayer.stream = currentSong
	musicPlayer.play()
