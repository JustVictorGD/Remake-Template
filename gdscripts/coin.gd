extends Node2D


var coin_id = -1

@onready var area_name = get_tree().current_scene.return_name()


func _ready():
	coin_id = AreaManager.next_coin_id
	AreaManager.next_coin_id += 1
	
	
	GlobalSignal.player_respawn.connect(player_respawn)
	GlobalSignal.checkpoint_touched.connect(checkpoint_touched)
	
	print(area_name)
	
	if AreaManager.save_data["level_1"][area_name]["coins"][coin_id] != 0:
		stay_collected()



func dont_activate(): # _ready():
	if coin_id not in AreaManager.save_data["level_1"][area_name]["coins"]:
		coin_id = AreaManager.next_coin_id
		AreaManager.get_next_id()
		AreaManager.save_data["level_1"][area_name]["coins"].append(0)
	
	



func player_respawn():
	if AreaManager.save_data["level_1"][area_name]["coins"][coin_id] == 1:
		drop()

func drop():
	var tween = create_tween()
	tween.tween_property($Sprite2D,"modulate:a", 1, 0.10)
	
	AreaManager.save_data["level_1"][area_name]["coins"][coin_id] = 0
	AreaManager.coin_update()
	
	$CollisionShape2D.disabled = false

func touched_by_player():
	var tween = create_tween()
	tween.tween_property($Sprite2D,"modulate:a", 0, 0.10)
	
	SFX.play("Coin")
	
	AreaManager.save_data["level_1"][area_name]["coins"][coin_id] = 1
	AreaManager.coin_update()
	GlobalSignal.update_checkpoint.emit()
	
	$CollisionShape2D.set_deferred("disabled", true)

func checkpoint_touched():
	if AreaManager.save_data["level_1"][area_name]["coins"][coin_id] == 1:
		AreaManager.save_data["level_1"][area_name]["coins"][coin_id] = 2

func stay_collected():
	$Sprite2D.modulate.a = 0.0
	$CollisionShape2D.set_deferred("disabled", true)
	

