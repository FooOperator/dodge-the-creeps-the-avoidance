extends ColorRect

@export var game_over_color: Color
@export var nextGradientPointTimer: Timer
@export var next_gradient_point_lerp_time: float = 0.5
@export var gameplay_gradients: Array[Gradient]

var gameplay_gradient: Gradient
var should_iterate_gradient: bool
var gradient_size: int
var current_gradient_index: int
var lerp_step: float


func _process(delta: float):
	if should_iterate_gradient:
		lerp_step = next_gradient_point_lerp_time * delta
		var offset = gameplay_gradient.get_offset(current_gradient_index)
		color = lerp(color, gameplay_gradient.sample(offset), lerp_step)


func _on_main_game_over():
	color = game_over_color


func _on_main_game_started():
	gameplay_gradient = gameplay_gradients.pick_random()
	gradient_size = gameplay_gradient.colors.size()
	current_gradient_index = 0
	color = gameplay_gradient.get_color(0)


func _on_mob_spawner_started_spawning():
	should_iterate_gradient = true
	nextGradientPointTimer.start()


func _on_mob_spawner_stopped_spawning():
	should_iterate_gradient = false
	nextGradientPointTimer.stop()


func _on_next_gradient_point_timer_timeout():
	current_gradient_index = wrapi(current_gradient_index + 1, 0, gradient_size)
