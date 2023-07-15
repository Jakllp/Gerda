extends Control

@onready var title_1 = $VBoxContainer/Mutator1/PanelContainer/Title
@onready var description_1 = $VBoxContainer/Mutator1/PanelContainer/Description
@onready var tex_1 = $VBoxContainer/Mutator1/Tex
@onready var title_2 = $VBoxContainer/Mutator2/PanelContainer/Title
@onready var description_2 = $VBoxContainer/Mutator2/PanelContainer/Description
@onready var tex_2 = $VBoxContainer/Mutator2/Tex
@onready var title_3 = $VBoxContainer/Mutator3/PanelContainer/Title
@onready var description_3 = $VBoxContainer/Mutator3/PanelContainer/Description
@onready var tex_3 = $VBoxContainer/Mutator3/Tex

var available_mutators

signal mutator_selected(mutator: Mutator)

func _ready():
	available_mutators = MutatorManager.get_random_mutators(3)
	var mutator_1 = available_mutators[0]
	var mutator_2 = available_mutators[1]
	var mutator_3 = available_mutators[2]
	
	title_1.text = mutator_1.title
	description_1.text = mutator_1.description
	tex_1.texture.region = Rect2(mutator_1.texture,Vector2(11, 9))
	
	title_2.text = mutator_2.title
	description_2.text = mutator_2.description
	tex_2.texture.region = Rect2(mutator_2.texture,Vector2(11, 9))
	
	title_3.text = mutator_3.title
	description_3.text = mutator_3.description
	tex_3.texture.region = Rect2(mutator_3.texture,Vector2(11, 9))


func _on_mutator_pressed(id):
	MutatorManager.add_mutator(available_mutators[id])
	mutator_selected.emit(available_mutators[id])
	
