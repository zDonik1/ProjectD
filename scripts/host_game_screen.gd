extends Control


signal open_lobby_pressed


var lobby_name: String setget , _get_lobby_name


func _on_OpenLobby_pressed():
	if not _get_lobby_name_text_edit().text.empty():
		emit_signal("open_lobby_pressed")


func _get_lobby_name() -> String:
	return _get_lobby_name_text_edit().text


func _get_lobby_name_text_edit() -> TextEdit:
	return $VBoxContainer/GridContainer/LobbyNameTextEdit as TextEdit
