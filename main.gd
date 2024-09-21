extends Node

@export var fish_scene : PackedScene
const NUM_FISH = 2
const MAX_FPS = 60
var score = 0
var sync_time = false

func new_game():
	score = 0
	$HUD.get_node("Labels/Countdown").set_text("60")
	$HUD.get_node("Labels/Score").set_text(str(score))
	$BkgMusic.play()
	$StartTimer.start()	
	$HUD.show_message("Catch fish, avoid holes, and left-click for speed.")
	$HUD/MessageTimer.start()

func game_over():
	$HUD/MessageTimer.stop()
	SilentWolf.Scores.save_score("gloria_test", score)
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	print("Scores: " + str(sw_result.scores))
	sync_time = false
	$ScoreTimer.stop()
	$GameOver.play()
	$HUD.show_game_over()
	$BkgMusic.stop()
	$Player.hide()
	get_tree().call_group("fish_all", "queue_free")
		
func _on_start_timer_timeout():
	$ScoreTimer.start()
	sync_time = true
	$Player.start($StartPosition.position)
	$Player/CollisionShape2D.disabled = false
	
func _spawn_fish():
	var fish = fish_scene.instantiate()
	var hole_pair = $placement._pick_random_hole_pair()
	fish.set_coords(hole_pair[0], hole_pair[1])
	fish.fish_gone.connect(_on_fish_gone)
	fish.fish_eaten.connect(_on_fish_eaten)
	add_child(fish)
	
func _on_fish_gone():
	_spawn_fish()
	
func _on_fish_eaten():
	$EatFish.play()
	score += 1
	$HUD/Labels/Score.set_text(str(score))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.max_fps = MAX_FPS
	$Player.hide()
	SilentWolf.configure({
	"api_key": "XUfvXwKMEA4znrGaOV2tV5ea6Lfpw3V58k4GjT4V",
	"game_id": "Waddell",
	"game_version": "1.0.2",
	"log_level": 1
	})

	SilentWolf.configure_scores({
	"open_scene_on_close": "res://scenes/MainPage.tscn"
	})
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if sync_time:
		$HUD.get_node("Labels/Countdown").set_text(str(int($ScoreTimer.get_time_left())))
		
func _on_score_timer_timeout() -> void:
	game_over()
