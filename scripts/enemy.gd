extends KinematicBody2D

const GRAV = 750
const SLOPE_STOP = 8
const JUMP_FORCE = 250
export var MS = 20

var coinInst = preload("res://pickables/Coin.tscn")
export var BOUNCE = 300

var vel = Vector2()
export var move_dir = -1
var freeze = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Body/BodyParts/body.modulate = Color("ff3030")
	if move_dir == 1:
		$ground_checker.position.x = 4
		$Body/BodyParts/body.flip_h = true 


func _physics_process(_delta):
	get_dir()
	
	vel.y += GRAV * _delta
	if !freeze:
		vel = move_and_slide(vel, Vector2.UP, SLOPE_STOP)

func get_dir():
	if is_on_wall() or !$ground_checker.is_colliding():
		switch_dir()
	vel.x = lerp(vel.x, move_dir * MS, 0.2)

func switch_dir():
	move_dir *= -1
	$ground_checker.position *= -1
	$Body/BodyParts/body.flip_h = !$Body/BodyParts/body.flip_h

func _on_top_checker_body_entered(body):
	died(body)

func _on_side_checker_body_entered(body):
	if !body.is_dashing():
		if !freeze:
			freeze = true
			PlayerData.died(PlayerData.current_stage_path)
	elif body.is_dashing():
		died(body)

func died(killer):
	if !freeze:
		freeze = true
		killer.change_direction()
		$Body/BodyParts/body.material = null
		PlayerData.screenShake.shake(50, 0.4, 100)
		$top_checker.queue_free()
		$right_checker.queue_free()
		$left_checker.queue_free()
		$CPUParticles2D.emitting = true
		#$trailPos.hide()
		$died.play()
		$Body/BodyParts/body.stop()
		$Body/BodyParts/body.modulate = Color(0.5,0.5,0.5)
		var tween = Tween.new()
		add_child(tween)
		tween.interpolate_property($Body/Light2D, "energy", $Body/Light2D.energy, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		#$Body/Light2D.color = Color(0.5, 0.5, 0.5)
		var newCoin = coinInst.instance()
		newCoin.position = position
		newCoin.pickable = false
		get_node("/root/Game").add_child(newCoin)
		newCoin.change_color("fire")
		killer.jump(-80)
		yield(get_tree().create_timer(0.2),"timeout")
		newCoin.pickable = true
