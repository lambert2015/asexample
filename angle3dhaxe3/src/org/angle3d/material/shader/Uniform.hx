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
	class Uniform extends ShaderVariable
	{
		private var _data:Vector<Float>;

		/**
		 * Binding to a renderer value, or null if user-defined uniform
		 */
		public var binding:Int;

		public function Uniform(name:String, size:Int)
		{
			super(name, size);

			_size = int(_size / 4);

			_data = new Vector<Float>(_size * 4, true);
		}

		override public function get size():Int
		{
			return _size;
		}

		public function setVector(data:Vector<Float>):Void
		{
			var count:Int = _size * 4;
			for (var i:Int = 0; i < count; i++)
			{
				_data[i] = data[i];
			}
		}

		
		public final function setMatrix4(mat:Matrix4f):Void
		{
			mat.toUniform(_data);
		}

		
		public final function setMatrix3(mat:Matrix3f):Void
		{
			mat.toUniform(_data);
		}

		
		public final function setColor(c:Color):Void
		{
			c.toUniform(_data);
		}

		
		public final function setFloat(value:Float):Void
		{
			_data[0] = value;
		}

		
		public final function setVector2(vec:Vector2f):Void
		{
			vec.toUniform(_data);
		}

		
		public final function setVector3(vec:Vector3f):Void
		{
			vec.toUniform(_data);
		}

		
		public final function setVector4(vec:Vector4f):Void
		{
			vec.toUniform(_data);
		}

		
		public final function setQuaterion(q:Quaternion):Void
		{
			q.toUniform(_data);
		}

		public function get data():Vector<Float>
		{
			return _data;
		}
	}
}

