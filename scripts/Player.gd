extends CharacterBody3D

const SPEED := 5.0
var last_position: Vector3

func _ready():
	last_position = global_transform.origin

func get_movement_input() -> Vector3:
	var dir = Vector3.ZERO
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		dir.z += 1
	if Input.is_action_pressed("ui_up"):
		dir.z -= 1
	return dir.normalized()

func _physics_process(_delta):
        var dir = get_movement_input()
        var target_velocity = dir * SPEED
        velocity.x = lerp(velocity.x, target_velocity.x, 0.2)
        velocity.z = lerp(velocity.z, target_velocity.z, 0.2)
        move_and_slide()

	var delta_pos = global_transform.origin - last_position
	if delta_pos.length() > 0:
                if get_node_or_null("../NetworkManager"):
                        get_node("../NetworkManager").send_movement(delta_pos)
                last_position = global_transform.origin

func _input(event):
        if event is InputEventKey and event.pressed and event.keycode == KEY_C:
                if has_node("Camera3D"):
                        var cam = get_node("Camera3D")
                        print("Camera position:", cam.global_transform.origin)
