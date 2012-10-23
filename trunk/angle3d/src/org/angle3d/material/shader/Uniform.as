package org.angle3d.material.shader
{

	import org.angle3d.math.Color;
	import org.angle3d.math.Matrix3f;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Quaternion;
	import org.angle3d.math.Vector2f;
	import org.angle3d.math.Vector3f;
	import org.angle3d.math.Vector4f;

	/**
	 * andy
	 * @author
	 */
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
			var count:int = _size * 4;
			for (var i:int = 0; i < count; i++)
			{
				_data[i] = data[i];
			}
		}

		[Inline]
		public final function setMatrix4(mat:Matrix4f):void
		{
			mat.toUniform(_data);
		}

		[Inline]
		public final function setMatrix3(mat:Matrix3f):void
		{
			mat.toUniform(_data);
		}

		[Inline]
		public final function setColor(c:Color):void
		{
			c.toUniform(_data);
		}

		[Inline]
		public final function setFloat(value:Number):void
		{
			_data[0] = value;
		}

		[Inline]
		public final function setVector2(vec:Vector2f):void
		{
			vec.toUniform(_data);
		}

		[Inline]
		public final function setVector3(vec:Vector3f):void
		{
			vec.toUniform(_data);
		}

		[Inline]
		public final function setVector4(vec:Vector4f):void
		{
			vec.toUniform(_data);
		}
		
		[Inline]
		public final function setQuaterion(q:Quaternion):void
		{
			q.toUniform(_data);
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

