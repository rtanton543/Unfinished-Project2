extends CanvasLayer


# Called when the node enters the scene tree for the first time.
@onready var anim = $ColorRect/AnimationPlayer;
var next_level

func _ready():
	anim.play_backwards("Fade");


func transition(next_scene: String) -> void:
	if (next_scene == "Main"):
		next_level = "res://Scenes/Main.tscn";
	
	if(next_scene == "Lab1"):
		next_level = "res://Scenes/Lab1.tscn"
	
	anim.play("Fade");
	await anim.animation_finished
	get_tree().change_scene_to_file(next_level)
	anim.play_backwards("Fade")
