extends Node

@onready var player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	player.bus = "Music"
	add_child(player)
	# Cargá la música inicial
	player.stream = load("res://Audio/818288__xantherock__positive-dance-music (1).wav")
	player.volume_db = -6
	player.autoplay = true
	
	player.play()

func play_music(path: String):
	var new_stream = load(path)
	if new_stream:
		player.stream = new_stream
		player.play()

func stop_music():
	player.stop()
