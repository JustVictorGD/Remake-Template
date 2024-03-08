extends Node


var player_scene = load("res://scenes/player.tscn").instantiate()

var area_size = Vector2(32, 20)
var player_position = Vector2.ZERO

var current_area_x = 2
var current_area_y = 2

var message = "The scene that you're trying to enter either doesn't exist, or doesn't have a correct name. (coming from area_manager.gd)"

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
	if ResourceLoader.exists("res://areas/1-" +\
	decimal_to_letter(current_area_x) + str(current_area_y - 1) + ".tscn"):
		
		get_tree().change_scene_to_file("res://areas/1-" +\
		decimal_to_letter(current_area_x) + str(current_area_y - 1) + ".tscn")
		
		current_area_y -= 1
		new_area_loaded()
	
	else:
		print(message)

func area_left():
	if ResourceLoader.exists("res://areas/1-" +\
	decimal_to_letter(current_area_x - 1) + str(current_area_y) + ".tscn"):
	
		get_tree().change_scene_to_file("res://areas/1-" +\
		decimal_to_letter(current_area_x - 1) + str(current_area_y) + ".tscn")
		
		current_area_x -= 1
		new_area_loaded()
	
	else:
		print(message)

func area_down():
	if ResourceLoader.exists("res://areas/1-" +\
	decimal_to_letter(current_area_x) + str(current_area_y + 1) + ".tscn"):
		
		get_tree().change_scene_to_file("res://areas/1-" +\
		decimal_to_letter(current_area_x) + str(current_area_y + 1) + ".tscn")
		
		current_area_y += 1
		new_area_loaded()
	
	else:
		print(message)

func area_right():
	if ResourceLoader.exists("res://areas/1-" +\
	decimal_to_letter(current_area_x + 1) + str(current_area_y) + ".tscn"):
		
		get_tree().change_scene_to_file("res://areas/1-" +\
		decimal_to_letter(current_area_x + 1) + str(current_area_y) + ".tscn")
		
		current_area_x += 1
		new_area_loaded()
	
	else:
		print(message)
