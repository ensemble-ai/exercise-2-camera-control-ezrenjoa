class_name Autoscroll
extends CameraControllerBase


@export var top_left:Vector2 = Vector2(-10.0, -10.0)
@export var bottom_right:Vector2 = Vector2(10, 10)
@export var autoscroll_speed:Vector3 = Vector3(3.0, 0, 3.0)

var is_active:bool = false
# boundaries
var left:float = top_left.x
var right:float = bottom_right.x
var top:float = top_left.y
var bottom:float = bottom_right.y


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
		position = target.position + Vector3(0.0, dist_above_target, 0.0)
	
	if draw_camera_logic:
		draw_logic()
	
	var fps := 1.0 / delta	# approximate frames per sec rate, based on delta
	var tpos := target.position - position	# target's position relative to cam
	
	position += autoscroll_speed / fps
	target.position += autoscroll_speed / fps
	
	if (tpos.x - target.WIDTH / 2.0) < left:
		tpos.x = left + target.WIDTH / 2.0
	if (tpos.x + target.WIDTH / 2.0) > right:
		tpos.x = right - target.WIDTH / 2.0
	if (tpos.z - target.HEIGHT / 2.0) < top:
		tpos.z = top + target.HEIGHT / 2.0
	if (tpos.z + target.HEIGHT / 2.0) > bottom:
		tpos.z = bottom - target.HEIGHT / 2.0
	
	target.position = tpos + position
	
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, 
			target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
