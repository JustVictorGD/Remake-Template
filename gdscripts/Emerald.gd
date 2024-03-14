extends Collectable


var emerald_id = -1

func _ready():
	if emerald_id not in GameState.coin_data:
		emerald_id = GameState.next_emerald_id
		GameState.get_next_emerald_id()
		GameState.uncollected_emeralds.append(emerald_id)

func collect():
	var tween = create_tween()
	tween.tween_property($Sprite2D,"modulate:b", 0, 0.2)
	tween.tween_property($Sprite2D,"modulate:a", 0, 0.5)
	
	SFX.play("Emerald")
	
	GameState.collected_emeralds.append(emerald_id)
	GameState.uncollected_emeralds.erase(emerald_id)
	GlobalSignal.update_checkpoint.emit()
