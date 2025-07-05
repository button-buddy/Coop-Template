extends Node

@onready var spawner: Node = $Spawner
@onready var players: Node = $Players

@export var player_scene:PackedScene
@onready var player_spawner: MultiplayerSpawner = $Players/PlayerSpawner

var is_dedicated = false

func _ready() -> void:
	if NetworkManager.players.is_empty():
		# singleplayer situation
		NetworkManager.players = {1: NetworkManager.connection_type}
		pass
	
	for i in NetworkManager.players:
		if NetworkManager.players[i] == "dedicated":
			is_dedicated = true
			print("Running on Dedicated Server")
	
	# everyone needs to know this
	player_spawner.spawn_function = spawn_player
	if multiplayer.is_server():
		spawn_all_players()


func spawn_all_players():
	var spawnpoints := spawner.get_children()
	var pid_array := NetworkManager.players.keys()
	
	if is_dedicated:
		pid_array.erase(1)
		# Removes dedicated server as a player
	pid_array.sort()  
	# this makes sure that the spawnpoints are in order. Not needed, just debug
	
	for i in pid_array.size():
		var pid = pid_array[i]
		var spawnpoint = spawnpoints[i].global_position
		
		player_spawner.spawn([pid, spawnpoint])
		
	
	
func spawn_player(data):
	var player = player_scene.instantiate()
	var pid = data[0]
	var spawnpoint = data[1]
	player.position = spawnpoint
	player.name = str(pid)
	
	
	return player
