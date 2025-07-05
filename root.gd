extends Node

var is_singleplayer := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainMenuStuff/PlayersJoined.visible = false
	$MainMenuStuff/ButtonContainer/Start.pressed.connect(GameManager.load_game.rpc)
	$MainMenuStuff/ButtonContainer/Host.pressed.connect(NetworkManager.create_game)
	$MainMenuStuff/ButtonContainer/Join.pressed.connect(NetworkManager.join_game)
	
	$"MainMenuStuff/ButtonContainer/Quit".pressed.connect(get_tree().quit)
	$MainMenuStuff/ButtonContainer/Start.grab_focus()  # for keyboard/controller use
	
	NetworkManager.player_connected.connect(_on_player_connected)
	NetworkManager.player_disconnected.connect(_on_player_disconnected)

func _on_player_connected(pid, info):
	$MainMenuStuff/PlayersJoined.text = "Players in Lobby: %s" %NetworkManager.players.size()
	$MainMenuStuff/PlayersJoined.visible = true
		
func _on_player_disconnected(pid):
	$MainMenuStuff/PlayersJoined.text = "Players in Lobby: %s" %NetworkManager.players.size()

#func start_game() -> void:
	#get_tree().change_scene_to_file("res://root.tscn")
#
#func exit() -> void:
	#get_tree().quit()
