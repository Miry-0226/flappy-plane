extends CanvasLayer

signal start_game

@onready var plane = $PlaneSprite

func _ready():
	self.show()
	plane.play()

func _on_button_pressed():
	self.hide()
	plane.stop()
	start_game.emit()
	
