extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var collisionBox = $CollisionShape2D
@onready var camera = $Camera2D

func _ready():
	pass;

func set_camera_limits(tile_map: TileMap):
	var map_limits = tile_map.get_used_rect();
	var map_cellsize = tile_map.cell_quadrant_size
	print(map_limits.position.x);
	camera.limit_left = map_limits.position.x * map_cellsize*2;
	camera.limit_top = map_limits.position.y * map_cellsize*2;
	camera.limit_right = map_limits.end.x * map_cellsize*2;
	camera.limit_bottom = map_limits.end.y * map_cellsize*2;

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	
	if Input.is_action_pressed("Right"):
		sprite.flip_h = false;
		collisionBox.position.x = -5;
		$CollisionCrouch.position.x = -12;
		
	if Input.is_action_pressed("Left"):
		sprite.flip_h = true;
		collisionBox.position.x = 5;
		$CollisionCrouch.position.x = 12;
	
	if Input.is_action_pressed("Down"):
		anim.play("CrouchIdle");
		collisionBox.disabled = true;
		$CollisionCrouch.disabled = false;
	else:
		collisionBox.disabled = false;
		$CollisionCrouch.disabled = true;
	
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0 and not Input.is_action_pressed("Down"):
			anim.play("Idle")
	
	if velocity.y > 0:
		anim.play("Fall")

	move_and_slide()
