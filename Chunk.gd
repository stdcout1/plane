extends Node3D
class_name  Chunk

var noise:Noise;
var x;
var z;
var chunk_size;
var new_mesh;


func _init(noise, x, z, chunk_size):
	self.noise = noise
	self.x = x
	self.z = z
	self.chunk_size = chunk_size

func _ready():
	generate_chunk();


func generate_chunk():
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(chunk_size, chunk_size)
	plane_mesh.subdivide_depth = chunk_size * 10
	plane_mesh.subdivide_width = chunk_size * 10
	var mdt = MeshDataTool.new();
	var st = SurfaceTool.new();
	st.create_from(plane_mesh,0)
	var array_mesh = st.commit()
	mdt.create_from_surface(array_mesh,0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i); # get the current vertex
		vertex.y = noise.get_noise_3d(vertex.x+x,vertex.y,vertex.z + z) * 30 # set it to the respective perlin noise
		mdt.set_vertex(i,vertex)
	array_mesh.clear_surfaces()

	mdt.commit_to_surface(array_mesh)
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.create_from(array_mesh,0)
	st.generate_normals()

	#make the mesh

	new_mesh = MeshInstance3D.new();
	new_mesh.mesh = st.commit();
	new_mesh.create_trimesh_collision();
	new_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(new_mesh)

	

