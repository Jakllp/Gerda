extends Node2D

@onready var line := $Line2D
@onready var enemy := $Spider

func _ready() -> void:
	line.width = 3


func _physics_process(delta: float) -> void:
	line.points = enemy.path
