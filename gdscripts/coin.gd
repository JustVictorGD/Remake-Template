extends Node2D


var coin_id = -1

@onready var area = get_tree().current_scene


func _ready():
	coin_id = AreaManager.next_coin_id
	AreaManager.next_coin_id += 1
	
	
	GlobalSignal.player_respawn.connect(player_respawn)
	GlobalSignal.checkpoint_touched.connect(checkpoint_touched)
	
	
	if AreaManager.save_data["level_1"][area.name]["coins"][coin_id] != 0:
		stay_collected()



func dont_activate(): # _ready():
	if coin_id not in AreaManager.save_data["level_1"][area.name]["coins"]:
		coin_id = AreaManager.next_coin_id
		AreaManager.get_next_id()
		AreaManager.save_data["level_1"][area.name]["coins"].append(0)
	
	



func player_respawn():
	
	if AreaManager.save_data[AreaManager.current_level][AreaManager.current_area]["coins"][coin_id] != 2:
		drop()

func drop():
	var tween = create_tween()
	tween.tween_property($Sprite2D,"modulate:a", 1, 0.10)
	
	
	#AreaManager.coin_dropped(coin_id)
	
	$CollisionShape2D.disabled = false

func touched_by_player():
	var tween = create_tween()
	tween.tween_property($Sprite2D,"modulate:a", 0, 0.10)
	
	$CollisionShape2D.set_deferred("disabled", true)
	SFX.play("Coin")
	
	AreaManager.coin_collected(coin_id)
	GlobalSignal.coin_collected.emit()
	GlobalSignal.update_checkpoint.emit()

func checkpoint_touched():
#	var counter = 0
#	for area1 in AreaManager.save_data[AreaManager.current_level]:
#		for coin in AreaManager.save_data[AreaManager.current_level][area1]["coins"]:
#			counter += 1
#			if coin == 1:
#				coin = 2
#	print(counter)
	pass

func stay_collected():
	$Sprite2D.modulate.a = 0.0
	$CollisionShape2D.set_deferred("disabled", true)
	

