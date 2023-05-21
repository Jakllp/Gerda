extends MovingEnity

class_name Player

@export var weapon_scene :PackedScene
@export var mining_equipment_scene :PackedScene

@onready var equipment_angle_point :Marker2D = $EquipmentAnglePoint
@onready var weapon := weapon_scene.instantiate()
@onready var mining_equipment := mining_equipment_scene.instantiate()

var input_component = PlayerInputComponent.new()

var current_equipment :Equipment
var ore_pouch := 0:
	set(value):
		if ore_pouch != value:
			print("+"+str(value-ore_pouch)+" Ore! We now have: "+str(value))
			ore_received.emit(value-ore_pouch, Vector2(global_position.x,global_position.y-20))
			ore_pouch = value

signal ore_received(amount, pos)


func _ready() -> void:
	weapon.position = equipment_angle_point.position
	add_child(weapon)
	weapon.owner = self
	mining_equipment.position = equipment_angle_point.position
	add_child(mining_equipment)
	mining_equipment.owner = self
	mining_equipment.visible = false
	
	current_equipment = weapon


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	input_component.update(self, delta)
	# Animate
	if self.direction.length() > 0:
		$AnimationPlayer.play("walk")
	elif $AnimationPlayer.is_playing():
		$AnimationPlayer.stop(false)
	current_equipment.update(self)


func change_equipment(equipment) -> void:
	current_equipment.visible = false
	current_equipment = equipment
	current_equipment.visible = true


func use_equipment(delta: float) -> void:
	current_equipment.act(self, delta)
