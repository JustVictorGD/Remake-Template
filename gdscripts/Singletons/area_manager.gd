extends Node2D


# Variables for movement between areas
var player_scene = load("res://scenes/player.tscn").instantiate()
var area_size := Vector2(32, 20)
var player_position := Vector2(250, 850)
var current_coordinates := Vector2i.ZERO

# Checkpoints
var respawn_pos := Vector2(250, 850)
var respawn_area := ""
var next_checkpoint_id := 0

var current_checkpoint_id: int = 0
var current_checkpoint_area: String = "res://levels/level_1/StartingRoom.tscn"
var current_checkpoint_can_update: bool = false


# Useful data for multi-area
var current_level := ""
var current_area := ""
var current_area_path := ""
var player_previously_dead := false

# Coins
var coins_collected := 0
var coin_requirement := 0
var requirement_met = false
var next_coin_id := 0

# Keys
var next_key_id := 0
var used_key_ids := []



func player_respawn():
	
	current_checkpoint_can_update = false
	
	for area in save_data[current_level]:
		
		for i in range(save_data[current_level][area]["coins"].size()):
			if save_data[current_level][area]["coins"][i] == 1:
				coins_collected -= 1
				save_data[current_level][area]["coins"][i] = 0
		
		if area != current_area:
		
			for i in range(save_data[current_level][area]["keys"].size()):
				if save_data[current_level][area]["keys"][i].y != 2:
					save_data[current_level][area]["keys"][i].y = 0
	
	if coins_collected < coin_requirement:
		requirement_met = false
		GlobalSignal.coin_requirement_lost.emit()

func update_checkpoint():
	current_checkpoint_can_update = true

func coin_collected(coin_id):
	save_data[current_level][current_area]["coins"][coin_id] = 1
	coins_collected += 1
	
	if coins_collected >= coin_requirement:
		requirement_met = true


func key_collected(true_id):
	save_data[current_level][current_area]["keys"][true_id].y = 1


func checkpoint_touched():
	for area in save_data[current_level]:
		
		for i in range(save_data[current_level][area]["coins"].size()):
			if save_data[current_level][area]["coins"][i] == 1:
				save_data[current_level][area]["coins"][i] = 2
		
		for i in range(save_data[current_level][area]["keys"].size()):
				if save_data[current_level][area]["keys"][i].y == 1:
					save_data[current_level][area]["keys"][i].y = 2



# Thanks Gemini for generating this for me
var letters = ["Z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", \
"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y"]



func decimal_to_letter(decimal):
	if decimal == 0:
		return "Z"
	
	elif decimal == -9223372036854775808: # When this number gets inverted, it exceeds 2^63-1 and would simply return "-"
		return "-CRPXNLSKVLJFHH"
	
	else:
		var minus_sign = ""
		var letter_string = ""
		
		if decimal < 0:
			minus_sign = "-"
			decimal *= -1
		
		while decimal > 0:
			letter_string = letters[decimal % 26] + letter_string
			decimal /= 26
		
		return minus_sign + letter_string


func area_up():
	for area in coordinates_data[current_level]:
		if coordinates_data[current_level][area]["coordinates"] == current_coordinates + Vector2i.UP:
			get_tree().change_scene_to_file(coordinates_data[current_level][area]["file_path"])

func area_left():
	for area in coordinates_data[current_level.trim_prefix("res://levels/")]:
		if coordinates_data[current_level][area]["coordinates"] == current_coordinates + Vector2i.LEFT:
			get_tree().change_scene_to_file(coordinates_data[current_level][area]["file_path"])

func area_down():
	for area in coordinates_data[current_level.trim_prefix("res://levels/")]:
		if coordinates_data[current_level][area]["coordinates"] == current_coordinates + Vector2i.DOWN:
			get_tree().change_scene_to_file(coordinates_data[current_level][area]["file_path"])

func area_right():
	for area in coordinates_data[current_level.trim_prefix("res://levels/")]:
		if coordinates_data[current_level][area]["coordinates"] == current_coordinates + Vector2i.RIGHT:
			get_tree().change_scene_to_file(coordinates_data[current_level][area]["file_path"])



var save_data = {}
var coordinates_data = {}



func _ready():
	
	GlobalSignal.player_respawn.connect(player_respawn)
	GlobalSignal.checkpoint_touched.connect(checkpoint_touched)
	GlobalSignal.update_checkpoint.connect(update_checkpoint)
	
	create_level_dictionaries()
	
	print()
	print(used_key_ids)
	print()



func create_level_dictionaries():
	
	var master_dir = DirAccess.open("res://levels")
	master_dir.list_dir_begin()
	var main_folder = master_dir.get_next()
	
	
	while main_folder.is_empty() == false:
		if main_folder != "ignored_files":
			
			save_data[main_folder] = {}
			coordinates_data[main_folder] = {}
		main_folder = master_dir.get_next()
	
	
	for level in save_data:
		
		create_area_dictionaries(level)



func create_area_dictionaries(level):
	
	var the_level_dir = DirAccess.open("res://levels/" + str(level))
	the_level_dir.list_dir_begin()
	var area = the_level_dir.get_next()
	
	
	while area.is_empty() == false:
		
		var area_name: String = str(area).trim_suffix(".tscn")
		
		save_data[level][area_name] = {}
		
		
		if load("res://levels/" + str(level) + "/" + str(area)) != null:
			
			var new_area = load("res://levels/" + str(level) + "/" + str(area)).instantiate()
			
			coordinates_data[level][area_name] = {"coordinates" = new_area.coordinates,
				"file_path" = "res://levels/" + str(level) + "/" + str(area)}
			
			create_save_arrays(level, area)
		
		
		area = the_level_dir.get_next()



func create_save_arrays(level, area):
	
	var loaded_area = load("res://levels/" + str(level) + "/" + str(area)).instantiate()
	
	save_data[level][area.trim_suffix(".tscn")]["coins"] = []
	save_data[level][area.trim_suffix(".tscn")]["keys"] = []
	
	
	if loaded_area.has_node("Collectables/Coins"):
		
		var coins_folder = loaded_area.get_node("Collectables/Coins")
		for node in coins_folder.get_children():
			
			save_data[str(level)][str(area).trim_suffix(".tscn")]["coins"].append(0)
			coin_requirement += 1
	
	
	if loaded_area.has_node("Collectables/Keys"):
		
		var keys_folder = loaded_area.get_node("Collectables/Keys")
		for key in keys_folder.get_children():
			
			save_data[str(level)][str(area).trim_suffix(".tscn")]["keys"].append(Vector2i(key.key_id, 0))
	
	if loaded_area.has_node("Doors/NormalDoors"):
		var doors_folder = loaded_area.get_node("Doors/NormalDoors")
		for door in doors_folder.get_children():
			
			used_key_ids.append(door.door_id)



func _physics_process(delta):
	#print_stuff()
	pass

func print_stuff():
	print("Save data: " + str(save_data))
	print()
	pass




