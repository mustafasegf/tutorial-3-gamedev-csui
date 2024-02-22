extends KinematicBody2D

export (float) var gravity_modifier = 10.0
export (float) var jump_modifier = 5.0
export (float) var speed = 400
export (float) var crouch_modifier = 2.0
export (float) var double_modifier = 2.0

var gravity = speed * gravity_modifier
var jump_speed = -1 * gravity / jump_modifier

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

func _process(delta):
		doubletap_time -= delta

func _input(event:  InputEvent):
	var action_name: String = ""
	if isDoubleTapped and (event.is_action_released("ui_right") or event.is_action_released("ui_left")):
		last_action = ""
		isDoubleTapped = false
		print("released")
		return

	if event.is_action_pressed("ui_right"):
		action_name = "right"
	elif event.is_action_pressed("ui_left"):
		action_name = "left"
	else:
		return
		
	if last_action == action_name and action_name != "" and doubletap_time >= 0:
		print("DOUBLETAP: ", action_name)
		isDoubleTapped = true
	else:
			last_action = action_name

	if action_name:
		doubletap_time = DOUBLETAP_DELAY

func get_input():
		var crouch: float = 1.0
		var speed_modifier: float = 1.0
		velocity.x = 0
		
		
		$Sprite.scale.y = default_scale
		$Sprite.offset.y = default_offset
		
		if is_on_floor():
			jump = 0

		if is_on_floor() and Input.is_action_just_pressed("ui_up"):
			velocity.y = jump_speed
			jump += 1
			
		if not timeout and jump <= 2 and Input.is_action_just_pressed("ui_up"):
			jump += 1
			velocity.y = jump_speed
			get_node("Timer").start()
			timeout = true

		if is_on_floor() and Input.is_action_pressed("ui_crouch"):
			var sprite_size = $Sprite.texture.get_size().y

			$Sprite.scale.y = default_scale * 0.7
			$Sprite.offset.y = sprite_size * 0.2
			crouch = crouch_modifier
		
		if isDoubleTapped:
			speed_modifier = double_modifier

		if Input.is_action_pressed('ui_right'):
				velocity.x += speed * speed_modifier / crouch
		if Input.is_action_pressed('ui_left'):
				velocity.x -= speed * speed_modifier / crouch

func _physics_process(delta):
		velocity.y += delta * gravity
		get_input()
		velocity = move_and_slide(velocity, UP)

func _on_Timer_timeout() -> void:
	timeout = false
