extends Node3D


var rotation_speed = 4

@onready var camera_pivot = $CameraPivot

func _process(delta: float) -> void:
	camera_pivot.rotation_degrees.y += delta * rotation_speed
