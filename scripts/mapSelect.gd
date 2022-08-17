extends CanvasLayer

export(PackedScene) var base_button
export(PackedScene) var timerLabel
export (int) var total_maps = 0
export(NodePath) var grid
var lvl_index = 0

func _ready():
	refreshLevelPreview()
#func generate_buttons(mapName: String, mapId: int, total_stages: int):
#	var bb = base_button.instance()
#	var tl = timerLabel.instance()
#	tl.set_name(mapName)
#	bb.set_name(mapName)
#	bb.set_text("Level " + str(mapId + 1))
#	bb.mapName = mapName
#	bb.mapId = mapId
#	bb.total_stages = total_stages
#
#	if PlayerData.maps[mapId]["fastestRecord"] == 0:
#		var fastestRecord_text = "Fastest Record: " + "00 : 00 : 00"
#		tl.text = fastestRecord_text
#	else:
#		var mils = fmod(PlayerData.maps[mapId]["fastestRecord"], 1)*100
#		var secs = fmod(PlayerData.maps[mapId]["fastestRecord"], 60)
#		var mins = fmod(PlayerData.maps[mapId]["fastestRecord"], 60*60) / 60
#
#		var fastestRecord_text = "Fastest Record: " + "%02d : %02d : %02d" % [mins,secs,mils]
#		tl.text = fastestRecord_text
#	grid.add_child(bb)
#	grid.add_child(tl)
#	pass

func column_size():
	if total_maps % 2 == 0:
		grid.columns = total_maps/2
	else:
		grid.columns = total_maps/2 + 1

func refreshLevelPreview():
	print(lvl_index)
	var tl = get_node("divider/centre_buttons/MarginContainer/VBoxContainer/levelPreview/Level/fastestRecord")
	$divider/centre_buttons/MarginContainer/VBoxContainer/levelPreview/Level.text = "Level " + str(lvl_index + 1)
	$levelPreview.texture = load(PlayerData.maps[lvl_index]["preview"])
	$divider/centre_buttons/MarginContainer/VBoxContainer/levelPreview.texture = load(PlayerData.maps[lvl_index]["preview"])
	if PlayerData.maps[lvl_index]["fastestRecord"] == 0:
		var fastestRecord_text = "Fastest Record: " + "00 : 00 : 00"
		tl.text = fastestRecord_text
	else:
		var mils = fmod(PlayerData.maps[lvl_index]["fastestRecord"], 1)*100
		var secs = fmod(PlayerData.maps[lvl_index]["fastestRecord"], 60)
		var mins = fmod(PlayerData.maps[lvl_index]["fastestRecord"], 60*60) / 60

		var fastestRecord_text = "Fastest Record: " + "%02d : %02d : %02d" % [mins,secs,mils]
		tl.text = fastestRecord_text

func _on_previous_pressed():
	lvl_index -= 1
	lvl_index = clamp(lvl_index, 0, total_maps - 1)
	refreshLevelPreview()


func _on_next_pressed():
	lvl_index += 1
	lvl_index = clamp(lvl_index, 0, total_maps - 1)
	refreshLevelPreview()





func _on_lvlBtn_pressed():
	PlayerData.current_stage = 0
	PlayerData.mapName = PlayerData.maps[lvl_index]["mapName"]
	PlayerData.mapId = lvl_index
	PlayerData.total_stages = PlayerData.maps[lvl_index]["total_stages"]
	PlayerData.tpBloo()


func _on_mainmenuButton_pressed():
	PlayerData.current_stage = 0
	inGameUI.resetTime()
	PlayerData.MainMenu = true
	SceneTransition.change_scene("res://MainMenu.tscn", 0.1)
