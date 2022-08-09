extends Node

onready var possessed = get_node("/root/Main/Player")

func _ready():
    pass
    
func  _process(delta):
    possessed.set_move_input(calc_move_input())

func _input(event):
    pass
    
func calc_move_input():
    return Vector2(Input.get_axis("ui_left", "ui_right"),
                   Input.get_axis("ui_up", "ui_down"))
