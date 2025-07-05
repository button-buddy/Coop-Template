extends Node

@onready var spawner: Node = $Spawner
@export var player_scene:PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_all_players(NetworkManager.players)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_all_players(player_dict: Dictionary):
	
	if player_dict.is_empty():
		# singleplayer
		player_dict = {1:"host"}
		pass
	
	var spawnpoints := spawner.get_children()
	var pid_array := player_dict.keys()

	pid_array.sort()  
	# this makes sure that the spawnpoints are same for all clients
	
	for i in pid_array.size():
		var player = player_scene.instantiate()
		player.position = spawnpoints[i].global_position
		player.name = str(pid_array[i])
		player.set_multiplayer_authority(pid_array[i])
		add_child(player)
		i+=1
	
