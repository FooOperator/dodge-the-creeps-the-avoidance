extends RigidBody2D
class_name Mob
@export var animatedSprite: AnimatedSprite2D
@export var min_speed: float = 100
@export var max_speed: float = 400
@export var game_over_speed_multiplier: float = 3.3


func _ready():
	var mob_types = animatedSprite.sprite_frames.get_animation_names()
	animatedSprite.play(mob_types[randi() % mob_types.size()])


func initialize(mob_spawn_location: PathFollow2D):
	mob_spawn_location.progress_ratio = randf()
	var direction = mob_spawn_location.rotation + PI / 2
	position = mob_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	rotation = direction
	var random_speed = randf_range(min_speed, max_speed)
	var velocity = Vector2(random_speed, 0.0)
	linear_velocity = velocity.rotated(direction)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_main_game_over():
	linear_velocity *= game_over_speed_multiplier
