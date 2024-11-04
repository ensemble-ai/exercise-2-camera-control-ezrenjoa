class_name LerpLookAhead
extends CameraControllerBase


@export var lead_speed:float = 1.15 * target.BASE_SPEED
@export var catchup_delay_duration:float = 0.2 # in seconds
@export var catchup_speed:float = 20
@export var leash_distance:float = 5.0

var is_active:bool = false
var catchup_timer:float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !current:
		is_active = false
		return
	
	if not is_active:
		is_active = true
		draw_camera_logic = true
		position.x = target.position.x
		position.z = target.position.z
	
	if draw_camera_logic:
		draw_logic()
	
	var fps := 1.0 / delta	# approximate frames per sec rate, based on delta
	var distance := Vector2(position.x, position.z).distance_to(
			Vector2(target.position.x, target.position.z))
	var catchup_speed_per_frame := catchup_speed / fps
	var direction := target.velocity.normalized()
	var velocity:Vector3 = lead_speed * direction
	var tpos_xz := Vector2(target.position.x, target.position.z)
	var cpos_xz := Vector2(position.x, position.z)
	
	# FIXME: when vessel is at leash distance and changes direction, 
			# it maintains same position relative to camera
	if target.velocity.x > target.BASE_SPEED or target.velocity.z > target.BASE_SPEED:
		velocity = target.HYPER_SPEED * direction
	elif distance > leash_distance:
		velocity = target.velocity
	else:
		velocity = lead_speed * direction
	
	if target.velocity.is_zero_approx():
		velocity = Vector3(0, 0, 0)
		catchup_timer += delta
		if catchup_timer >= catchup_delay_duration:
			cpos_xz = cpos_xz.move_toward(tpos_xz, catchup_speed_per_frame)
			position = Vector3(cpos_xz.x, 0, cpos_xz.y)
	else:
		catchup_timer = 0
	
	
	position += velocity / fps
	
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(-5.0, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(5.0, 0, 0))
	
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -5.0))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, 5.0))
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
