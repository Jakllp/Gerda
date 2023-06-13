extends Node

class_name PerlinHelper

const frequency := 0.1
const octaves  := 4
const lacunarity := 0.25
const gain := 0.5


static func generate_heightmap() -> FastNoiseLite:
	var heightmap := FastNoiseLite.new()
	heightmap.noise_type = FastNoiseLite.TYPE_PERLIN
	heightmap.fractal_type = FastNoiseLite.FRACTAL_FBM
	
	heightmap.seed = randi_range(0,192928342)
	
	heightmap.frequency = frequency
	heightmap.fractal_lacunarity = lacunarity
	heightmap.fractal_gain = gain
	
	return heightmap
