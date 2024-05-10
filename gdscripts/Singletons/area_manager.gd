extends Node2D


const AREA_SIZE := Vector2(32, 20)

# Position
var player_position := Vector2(250, 850)
var current_coordinates := Vector2i.ZERO


var respawn := {
	"position": Vector2(250, 850),
	"area_file_path": ""
}

var current_checkpoint := {
	"id": 0,
	"area_file_path": "res://levels/level_1/StartingRoom.tscn",
	"can_update": false
}

# Useful data for multi-area
var current_level_name := ""
var current_area_name := ""
var current_area_file_path := ""
var player_currently_dead := false
var player_previously_dead := false

var money := {
	"amount": 0,
	"requirement": 0,
	"satisfied": false
}

var object_id_generation := {
	"coin": 0,
	"key": 0,
	"checkpoint": 0
}

var cutscene_info := {
	"key_collected" = null,
	"money_reached" = null
}

# Save system
var save_data = {}
var coordinates_data = {}

var door_info := {}
var money_thresholds := []

# Other
var deaths := 0
var current_scene # The actual object

var time := 0.0
var total_seconds := 0

var hours:= 0
var minutes:= 0
var seconds:= 0
var milliseconds:= 0

var time_string := ""
var millisecond_string := ""



func _physics_process(delta):
	time += delta
	
	total_seconds = int(time)
	@warning_ignore("integer_division")
	hours = int(total_seconds / 3600)
	
	total_seconds -= hours * 3600
	@warning_ignore("integer_division")
	minutes = int(total_seconds / 60)
	
	total_seconds -= minutes * 60
	seconds = total_seconds
	
	milliseconds = int(fmod(time, 1) * 1000)
	
	time_string = "%02d:%02d:%02d" % [hours, minutes, seconds]
	millisecond_string = ".%03d" % [milliseconds]

func player_respawn():
	current_checkpoint["can_update"] = false
	
	for area in save_data[current_level_name]:
		for i in range(save_data[current_level_name][area]["coins"].size()):
			if save_data[current_level_name][area]["coins"][i] == 1:
				money["amount"] -= 1
				save_data[current_level_name][area]["coins"][i] = 0
				GlobalSignal.money_lost.emit()
		
		if area != current_area_name:
			for i in range(save_data[current_level_name][area]["keys"].size()):
				if save_data[current_level_name][area]["keys"][i].y == 1:
					save_data[current_level_name][area]["keys"][i].y = 0
					GlobalSignal.money_lost.emit()
	
	if money["amount"] < money["requirement"]:
		money["satisfied"] = false
		GlobalSignal.coin_requirement_lost.emit()

func update_checkpoint():
	current_checkpoint["can_update"] = true

func coin_collected(coin_id):
	save_data[current_level_name][current_area_name]["coins"][coin_id] = 1
	money["amount"] += 1
	
	if money["amount"] >= money["requirement"]:
		money["satisfied"] = true
	
	for i in range(money_thresholds.size()):
		if money["amount"] >= money_thresholds[i]:
			cutscene_info["money_reached"] = money_thresholds[i]
			
			# This function is broken, and it seems that fixing it will take a while.
			# check_golden_doors(money_thresholds[i])

func key_collected(true_id):
	save_data[current_level_name][current_area_name]["keys"][true_id].y = 1

func checkpoint_touched():
	for area in save_data[current_level_name]:
		for i in range(save_data[current_level_name][area]["coins"].size()):
			if save_data[current_level_name][area]["coins"][i] == 1:
				save_data[current_level_name][area]["coins"][i] = 2
		
		for i in range(save_data[current_level_name][area]["keys"].size()):
				if save_data[current_level_name][area]["keys"][i].y == 1:
					save_data[current_level_name][area]["keys"][i].y = 2


