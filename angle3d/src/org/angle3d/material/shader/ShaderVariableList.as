package org.angle3d.material.shader
{

	/**
	 * ShaderVariable List
	 * @author
	 */
	public class ShaderVariableList
	{
		protected var _variables:Vector.<ShaderVariable>;

		public function ShaderVariableList()
		{
			_variables = new Vector.<ShaderVariable>();
		}

		public function addVariable(value:ShaderVariable):void
		{
			_variables.push(value);
		}

		/**
		 * read only
		 * @return
		 */
		public function getVariables():Vector.<ShaderVariable>
		{
			return _variables;
		}

		/**
		 * 添加所有变量后，设置每个变量的位置
		 */
		public function build():void
		{
			//默认是按照在数组中的顺序来设置location
			var vLength:int = _variables.length;
			for (var i:int = 0; i < vLength; i++)
			{
				_variables[i].location = i;
			}
		}

		public function getVariableAt(index:int):ShaderVariable
		{
			return _variables[index];
		}

		public function getVariable(name:String):ShaderVariable
		{
			var length:int = _variables.length;
			for (var i:int = 0; i < length; i++)
			{
				if (_variables[i].name == name)
				{
					return _variables[i];
				}
			}
			return null;
		}
	}
}

