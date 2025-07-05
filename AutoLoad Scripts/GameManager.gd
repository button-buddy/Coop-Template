extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# When the server decides to start the game from a UI scene,
# do GameManager.load_game.rpc()
@rpc("any_peer", "call_local", "reliable")
func load_game(game_scene_path = "res://game.tscn"):
	get_tree().change_scene_to_file(game_scene_path)
