package org.angle3d.shader.hgal.core;

import flash.Vector;
import org.angle3d.shader.hgal.core.pool.AttributeRegPool;
import org.angle3d.shader.hgal.core.pool.TextureRegPool;
import org.angle3d.shader.hgal.core.pool.TempRegPool;
import org.angle3d.shader.hgal.core.pool.UniformRegPool;
import org.angle3d.shader.hgal.core.pool.VaryingRegPool;
import org.angle3d.shader.hgal.core.reg.Reg;
import org.angle3d.shader.hgal.core.reg.OcReg;
import org.angle3d.shader.hgal.core.reg.OpReg;
import org.angle3d.shader.hgal.core.reg.TempReg;
import org.angle3d.shader.hgal.core.reg.UniformReg;
import org.angle3d.shader.Shader;
import org.angle3d.shader.ShaderType;
import org.angle3d.shader.ShaderVarType;
import org.angle3d.utils.Assert;
import org.angle3d.utils.HashMap;
/**
 * ...
 * @author andy
 */
class CompileData 
{
	/**
	 * Shader类型
	 */
	public var shaderType:String;
	
	public var codes:Vector<Code>;
	
	public var attributePool:AttributeRegPool;
	public var uniformPool:UniformRegPool;
	public var varyingPool:VaryingRegPool;
	public var texturePool:TextureRegPool;
	
	private var _tempPool:TempRegPool;
	
	/**
	 * 所有变量的集合
	 */
	private var _regsMap:HashMap<String,Reg>;

	public function new(shaderType:String) 
	{
		this.shaderType = shaderType;
		
		codes = new Vector<Code>();
		
		_regsMap = new HashMap<String,Reg>();
		
		_tempPool = new TempRegPool();
		uniformPool = new UniformRegPool(shaderType);
		if (shaderType == ShaderType.VERTEX)
		{
			attributePool = new AttributeRegPool();
			varyingPool = new VaryingRegPool();
			
			//加入op
			addReg(new OpReg());
		}
		else
		{
			texturePool = new TextureRegPool();

			//加入oc
			addReg(new OcReg());
		}
	}

	public function clear():Void
	{
		codes.length = 0;
		
		_regsMap.clear();
		
		_tempPool.clear();
		uniformPool.clear();
		if (shaderType == ShaderType.VERTEX)
		{
			attributePool.clear();
			varyingPool.clear();
			//加入op
			addReg(new OpReg());
		}
		else
		{
			texturePool.clear();
			//加入oc
			addReg(new OcReg());
		}
	}
	
	public inline function addCode(code:Code):Void
	{
		codes.push(code);
	}
	
	/**
	 * 复制Varying数据
	 * @param	other
	 */
	public function copyVaryingFrom(other:CompileData):Void
	{
		#if debug
		Assert.assert(shaderType == ShaderType.FRAGMENT, "share只能在Fragment中调用");
		#end
		
		var pool:VaryingRegPool = other.varyingPool;
		
		var variables:Vector<Reg> = pool.getRegs();
		for (i in 0...variables.length)
		{
			var value:Reg = variables[i];
			
			#if debug
			Assert.assert(!_regsMap.containsKey(value.name), value.name + "变量名定义重复,此变量名已经被varying使用");
			#end
		
			_regsMap.setValue(value.name, value);
		}
	}
	
	/**
	 * 添加变量到对应的寄存器池中
	 * @param	value
	 */
	public function addReg(value:Reg):Void
	{
		#if debug
		Assert.assert(value != null, "变量不存在");
		#end
		
		switch(value.varKind)
		{
			case VarKind.KIND_ATTRIBUTE:
				attributePool.addReg(value);
				#if debug
				Assert.assert(shaderType == ShaderType.VERTEX, "AttributeVar只能定义在Vertex中");	
				#end
			case VarKind.KIND_TEXTURE:
				texturePool.addReg(value);
				#if debug
			    Assert.assert(shaderType == ShaderType.FRAGMENT, "SamplerVar只能定义在Fragment中");
				#end
			case VarKind.KIND_TEMP:
				_tempPool.addReg(value);	
			case VarKind.KIND_UNIFORM:
				uniformPool.addReg(value);	
			case VarKind.KIND_VARYING:
				varyingPool.addReg(value);	
			case VarKind.KIND_SPECIAL:
				//do nothing
			default:
				#if debug
				Assert.assert(false, "未定义类型");
				#end
		}
		
		#if debug
		Assert.assert(!_regsMap.containsKey(value.name), value.name + "变量名定义重复");
		#end
		
		_regsMap.setValue(value.name, value);
	}
	
