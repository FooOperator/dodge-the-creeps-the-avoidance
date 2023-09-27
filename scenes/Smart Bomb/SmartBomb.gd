extends Area2D
class_name SmartBomb
signal detonated

@export var animatedSprite: AnimatedSprite2D
@export var explosionStream: AudioStreamPlayer2D

var detonating: bool


func _ready():
	animatedSprite.play()


func _on_area_entered(area: Area2D):
	if area.is_in_group("player") and not detonating:
		player_entered_me()


func player_entered_me():
	detonating = true
	animatedSprite.hide()
	var mobs_in_scene = get_tree().get_nodes_in_group("mobs")
	for mob in mobs_in_scene:
		mob.queue_free()
	detonated.emit(mobs_in_scene.size())
	explosionStream.play()
	await explosionStream.finished
	queue_free()
