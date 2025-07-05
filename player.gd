extends CharacterBody2D


@export var speed = 400.0
@onready var player_id: Label = $"Player ID"

#func _enter_tree():
	#set_multiplayer_authority(int(str(name)))

func _ready() -> void:
	player_id.text = name

func _physics_process(_delta: float) -> void:
	
	if not is_multiplayer_authority():
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

	
	move_and_slide()
