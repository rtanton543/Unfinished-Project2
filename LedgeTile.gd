extends Sprite2D

signal ledge_area_entered
var grabable = true;
@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		timer.start(2)
		if grabable == true:
			body.Grab_ledge($HangPoint.global_position);
			grabable = false;
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		timer.start(1)
	pass # Replace with function body.


func _on_timer_timeout():
	grabable = true;
	pass # Replace with function body.
