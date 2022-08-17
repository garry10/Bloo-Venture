extends Button

var mapName : String
var mapId : int
var total_stages : int

func _on_levelBtn_pressed():
	PlayerData.current_stage = 0
	PlayerData.mapName = mapName
	PlayerData.mapId = mapId
	PlayerData.total_stages = total_stages
	PlayerData.tpBloo()
