extends Node2D


var player_scene = load("res://scenes/player.tscn").instantiate()

var area_size := Vector2(32, 20)
var player_position := Vector2(250, 850)

var current_area_x := 2
var current_area_y := 2

var current_level := ""
var current_coordinates := Vector2i.ZERO

var message := "MULTI-AREA ERROR: The scene that you're trying to enter either doesn't exist, \
or doesn't have a correct name. (coming from area_manager.gd)"



var next_coin_id := 0

var coin_requirement := 0
var requirement_met = false


func coin_update():
	
	var temporary_array := []
	
	
	for area in save_data["level_1"]:
		for coin in save_data["level_1"][area]["coins"]:
			if coin == 0:
				temporary_array.append(0)
	
	print(temporary_array)
	
	if temporary_array.size() == 0 and requirement_met == false:
		requirement_met = true
		print("VICTORY!")
		GlobalSignal.coin_requirement_met.emit()
		
	elif temporary_array.size() >= 1 and requirement_met:
		print("What a shame")
		requirement_met = false
		GlobalSignal.coin_requirement_lost.emit()


func _physics_process(delta):
	#print("save_data = " + str(save_data))
	#print()
	pass



# Thanks Gemini for generating this for me
var letters = ["Z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", \
"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y"]


# Please excuse this horrendous code
func decimal_to_letter(decimal):
	if decimal >= 0: # Positive / Negative check
		if decimal > 17575: # 4th letter
			return str(letters[decimal / 17576 % 26]) + str(letters[decimal / 676 % 26]) + \
			str(letters[decimal / 26 % 26]) + str(letters[decimal % 26])
		
		elif decimal > 675: # 3rd letter
			return str(letters[decimal / 676 % 26]) + \
			str(letters[decimal / 26 % 26]) + str(letters[decimal % 26])
		
		elif decimal > 25: # 2nd letter
			return str(letters[decimal / 26 % 26]) + str(letters[decimal % 26])
		
		elif decimal < 26: # 1st letter
			return str(letters[decimal % 26])
	
	else:
		decimal *= -1
		if decimal > 17575: # 4th letter
			return "-" + str(letters[decimal / 17576 % 26]) + str(letters[decimal / 676 % 26]) + \
			str(letters[decimal / 26 % 26]) + str(letters[decimal % 26])
		
		elif decimal > 675: # 3rd letter
			return "-" + str(letters[decimal / 676 % 26]) + \
			str(letters[decimal / 26 % 26]) + str(letters[decimal % 26])
		
		elif decimal > 25: # 2nd letter
			return "-" + str(letters[decimal / 26 % 26]) + str(letters[decimal % 26])
		
		elif decimal < 26: # 1st letter
			return "-" + str(letters[decimal % 26])


func area_up():
	for area in coordinates_data[current_level.trim_prefix("res://levels/")]:
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


func coin_collected(coin_id):
	pass




var save_data = {}
var coordinates_data = {}

func _ready():
	# This thing returns 4 lines, starting with "1-A1 coordinates = (1, 1)".
	
	var level_1_dir = DirAccess.open("res://levels/level_1/")
	level_1_dir.list_dir_begin()
	var file_info = level_1_dir.get_next()
	
	while file_info.is_empty() == false:
		
		var new_area = load("res://levels/level_1/" + str(file_info)).instantiate()
		print(str(new_area.name) + " coordinates = " + str(new_area.coordinates))
		
		file_info = level_1_dir.get_next()
	
	
	GlobalSignal.player_respawn.connect(coin_update)
	GlobalSignal.coin_collected.connect(coin_collected)
	
	
	
	# Accessing the main "levels" folder.
	var master_dir = DirAccess.open("res://levels")
	master_dir.list_dir_begin()
	var main_folder = master_dir.get_next()
	
	
	# Iterating through the folder, and adding dictionaries named based on the level folders to save_data.
	while main_folder.is_empty() == false:
		if main_folder != "ignored_files":
			
			save_data[main_folder] = {}
			coordinates_data[main_folder] = {}
		main_folder = master_dir.get_next()
	
	
	# This entire thing is repeated for every level folder found in the main "levels" folder.
	for level in save_data:
		
		# Accessing the level folder(s).
		var the_level_dir = DirAccess.open("res://levels/" + str(level))
		the_level_dir.list_dir_begin()
		var area = the_level_dir.get_next()
		
		
		# Iterating through the folder(s), again.
		while area.is_empty() == false:
			
			
			var area_name: String = str(area).trim_suffix(".tscn") # This is a shortened version of the scene's file name.
			
			save_data[level][str(area).trim_suffix(".tscn")] = {} # Adding a dictionary named after the area, to the level dictionary.
			
			if load("res://levels/" + str(level) + "/" + str(area)) != null:
				
				var new_area = load("res://levels/" + str(level) + "/" + str(area)).instantiate()
				
				print(str(level) + " and " + str(area))
				
				coordinates_data[str(level)][str(area).trim_suffix(".tscn")] = {"coordinates" = new_area.coordinates, \
"file_path" = "res://levels/" + str(level) + "/" + str(area)}
				
				
				
				
				
			# Adding empty coin and key arrays to each area found.
			save_data[level][area_name]["coins"] = []
			save_data[level][area_name]["keys"] = []
			
			
			# Loading the area, to access its contents.
			if load("res://levels/" + str(level) + "/" + str(area)) != null:
				var loaded_area = load("res://levels/" + str(level) + "/" + str(area)).instantiate()
				
				# Checking for a "Coins" folder inside the actual area.
				if loaded_area.get_node("Coins") != null:
					var coins_folder = loaded_area.get_node("Coins")
					
					
					# Adding a "0" to the "coins" array for every coin found in the area.
					for node in coins_folder.get_children():
						save_data[str(level)][str(area).trim_suffix(".tscn")]["coins"].append(0)
				
				
				# No "Coins" folder found?
				
				else:
					print("The area " + str(level) + ", " + str(area).trim_suffix(".tscn") + ", doesn't seem to have a \
valid \"Coins\" folder. Make sure you're using PascalCase for your nodes and folders, this is how the Remake Template works by default.")
			
			# The area (levels -> level_name -> area_name) doesn't exist?
			
			else:
				print("FAIL. " + str(area))
			
			# Continuing the folder iteration. Fun fact: Not including this will result in a while loop.
			
			area = the_level_dir.get_next()
	
	print()
	print("Coordiantes Data: " + str(coordinates_data))
	print()



func create_level_dictionaries():
	pass


func create_area_dictionaries():
	pass



