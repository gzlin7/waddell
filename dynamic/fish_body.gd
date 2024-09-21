extends Area2D

@onready var parent = get_parent() as PathFollow2D
const FISH_SPEED = 4.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("flop")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if parent.progress_ratio == 1.0:
		parent.get_parent().get_parent().handle_fish_gone()
		queue_free()
	else:
		parent.set_progress(parent.get_progress() + FISH_SPEED)
