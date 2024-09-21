extends Node

const MAX_WIGGLE_PROP = 0.2
const MIN_WIGGLE_MAG = 50
const MAX_WIGGLE_MAG = 150
const LEN_PER_WIGGLE = 200

signal fish_gone
signal fish_eaten

func set_coords(begin: Vector2, end: Vector2) -> void:
	"""Pass in begin/end and handle adding noise and avoidance in between."""
	var slope = (end[1] - begin[1]) / (end[0] - begin[0])
	var intercept = end[1] - slope * end[0]
	var normal_slope = -1 / slope
	var len = begin.distance_to(end)
	var coords = [begin, end]
	
	# Add perturbation wiggle woggle
	var wiggle_y
	var direction = 1
	var rand_xs = [] 
	for i in range(1 + int(len/LEN_PER_WIGGLE)):
		rand_xs.append(randf_range(begin[0], end[0]))
	rand_xs.sort()
	for rand_x in rand_xs:
		wiggle_y = slope * rand_x + intercept
		wiggle_y += direction * normal_slope * clamp(randf() * MAX_WIGGLE_PROP * len, MIN_WIGGLE_MAG, MAX_WIGGLE_MAG) 
		coords.append(Vector2(rand_x,clamp(wiggle_y, 60, 720)))
		direction *= -1
		
	coords.sort()
	# Create new curve since by default instances share the same curve
	# https://forum.godotengine.org/t/why-do-path2d-extending-scenes-share-curve-instances/28636/2
	var new_curve = Curve2D.new()
	for c in coords:
		new_curve.add_point(c)
	$Path2D.curve = new_curve
	
func handle_fish_gone():
	fish_gone.emit()
	queue_free()
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_fish_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		fish_eaten.emit()
		handle_fish_gone()
		
