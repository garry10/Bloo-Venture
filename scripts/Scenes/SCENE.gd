extends Node2D

enum {
	Scene1,
	Scene2,
	Scene3
}

export var Narasi1 = [
	'I think i should rest for a bit in here..',
	'[shake]I hope they not around here..',
	'[shake rate = 100]*Sobbing*'
]

export var Narasi2 = [
	'6 months later..',
	'What is that?!?!'
]

export var Narasi3 = [
	'"Im Auna, the queen of Sea Ghosts, me and my daughter Lily is on the way to ghost of seperator to help Lily get out from this Crystal"',
	'"I put Lily to this Crystal so she can be safe from those [shake]EVIL HUMANS"',
	'"[shake rate = 100]And it looks like someone outside trying to caught us, please help us.."',
	'"[shake rate = 10]I wish someone want to help my daughter out from this Crystal.."'
]

var MAX_NARASI = Narasi1.size()
export var scene = Scene1
var NarasiIndex = 0
var Finished = false

func _ready():
	load_Narasi()

func _process(_delta):
	$Arrow.visible = Finished
	if Input.is_action_just_pressed("ui_accept") and Finished:
		load_Narasi()

func load_Narasi():
	if NarasiIndex < MAX_NARASI:
		Finished = false
		match scene:
			Scene1:
				$Narasi.bbcode_text = Narasi1[NarasiIndex]
			Scene2:
				$Narasi.bbcode_text = Narasi2[NarasiIndex]
			Scene3:
				$Narasi.bbcode_text = Narasi3[NarasiIndex]
		$Narasi.percent_visible = 0
		$Tween.interpolate_property(
			$Narasi, "percent_visible", 0, 1, 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Tween.start()
	else:
		match scene:
			Scene1:
				NarasiIndex = 0
				MAX_NARASI = Narasi2.size()
				SceneTransition.Trans()
				yield(SceneTransition, "sceneChanged")
				$scene/Figure.visible = false
				$Narasi.bbcode_text = Narasi2[NarasiIndex]
				$scene2.show()
				$scene.queue_free()
				scene = Scene2
			Scene2:
				NarasiIndex = 0
				MAX_NARASI = Narasi3.size()
				SceneTransition.Trans()
				yield(SceneTransition, "sceneChanged")
				$Narasi.bbcode_text = Narasi3[NarasiIndex]
				$scene3.show()
				$scene2.queue_free()
				scene = Scene3
			Scene3:
				SceneTransition.change_scene("res://mapSelect.tscn")
	NarasiIndex += 1

func change_story_scene():
	pass

func _on_Tween_tween_completed(_object, _key):
	Finished = true

func _on_next_pressed():
	load_Narasi()
