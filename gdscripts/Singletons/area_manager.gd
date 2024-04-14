extends Node2D


var player_scene = load("res://scenes/player.tscn").instantiate()

var area_size := Vector2(32, 20)
var player_position := Vector2(250, 850)

var current_area_x := 2
var current_area_y := 2

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



func new_area_loaded():
	print("EEEEE")

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
	if ResourceLoader.exists("res://levels/level_1/1-" +\
	decimal_to_letter(current_area_x) + str(current_area_y - 1) + ".tscn"):
		
		get_tree().change_scene_to_file("res://levels/level_1/1-" +\
		decimal_to_letter(current_area_x) + str(current_area_y - 1) + ".tscn")
		
		current_area_y -= 1
		new_area_loaded()
	
	else:
		print(message)

func area_left():
	if ResourceLoader.exists("res://levels/level_1/1-" +\
	decimal_to_letter(current_area_x - 1) + str(current_area_y) + ".tscn"):
	
		get_tree().change_scene_to_file("res://levels/level_1/1-" +\
		decimal_to_letter(current_area_x - 1) + str(current_area_y) + ".tscn")
		
		current_area_x -= 1
		new_area_loaded()
		player_position.x = area_size.x * 50 - 22
	
	else:
		print(message)

func area_down():
	if ResourceLoader.exists("res://levels/level_1/1-" +\
	decimal_to_letter(current_area_x) + str(current_area_y + 1) + ".tscn"):
		
		get_tree().change_scene_to_file("res://levels/level_1/1-" +\
		decimal_to_letter(current_area_x) + str(current_area_y + 1) + ".tscn")
		
		current_area_y += 1
		new_area_loaded()
		player_position.y = 22
	
	else:
		print(message)

func area_right():
	if ResourceLoader.exists("res://levels/level_1/1-" +\
	decimal_to_letter(current_area_x + 1) + str(current_area_y) + ".tscn"):
		
		get_tree().change_scene_to_file("res://levels/level_1/1-" +\
		decimal_to_letter(current_area_x + 1) + str(current_area_y) + ".tscn")
		
		current_area_x += 1
		new_area_loaded()
		player_position.x = 22
	
	else:
		print(message)


func coin_collected(coin_id):
	pass


var save_data = {}

func _ready():
	
	GlobalSignal.player_respawn.connect(coin_update)
	GlobalSignal.coin_collected.connect(coin_collected)
	
	
	var dir1 = DirAccess.open("res://levels")
	dir1.list_dir_begin()
	var main_folder = dir1.get_next()
	
	while main_folder.is_empty() == false:
		if main_folder != "ignored_files":
			
			save_data[str(main_folder)] = {}
		main_folder = dir1.get_next()
	
	create_level_dictionaries()


func create_level_dictionaries():
	
	for level in save_data:
		
		var dir2 = DirAccess.open("res://levels/" + str(level))
		dir2.list_dir_begin()
		var level_folder = dir2.get_next()
		
		
		while level_folder.is_empty() == false:
			
			var area_name: String = str(level_folder).trim_suffix(".tscn")
			
			save_data[str(level)][str(level_folder).trim_suffix(".tscn")] = {}
			
			
			
			
			
			# save_data["level_1"]["1-A1"] doesn't exist.
			
			save_data[str(level)][str(area_name)]["coins"] = [] # Error appears here. It seems that the "area_name" part is causing the trouble.
			save_data[str(level)][str(area_name)]["keys"] = []
			
			if load("res://levels/" + str(level) + "/" + str(level_folder)) != null:
				var loaded_area: PackedScene = load("res://levels/" + str(level) + "/" + str(level_folder))
				var instantiated_area = loaded_area.instantiate()
				
				if instantiated_area.get_node("Coins") != null:
				
				
					var coins_folder = instantiated_area.get_node("Coins")
					
					
					for node in coins_folder.get_children():
						
						save_data[str(level)][str(level_folder).trim_suffix(".tscn")]["coins"].append(0)
					
					#print("12341234" + str(save_data[str(level)]))
					
					#print(str(level_folder).trim_suffix(".tscn") + " coins = " + \
					#str(save_data["level_1"][str(level_folder).trim_suffix(".tscn")]["coins"]))
				
				
				else:
					print("The area " + str(level) + ", " + str(level_folder).trim_suffix(".tscn") + ", doesn't seem to have a valid 'Coins' folder. \
Make sure you're using PascalCase for your nodes and folders, this is how the Remake Template works by default.")
			
			
			else:
				print("FAIL. " + str(level_folder))
				
			level_folder = dir2.get_next()
			
			
	print("Specific 1-A2 array: " + str(save_data["level_1"]["1-A2"]["coins"]))
	
	

