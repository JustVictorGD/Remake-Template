extends Node2D

# This script is used by every area, it's not a singleton.

var player_scene = preload("res://scenes/player.tscn")

func _ready():
	print("Change has been successful.")
	var player = player_scene.instantiate()
	add_child(player)
	player.position = AreaManager.player_position
