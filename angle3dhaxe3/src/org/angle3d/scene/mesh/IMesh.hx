package org.angle3d.scene.mesh;
import haxe.ds.Vector;
interface IMesh
{
	var subMeshList(get,set):Array<SubMesh>;
	var type(get,null):MeshType;
}

