package org.angle3d.material.shader;

import flash.utils.ByteArray;
import flash.utils.Dictionary;

import org.angle3d.manager.ShaderManager;
import org.angle3d.renderer.IRenderer;

/**
 * 一个Shader是一个Technique中的一个实现，Technique根据不同的条件生成不同的Shader
 */
//TODO 优化
class Shader
{
	//vertex
	private var _vUniformList:UniformList;
	private var _attributeList:AttributeList;

	//fragment
	private var _fUniformList:UniformList;
	private var _textureList:ShaderVariableList;

	private var _bindUniforms:Vector<Uniform>;

	private var _bindAttributes:Dictionary;

	public var vertexData:ByteArray;
	public var fragmentData:ByteArray;

	public var name:String;

	public function new()
	{
		_attributeList = new AttributeList();
		_vUniformList = new UniformList();
		_fUniformList = new UniformList();
		_textureList = new ShaderVariableList();

		_bindUniforms = new Vector<Uniform>();
		_bindAttributes = new Dictionary();
	}

	public function addVariable(shaderType:String, type:Int, name:String, size:Int):Void
	{
		switch (type)
		{
			case ShaderVarType.ATTRIBUTE:
				_attributeList.addVariable(new AttributeVar(name, size));
				break;
			case ShaderVarType.UNIFORM:
				getUniformList(shaderType).addVariable(new Uniform(name, size));
				break;
			case ShaderVarType.TEXTURE:
				_textureList.addVariable(new TextureVariable(name, size));
				break;
		}
	}

	/**
	 *
	 * @param	shaderType
	 * @param	digits
	 */
	public function setConstants(shaderType:String, digits:Vector<Vector<Float>>):Void
	{
		var list:UniformList = getUniformList(shaderType);

		list.setConstants(digits);
	}

	public function getTextureVar(name:String):TextureVariable
	{
		return cast _textureList.getVariable(name);
	}

	//TODO 添加方法根据类型来获得AttributeVar
	public function getAttributeByName(name:String):AttributeVar
	{
		return cast _attributeList.getVariable(name);
	}

	
	public function getTextureList():ShaderVariableList
	{
		return _textureList;
	}

	
	public function getUniformList(shaderType:String):UniformList
	{
		return (shaderType == ShaderType.VERTEX) ? _vUniformList : _fUniformList;
	}

	private var mShaderTypes:Array = [ShaderType.VERTEX, ShaderType.FRAGMENT];

	public function uploadTexture(render:IRenderer):Void
	{
		//上传贴图
		var textures:Vector<ShaderVariable> = _textureList.getVariables();
		var size:Int = textures.length;
		for (i in 0...size)
		{
			var tex:TextureVariable = cast textures[i];
			render.setTextureAt(tex.location, tex.textureMap);
		}
	}

	//TODO 这里可以测试是否可以合并数据，一次提交数据
	public function upload(render:IRenderer):Void
	{
		for (i in 0...2)
		{
			var type:String = mShaderTypes[i];

			//上传常量
			_uploadConstants(render, type);

			//其他自定义数据
			var list:UniformList = getUniformList(type);
			var uniforms:Vector<ShaderVariable> = list.getUniforms();
			var size:Int = uniforms.length;
			var uniform:Uniform;
			for (j in 0...size)
			{
				uniform = list.getUniformAt(j);
				render.setShaderConstants(type, uniform.location, uniform.data, uniform.size);
			}
		}
	}

	/**
	 * 常量总最先传
	 * @param	type
	 */
	private function _uploadConstants(render:IRenderer, shaderType:String):Void
	{
		var digits:Vector<Vector<Float>> = getUniformList(shaderType).getConstants();

		if (digits == null)
			return;

		var length:Int = digits.length;
		for (i in 0...length)
		{
			render.setShaderConstants(shaderType, i, digits[i], 1);
		}
	}

	public function setUniform(type:String, name:String, data:Vector<Float>):Void
	{
		var uniform:Uniform = getUniform(type, name);
		if (uniform != null)
		{
			uniform.setVector(data);
		}
	}

	public function getUniform(type:String, name:String):Uniform
	{
		return cast getUniformList(type).getVariable(name);
	}

	public function getAttributes():Dictionary
	{
		return _bindAttributes;
	}

	public function bindAttribute(bufferType:String, name:String):Void
	{
		_bindAttributes[bufferType] = _attributeList.getVariable(name);
	}

	public function getAttribute(bufferType:String):AttributeVar
	{
		return _bindAttributes[bufferType];
	}

	/**
	 * 设置由系统自动计算传递数据的一些Uniform，例如worldViewProjectionMatrix
	 * @param	type
	 * @param	name
	 * @param	bd
	 */
	public function bindUniform(type:String, name:String, bd:Int):Void
	{
		var uniform:Uniform = getUniform(type, name);
		if (uniform != null)
		{
			uniform.binding = bd;
			_bindUniforms.push(uniform);
		}
	}

	/**
	 * Returns a list of uniforms that implements the world parameters
	 * that were requested by the material definition.
	 *
	 * @return a list of uniforms implementing the world parameters.
	 */
	public function getBindUniforms():Vector<Uniform>
	{
		return _bindUniforms;
	}

	/**
	 *
	 */
	public function build():Void
	{
		_attributeList.build();
		_vUniformList.build();
		_fUniformList.build();
		_textureList.build();
	}

	public function destroy():Void
	{
		_vUniformList = null;
		_fUniformList = null;
		_textureList = null;
		_attributeList = null;
		_bindUniforms = null;
		vertexData = null;
		fragmentData = null;
		ShaderManager.instance.unregisterShader(name);
	}

	/**
	 * 设置系统绑定的Uniform
	 */
	public function setUniformBindings(binds:Vector<UniformBindingHelp>):Void
	{
		var bLength:Int = binds.length;
		for (i in 0...bLength)
		{
			var help:UniformBindingHelp = binds[i];
			bindUniform(help.shaderType, help.name, help.bindType);
		}
	}

	/**
	 * 设置系统绑定的Attribute
	 */
	public function setAttributeBindings(attributeMap:Dictionary):Void
	{
		var bufferType:String;
		for (bufferType in attributeMap)
		{
			bindAttribute(bufferType, attributeMap[bufferType]);
		}
	}
}

