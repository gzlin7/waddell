extends RigidBody2D

@onready var curr_sprite = $SleepSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AwakeSprite.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _toggle_sprite() -> void:
	curr_sprite.hide()
	curr_sprite = $AwakeSprite if curr_sprite == $SleepSprite else $SleepSprite
	curr_sprite.show()

func wake_up() -> void:
	_toggle_sprite()
	$Bark.play()
	await get_tree().create_timer(0.2).timeout
	_toggle_sprite()
