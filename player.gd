extends CharacterBody2D


@export var speed = 400.0

var syncPos := Vector2(0.0, 0.0)

func _enter_tree():
	# Doing this here instead of on ready prevents bugs.
	set_multiplayer_authority(int(str(name)))

func _ready() -> void:	
	syncPos = global_position
	
	$"Player ID".text = name
	GameManager.player_info[int(name)] = {"spawnpoint":syncPos, "node":self}

func _physics_process(_delta: float) -> void:
	
	if not is_multiplayer_authority():
		# Making it 30fps (save bandwidth) and lerping with local fps to hide the stutter
		position = lerp(position, syncPos, 0.5)
		return
	
	velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("right_1"):
		velocity.x += 1
	if Input.is_action_pressed("left_1"):
		velocity.x -= 1
	if Input.is_action_pressed("down_1"):
		velocity.y += 1
	if Input.is_action_pressed("up_1"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	syncPos = global_position
	move_and_slide()
