extends Node2D

# This script is used by every area, it's not a singleton.

@export var coordinates = Vector2i(0, 0)

var player_scene = preload("res://scenes/player.tscn")

func _ready():
	
	if get_node_or_null("Gameplay"):
		$Gameplay.scale.y = 600.0 / (AreaManager.area_size.y * 50)
		$Gameplay.scale.x = 600.0 / (AreaManager.area_size.y * 50)
		
		$Gameplay.position.y += 60
		$Gameplay.position.x += 160
	
	
	var interface = load("res://scenes/interface.tscn").instantiate()
	add_child(interface)
	
	var player = player_scene.instantiate()
	$Gameplay.add_child(player)
	player.position = AreaManager.player_position
	
	AreaManager.next_coin_id = 0
	AreaManager.next_key_id = 0
	AreaManager.next_checkpoint_id = 0
	
	AreaManager.current_area = self.name
	AreaManager.current_area_path = self.scene_file_path
	
	AreaManager.current_coordinates = self.coordinates
	AreaManager.current_level = str(scene_file_path.get_slice("/", 3))
	
	print("Currently entering an area with the name \"" + str(name) + "\" on the coordinates " + str(coordinates))
	print()


