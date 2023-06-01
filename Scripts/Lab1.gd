extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_first_node_in_group("Player").set_camera_limits($TileMap);
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
