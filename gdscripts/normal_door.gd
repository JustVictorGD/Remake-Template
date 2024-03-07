extends Door

@export_category("Normal Door Property")
@export var door_id = -1


func _ready():
	setup_size()
	
	GlobalSignal.key_collected.connect(key_collected)
	GlobalSignal.key_lost.connect(key_lost)


func key_collected(key_id):
	if key_id == door_id:
		open()


func key_lost(key_id):
	if key_id == door_id:
		close()

