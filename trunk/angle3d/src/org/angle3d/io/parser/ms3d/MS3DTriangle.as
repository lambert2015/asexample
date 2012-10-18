package org.angle3d.io.parser.ms3d
{
	import org.angle3d.math.Vector3f;

	public class MS3DTriangle
	{
		public var indices : Vector.<int>;
		public var normals : Vector.<Vector3f>;
		public var tUs : Vector.<Number>;
		public var tVs : Vector.<Number>;
		public var groupIndex : int;

		public function MS3DTriangle()
		{
			indices = new Vector.<int>(3, true);
			normals = new Vector.<Vector3f>(3, true);
			for (var i : int = 0; i < 3; i++)
			{
				normals[i] = new Vector3f();
			}
			tUs = new Vector.<Number>(3, true);
			tVs = new Vector.<Number>(3, true);
		}
	}
}
