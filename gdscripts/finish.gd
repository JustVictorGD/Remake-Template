extends "res://gdscripts/checkpoint.gd"






func _ready():
	GlobalSignal.checkpoint_touched.connect(checkpoint_touched)
	GlobalSignal.update_checkpoint.connect(update_checkpoint)
	GlobalSignal.player_death.connect(player_death)

func touched_by_player():
	if not selection_state == 2:
		var tween = create_tween()
		tween.tween_property($ColorRect,"modulate", Color(0.478, 0.745, 0.478), 0)
		tween.tween_property($ColorRect,"modulate", Color(0.643, 0.996, 0.639), 0.5)
		
		GameState.respawn_pos = self.position
		GlobalSignal.checkpoint_touched.emit()
		
		selection_state = 2
		SFX.play("Checkpoint")
		if AreaManager.requirement_met:
			SFX.play("Finish")
