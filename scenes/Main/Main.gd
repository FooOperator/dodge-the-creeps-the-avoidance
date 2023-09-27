extends Node
class_name GameLoopController
signal score_changed(score: int)
signal highscore_loaded(old_highscore: SaveHighscore)
signal game_started
signal game_over

@export var playerScene: Player
@export var musicLoopStream: AudioStreamPlayer2D
@export var startTimer: Timer
@export var scoreTimer: Timer
@export var playerStart: Marker2D
@export var score_per_kill: int = 1

var score: int
var highscore: SaveHighscore


func _ready():
	highscore = load_save()
	if not highscore:
		highscore = SaveHighscore.new()
	else:
		highscore_loaded.emit(highscore)


func load_save():
	var loaded_highscore = SaveHighscore.load_highscore()
	return loaded_highscore


func new_game():
	update_score(0)
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("smart_bombs", "queue_free")
	playerScene.start(playerStart.position)
	game_started.emit()
	musicLoopStream.play()
	startTimer.start()


func update_score(new_score: int):
	score = new_score
	score_changed.emit(score)


func _on_score_timer_timeout():
	update_score(score + 1)


func _on_start_timer_timeout():
	scoreTimer.start()


func _on_player_hit():
	scoreTimer.stop()
	musicLoopStream.stop()
	if score > highscore.score:
		highscore.score = score
		highscore.save_highscore()
		highscore_loaded.emit(highscore)
	game_over.emit()


func _on_smart_bomb_detonated(amount_killed: int):
	score += amount_killed * score_per_kill
	update_score(score)
