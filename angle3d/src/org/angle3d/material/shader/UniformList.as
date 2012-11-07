package org.angle3d.material.shader
{

	public class UniformList extends ShaderVariableList
	{
		private var _constants:Vector.<Vector.<Number>>;

		public function UniformList()
		{
			super();
			_constants = new Vector.<Vector.<Number>>();
		}

		public function setConstants(value:Vector.<Vector.<Number>>):void
		{
			_constants = value;
		}

		public function getConstants():Vector.<Vector.<Number>>
		{
			return _constants;
		}

		public function getUniforms():Vector.<ShaderVariable>
		{
			return _variables;
		}

		public function getUniformAt(i:int):Uniform
		{
			return _variables[i] as Uniform;
		}

		/**
		 * 需要偏移常数数组的长度
		 */
		override public function build():void
		{
			var offset:int = _constants != null ? _constants.length : 0;
			var vLength:int = _variables.length;
			for (var i:int = 0; i < vLength; i++)
			{
				var sv:ShaderVariable = _variables[i];
				sv.location = offset;
				offset += sv.size;
			}
		}
	}
}

