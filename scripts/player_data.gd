extends Node

signal dead()

var screenShake = null
var max_coin = 3
var coin = 0
var current_stage = 0
var total_stages = 5
var current_stage_path = ""
var complete = false
var inGame = false
var MainMenu = true
var fastestRecord = 0
var mapName = "Good Morning"
var mapId

var maps = {
	0 : {
		"mapName" : "Good Morning",
		"total_stages" : 4,
		"fastestRecord" : 0,
		"preview" : "res://Assets/Photos/Bloo Venture (DEBUG) 04_08_2022 21.29.36.png"
	},
	1 : {
		"mapName" : "Good Afternoon",
		"total_stages" : 5,
		"fastestRecord" : 0,
		"preview" : "res://Assets/Photos/Bloo Venture (DEBUG) 04_08_2022 21.28.47.png"
	},
	2 : {
		"mapName" : "Good Evening",
		"total_stages" : 5,
		"fastestRecord" : 0,
		"preview" : "res://Assets/Photos/Bloo Venture (DEBUG) 04_08_2022 21.28.47.png"
	}
}

func add_coins(value):
	if PlayerData.coin != max_coin:
		PlayerData.coin += value
		inGameUI.coinCounter.text = String(PlayerData.coin) + "/" + String(PlayerData.max_coin)
	if PlayerData.coin == max_coin:
		tpBloo()

func _input(event):
#	if Input.is_action_just_pressed("Menu") && inGame == true && MainMenu == false:
#		complete = false
#		PlayerData.current_stage = 0
#		yield(get_tree().create_timer(0.2), "timeout")
#		inGameUI.resetTime()
#		MainMenu = true
#		SceneTransition.change_scene("res://MainMenu.tscn", 0.1)
	if Input.is_action_just_pressed("reset") && MainMenu == false && get_node("/root/Game/Bloo").walking == false:
		reset_stage()
	if ((event is InputEventScreenTouch && event.is_pressed()) or Input.is_action_just_pressed("jump")) && complete == true:
		complete = false
		PlayerData.current_stage = 0
		yield(get_tree().create_timer(0.2), "timeout")
		inGameUI.resetTime()
		MainMenu = true
		SceneTransition.change_scene("res://MainMenu.tscn", 0.1)

func tpBloo():
	if PlayerData.current_stage != PlayerData.total_stages:
		if !MainMenu:
			yield(get_node("/root/Game/Bloo"), "notWalking")
			get_node("/root/Game/Bloo").freeze = true
			inGame = false
		PlayerData.current_stage_path = "res://levels/" + PlayerData.mapName + "/Level" + String(PlayerData.current_stage + 1) + ".tscn"
		PlayerData.current_stage += 1
		print(current_stage_path)
		SceneTransition.change_scene(current_stage_path, 0.5)
	else:
		yield(get_node("/root/Game/Bloo"), "notWalking")
		get_node("/root/Game/Bloo").freeze = true
		complete = true
		if inGameUI.time < maps[mapId]["fastestRecord"] or maps[mapId]["fastestRecord"] == 0:
			maps[mapId]["fastestRecord"] = inGameUI.time
		inGame = false
		print(String(maps[mapId]["fastestRecord"]))
		print("Complete!")

func reset_stage():
	if SceneTransition.is_changing_scene() or complete:
		return
	if !MainMenu:
		get_node("/root/Game/Bloo").freeze = true
		inGame = false
		inGameUI.resetTime()
	current_stage_path = "res://levels/" + PlayerData.mapName + "/Level1" + ".tscn"
	current_stage = 1
	SceneTransition.change_scene(current_stage_path, 0.5)

func died(level_path):
	PlayerData.inGame = false
	if current_stage == 1:
		inGameUI.resetTime()
	SceneTransition.change_scene(level_path, 0.3)
	emit_signal("dead")
