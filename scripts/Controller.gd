extends Node

func _ready():
    pass

func _on_MovementJoystick_controlling():
    var direction = get_node("/root/Main/MovementJoystick").velocity
    print(direction)
