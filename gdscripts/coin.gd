extends Node2D


var coin_id = -1


func _ready():
	coin_id = AreaManager.object_id_generation["coin"]
	AreaManager.object_id_generation["coin"] += 1
	
	if AreaManager.save_data["level_1"][owner.name]["coins"][coin_id] != 0:
		stay_collected()
	
	GlobalSignal.player_respawn.connect(player_respawn)



func touched_by_player():
	var tween = create_tween()
	tween.tween_property($Sprite2D,"modulate:a", 0, 0.10)
	
	$CollisionShape2D.set_deferred("disabled", true)
	SFX.play("Coin")
	
	AreaManager.coin_collected(coin_id)
	GlobalSignal.coin_collected.emit()
	
	GlobalSignal.update_checkpoint.emit()



func player_respawn():
	
	if AreaManager.save_data[AreaManager.current_level_name][AreaManager.current_area_name]["coins"][coin_id] != 2:
		drop()



func drop():
	var tween = create_tween()
	tween.tween_property($Sprite2D,"modulate:a", 1, 0.10)
	
	$CollisionShape2D.disabled = false



func stay_collected():
	$Sprite2D.modulate.a = 0.0
	$CollisionShape2D.set_deferred("disabled", true)
	

