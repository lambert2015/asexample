package org.angle3d.io.parser.ms3d
{

	public class MS3DKeyframe
	{
		public var time : Number;
		public var data : Vector.<Number>;

		public function MS3DKeyframe()
		{
			data = new Vector.<Number>(3, true);
		}
	}
}
