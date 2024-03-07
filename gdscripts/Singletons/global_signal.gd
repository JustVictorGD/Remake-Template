extends Node

# Player actions
signal player_death
signal player_respawn

# Checkpoint related
signal checkpoint_touched
signal update_checkpoint

# Collectibles
signal coin_requirement_met
signal key_collected(key_id)
signal key_lost(key_id)

signal paint_collected

# Object Related Stuff

signal speed_changed(speed)
