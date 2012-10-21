package org.angle3d.material.shader
{

	import org.angle3d.math.Color;
	import org.angle3d.math.Matrix3f;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Vector2f;
	import org.angle3d.math.Vector3f;
	import org.angle3d.math.Vector4f;

	/**
	 * andy
	 * @author
	 */
//TODO 需要判断_data长度
	//uniform mat4 u_boneMatrix[32]
	public class Uniform extends ShaderVariable
	{
		private var _data:Vector.<Number>;

		/**
		 * Binding to a renderer value, or null if user-defined uniform
		 */
		private var _binding:int;

		public function Uniform(name:String, size:int)
		{
			super(name, size);

			_size = int(_size / 4);

			_data = new Vector.<Number>(_size * 4, true);
		}

		override public function get size():int
		{
			return _size;
		}

		public function setVector(data:Vector.<Number>):void
		{
			_data = data.concat();
		}

		public function setMatrix4(mat:Matrix4f):void
		{
//			if (_data.length > 16)
//			{
//				_data.length = 16;
//			}
			mat.toUniform(_data);
		}

		public function setMatrix3(mat:Matrix3f):void
		{
//			if (_data.length > 12)
//			{
//				_data.length = 12;
//			}
			mat.toUniform(_data);
		}

		public function setColor(c:Color):void
		{
//			_data.length = 4;
			c.toUniform(_data);
		}

		public function setFloat(value:Number):void
		{
//			_data.length = 4;
			_data[0] = value;
		}

		public function setVector2(vec:Vector2f):void
		{
//			_data.length = 4;
			vec.toVector(_data);
		}

		public function setVector3(vec:Vector3f):void
		{
//			_data.length = 4;
			vec.toVector(_data);
		}

		public function setVector4(vec:Vector4f):void
		{
//			_data.length = 4;
			vec.toVector(_data);
		}

		public function get data():Vector.<Number>
		{
			return _data;
		}

		public function set binding(value:int):void
		{
			_binding = value;
		}

		public function get binding():int
		{
			return _binding;
		}
	}
}

