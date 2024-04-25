extends Node

enum Powerup {
	BOMB, MAGNET, SHIELD
}

var music_is_on: bool = true
var save_data: SaveData

func _ready():
	save_data = SaveData.load_or_create()
