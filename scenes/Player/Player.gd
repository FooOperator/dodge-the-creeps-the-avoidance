extends Area2D
class_name Player
signal hit
@export var speed: float = 400
@export var collider: CollisionShape2D
@export var animatedSprite: AnimatedSprite2D
@export var deathSoundStream: AudioStreamPlayer2D
@export var start_hidden: bool = true
var screen_size: Vector2
var invulnerable: bool


func _ready():
	if start_hidden:
		hide()
	screen_size = get_viewport_rect().size


func _process(delta):
	var input_vector = get_input_vector()
	if Input.is_action_just_pressed("invulnerability_toggle"):
		invulnerable = !invulnerable
	handle_movement(input_vector, delta)
	handle_animation(input_vector)


func get_input_vector() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()


func handle_movement(input_vector: Vector2, delta: float):
	var velocity = input_vector * speed * delta
	position += velocity
	position = position.clamp(Vector2.ZERO, screen_size)


func handle_animation(velocity: Vector2):
	if velocity.length() > 0:
		handle_orientation(velocity)
		if velocity.x != 0 or velocity.y == 0:
			animatedSprite.animation = "walk"
		elif velocity.x == 0 or velocity.y != 0:
			animatedSprite.animation = "up"
		animatedSprite.play()
	else:
		animatedSprite.stop()


func handle_orientation(velocity: Vector2):
	if velocity.x != 0:
		scale.x = round(velocity.x)
	if velocity.y != 0:
		scale.y = round(-velocity.y)


func _on_body_entered(_body: Node2D):
	if invulnerable:
		return
	hide()
	hit.emit()
	deathSoundStream.play()
	collider.set_deferred("disabled", true)


func start(newPosition: Vector2 = Vector2(screen_size.x / 2, screen_size.y / 2)):
	position = newPosition
	show()
	collider.disabled = false
