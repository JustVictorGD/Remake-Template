extends Node
class_name Collectable

# 0 - Uncollected
# 1 - Collected
# 2 - Saved
var save_state = 0

func _ready():
	GlobalSignal.player_respawn.connect(player_respawn)
	GlobalSignal.checkpoint_touched.connect(checkpoint_touched)


func touched_by_player():
	if save_state == 0:
		save_state = 1
		collect()

func player_respawn():
	if save_state == 1:
		save_state = 0
		drop()

func checkpoint_touched():
	if save_state == 1:
		save_state = 2
		save()


func collect():
	pass

func drop():
	pass

func save():
	pass
