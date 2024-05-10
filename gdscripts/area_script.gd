extends Node

# This script is used by every area, it's not a singleton.

@export var coordinates := Vector2i(0, 0)
@export var bottom_text := ""

var player = load("res://scenes/player.tscn").instantiate()
var interface = load("res://scenes/interface.tscn").instantiate()

var in_cutscene = false



func _ready():
	add_child(interface)
	# Top half of the interface
	interface.get_node("Level").text = "Level: 1 - " + AreaManager.decimal_to_letter(coordinates.x) + str(coordinates.y)
	interface.get_node("Money").text = "Coins: " + str(AreaManager.money["amount"]) + " / " + str(AreaManager.money["requirement"])
	interface.get_node("Deaths").text = "Deaths: " + str(AreaManager.deaths)
	# Bottom half of the interface
	interface.get_node("BottomText").text = bottom_text
	interface.get_node("Timer").text = AreaManager.time_string
	interface.get_node("MillisecondTimer").text = AreaManager.millisecond_string
	
	# Setting up proper camera and zoom
	$Gameplay.scale.y = 600.0 / (AreaManager.AREA_SIZE.y * 50)
	$Gameplay.scale.x = 600.0 / (AreaManager.AREA_SIZE.y * 50)
	$Gameplay.position.y += 60
	$Gameplay.position.x += 160
	
	# Resetting the ID variables that the game objects will be using
	AreaManager.object_id_generation["coin"] = 0
	AreaManager.object_id_generation["key"] = 0
	AreaManager.object_id_generation["checkpoint"] = 0
	
	# When loading the area normally
	if not in_cutscene:
		$Gameplay.add_child(player)
		player.position = AreaManager.player_position
		
		AreaManager.current_scene = self
		AreaManager.current_area_name = self.name
		AreaManager.current_area_file_path = self.scene_file_path
		
		AreaManager.current_coordinates = self.coordinates
		AreaManager.current_level_name = str(scene_file_path.get_slice("/", 3))
		
		GlobalSignal.coin_collected.connect(coin_collected)
		GlobalSignal.player_respawn.connect(player_respawn)
		GlobalSignal.money_lost.connect(money_lost)
	
	# Is it inside a cutscene?!
	else:
		process_mode = Node.PROCESS_MODE_WHEN_PAUSED # Makes the area play even when the scene tree is paused


func coin_collected():
	# Makes the money text flash golden
	var tween = create_tween()
	tween.tween_property(interface.get_node("Money"), "modulate", Color8(255, 204, 0), 0)
	tween.tween_property(interface.get_node("Money"), "modulate", Color.WHITE, 0.5)
	# Update the text
	interface.get_node("Money").text = "Coins: " + str(AreaManager.money["amount"]) + " / " + str(AreaManager.money["requirement"])

func player_respawn():
	# Update the Coins, and the Deaths labels.
	interface.get_node("Money").text = "Coins: " + str(AreaManager.money["amount"]) + " / " + str(AreaManager.money["requirement"])
	interface.get_node("Deaths").text = "Deaths: " + str(AreaManager.deaths)

func money_lost():
	# Makes the money text flash red. Activates when losing money.
	var tween = create_tween()
	tween.tween_property(interface.get_node("Money"), "modulate", Color.RED, 0)
	tween.tween_property(interface.get_node("Money"), "modulate", Color.WHITE, 0.5)

