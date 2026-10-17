extends Node

var body_part_database: BodyPartsDatabase = BodyPartsDatabase.new()
var game_state: GameState
var current_item: Item
var unlocked_items: Array[Item]

enum GameState {
	MAIN_MENU,
	WORKSHOP,
}
