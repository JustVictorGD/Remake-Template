extends Collectable


@export var key_id = -1


func collect():
	var tween = create_tween()
	
	tween.tween_property($Sprite2D, "modulate:a", 0, 0.1)
	SFX.play("Key")
	
	GlobalSignal.update_checkpoint.emit()
	if key_id != -1:
		GlobalSignal.key_collected.emit(key_id)


func drop():
	var tween = create_tween()
	tween.tween_property($Sprite2D,"modulate:a", 1, 0.10)
	GlobalSignal.key_lost.emit(key_id)
