extends Object

class_name PerlinHelper


static func generate_heightmap(frequency :float, octaves :int, lacunarity :float, gain :float) -> FastNoiseLite:
	var heightmap := FastNoiseLite.new()
	heightmap.noise_type = FastNoiseLite.TYPE_PERLIN
	heightmap.fractal_type = FastNoiseLite.FRACTAL_FBM
	
	heightmap.seed = randi()
	
	heightmap.frequency = frequency
	heightmap.fractal_lacunarity = lacunarity
	heightmap.fractal_gain = gain
	
	return heightmap
