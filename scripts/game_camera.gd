extends Camera2D

var target_position: Vector2 = Vector2.ZERO

@export var background_color: Color
@export var shake_noise: FastNoiseLite

"""var x_noise_sample: Vector2 = Vector2.RIGHT
var y_noise_sample: Vector2 = Vector2.DOWN
var x_noise_sample_position: Vector2 = Vector2.ZERO
var y_noise_sample_position: Vector2 = Vector2.ZERO

var NOISE_SAMPLE_TRAVEL_RATE: int = 5
const MAX_SHAKE_OFFSET: int = 6
var current_shake_percentage: int = 0
var shake_decay: int = 4"""

func _ready():
	RenderingServer.set_default_clear_color(background_color)

func _process(delta):
	acquire_target_position()
	
	global_position = lerp(target_position, global_position, pow(2, -10 * delta))
	
	"""if (Input.is_action_just_pressed("jump")):
		apply_shake(1)
	
	if current_shake_percentage > 0:
		x_noise_sample_position += x_noise_sample * NOISE_SAMPLE_TRAVEL_RATE * delta
		y_noise_sample_position += y_noise_sample * NOISE_SAMPLE_TRAVEL_RATE * delta
		
		var x_sample = shake_noise.get_noise_2d(x_noise_sample_position.x, x_noise_sample_position.y)
		var y_sample = shake_noise.get_noise_2d(y_noise_sample_position.x, y_noise_sample_position.y)
		
		var calculated_offset = Vector2(x_sample, y_sample) * MAX_SHAKE_OFFSET * current_shake_percentage
		offset = calculated_offset
		
		current_shake_percentage = clamp(current_shake_percentage - shake_decay * delta, 0, 1)
	"""
	


"""func apply_shake(percentage: int):
	current_shake_percentage = clamp(current_shake_percentage + percentage, 0, 1)"""


func acquire_target_position():
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player: CharacterBody2D = players[0] as CharacterBody2D
		target_position = player.global_position
	
