extends Weapon

class_name Gun

@export var ammo_needed_per_shot :int
@export var base_reload_time :int
@export var max_ammo_stored :int
@export var mag_size :int
@onready var mag_contents :int = mag_size
@onready var ammo_stored :int = max_ammo_stored
@onready var reload_time :int = base_reload_time

@onready var reload_timer :Timer = $ReloadTimer


func update(player: Player) -> void:
	for child in get_children():
		if child.has_method("update"):
			child.update(player)
			
	
	
	if Input.is_action_just_pressed("reload"):
		# Do we need to reload and do we have ammo?
		if mag_contents < mag_size:
			# If so -> Start reload-process
			trigger_reload()


func act(player: Player, delta: float) -> void:
	pass

func do_rotation(player: Player):
	$Anglepoint.aim_at_mouse_with_right_angled_grip(player)


# Starts the Reload-Timer
func trigger_reload():
	if ammo_stored > 0 and reload_timer.is_stopped():
		print("Reloading...")
		reload_timer.wait_time = reload_time
		reload_timer.start()


# Triggered by Reload-Timer
func reload() -> void:
	var mag_diff = mag_size - mag_contents
	if ammo_stored >= mag_diff:
		# We have enough to fill!
		mag_contents = mag_size
		ammo_stored -= mag_diff
	else: 
		# Not enough to fill completely -> Empty store
		mag_contents += ammo_stored
		ammo_stored = 0
	print("Reloaded! "+str(mag_contents)+"/"+str(ammo_stored))


func needs_crafting() -> bool:
	if max_ammo_stored - ammo_stored > restore_per_craft:
		return true
	return false


func crafted() -> void:
	ammo_stored += restore_per_craft
	print("Total ammo replenished: "+str(mag_contents)+"/"+str(ammo_stored))
