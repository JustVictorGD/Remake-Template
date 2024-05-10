extends Node2D

## Use this to connect the key to doors. A key with the ID of 1 will open any normal door in the level that has its Connection ID set to 1.
@export var key_id = -1


var true_id = -1


func _ready():
	
	true_id = AreaManager.object_id_generation["key"]
	AreaManager.object_id_generation["key"] += 1
	
	GlobalSignal.player_respawn.connect(player_respawn)
	GlobalSignal.checkpoint_touched.connect(checkpoint_touched)
	
	if AreaManager.save_data["level_1"][owner.name]["keys"][true_id].y != 0:
		
		stay_collected()



func player_respawn():
	if AreaManager.save_data[AreaManager.current_level_name][AreaManager.current_area_name]["keys"][true_id].y == 1:
		
		AreaManager.save_data[AreaManager.current_level_name][AreaManager.current_area_name]["keys"][true_id].y = 0
		GlobalSignal.key_lost.emit(key_id)
		drop()



func touched_by_player():
	var tween = create_tween()
	
	tween.tween_property($Sprite2D, "modulate:a", 0, 0.1)
	$CollisionShape2D.set_deferred("disabled", true)
	SFX.play("Key")
	
	AreaManager.check_normal_doors(key_id)
	
	AreaManager.save_data["level_1"][owner.name]["keys"][true_id].y = 1
	AreaManager.cutscene_info["key_collected"] = self.key_id
	
	if key_id != -1:
		GlobalSignal.key_collected.emit(key_id)
	
	GlobalSignal.update_checkpoint.emit()



func drop():
	var tween = create_tween()
	tween.tween_property($Sprite2D,"modulate:a", 1, 0.1)
	$CollisionShape2D.disabled = false
	
	GlobalSignal.key_lost.emit(key_id)
	AreaManager.save_data["level_1"][owner.name]["keys"][true_id].y = 0



func stay_collected():
	$Sprite2D.modulate.a = 0.0
	$CollisionShape2D.set_deferred("disabled", true)



func checkpoint_touched():
	if AreaManager.save_data[AreaManager.current_level_name][AreaManager.current_area_name]["keys"][true_id].y == 1:
		AreaManager.save_data[AreaManager.current_level_name][AreaManager.current_area_name]["keys"][true_id].y = 2

