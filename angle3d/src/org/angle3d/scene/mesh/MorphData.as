package org.angle3d.scene.mesh
{

	public class MorphData
	{
		public var name : String;
		public var start : int;
		public var end : int;

		public function MorphData(name : String, start : int, end : int)
		{
			this.name = name;
			this.start = start;
			this.end = end;
		}
	}
}
