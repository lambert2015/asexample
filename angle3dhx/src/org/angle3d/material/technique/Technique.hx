package org.angle3d.material.technique;

import flash.display3D.Program3D;
import flash.Vector;
import org.angle3d.light.LightType;
import org.angle3d.material.RenderState;
import org.angle3d.scene.mesh.MeshType;
import org.angle3d.material.shader.Shader;
import org.angle3d.material.shader.ShaderManager;
import org.angle3d.material.shader.UniformBinding;
import org.angle3d.material.shader.UniformBindingHelp;
import org.angle3d.utils.HashMap;

/**
 * Technique可能对应多个Shader
 * @author andy
 */
class Technique 
{
	private var _name:String;
	
	private var _shaderMap:HashMap<String,Shader>;
	private var _optionMap:HashMap<String,Array<Array<String>>>;

	private var _renderState:RenderState;
	
	private var _requiresLight:Bool;
	public var requiresLight(_getRequiresLight, _setRequiresLight):Bool;
	
	private var _bindUniforms:Vector<UniformBindingHelp>;

	public function new(name:String) 
	{
		_initInternal();
		
		_name = name;
	}
	
	public function getName():String
	{
		return _name;
	}
	
	public function getRenderState():RenderState
	{
		return _renderState;
	}
	
	/**
	 * 更新Shader属性
	 * 
	 * @param	shader
	 */
	public function updateShader(shader:Shader):Void
	{
		
	}
	
	/**
	 * 获取Shader时，需要更新其UniformBinding
	 * @param	lightType
	 * @param	meshKey
	 * @return
	 */
	public function getShader(lightType:Int = -1, meshKey:Int = 0):Shader
	{
		var key:String = _getKey(lightType, meshKey);
		
		var shader:Shader = _shaderMap.getValue(key);

		if (shader == null)
		{
			shader = ShaderManager.instance.registerShader(key, 
			                               [getVertexSource(), getFragmentSource()],
										   _getOption(lightType,meshKey));
			
			shader.setUniformBinding(_bindUniforms);
			
			_shaderMap.setValue(key, shader);
		}

		return shader;
	}
	
	private function _initInternal():Void
	{
		_shaderMap = new HashMap<String,Shader>();
		_optionMap = new HashMap<String,Array<Array<String>>>();

		_renderState = new RenderState();
		_requiresLight = false;
		
		_bindUniforms = new Vector<UniformBindingHelp>();
		_initUniformBindings();
	}
	
	private function _initUniformBindings():Void
	{
		
	}
	
	private function _getRequiresLight():Bool
	{
		return _requiresLight;
	}
	
	private function _setRequiresLight(value:Bool):Bool
	{
		_requiresLight = value;
		return _requiresLight;
	}
	
	private function addUniformBinding(type:String, name:String, bind:Int):Void
	{
		_bindUniforms.push(new UniformBindingHelp(type, name, bind));
	}
	
	private function getVertexSource():String
	{
		return "";
	}
	
	private function getFragmentSource():String
	{
		return "";
	}
	
	private function _getOption(lightType:Int = -1, meshType:Int = 0):Array<Array<String>>
	{
		var key:String = _getKey(lightType, meshType);
		
		if (!_optionMap.containsKey(key))
		{
			_optionMap.setValue(key, _createOption(lightType, meshType));
		}
	    return _optionMap.getValue(key);
	}
	
	private function _createOption(lightType:Int = -1, meshType:Int = 0):Array<Array<String>>
	{
		return null;
	}
	
	private function _getKey(lightType:Int = -1, meshType:Int = 0):String
	{
		var result:String = _name;
		
		if (lightType != -1)
		{
			result += "_LightType" + lightType;
		}
		
		if (meshType != 0)
		{
			result += "_MeshType" + meshType;
		}
		
		return result;
	}
	
}