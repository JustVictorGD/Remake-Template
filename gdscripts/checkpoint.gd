extends Area2D



var checkpoint_id = -1

@export var type: CheckpointType = CheckpointType.CHECKPOINT

enum CheckpointType {
	CHECKPOINT,
	START,
	FINISH
}

func _ready():
	checkpoint_id = AreaManager.object_id_generation["checkpoint"]
	AreaManager.object_id_generation["checkpoint"] += 1
	
	if AreaManager.respawn["area_file_path"] == "": # Check if the respawn area hasn't been specified yet
		AreaManager.respawn["area_file_path"] = owner.scene_file_path



func touched_by_player():
	if self.checkpoint_id != AreaManager.current_checkpoint["id"] or owner.scene_file_path != AreaManager.current_checkpoint["area_file_path"]:
		activate()
	
	elif AreaManager.current_checkpoint["can_update"]:
		activate()



func activate():
	# Pulse darker green
	var tween = create_tween()
	tween.tween_property($ColorRect,"modulate", Color(0.478, 0.745, 0.478), 0)
	tween.tween_property($ColorRect,"modulate", Color(0.643, 0.996, 0.639), 0.5)
	
	# Updating respawn data
	AreaManager.respawn["position"] = self.position
	AreaManager.respawn["area_file_path"] = owner.scene_file_path
	# Updating the "Current Checkpoint" data
	AreaManager.current_checkpoint["id"] = self.checkpoint_id
	AreaManager.current_checkpoint["area_file_path"] = owner.scene_file_path
	AreaManager.current_checkpoint["can_update"] = false
	
	GlobalSignal.checkpoint_touched.emit()
	
	# Is the checkpoint a finish, and have you collected all of the money?
	if type == CheckpointType.FINISH and AreaManager.money["satisfied"]:
		print("VICTORY!!!")
		SFX.play("Finish")
		GlobalSignal.finish.emit()
	# Activate normally.
	else:
		SFX.play("Checkpoint")