# Thanks Gemini for generating this for me
var letters := ["Z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", \
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


func travel_areas(direction: Vector2i):
	for area in coordinates_data[current_level_name]:
		if coordinates_data[current_level_name][area]["coordinates"] == current_coordinates + direction:
			get_tree().change_scene_to_file(coordinates_data[current_level_name][area]["file_path"])


func _ready():
	GlobalSignal.player_respawn.connect(player_respawn)
	GlobalSignal.checkpoint_touched.connect(checkpoint_touched)
	GlobalSignal.update_checkpoint.connect(update_checkpoint)
	
	create_level_dictionaries()
	
	for i in range(money_thresholds.size()):
		if money_thresholds[i] <= 0:
			money_thresholds[i] += money["requirement"]
	
	money_thresholds.sort()
	
	#print()
	#print("Door info: " + str(door_info))
	#print()


func create_level_dictionaries():
	var master_dir = DirAccess.open("res://levels")
	master_dir.list_dir_begin()
	var main_folder = master_dir.get_next()
	
	while main_folder.is_empty() == false:
		if main_folder != "ignored_files":
			save_data[main_folder] = {}
			coordinates_data[main_folder] = {}
			door_info[main_folder] = {}
		
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
		door_info[level][area_name] = {}
		
		if load("res://levels/" + str(level) + "/" + str(area)) != null:
			var new_area = load("res://levels/" + str(level) + "/" + str(area)).instantiate()
			
			coordinates_data[level][area_name] = {"coordinates" = new_area.coordinates,
			"file_path" = "res://levels/" + str(level) + "/" + str(area)}
			
			door_info[level][area_name]["area_file_path"] = new_area.scene_file_path
			door_info[level][area_name]["normal_doors"] = []
			door_info[level][area_name]["golden_doors"] = []
			
			if new_area.has_node("Gameplay/Doors/NormalDoors"):
				for normal_door in new_area.get_node("Gameplay/Doors/NormalDoors").get_children():
					door_info[level][area_name]["normal_doors"].append(Vector2i(normal_door.connection_id, int(normal_door.play_cutscene)))
			
			if new_area.has_node("Gameplay/Doors/GoldenDoors"):
				for golden_door in new_area.get_node("Gameplay/Doors/GoldenDoors").get_children():
					door_info[level][area_name]["golden_doors"].append(Vector2i(golden_door.money_requirement, int(golden_door.play_cutscene)))
					AreaManager.money_thresholds.append(golden_door.money_requirement)
			
			create_save_arrays(level, area)
		
		area = the_level_dir.get_next()


func create_save_arrays(level, area):
	var loaded_area = load("res://levels/" + str(level) + "/" + str(area)).instantiate()
	
	save_data[level][area.trim_suffix(".tscn")]["coins"] = []
	save_data[level][area.trim_suffix(".tscn")]["keys"] = []
	
	if loaded_area.has_node("Gameplay/Collectables/Coins"):
		var coins_folder = loaded_area.get_node("Gameplay/Collectables/Coins")
		
		for node in coins_folder.get_children():
			save_data[str(level)][str(area).trim_suffix(".tscn")]["coins"].append(0)
			money["requirement"] += 1
	
	if loaded_area.has_node("Gameplay/Collectables/Keys"):
		var keys_folder = loaded_area.get_node("Gameplay/Collectables/Keys")
		
		for key in keys_folder.get_children():
			save_data[str(level)][str(area).trim_suffix(".tscn")]["keys"].append(Vector2i(key.key_id, 0))


func check_normal_doors(key_id):
	var cutscene_queue := []
	
	
	
	for area in door_info[current_level_name]:
		for door in door_info[current_level_name][area]["normal_doors"]:
			if door.y != 0 and door.x == key_id and door_info[current_level_name][area]["area_file_path"] not in cutscene_queue:
				cutscene_queue.append(door_info[current_level_name][area]["area_file_path"])
	
	play_cutscene(cutscene_queue)


func check_golden_doors(money_reached):
	var cutscene_queue := []
	
	for area in door_info[current_level_name]:
		for door in door_info[current_level_name][area]["golden_doors"]:
			if door.y != 0 and door.x == money_reached and door_info[current_level_name][area]["area_file_path"] not in cutscene_queue:
				cutscene_queue.append(door_info[current_level_name][area]["area_file_path"])
	
	play_cutscene(cutscene_queue)



func play_cutscene(cutscene_queue):
	var duration = Vector2(0.25, 0.75)
	
	await get_tree().create_timer(0.5).timeout
	
	if player_currently_dead:
		return # Abort the function
	
	for area_path in cutscene_queue:
		if current_area_file_path == area_path:
			cutscene_queue.erase(current_area_file_path)
	
	if cutscene_queue.size() > 0:
		duration *= ((cutscene_queue.size() + 1) * 0.5) / cutscene_queue.size()
	
	for area_path in cutscene_queue:
		var new_area = load(area_path).instantiate()
		new_area.in_cutscene = true
		current_scene.add_sibling(new_area)
		
		current_scene.get_tree().paused = true
		current_scene.visible = false
		
		await get_tree().create_timer(duration.x).timeout
		
		GlobalSignal.open_doors_in_cutscenes.emit()
		
		SFX.play("OpenDoor")
		
		await get_tree().create_timer(duration.y).timeout
		
		new_area.queue_free()
		current_scene.get_tree().paused = false
		current_scene.visible = true
	
	cutscene_info["key_collected"] = null

