extends Node2D



var player_scene = load("res://scenes/player.tscn").instantiate()

var area_size = Vector2(32, 20)
var player_position = Vector2(250, 850)

var current_area_x = 2
var current_area_y = 2

var message = "The scene that you're trying to enter either doesn't exist, or doesn't have a correct name. (coming from area_manager.gd)"



func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


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




var save_data = {}

func _ready():
	
	var dir1 = DirAccess.open("res://levels")
	dir1.list_dir_begin()
	var main_folder = dir1.get_next()
	
	
	
	while main_folder.is_empty() == false:
		if main_folder != "ignored_files":
			
			save_data[str(main_folder)] = {}
		main_folder = dir1.get_next()
	
	
	
	for level in save_data:
		
		var dir2 = DirAccess.open("res://levels/" + str(level))
		dir2.list_dir_begin()
		var level_folder = dir2.get_next()
		
		
		while level_folder.is_empty() == false:
			save_data[str(level)][str(level_folder)] = {}
			level_folder = dir2.get_next()
		
		
	
	
	
	print(save_data)
	
