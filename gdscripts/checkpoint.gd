extends Area2D



var checkpoint_id = -1

@export var type: CheckpointType = CheckpointType.CHECKPOINT

enum CheckpointType {
	CHECKPOINT,
	START,
	FINISH
}

func _ready():
	checkpoint_id = AreaManager.next_checkpoint_id
	AreaManager.next_checkpoint_id += 1
	
	if AreaManager.respawn_area == "":
		AreaManager.respawn_area = owner.scene_file_path



func touched_by_player():
	print("Checkpoint id = " + str(checkpoint_id))
	
	if self.checkpoint_id != AreaManager.current_checkpoint_id or owner.scene_file_path != AreaManager.current_checkpoint_area:
		activate()
	
	elif AreaManager.current_checkpoint_can_update:
		activate()

func activate():
	
	var tween = create_tween()
	tween.tween_property($ColorRect,"modulate", Color(0.478, 0.745, 0.478), 0)
	tween.tween_property($ColorRect,"modulate", Color(0.643, 0.996, 0.639), 0.5)
	
	AreaManager.respawn_pos = self.position
	AreaManager.respawn_area = owner.scene_file_path
	
	AreaManager.current_checkpoint_id = self.checkpoint_id
	AreaManager.current_checkpoint_area = owner.scene_file_path
	AreaManager.current_checkpoint_can_update = false
	
	GlobalSignal.checkpoint_touched.emit()
	
	if type and AreaManager.requirement_met:
		print("W")
		SFX.play("Finish")
		GlobalSignal.finish.emit()
	else:
		SFX.play("Checkpoint")
