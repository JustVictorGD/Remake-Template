extends Node

# Player actions
signal player_death
signal player_respawn

# Checkpoints
signal checkpoint_touched
signal update_checkpoint

# Collectibles
signal coin_collected(coin_id)

signal coin_requirement_met
signal coin_requirement_lost

signal key_collected(key_id, true_id)
signal key_lost(key_id)

# Areas
signal area_loaded(area)

# Object Related Stuff
signal paint_collected

signal speed_changed(speed)
