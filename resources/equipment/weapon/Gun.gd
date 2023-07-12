extends Weapon

class_name Gun

@export var full_auto := false
@export var ammo_needed_per_shot :int
@export var base_reload_time :float
@export var base_fire_delay :float
@export var max_ammo_stored :int
@export var mag_size :int
## How many percent (in relation to base_reload_time) faster you reload per upgrade 
@export var reload_time_upgrade_modifier :int
## How many percent (in relation to base_fire_delay) faster you can shoot per upgrade 
@export var fire_delay_upgrade_modifier :int
@onready var mag_contents :int:
	set(value):
		mag_contents_changed.emit(value)
		mag_contents = value
@onready var ammo_stored :int:
	set(value):
		ammo_stored_changed.emit(value)
		ammo_stored = value

@onready var reload_timer :Timer = $ReloadTimer
@onready var fire_rate_timer :Timer = $FireRateTimer

signal mag_contents_changed(value)
signal ammo_stored_changed(value)


func _ready() -> void:
	super._ready()
	mag_contents = mag_size
	ammo_stored = max_ammo_stored / 2


func update(player: Player) -> void:
	for child in get_children():
		if child.has_method("update"):
			child.update(player)	
	
	if Input.is_action_just_pressed("reload"):
		# Do we need to reload and do we have ammo?
		if mag_contents < mag_size:
			# If so -> Start reload-process
			trigger_reload()


func act(_player: Player, _delta: float) -> void:
	pass

func do_rotation(player: Player):
	$Anglepoint.aim_at_mouse_with_right_angled_grip(player)


# Starts the Reload-Timer
func trigger_reload():
	if ammo_stored > 0 and reload_timer.is_stopped():
		var reload_time = base_reload_time - (base_reload_time * reload_time_upgrade_modifier/100) * active_upgrades[Items.Type.WEAPON_SPEED]
		
		# Animation
		do_animation(reload_time)
		
		reload_timer.wait_time = reload_time
		reload_timer.start()


func do_animation(time) -> void:
	var loading_ring :TextureProgressBar = preload("res://resources/other/LoadingRing.tscn").instantiate()
	owner.add_child(loading_ring)
	loading_ring.position.y -= 17
	loading_ring.position.x -= -2
	var reload_tween :Tween = loading_ring.create_tween()
	reload_tween.tween_property(loading_ring, 'value', 100, time)
	reload_tween.tween_callback(loading_ring.queue_free)
	reload_tween.play()


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


func get_max_restorable() -> int:
	return max_ammo_stored


func get_current_restorable() -> int:
	return ammo_stored


func needs_crafting(stack := false) -> bool:
	if stack and max_ammo_stored - ammo_stored >= restore_per_craft * stack_size:
		return true
	elif max_ammo_stored - ammo_stored >= restore_per_craft:
		return true
	return false


func crafted(stack :bool) -> void:
	ammo_stored += restore_per_craft * stack_size if stack else restore_per_craft
	print("Total ammo replenished: "+str(mag_contents)+"/"+str(ammo_stored))
