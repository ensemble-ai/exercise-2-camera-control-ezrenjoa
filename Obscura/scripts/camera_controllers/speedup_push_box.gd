class_name SpeedupPushBox
extends CameraControllerBase


@export var push_ratio:float = 0.75
@export var pushbox_top_left:Vector2 = Vector2(-7.5, -7.5)
@export var pushbox_bottom_right:Vector2 = Vector2(7.5, 7.5)
@export var speedup_zone_top_left:Vector2 = Vector2(-5.0, -5.0)
@export var speedup_zone_bottom_right:Vector2 = Vector2(5.0, 5.0)

var is_active:bool = false


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
	var tpos := target.position - position	# target's position relative to cam
	var tvelocity_xz := Vector2(target.velocity.x, target.velocity.z)
	var cvelocity_xz := Vector2(0, 0)
	
	# speedup zone checks
	# left
	if (tpos.x - target.WIDTH / 2.0) < speedup_zone_top_left.x and tvelocity_xz.x < 0:
		cvelocity_xz.x = push_ratio * tvelocity_xz.x
	# right
	if (tpos.x + target.WIDTH / 2.0) > speedup_zone_bottom_right.x and tvelocity_xz.x > 0:
		cvelocity_xz.x = push_ratio * tvelocity_xz.x
	# top
	if (tpos.z - target.HEIGHT / 2.0) < speedup_zone_top_left.y and tvelocity_xz.y < 0:
		cvelocity_xz.y = push_ratio * tvelocity_xz.y
	# bottom
	if (tpos.z + target.HEIGHT / 2.0) > speedup_zone_bottom_right.y and tvelocity_xz.y > 0:
		cvelocity_xz.y = push_ratio * tvelocity_xz.y
	
	# pushbox boundary checks
	#left
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - pushbox_top_left.x
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges
		cvelocity_xz.x = 0
		cvelocity_xz.y = push_ratio * tvelocity_xz.y
	#right
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - pushbox_bottom_right.x
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges
		cvelocity_xz.x = 0
		cvelocity_xz.y = push_ratio * tvelocity_xz.y
	#top
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - pushbox_top_left.y
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges
		cvelocity_xz.x = push_ratio * tvelocity_xz.x
		cvelocity_xz.y = 0
	#bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - pushbox_bottom_right.y
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges
		cvelocity_xz.x = push_ratio * tvelocity_xz.x
		cvelocity_xz.y = 0
	# corners
	# top left
	if diff_between_left_edges < 0 and diff_between_top_edges < 0:
		cvelocity_xz = Vector2(0, 0)
	# top right
	if diff_between_right_edges > 0 and diff_between_top_edges < 0:
		cvelocity_xz = Vector2(0, 0)
	# bottom left
	if diff_between_left_edges < 0 and diff_between_bottom_edges > 0:
		cvelocity_xz = Vector2(0, 0)
	# bottom right
	if diff_between_right_edges > 0 and diff_between_bottom_edges > 0:
		cvelocity_xz = Vector2(0, 0)
	
	position += Vector3(cvelocity_xz.x, 0, cvelocity_xz.y) / fps
	
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = pushbox_top_left.x
	var right:float = pushbox_bottom_right.x
	var top:float = pushbox_top_left.y
	var bottom:float = pushbox_bottom_right.y
	
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
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
