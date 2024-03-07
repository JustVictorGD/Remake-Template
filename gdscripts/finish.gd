extends "res://gdscripts/checkpoint.gd"



@onready var coin_requirement = GameState.uncollected_coins.size()



func _ready():
	GlobalSignal.checkpoint_touched.connect(checkpoint_touched)
	GlobalSignal.update_checkpoint.connect(update_checkpoint)
	GlobalSignal.player_death.connect(player_death)
	
	GameState.coin_requirement = coin_requirement

func touched_by_player():
	if not selection_state == 2:
		var tween = create_tween()
		tween.tween_property($ColorRect,"modulate", Color(0.478, 0.745, 0.478), 0)
		tween.tween_property($ColorRect,"modulate", Color(0.643, 0.996, 0.639), 0.5)
		
		GameState.respawn_pos = self.position
		GlobalSignal.checkpoint_touched.emit()
		
		selection_state = 2
		SFX.play("Checkpoint")
		if GameState.collected_coins.size() + GameState.saved_coins.size() > coin_requirement - 1:
			SFX.play("Finish")
