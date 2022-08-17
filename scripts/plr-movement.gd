extends KinematicBody2D

signal notWalking()

const UP_DIRECTION = Vector2.UP
const dash_delay = 0.2

export var speed = 50
export var wall_jump_speed = 90


export var jump_strength = 100
export var gravity = 450
export var wall_slide_speed = 60
export var wall_slide_gravity = 1

var _velocity = Vector2.ZERO
var walking = false
export var horizontal_direction = 1
var is_wall_sliding = false
var freeze = false
var jumping = false

var can_dash = true
var dashing = false

onready var anim_player = $AnimationPlayer

func _ready():
	if horizontal_direction == -1:
		$Blue/Blue1.flip_h = true
	var _n = inGameUI.get_node("Control/Button").connect("button_down", self, "inputJump")
	var _n1 = inGameUI.get_node("Control/dashBtn").connect("button_down", self, "inputDash")
	var _n2 = PlayerData.connect("dead", self, "on_dead")

func _physics_process(delta):
	if freeze == true or PlayerData.MainMenu:
		return
	inGameUI.get_node("Control/dashBtn").disabled = !can_dash
	_velocity.y += gravity * delta
	if is_on_wall():
		if is_dashing():
			$dashDuration.stop()
			$dashDuration.emit_signal("timeout")
		if !is_on_floor():
			is_wall_sliding = true
		else:
			is_wall_sliding = false
			change_direction()
			walking = false
			emit_signal("notWalking")
	else:
		is_wall_sliding = false

	if is_wall_sliding == true:
		if jumping == true:
			jumping = false
			$jump_sfx.play()
			change_direction()
			jump(-jump_strength)
			walking = true
		else:
			_velocity.y += wall_slide_gravity * delta 
			_velocity.y = min(_velocity.y, wall_slide_speed)

	if walking == true:
		if is_wall_sliding:
			_velocity.x = horizontal_direction * wall_jump_speed
		else:
			_velocity.x = horizontal_direction * speed if !is_dashing() else horizontal_direction * (speed * 2 + 25)
	if dashing == true:
		dashing = false
		$dash_sfx.play()
		walking = true
		start_dash(0.2)
	
	if jumping == true :
		jumping = false
		walking = true
		if !is_dashing():
			jump(-jump_strength)
	
	if is_dashing():
		_velocity.y = 0
	
	_velocity = move_and_slide(_velocity, UP_DIRECTION)
	pass

func _input(_event):
	if Input.is_action_just_pressed("jump"):
		inputJump()
	if Input.is_action_just_pressed("dash"):
		inputDash()

func inputJump():
	if !is_wall_sliding && is_on_floor():
		jumping = true
	elif is_wall_sliding:
		jumping = true

func inputDash():
	if !is_wall_sliding && can_dash:
		can_dash = false
		dashing = true

func jump(jumpValue):
	_velocity.y = jumpValue
	$jump_sfx.play()
	PlayerData.inGame = true

func start_dash(duration):
	$Blue/Blue1.texture = load("res://Assets/BlueDash.png")
	$Blue/Blue2.hide()
	$dashDuration.wait_time = duration
	$dashDuration.start()
	$Blue/Blue1.modulate = Color(0.415686, 0.913725, 2)
	$Blue/Light2D.texture_scale = 0.85
	$Blue/Light2D.energy = 0.9
	PlayerData.inGame = true

func end_dash():
	$Blue/Blue1.texture = load("res://Assets/Blue1.png")
	$Blue/Blue2.show()
	yield(get_tree().create_timer(dash_delay), "timeout")
	$Blue/Blue1.modulate = Color(0.415686, 0.913725, 1)
	$Blue/Light2D.texture_scale = 0.8
	$Blue/Light2D.energy = 0.75
	can_dash = true
	pass

func is_dashing():
	return !$dashDuration.is_stopped()

func change_direction():
	$Blue/Blue1.flip_h = !$Blue/Blue1.flip_h
	horizontal_direction *= -1

func _on_dashDuration_timeout():
	end_dash()

func on_dead():
	freeze = true
	anim_player.play("died")
	yield(anim_player, "animation_finished")
