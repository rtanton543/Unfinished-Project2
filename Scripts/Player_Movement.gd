extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const CRAWL_SPEED = 150.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var collisionBox = $CollisionShape2D
@onready var camera = $Camera2D
@onready var animtree : AnimationTree = $AnimationTree;

@export var on_ledge = false;

var direction;
var max_health = 99;
var curr_health = max_health;
var crawling = false;
var attacking = false;

func _ready():
	animtree.active = true;
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
	if is_on_floor():
		on_ledge = false;
	# Add the gravity.
	if not is_on_floor() and on_ledge == false:
		velocity.y += gravity * delta
	else:
		velocity.y == 0;
		
	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		on_ledge = false;
		velocity.y = JUMP_VELOCITY
		Jump();
	
	if Input.is_action_just_pressed("Jump") and on_ledge == true:
		on_ledge = false
		velocity.y = JUMP_VELOCITY
		Jump();

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("Left", "Right")
	
	if Input.is_action_pressed("Right") and on_ledge == false:
		sprite.flip_h = false;
		collisionBox.position.x = -5;
		$CollisionCrouch.position.x = -12;
		$CollisionHang.position.x = -13;
		$CollisionAttack.position.x = 25
		
	if Input.is_action_pressed("Left") and on_ledge == false:
		sprite.flip_h = true;
		collisionBox.position.x = 5;
		$CollisionCrouch.position.x = 12;
		$CollisionHang.position.x = 13;
		$CollisionAttack.position.x = -25
	
	if Input.is_action_pressed("Down") and is_on_floor():
		if direction:
			Crawl()
		else:
			Crouch()
			
	
	if direction:
		if on_ledge == false:
			if crawling == true:
				velocity.x = direction * CRAWL_SPEED;
			elif attacking == true:
				velocity.x = 0;
			else:
				velocity.x = direction * SPEED;
		if velocity.y == 0 and on_ledge == false:
			if Input.is_action_pressed("Down"):
				Crawl();
			elif Input.is_action_pressed("Attack"):
				Attack();
			else:
				Run();
			
		else:
			Jump();
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			if on_ledge == true:
				Ledge_hang();
			elif Input.is_action_pressed("Down"):
				Crouch();
			elif Input.is_action_pressed("Attack"):
				Attack();
			else:
				Idle();

	animtree.set("parameters/Jump_Fall/blend_position", velocity.y)
	animtree.set("parameters/Run_Jump/blend_position", velocity.y)

	move_and_slide()


func Grab_ledge(grab_point):
	print_debug("Grab that ledge!")
	on_ledge = true;
	velocity.y = 0;
	velocity.x = 0;
	position = grab_point;
	animtree.get("parameters/playback").travel("Ledge grab")
	call_deferred("Ledge_hang");

func Ledge_hang():
	collisionBox.disabled = true;
	$CollisionHang.disabled = false;
	animtree.get("parameters/playback").travel("Ledge idle")

func Jump():
	animtree.set("parameters/Jump_Fall/blend_position", velocity.y)
	collisionBox.disabled = false
	$CollisionCrouch.disabled = true;
	$CollisionHang.disabled = true;
	animtree.get("parameters/playback").travel("Jump_Fall")
	
func Idle():
	crawling = false;
	collisionBox.disabled = false;
	$CollisionCrouch.disabled = true;
	$CollisionHang.disabled = true;
	animtree.get("parameters/playback").travel("Idle")

func Crouch():
	collisionBox.disabled = true;
	$CollisionCrouch.disabled = false;
	$CollisionHang.disabled = true;
	animtree.get("parameters/playback").travel("CrouchIdle")
	

func Run():
	crawling = false;
	if is_on_floor():
			animtree.get("parameters/playback").travel("Run_Jump")
	collisionBox.disabled = false
	$CollisionCrouch.disabled = true;
	$CollisionHang.disabled = true;
	
func Crawl():
	crawling = true;
	collisionBox.disabled = true;
	$CollisionCrouch.disabled = false;
	$CollisionHang.disabled = true;
	
func Attack():
	attacking = true;
	animtree.get("parameters/playback").travel("Attack")
	

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "Attack":
		attacking = false
	pass # Replace with function body.
