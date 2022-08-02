extends RigidBody2D

export(int) var max_speed = 200

func _ready():
    apply_central_impulse(Vector2.RIGHT*10)

func _process(delta):
    pass

func _physics_process(delta):
    linear_velocity = get_move_direction() * max_speed
    

func get_move_direction():
    var move_direction = Vector2.ZERO
    if Input.is_action_pressed("move_right"):
        move_direction.x += 1
    if Input.is_action_pressed("move_left"):
        move_direction.x += -1
    if Input.is_action_pressed("move_up"):
        move_direction.y += -1
    if Input.is_action_pressed("move_down"):
        move_direction.y += 1
    return move_direction.normalized()
