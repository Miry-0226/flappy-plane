extends Node

signal hit
signal scored

@onready var top_rock = $RockTop
@onready var bottom_rock = $RockBottom

const ROCK_RANGE : int = 50

func _ready():
	top_rock.position.y += randi_range(-ROCK_RANGE, 0)
	bottom_rock.position.y += randi_range(0, ROCK_RANGE)
	
func _on_body_entered(_body):
	hit.emit()

func _on_score_area_body_entered(_body):
	scored.emit() 
