extends Node2D


# Called when the node enters the scene tree for the first time.

@export var next_level: String

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		FadeTransition.transition(next_level);
	pass # Replace with function body.
