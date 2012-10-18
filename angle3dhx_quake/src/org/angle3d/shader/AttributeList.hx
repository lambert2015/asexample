package org.angle3d.shader;
import flash.display3D.Context3DVertexBufferFormat;

class AttributeList extends ShaderVarList
{
	public function new() 
	{
		super();
	}
	
	/**
	 * 
	 * @param	name
	 * @return
	 */
	public function getFormat(name:String):Context3DVertexBufferFormat
	{
		var size:Int = getSize(name);
		switch(size)
		{
			case 1:
				return Context3DVertexBufferFormat.FLOAT_1;
			case 2:
				return Context3DVertexBufferFormat.FLOAT_2;
			case 3:
				return Context3DVertexBufferFormat.FLOAT_3;
			case 4:
				return Context3DVertexBufferFormat.FLOAT_4;
			default:
				return null;
		}
	}
	
	override public function arrange():Void
	{
		var offset:Int = 0;
		for (i in 0..._variables.length)
		{
			var sv:ShaderVar = _variables[i];
			
			sv.setLocation(offset);
			
			offset += sv.getSize();
		}
	}
}