extends Node


func _ready():
	get_children()

func play(sfx_name: String):
	if get_node_or_null(sfx_name) is AudioStreamPlayer:
		get_node(sfx_name).play()
	else:
		print("No SFX with such name has been found... (Message coming from sfx.gd)")
