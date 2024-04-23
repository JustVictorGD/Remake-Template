extends Door

@export_category("Normal Door Property")

@export var door_id = -1

func _ready():
	setup_size()
	
	
	GlobalSignal.key_collected.connect(key_collected)
	GlobalSignal.key_lost.connect(key_lost)
	
	if door_id >= 0:
		for level in AreaManager.save_data:
			for area in AreaManager.save_data[level]:
				for key in AreaManager.save_data[level][area]["keys"]:
					if key.x == door_id and key.y != 0:
						stay_open()


func key_collected(key_id):
	if key_id == door_id:
		open()


func key_lost(key_id):
	if key_id == door_id:
		close()

