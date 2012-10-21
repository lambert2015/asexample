package org.angle3d.io.parser.ms3d
{

	public class MS3DVertex
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;

		public var bones:Vector.<int>;
		public var weights:Vector.<Number>;

		public function MS3DVertex()
		{
			bones = new Vector.<int>(4, true);
			weights = new Vector.<Number>(4, true);
			weights[0] = 1.0;
			weights[1] = 0.0;
			weights[2] = 0.0;
			weights[3] = 0.0;
		}
	}
}
