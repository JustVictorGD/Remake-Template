extends Node2D


# Variables for movement between areas
var player_scene = load("res://scenes/player.tscn").instantiate()
var area_size := Vector2(32, 20)
var player_position := Vector2(250, 850)
var current_coordinates := Vector2i.ZERO

# Useful data
var current_level := ""
var current_area := ""

# Coins
var coins_collected := 0
var coin_requirement := 0
var requirement_met = false
var next_coin_id := 0

# Keys
var next_key_id := 0



func player_respawn():
	for area in save_data[current_level]:
		for i in range(save_data[current_level][area]["coins"].size()):
			if save_data[current_level][area]["coins"][i] == 1:
				coins_collected -= 1
				save_data[current_level][area]["coins"][i] = 0
	
	if coins_collected < coin_requirement:
		requirement_met = false
		GlobalSignal.coin_requirement_lost.emit()



func coin_collected(coin_id):
	save_data[current_level][current_area]["coins"][coin_id] = 1
	
	coins_collected += 1

func key_collected(true_id):
	save_data[current_level][current_area]["keys"][true_id].y = 1

func checkpoint_touched():
	for area in save_data[current_level]:
		for i in range(save_data[current_level][area]["coins"].size()):
			if save_data[current_level][area]["coins"][i] == 1:
				save_data[current_level][area]["coins"][i] = 2



# Thanks Gemini for generating this for me
var letters = ["Z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", \
"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y"]



func decimal_to_letter(decimal):
	if decimal == 0:
		return "Z"
	
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
	
	create_level_dictionaries()
	
	print()
	print("Save data: " + str(save_data))
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
			
			print("name = " + str(key.name) + ", key_id = " + str(key.key_id))
			save_data[str(level)][str(area).trim_suffix(".tscn")]["keys"].append(Vector2i(key.key_id, 0))



func _physics_process(delta):
	#print_stuff()
	pass

func print_stuff():
	#for area in save_data[current_level]:
	#	print(str(area) + " = " + str(save_data[current_level][str(area)]["coins"]))
	#print("Save data: " + str(save_data))
	print("Coins collected: " + str(coins_collected) + "/" + str(coin_requirement))
	#print()
	#print(uncollected_coins)
	pass




