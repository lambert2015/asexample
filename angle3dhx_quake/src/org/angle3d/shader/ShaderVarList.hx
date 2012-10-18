package org.angle3d.shader;
import flash.Vector;

/**
 * ShaderVariable List
 * @author 
 */
class ShaderVarList 
{
	private var _variables:Vector<ShaderVar>;

	public function new() 
	{
		_variables = new Vector<ShaderVar>();
	}
	
	public function addVariable(value:ShaderVar):Void
	{
		_variables.push(value);
	}
	
	/**
	 * read only
	 * @return
	 */
	public function getVariables():Vector<ShaderVar>
	{
		return _variables;
	}
	
	/**
	 * 添加所有变量后，设置每个变量的位置
	 */
	public function arrange():Void
	{
		//默认是按照在数组中的顺序来设置location
		for (i in 0..._variables.length)
		{
			var sv:ShaderVar = _variables[i];
			sv.setLocation(i);
		}
	}
	
	public function getSize(name:String):Int
	{
		var v:ShaderVar = getVariable(name);
		if (v != null)
		{
			return v.getSize();
		}
		
		return -1;
	}
	
	public function getLocation(name:String):Int
	{
		var v:ShaderVar = getVariable(name);
		if (v != null)
		{
			return v.getLocation();
		}
		return -1;
	}
	
	public function getIndex(name:String):Int
	{
		for (i in 0..._variables.length)
		{
			if (_variables[i].name == name)
			{
				return i;
			}
		}
		return -1;
	}
	
	public function getVariableAt(index:Int):ShaderVar
	{
		return _variables[index];
	}
	
	public function getVariable(name:String):ShaderVar
	{
		for (i in 0..._variables.length)
		{
			if (_variables[i].name == name)
			{
				return _variables[i];
			}
		}
		return null;
	}
	
}