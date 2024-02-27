extends KinematicBody2D

export (float) var gravity_modifier = 10.0
export (float) var jump_modifier = 4.0
export (float) var speed = 400.0
export (float) var crouch_modifier = 2.0
export (float) var double_modifier = 3.0
export (float) var rotate_modifier = 10.0

var gravity = speed * gravity_modifier
var jump_speed = -1 * gravity / jump_modifier
var rotate_deg: float = 0.0;

const UP = Vector2(0,-1)
var velocity = Vector2()

var jump = 0
var timeout = false

onready var default_scale = $Sprite.scale.y
onready var default_offset = $Sprite.offset.y

const DOUBLETAP_DELAY = .25
var doubletap_time = DOUBLETAP_DELAY
var last_action: String = ""
var isDoubleTapped = false

var on_wall = false
var wall_dir = 0  # -1 for left, 1 for right
var can_jump = true


func _process(delta):
		doubletap_time -= delta

func _input(event:  InputEvent):
	var action_name: String = ""
	if isDoubleTapped and (event.is_action_released("ui_right") or event.is_action_released("ui_left")):
		last_action = ""
		isDoubleTapped = false
		return

	if event.is_action_pressed("ui_right"):
		action_name = "right"
	elif event.is_action_pressed("ui_left"):
		action_name = "left"
	else:
		return
		
	if last_action == action_name and action_name != "" and doubletap_time >= 0:
		isDoubleTapped = true
	else:
			last_action = action_name

	if action_name:
		doubletap_time = DOUBLETAP_DELAY

func get_input():
	var is_wall_grabbing = false
	var crouch: float = 1.0
	var speed_modifier: float = 1.0
	var rotate: float = rotate_modifier
	
	velocity.x = 0
		
	$Sprite.scale.y = default_scale
	$Sprite.offset.y = default_offset
		
	if is_on_floor():
		jump = 0

	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_speed
		jump += 1
		get_node("Timer").start()
		timeout = true
			
	if not timeout and jump <= 2 and Input.is_action_just_pressed("ui_up"):
		jump += 1
		velocity.y = jump_speed
		get_node("Timer").start()
		timeout = true

	# Wall grab detection
	if (Input.is_action_pressed('ui_left') or Input.is_action_pressed('ui_right')) and is_on_wall():
		is_wall_grabbing = true
		velocity.y = 0  # Stop vertical movement if grabbing onto a wall
		jump = 0  # Reset jump count to allow for wall jump
		# Wall Jump logic
	if is_wall_grabbing and Input.is_action_just_pressed("ui_up"):
		if Input.is_action_pressed('ui_right'):
			velocity.x -= speed  # Push off wall to the left
		elif Input.is_action_pressed('ui_left'):
			velocity.x += speed  # Push off wall to the right
		velocity.y = jump_speed
		is_wall_grabbing = false  # Reset wall grabbing state after jumping

		
	if isDoubleTapped:
		speed_modifier = double_modifier
		create_trail()

	if Input.is_action_pressed('ui_right'):
		velocity.x += speed * speed_modifier / crouch
		rotate_deg += rotate
				
	if Input.is_action_pressed('ui_left'):
		velocity.x -= speed * speed_modifier / crouch
		rotate_deg -= rotate
		
	$Sprite.rotation_degrees = rotate_deg

func _physics_process(delta):
		velocity.y += delta * gravity
		get_input()
		velocity = move_and_slide(velocity, UP)

func _on_Timer_timeout() -> void:
	timeout = false

var trail_scene = preload("res://scenes/Trail.tscn")

func create_trail():
	var trail = trail_scene.instance()
	
	trail.global_position = $Sprite.global_position
	trail.flip_h = $Sprite.flip_h
	trail.flip_v = $Sprite.flip_v
	trail.rotation_degrees = $Sprite.rotation_degrees
	trail.texture = $Sprite.texture
	trail.scale = $Sprite.scale
	trail.frame = $Sprite.frame
	trail.z_index = -1
	trail.show_behind_parent = true
	var values = [0, 0.5, 1]
	var r = 0
	var g = 0
	var b = 0
	while r == 0 and g == 0 and b == 0:
		r = values[randi() % values.size()]
		g = values[randi() % values.size()]
		b = values[randi() % values.size()]
		
	trail.material.set_shader_param("flash_color", Color(r, g, b, 1.0))
	
	get_tree().get_root().add_child(trail)

