extends Node

@export var hole_scene: PackedScene
@export var walrus_scene: PackedScene
@onready var hole_loc_array : Array[Vector2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	randomize()
	
	hole_loc_array.assign($holes.points)
	for point in $holes.points:
		var hole = hole_scene.instantiate()
		hole.position = point
		add_child(hole)
		
	for point in $walruses.points:
		var walrus = walrus_scene.instantiate()
		walrus.position = point
		add_child(walrus)
		
	$holes.hide()
	$walruses.hide()
	
func _pick_random_hole_pair() -> Array[Vector2]:
	hole_loc_array.shuffle()
	return hole_loc_array.slice(0,2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
