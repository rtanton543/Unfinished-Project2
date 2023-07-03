extends Control


@onready var health_text = $HBoxContainer/HealthText
@onready var ram_text = $HBoxContainer/RamText
@onready var player = $"../.."
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_text.text = "Health: " + str(player.curr_health)
	pass
