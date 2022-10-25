extends ItemList

var lobby: Lobby


func _ready():
	var _u: int
	_u = lobby.connect("peer_added", self, "_add_player")
	_u = lobby.connect("peer_removed", self, "_remove_player")


func get_item_names():
	var result := []
	for i in range(get_item_count()):
		result.append(get_item_text(i))
	return result


func set_item_names(names: Array):
	clear()
	for name in names:
		add_item(name)


func _add_player(info: Dictionary):
	add_item(info.name)


func _remove_player(index: int):
	remove_item(index)
