extends CanvasLayer
signal start_button_pressed
@export_group("Game Start")
@export var dodgeTheCreepsLabel: Label
@export var startButton: Button
@export_group("Gameplay")
@export var getReadyLabel: Label
@export var scoreLabel: Label
@export_group("Game Over")
@export var gameOverLabel: Label
@export var highscoreLabel: Label

var highscore: SaveHighscore


func _on_start_button_pressed():
	dodgeTheCreepsLabel.hide()
	startButton.hide()
	gameOverLabel.hide()
	getReadyLabel.show()
	highscoreLabel.hide()
	scoreLabel.show()
	start_button_pressed.emit()


func update_score(score: int):
	scoreLabel.text = str(score)


func _on_mob_spawner_started_spawning():
	getReadyLabel.hide()


func _on_mob_spawner_stopped_spawning():
	gameOverLabel.show()
	startButton.show()
	if highscore.score > 0:
		highscoreLabel.show()


func _on_game_loop_highscore_loaded(loaded_highscore: SaveHighscore):
	highscore = loaded_highscore
	highscoreLabel.text = "Best Score: %s" % highscore.score
	highscoreLabel.show()
