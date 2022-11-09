extends "res://scripts/lobby_ui.gd"

signal start_game_pressed


func _ready():
    var _u := $StartGame.connect("pressed", self, "_on_start_game_button_pressed")


func _on_start_game_button_pressed():
    emit_signal("start_game_pressed")
