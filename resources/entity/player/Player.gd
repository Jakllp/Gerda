extends MovingEnity

class_name Player

## How much percent of the base speed each upgrade does
@export var walk_speed_upgrade_modifier :int
## How much the cooldown goes down with each upgrade
@export var dash_cooldown_upgrade_modifier :float

@onready var equipment_angle_point :Marker2D = $EquipmentAnglePoint
@onready var dash = $Dash
@onready var active_upgrades := {}

var weapon: Weapon
var mining_equipment: MiningEquipment
var status_effects: StatusEffectSet = StatusEffectSet.new(self)

## How much the dash increases the movement speed
const dash_multiplier = 3
const dash_duration = 0.1
var dash_max_amount = 2:
	set(value):
		assert(value >= 0, "you cannot have a negative amount of dashes!")
		dash_max_amount_changed.emit(value)
		dash_max_amount = value
var dashes_left = dash_max_amount:
	set(value):
		assert(value >= 0, "you cannot dash with less than one dash")
		assert(value <= dash_max_amount, "you cannot have more dashes than your max amount")
		dashes_left_changed.emit(dashes_left, value - dashes_left)
		dashes_left = value
## How long it takes for dashes to recharge
var dash_cooldown = 1.0

var input_component = PlayerInputComponent.new()

var current_equipment :Equipment
var ore_pouch := 0:
	set(value):
		if ore_pouch != value:
			if value > ore_pouch:
				ore_received.emit(value-ore_pouch, Vector2(global_position.x,global_position.y-20))
			ore_pouch = value
			ore_changed.emit(ore_pouch)

signal ore_received(amount, pos)
signal ore_changed(amount)
signal player_upgrade_received(type)
signal health_changed(amount)
signal dash_max_amount_changed(amount)
signal dashes_left_changed(previous, diff)
signal pause


func _ready() -> void:
	weapon.position = equipment_angle_point.position
	add_child(weapon)
	weapon.owner = self
	mining_equipment.position = equipment_angle_point.position
	add_child(mining_equipment)
	mining_equipment.owner = self
	mining_equipment.visible = false
	
	current_equipment = weapon
	
	# Fill upgrades
	for x in Upgrade.Player_Upgrade.values():
		active_upgrades[x] = 0
	
	dash.get_node("RefillTimer").timeout.connect(_on_dash_refill)
	dash_max_amount_changed.emit(dash_max_amount)
	
	$PlayerHealthComponent.max_hp_changed.emit($PlayerHealthComponent.hp_max)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	# Movement-Code
	input_component.update(self, delta)
	var speedup = (base_speed * walk_speed_upgrade_modifier/100) * active_upgrades[Upgrade.Player_Upgrade.WALK_SPEED]
	var calculated_speed = base_speed + speedup
	speed = calculated_speed * dash_multiplier if dash.is_dashing() else calculated_speed 
	
	# Animate
	if self.direction.length() > 0:
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play("walk")
	elif $AnimationPlayer.is_playing():
		$AnimationPlayer.stop(false)
	if !dash.is_dashing() and $DashEffect.emitting:
		$DashEffect.emitting = false
	
	current_equipment.update(self)
	
	# this has to be one of the last things in the process
	status_effects.process(delta)


func change_equipment(equipment) -> void:
	current_equipment.visible = false
	current_equipment = equipment
	current_equipment.visible = true


func use_equipment(delta: float, try_auto_weapon: bool = false) -> void:
	if try_auto_weapon and weapon is Gun and weapon.full_auto:
		current_equipment.act(self, delta)
	elif not try_auto_weapon:
		current_equipment.act(self, delta)


func try_dash() -> void:
	print(str(dash.allowed_to_dash()))
	if dashes_left > 0 && dash.allowed_to_dash() && direction.length() > 0:
		var calculated_cooldown = dash_cooldown - dash_cooldown_upgrade_modifier * active_upgrades[Upgrade.Player_Upgrade.DASH_COOLDOWN]
		if calculated_cooldown < 0.0: calculated_cooldown = 0
		dash.start_dash(dash_duration, calculated_cooldown)
		
		$DashEffect.emitting = true
		var dash_flash_tween = self.create_tween()
		dash_flash_tween.tween_method(set_shader_value, 0.8, 0.0, dash_duration)
		dash_flash_tween.play()
		
		dashes_left -= 1
		print("Dashed - Dashes left: "+str(dashes_left)+"/"+str(dash_max_amount))


func set_shader_value(value: float):
	$SubViewportContainer/SubViewport/AnimatedSprite2D.material.set_shader_parameter("flash_modifier", value)


func add_upgrade(upgrade :Upgrade.Player_Upgrade):
	player_upgrade_received.emit(upgrade)
	active_upgrades[upgrade] += 1
	print(str(Upgrade.Player_Upgrade.keys()[upgrade])+" now at "+str(active_upgrades[upgrade]))


func _on_dash_refill() -> void:
	if dashes_left < dash_max_amount:
		dashes_left+=1
		print("Refilled Dash - Dashes left: "+str(dashes_left)+"/"+str(dash_max_amount))
		if dashes_left == dash_max_amount:
			dash.stop_refill()
			

func _unhandled_input(event):
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		pause.emit()
		get_viewport().set_input_as_handled()
