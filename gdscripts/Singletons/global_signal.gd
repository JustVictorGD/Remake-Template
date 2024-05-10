extends Node

# Player actions
signal player_death
signal player_respawn

# Checkpoints
signal checkpoint_touched
signal update_checkpoint
signal finish

# Collectibles
signal coin_collected
signal diamond_collected
signal money_lost

signal coin_requirement_met
signal coin_requirement_lost

signal key_collected(key_id, true_id)
signal key_lost(key_id)

# Areas
signal area_loaded(area)
signal send_current_scene(scene)

signal open_doors_in_cutscenes

# Object Related Stuff
signal paint_collected

signal speed_changed(speed)
