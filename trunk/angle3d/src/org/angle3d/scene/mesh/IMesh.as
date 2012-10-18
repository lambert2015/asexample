package org.angle3d.scene.mesh
{

	public interface IMesh
	{
		function get subMeshList() : Vector.<SubMesh>;
		function get type() : String;
	}
}
