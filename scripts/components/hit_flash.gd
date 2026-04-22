class_name HitFlash
extends Node

@export var target: NodePath
@export var flash_time: float = 0.08
@export var flash_color: Color = Color(1, 0.3, 0.3, 1)

var _mesh: MeshInstance3D
var _timer: float = 0.0
var _mat: StandardMaterial3D
var _orig_albedo: Color = Color.WHITE
var _orig_emission: Color = Color.BLACK

func _ready() -> void:
	if target != NodePath():
		_mesh = get_node_or_null(target) as MeshInstance3D
	else:
		_mesh = owner as MeshInstance3D
	if not _mesh:
		return

	_mat = _get_or_make_standard_material(_mesh)
	if _mat:
		_orig_albedo = _mat.albedo_color
		_orig_emission = _mat.emission

func flash() -> void:
	if not _mesh or not _mat:
		return
	_timer = flash_time
	_mat.emission_enabled = true
	_mat.emission = flash_color

func _process(delta: float) -> void:
	if not _mesh or not _mat:
		return
	if _timer <= 0.0:
		return
	_timer -= delta
	if _timer <= 0.0:
		_mat.emission = _orig_emission
		_mat.emission_enabled = (_orig_emission != Color.BLACK)

func _get_or_make_standard_material(mesh: MeshInstance3D) -> StandardMaterial3D:
	if mesh.material_override and mesh.material_override is StandardMaterial3D:
		return mesh.material_override as StandardMaterial3D

	if mesh.material_override and mesh.material_override is Material:
		mesh.material_override = (mesh.material_override as Material).duplicate()
		if mesh.material_override is StandardMaterial3D:
			return mesh.material_override as StandardMaterial3D

	if mesh.mesh and mesh.mesh.get_surface_count() > 0:
		var surf_mat := mesh.mesh.surface_get_material(0)
		if surf_mat and surf_mat is StandardMaterial3D:
			var dup := (surf_mat as StandardMaterial3D).duplicate()
			mesh.material_override = dup
			return dup

	var fresh := StandardMaterial3D.new()
	mesh.material_override = fresh
	return fresh
