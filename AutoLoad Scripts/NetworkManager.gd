extends Node

# Autoload named Network Manager

# These signals can be connected to by a UI lobby scene or the game scene.
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT = 36666
const DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost, replace with server
const MAX_CONNECTIONS = 5

# This will contain player info for every player,
# with the keys being each player's unique IDs.
var players = {}

var connection_type := "player"

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	if OS.has_feature("dedicated_server"):
		connection_type = "dedicated"
		create_game()


func join_game(address = ""):
	print("Joining")
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		print("Couldnt join")
		return error
	multiplayer.multiplayer_peer = peer
	
	


func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

	players[1] = connection_type
	player_connected.emit(1, connection_type)


#func remove_multiplayer_peer():
	#multiplayer.multiplayer_peer = null
	#players.clear()

# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(id):
	_register_player.rpc_id(id, connection_type)


@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)


func _on_player_disconnected(id):
	print("Player ", id, " Left")
	players.erase(id)
	player_disconnected.emit(id)


func _on_connected_ok():
	print("Connected")
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = connection_type
	player_connected.emit(peer_id, connection_type)


func _on_connected_fail():
	print("Couldn't Join")
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()


func _on_server_disconnected():
	print("Server Disconnected")
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()
	server_disconnected.emit()
