extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Waddell.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	$Waddell.show()
	if body.name == "Player":
		body.set_to_dead()
	await get_tree().create_timer(1).timeout
	$Waddell.hide()
	
