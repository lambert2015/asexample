package org.angle3d.material.shader
{

	/**
	 * ...
	 * @author andy
	 */
	public class UniformBindingHelp
	{
		public var shaderType:String;

		public var name:String;

		public var bindType:int;

		public function UniformBindingHelp(shaderType:String, name:String, bindType:int)
		{
			this.shaderType = shaderType;
			this.name = name;
			this.bindType = bindType;
		}
	}
}

