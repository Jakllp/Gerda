extends Camera2D

## Strength of the camera offset
@export var SHAKE_STRENGTH: float = 20.0
## Multiplier for lerping the shake strength to zero
@export var SHAKE_DECAY_RATE: float = 0.2
## Time in seconds how long the shake will last
@export var SHAKE_DURATION: float = 3.0
## How quickly to move through the noise
@export var NOISE_SHAKE_SPEED: float = 60.0

var is_shaking = false
var _decay: float = 0.0
var _shake_strength: float = 0.0
# Used to keep track of where we are in the noise
# so that we can smoothly move through it
var noise_i: float = 0.0

enum ShakeType {
	RANDOM,
	NOISY,
}
var shake_type: ShakeType = ShakeType.NOISY

@onready var noise = FastNoiseLite.new()
@onready var rand = RandomNumberGenerator.new()

signal shake_finished

func _ready() -> void:
	rand.randomize()
	
	# Randomize the generated noise
	noise.seed = rand.randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	

func _process(delta: float) -> void:
	if not is_shaking:
		return
	if is_shaking and _shake_strength <= 0.05:
		stop_shake()
	
	# Fade out the intensity over time
	_decay += SHAKE_DECAY_RATE * delta
	_shake_strength = max(0, lerp(SHAKE_STRENGTH, 0.0, _decay))
	
	match shake_type:
		ShakeType.RANDOM:
			offset = get_random_offset()
		ShakeType.NOISY:
			offset = get_noise_offset(delta)
	

func apply_random_screen_shake(strength: float = SHAKE_STRENGTH, decay_rate: float = SHAKE_DECAY_RATE, duration: float = SHAKE_DURATION) -> void:
	shake_type = ShakeType.RANDOM
	SHAKE_STRENGTH = strength
	_shake_strength = strength
	SHAKE_DECAY_RATE = decay_rate
	_decay = 0
	is_shaking = true
	get_tree().create_timer(duration, false).timeout.connect(shake_over)
	

func apply_noise_screen_shake(strength: float = SHAKE_STRENGTH, decay_rate: float = SHAKE_DECAY_RATE, duration: float = SHAKE_DURATION, speed: float = NOISE_SHAKE_SPEED) -> void:
	shake_type = ShakeType.NOISY
	SHAKE_STRENGTH = strength
	_shake_strength = strength
	SHAKE_DECAY_RATE = decay_rate
	_decay = 0
	NOISE_SHAKE_SPEED = speed
	is_shaking = true
	get_tree().create_timer(duration, false).timeout.connect(shake_over)
	

func shake_over() -> void:
	shake_finished.emit()
	stop_shake()

func stop_shake() -> void:
	is_shaking = false
	offset = Vector2.ZERO
	_decay = 1
	_shake_strength = 0
	noise_i = 0
	

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * NOISE_SHAKE_SPEED
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * _shake_strength,
		noise.get_noise_2d(100, noise_i) * _shake_strength
	)
	

func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-_shake_strength, _shake_strength),
		rand.randf_range(-_shake_strength, _shake_strength)
	)
