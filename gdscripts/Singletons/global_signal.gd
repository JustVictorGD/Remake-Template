extends Node

# Player actions
signal player_death
signal player_respawn

# Checkpoint related
signal checkpoint_touched
signal update_checkpoint

# Collectibles
signal coin_requirement_met
signal coin_requirement_lost

signal key_collected(key_id)
signal key_lost(key_id)

# Object Related Stuff
signal paint_collected

signal speed_changed(speed)
