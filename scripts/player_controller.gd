extends Node

const Player := preload("res://scripts/player.gd")

var player: Player


func _ready():
	set_process(false)


func  _process(_delta):
	player.set_move_input(calc_move_input())

	
func calc_move_input():
	return Vector2(Input.get_axis("ui_left", "ui_right"),
				   Input.get_axis("ui_up", "ui_down"))
