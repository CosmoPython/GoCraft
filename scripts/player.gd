extends CharacterBody3D


const SPEED = 8.0
const JUMP_VELOCITY = 8.0

var sensitivity = 0.002
var gravity = 50.0
var selected = 6

@onready var camera_3d = $Camera3D
@onready var ray_cast_3d = $Camera3D/RayCast3D
@onready var hotbar = $hotbar


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation.y = rotation.y - event.relative.x * sensitivity
		camera_3d.rotation.x = camera_3d.rotation.x - event.relative.y * sensitivity
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-70), deg_to_rad(80))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0
		velocity.z = 0
		
	if Input.is_action_just_pressed("left_click"):
		if ray_cast_3d.is_colliding():
			if ray_cast_3d.get_collider().has_method("destroy_block"):
				ray_cast_3d.get_collider().destroy_block(ray_cast_3d.get_collision_point() - 
														ray_cast_3d.get_collision_normal())


	if Input.is_action_just_pressed("right_click"):
		if ray_cast_3d.is_colliding():
			if ray_cast_3d.get_collider().has_method("place_block"):
				ray_cast_3d.get_collider().place_block(ray_cast_3d.get_collision_point() + 
													ray_cast_3d.get_collision_normal(), selected)

	if Input.is_action_just_pressed("one"):
		selected = 5
		hotbar.select(0)
		
	if Input.is_action_just_pressed("two"):
		selected = 1
		hotbar.select(1)
		
	if Input.is_action_just_pressed("three"):
		selected = 4
		hotbar.select(2)
		
	if Input.is_action_just_pressed("four"):
		selected = 0
		hotbar.select(3)
		


	move_and_slide()
