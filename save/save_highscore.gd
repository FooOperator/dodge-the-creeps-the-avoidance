extends Resource
class_name SaveHighscore
@export var score := 0
const SAVE_GAME_PATH := "user://highscore.tres"


func save_highscore() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)


static func load_highscore() -> SaveHighscore:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null
