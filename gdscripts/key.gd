extends Node2D


@export var key_id = -1

@onready var area = get_tree().current_scene

var true_id = -1

# Coins are saved as integer variabes, keys are saved as Vector2i variables because they have 3 things to keep track of.
#
# True ID = Position inside the array. To access a key with the true id of 3, use something along the lines of "keys[3]".
# Key ID = The "X" value of the Vector2i element inside the save data.
# Save state = The "Y" value of the Vector2i element inside the save data.

func _ready():
	true_id = AreaManager.next_key_id
	AreaManager.next_key_id += 1
	
	GlobalSignal.player_respawn.connect(player_respawn)
	GlobalSignal.checkpoint_touched.connect(checkpoint_touched)
	
	if AreaManager.save_data["level_1"][area.name]["keys"][true_id].y != 0:
		stay_collected()

func player_respawn():
	if AreaManager.save_data[AreaManager.current_level][AreaManager.current_area]["keys"][true_id].y == 1:
		AreaManager.save_data[AreaManager.current_level][AreaManager.current_area]["keys"][true_id].y = 0
		GlobalSignal.key_lost.emit(key_id)
		drop()
		print("SDFHGFSDGHFSDG")

func touched_by_player():
	var tween = create_tween()
	
	tween.tween_property($Sprite2D, "modulate:a", 0, 0.1)
	$CollisionShape2D.set_deferred("disabled", true)
	SFX.play("Key")
	
	AreaManager.save_data["level_1"][area.name]["keys"][true_id].y = 1
	
	if key_id != -1:
		GlobalSignal.key_collected.emit(key_id)
	
	GlobalSignal.update_checkpoint.emit()
	
	if owner.has_node("Doors/NormalDoors"):
		var temporary_array := []
		
		var doors_folder = owner.get_node("Doors/NormalDoors")
		for door in doors_folder.get_children():
			if door.door_id == key_id:
				temporary_array.append(0)
		
		if temporary_array.size() == 0:
			SFX.play("DistantDoor")
			print("Failure")

func drop():
	var tween = create_tween()
	tween.tween_property($Sprite2D,"modulate:a", 1, 0.1)
	$CollisionShape2D.disabled = false
	
	GlobalSignal.key_lost.emit(key_id)
	AreaManager.save_data["level_1"][area.name]["keys"][true_id].y = 0

func stay_collected():
	$Sprite2D.modulate.a = 0.0
	$CollisionShape2D.set_deferred("disabled", true)

func checkpoint_touched():
	if AreaManager.save_data[AreaManager.current_level][AreaManager.current_area]["keys"][true_id].y == 1:
		AreaManager.save_data[AreaManager.current_level][AreaManager.current_area]["keys"][true_id].y = 2

