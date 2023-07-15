extends ColorRect


var materials = [
	preload("res://resources/particles/DashEffect.tres"),
	preload("res://resources/particles/biome1/SpiderBossHit.tres"),
	preload("res://resources/particles/biome1/SpiderBossLegLeft.tres"),
	preload("res://resources/particles/biome1/SpiderBossLegRight.tres"),
	preload("res://resources/particles/biome1/SpiderBossStomp.tres"),
	preload("res://resources/particles/biome1/SpiderHit.tres"),
	preload("res://resources/particles/biome1/WormHit.tres")
]

func _ready():
	for part_material in materials:
		var particles_instance = GPUParticles2D.new()
		particles_instance.process_material = material
		particles_instance.one_shot = true
		#particles_instance.modulate = Color(1,1,1,0)
		particles_instance.texture = load("res://asset/visual/other/dust.png")
		self.add_child(particles_instance)
		particles_instance.emitting = true