	/**
	 * 根据name获取对应的变量
	 * @param	name
	 * @return
	 */
	public inline function getReg(name:String):Reg
	{
		var tVar:Reg = _regsMap.getValue(name);
		
		#if debug
		Assert.assert(tVar != null, name + "变量未定义，请检查脚本");
		#end
		
		return tVar;
	}
	
	public inline function addDigit(value:Float):Void
	{
		//加入到_uniformPool中
		uniformPool.addDigit(value);
	}
	
	public inline function getDigitParam(shaderType:String,value:Float):CodeParam
	{
		var codeParam:CodeParam = new CodeParam();
		
		var reg:UniformReg = new UniformReg(shaderType, VarType.TYPE_FLOAT, value + "");
		reg.index = uniformPool.getDigitIndex(value);
		
		codeParam.reg = reg;
		codeParam.swizzle = [uniformPool.getDigitComponent(value)];
		
		return codeParam;
	}

	/**
	 * 注册所有Reg，设置它们的位置
	 */
	public function arrange():Void
	{
		if (shaderType == ShaderType.VERTEX)
		{
			attributePool.arrange();
			varyingPool.arrange();
		}
		else
		{
			texturePool.arrange();
		}
		uniformPool.arrange();
		

		//添加所有临时变量到一个数组中
		var tempList:Vector<TempReg> = _getTempRegs();
		_registerTempVar(tempList);
		
		//TODO 看看是否有办法不使用初始化，毕竟占了最多8个语句
		//需要在头部初始化所有临时变量的代码
		//在最前端加上初始化临时变量的语句
		//而且极有可能结果出错
		var maxReg:Int = _tempPool.getMaxReg();
		//if (maxReg > 0)
		//{
			//var list:Vector<Code> = new Vector<Code>();
			//for (i in 0...maxReg)
			//{
				//var code:Code = new Code(shaderType);
				//
				//code.opCode = OpCodeManager.getInstance().getCode("mov");
				//
				//var destParam:CodeParam = new CodeParam();
				//destParam.reg = new TempReg(shaderType, VarType.TYPE_VEC4, "tmp_" + i);
				//destParam.reg.index = i;
				//destParam.swizzle = ["x","y","z","w"];
				//
				//var param1:CodeParam = getDigitParam(shaderType, 0.0);
				//
				//code.dest = destParam;
				//
				//code.addParam(param1);
				//
				//list.push(code);
			//}
			//
			//codes = list.concat(codes);
		//}
	}

	/**
	 * 递归注册和释放临时变量
	 * @param	list
	 */
	private function _registerTempVar(list:Vector<TempReg>):Void
	{
		if (list.length > 0)
		{
			//取出第一个临时变量
			var tempVar:TempReg = list.shift();
			
			//未注册
			if (!tempVar.isRegistered())
			{
				//注册
				_tempPool.register(tempVar);
			}
			
			//如果数组中剩余项不包含这个变量，也就代表无引用了
			if (list.indexOf(tempVar) == -1)
			{
				//可以释放其占用位置
				_tempPool.logout(tempVar);
			}
			
			//递归锁定和释放，直到数组为空
			_registerTempVar(list);
		}
	}

	/**
	 * 获得所有临时变量
	 * @return
	 */
	private function _getTempRegs():Vector<TempReg>
	{
		var tempList:Vector<TempReg> = new Vector<TempReg>();
		for (i in 0...codes.length)
		{
			tempList = tempList.concat(codes[i].getTempRegs());
		}
		return tempList;
	}
	
}