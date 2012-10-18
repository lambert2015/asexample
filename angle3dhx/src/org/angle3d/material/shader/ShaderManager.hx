package org.angle3d.material.shader;

import flash.display3D.Context3D;
import flash.display3D.Program3D;
import flash.utils.ByteArray;
import org.angle3d.material.hgal.ShaderCompiler;
import org.angle3d.utils.HashMap;
import org.angle3d.utils.Logger;

/**
 * 注册和注销Shader管理
 * @author andy
 */
class ShaderManager 
{
	public static var instance:ShaderManager = new ShaderManager();

	private var _shaderMap:HashMap<String,Shader>;
	private var _programMap:HashMap<String,Program3D>;
	private var _shaderCount:HashMap<String,Int>;
	private var _shaderCompiler:ShaderCompiler;

	public function new() 
	{
		_shaderMap = new HashMap<String,Shader>();
		_programMap = new HashMap<String,Program3D>();
		_shaderCount = new HashMap<String,Int>();
		
		_shaderCompiler = new ShaderCompiler();
	}
	
	public function isRegistered(key:String):Bool
	{
		return _shaderMap.containsKey(key);
	}
	
	public function getShader(key:String):Shader
	{
		return _shaderMap.getValue(key);
	}
	
	/**
	 * 注册一个Shader
	 * @param	key
	 * @param	vertexData
	 * @param	fragmentData
	 */
	public function registerShader(key:String, sources:Array<String>, conditions:Array<Array<String>> = null):Shader
	{
		var shader:Shader = _shaderMap.getValue(key);
		if (shader == null)
		{
			shader = _shaderCompiler.complie(sources, conditions);
			shader.name = key;
			
		    _shaderMap.setValue(key, shader);
		}

		//使用次数+1
		if (_shaderCount.containsKey(key) && !Math.isNaN(_shaderCount.getValue(key)))
		{
			_shaderCount.setValue(key, _shaderCount.getValue(key) + 1);
		}
		else
		{
			_shaderCount.setValue(key, 1);
		}
		
		#if debug
		Logger.log("[REGISTER SHADER]" + key + " count:" + _shaderCount.getValue(key));
		#end
		
		return shader;
	}
	
	/**
	 * 注销一个Shader,Shader引用为0时销毁对应的Progame3D
	 * @param	key
	 */
	public function unregisterShader(key:String):Void
	{
		if (_shaderCount.getValue(key) == 1)
		{
			_shaderMap.delete(key);
			_shaderCount.delete(key);
			
			var program:Program3D = _programMap.delete(key);
			if (program != null)
			{
				program.dispose();
			}
		}
		else
		{
			_shaderCount.setValue(key, _shaderCount.getValue(key) - 1);
			
			#if debug
			Logger.log("[UNREGISTER SHADER]" + key + " count:" + _shaderCount.getValue(key));
			#end
		}
	}
	
	public function getProgram(key:String, context:Context3D):Program3D
	{
		if (!_programMap.containsKey(key))
		{
			var shader:Shader = _shaderMap.getValue(key);
			if (shader == null)
			{
				return null;
			}
			
			var program:Program3D = context.createProgram();
			program.upload(shader.vertexData, shader.fragmentData);
			
			_programMap.setValue(key, program);
		}
		return _programMap.getValue(key);
	}
	
}