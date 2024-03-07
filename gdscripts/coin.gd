extends Collectable


var coin_id = -1

func _ready():
	if coin_id not in GameState.coin_data:
		coin_id = GameState.next_coin_id
		GameState.get_next_id()
		GameState.uncollected_coins.append(coin_id)
	
	GlobalSignal.player_respawn.connect(player_respawn)
	GlobalSignal.checkpoint_touched.connect(checkpoint_touched)
	



func drop():
	var tween = create_tween()
	tween.tween_property($Sprite2D,"modulate:a", 1, 0.10)
	
	GameState.collected_coins.erase(coin_id)
	GameState.uncollected_coins.append(coin_id)

func collect():
	var tween = create_tween()
	tween.tween_property($Sprite2D,"modulate:a", 0, 0.10)
	
	SFX.play("Coin")
	
	GameState.collected_coins.append(coin_id)
	GameState.uncollected_coins.erase(coin_id)
	GlobalSignal.update_checkpoint.emit()

func save():
	GameState.collected_coins.erase(coin_id)
	GameState.saved_coins.append(coin_id)

