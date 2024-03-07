extends Collectable


func collect():
	GameState.player_outline = $Outline.modulate
	GameState.player_filling = $Filling.modulate
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0)
	SFX.play("Key")


