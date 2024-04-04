extends Node2D

@export var rock_scene : PackedScene

@onready var player = $Player
@onready var ground = $Ground 
@onready var rock_timer = $RockTimer
@onready var score_label = $Score
@onready var game_over_menu = $GameOver
@onready var high_score_label = $GameOver/HighScore
@onready var medal = $GameOver/Medal

const SCROLL_SPEED : int = 4
const ROCK_DELAY : int = 100
const ROCK_RANGE : int = 80

var game_running : bool
var game_over : bool
var scroll
var score
var screen_size : Vector2i
var ground_height : int 
var ground_width : int 
var rocks : Array
var high_score: int

var bronze = load("res://assets/UI/medalBronze.png")
var silver = load("res://assets/UI/medalSilver.png")
var gold = load("res://assets/UI/medalGold.png")

# Set game
func _ready():
	screen_size = get_window().size
	
	ground_height = ground.get_node("GroundIce").texture.get_height()
	ground_width = ground.get_node("GroundIce").texture.get_width()

	high_score = 0
	medal.hide()
	game_over_menu.hide()
	new_game()

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	score_label.text = "Score: " + str(score)
	
	get_tree().call_group("rocks", "queue_free")
	rocks.clear()
	player.reset()
	generate_rocks()

func _input(event):
	if(!game_over):
		if event is InputEventMouseButton:
			if Input.is_action_pressed("Click"):
				if(!game_running):
					start_game()
				elif player.flying:
					player.fly_up()
					check_top()

func start_game():
	game_running = true
	player.flying = true
	
	player.fly_up()
	rock_timer.start()

func _process(_delta):
	if game_running:
		scroll += SCROLL_SPEED
		
		if scroll >= ground_width:
			scroll = 0
		ground.position.x = -scroll
		
		for rock in rocks:
			rock.position.x -= SCROLL_SPEED
			
			#Deletes rock if it's outside of the screen
			if rock.position.x <= -80:
				rocks.erase(rock)
				rock.queue_free()

func _on_rock_timer_timeout():
	generate_rocks()

func generate_rocks():
	var rock = rock_scene.instantiate()	
	
	rock.position.x = screen_size.x + ROCK_DELAY
	rock.position.y = (screen_size.y - ground_height)/2 + randi_range(-ROCK_RANGE, ROCK_RANGE)
	
	rock.hit.connect(player_hit)
	rock.scored.connect(player_scored)
	
	add_child(rock)
	rocks.append(rock)

func player_scored():
	score += 1
	score_label.text = "Score: " + str(score)
	
	if score >= high_score:
		high_score = score
		

func check_top():
	if player.position.y < 0:
		player.falling = true
		stop_game()

func stop_game():
	rock_timer.stop()
	
	high_score_label.text = "High Score: " + str(high_score)
	
	if score >= 20:
		medal.show()
		medal.texture = bronze
		if score >= 40:
			medal.texture = silver
			if score >= 80:
				medal.texture = gold
	else:
		medal.hide()
		
	game_over_menu.show()
	
	player.flying = false
	game_running = false
	game_over = true

func player_hit():
	player.falling = true
	stop_game()

func _on_ground_hit():
	player.falling = false
	stop_game()
