package org.angle3d.scene.mesh;
import flash.Vector;
interface IMesh
{
	var subMeshList(get,set):Array<SubMesh>;
	var type(get,null):MeshType;
}

