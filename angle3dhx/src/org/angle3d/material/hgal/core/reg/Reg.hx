package org.angle3d.material.hgal.core.reg;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.material.hgal.core.VarKind;
import org.angle3d.utils.Assert;
import org.angle3d.material.hgal.core.VarType;

/**
 * HGAL中的变量
 * @author andy 
 */
class Reg 
{
	public var shaderType:String;
	
	public var varKind:String;
	
	public var varType:String;
	
	public var name:String;//名称

	//注册地址
	public var index:Int;
	
	public var size:Int;
	
	public var emitCode:UInt;
	
	//标识
	public var flags : UInt;
	
	//范围
	public var range : UInt;

	public function new(shaderType:String,kind:String,type:String,name:String) 
	{
		this.shaderType = shaderType;
		this.varKind = kind;
		this.varType = type;
		this.name = name;
		
		size = VarType.getLength(varType);
		
		index = -1;
	}
	
	public function isRegistered():Bool
	{
		return index > -1;
	}	
	
	/**
	 * 获取其在agal中的真实名词，只有在变量锁定之后调用这里才是正确的
	 * @return
	 */
	public function toAgal():String
	{
		#if debug
		Assert.assert(isRegistered(), "变量还未注册，不能获得其agal代码");
		#end
		
		return getPrefix() + index;
	}
	
	public function getPrefix():String
	{
		return "";
	}
}