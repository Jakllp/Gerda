extends Entity

class_name Player

@export var weapon_scene :PackedScene
@export var mining_equipment_scene :PackedScene

@onready var equipment_angle_point :Vector2 = $EquipmentAnglePoint.position
@onready var weapon := weapon_scene.instantiate()
@onready var mining_equipment := mining_equipment_scene.instantiate()

@onready var input_component = PlayerInputComponent.new()

var current_equipment :Equipment
var ore_pouch := 0

signal ore_received(amount, ore_pos)


func _ready() -> void:	
	weapon.position = equipment_angle_point
	add_child(weapon)
	mining_equipment.position = equipment_angle_point
	add_child(mining_equipment)
	mining_equipment.visible = false
	
	current_equipment = weapon
	
	mining_equipment.get("mining_component").ore_mined.connect(_on_ore_mined)


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


func _on_ore_mined(mined_by_player: bool, amount: int, ore_pos: Vector2i) -> void:
	if mined_by_player:
		ore_pouch += amount
		ore_received.emit(amount, ore_pos)
		print("+"+str(amount)+" Ore! We now have: "+str(ore_pouch))
