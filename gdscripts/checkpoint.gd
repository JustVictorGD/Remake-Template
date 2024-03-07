extends Area2D




# 0 - Not selected
# 1 - Can be re-selected
# 2 - Selected

@export var selection_state = 0

func _ready():
	GlobalSignal.checkpoint_touched.connect(checkpoint_touched)
	GlobalSignal.update_checkpoint.connect(update_checkpoint)
	GlobalSignal.player_death.connect(player_death)

func touched_by_player():
	if not selection_state == 2:
		var tween = create_tween()
		tween.tween_property($ColorRect,"modulate", Color(0.478, 0.745, 0.478), 0)
		tween.tween_property($ColorRect,"modulate", Color(0.643, 0.996, 0.639), 0.5)
		
		SFX.play("Checkpoint")
		
		GameState.respawn_pos = self.position
		GlobalSignal.checkpoint_touched.emit()
		
		selection_state = 2

func checkpoint_touched():
	selection_state = 0

func update_checkpoint():
	if selection_state == 2:
		selection_state = 1

func player_death():
	if selection_state == 1:
		selection_state = 2

