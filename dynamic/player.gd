extends CharacterBody2D

signal signal_alive
signal signal_dead

const SPEED = 300.0
const RUNNING_MULTIPLIER = 1.3
# Tolerance coeff when determining whether mouse is inside/outside of player
const INSIDE_PLAYER_TOLERANCE = 0.01
const OUTSIDE_PLAYER_TOLERANCE = 1.2
var mouse_position = null
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _player_radius = $CollisionShape2D.shape.radius
var is_alive = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func _physics_process(delta: float) -> void:
	"""
	Player faces and moves towards the mouse. Runs if left mouse is clicked.
	"""
	# Do not handle physics when not alive
	if not is_alive:
		return
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D and $BounceTimer.time_left == 0:
			c.get_collider().wake_up()
			velocity = velocity.bounce(c.get_normal()) 
			velocity = velocity.normalized() * 800.0
			$BounceTimer.start()
					
	mouse_position = get_global_mouse_position()
	var distance_from_mouse = (position - mouse_position).length()
	
	rotate(get_angle_to(mouse_position))
	

	# Don't move when character is already at mouse
	if distance_from_mouse > INSIDE_PLAYER_TOLERANCE * _player_radius:
		# Rotate only when mouse is outside of character to prevent jerkiness
		if distance_from_mouse > OUTSIDE_PLAYER_TOLERANCE * _player_radius:
			rotate(get_angle_to(mouse_position))
		var direction = (mouse_position - position).normalized() 
		var running = RUNNING_MULTIPLIER if Input.is_action_pressed("run") else 1.0
		#velocity = direction * SPEED * running
		velocity = 0.93 * velocity + 0.11 * direction * SPEED * running
	else:
		velocity = Vector2(0.0,0.0)
			

func set_to_dead():
	is_alive = false
	signal_dead.emit()
	velocity = Vector2(0.0, 0.0)
	$CollisionShape2D.disabled = true
	hide()

			
func _process(_delta):
	if velocity.length() > 0:
		_animated_sprite.play("walk")
	else:
		_animated_sprite.stop()
	move_and_slide()
	
func start(pos):
	is_alive = true
	position = pos
	velocity = Vector2(0.0, 0.0)
	show()
