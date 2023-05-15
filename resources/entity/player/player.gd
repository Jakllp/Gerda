extends Entity

class_name Player

@export var weapon_scene :PackedScene
@export var mining_equipment_scene :PackedScene

@onready var equipment_angle_point :Vector2 = $EquipmentAnglePoint.position
@onready var weapon := weapon_scene.instantiate()
@onready var mining_equipment := mining_equipment_scene.instantiate()

var input_component = PlayerInputComponent.new()

var current_equipment :Equipment
var ore_pouch := 0:
	set(value):
		if ore_pouch != value:
			print("+"+str(value-ore_pouch)+" Ore! We now have: "+str(value))
			ore_received.emit(value-ore_pouch, global_position)
			ore_pouch = value

signal ore_received(amount, pos)


func _ready() -> void:	
	weapon.position = equipment_angle_point
	add_child(weapon)
	weapon.owner = self
	mining_equipment.position = equipment_angle_point
	add_child(mining_equipment)
	mining_equipment.owner = self
	mining_equipment.visible = false
	
	current_equipment = weapon


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	input_component.update(self, delta)
	current_equipment.update(self)


func change_equipment(equipment) -> void:
	current_equipment.visible = false
	current_equipment = equipment
	current_equipment.visible = true


func use_equipment(delta: float) -> void:
	current_equipment.act(self, delta)
