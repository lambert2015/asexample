package org.angle3d.material.shader;

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.display3D.VertexBuffer3D;
import flash.Lib;
import flash.utils.ByteArray;
import flash.Vector;
import org.angle3d.texture.TextureMapBase;

/**
 * 一个Shader是一个Technique中的一个实现，Technique根据不同的条件生成不同的Shader
 */
class Shader
{
	//vertex
	private var _vUniformList:UniformList;
	private var _attributeList:AttributeList;

	//fragment
	private var _fUniformList:UniformList;
	private var _textureList:ShaderVarList;
	
	private var _bindUniforms:Vector<Uniform>;

	public var vertexData:ByteArray;
	public var fragmentData:ByteArray;
	
	public var name:String;
	
	public function new() 
	{
		_attributeList = new AttributeList();
		_vUniformList = new UniformList();
		_fUniformList = new UniformList();
		_textureList = new ShaderVarList();
		
		_bindUniforms = new Vector<Uniform>();
	}
	
	public function addVariable(shaderType:String,type:Int,name:String,size:Int):Void
	{
		switch(type)
		{
			case ShaderVarType.ATTRIBUTE:
				_attributeList.addVariable(new AttributeVar(name, size));
			case ShaderVarType.UNIFORM:
				getUniformList(shaderType).addVariable(new Uniform(name, size));
			case ShaderVarType.TEXTURE:
				_textureList.addVariable(new TextureVar(name,size));
		}
	}
	
	/**
	 * 
	 * @param	shaderType
	 * @param	digits
	 */
	public function setDigits(shaderType:String,digits:Vector<Vector<Float>>):Void
	{
		var list:UniformList = getUniformList(shaderType);
		
		list.setDigits(digits);
	}
	
	public function getProgramType(type:String):Context3DProgramType
	{
		if (type == ShaderType.VERTEX)
		{
			return Context3DProgramType.VERTEX;
		}
		else
		{
			return Context3DProgramType.FRAGMENT;
		}
	}

	public function getTextureVar(name:String):TextureVar
	{
		return Lib.as(_textureList.getVariable(name),TextureVar);
	}
	
	public function getAttribute(name:String):AttributeVar
	{
		return Lib.as(_attributeList.getVariable(name),AttributeVar);
	}
	
	public function getTextureList():ShaderVarList
	{
		return _textureList;
	}
	
	public function getUniformList(shaderType:String):UniformList
	{
		return (shaderType == ShaderType.VERTEX) ? _vUniformList : _fUniformList;
	}

	public function uploadShader(context:Context3D):Void
	{
		var types:Array<String> = [ShaderType.VERTEX, ShaderType.FRAGMENT];
		for (i in 0...2)
		{
			var type:String = types[i];
			
			//上传常量
			_uploadUniformDigits(context,type);
		
			//其他自定义数据
			var list:UniformList = getUniformList(type);
			var uniforms:Vector<ShaderVar> = list.getUniforms();
			for (i in 0...uniforms.length)
			{
				var uniform:Uniform = list.getUniformAt(i);
				context.setProgramConstantsFromVector(getProgramType(type), 
			        	uniform.getLocation(), 
						uniform.getValue(), 
						uniform.getSize());
			}
		}
		
		//上传贴图
		var variables:Vector<ShaderVar> = _textureList.getVariables();
		for (i in 0...variables.length)
		{
			var tex:TextureVar =  Lib.as(variables[i], TextureVar);
			setTextureAt(context, tex.getLocation(), tex.textureMap);
		}
	}
	
	private inline function setTextureAt(context:Context3D, index:Int, map:TextureMapBase):Void
	{
		context.setTextureAt(index,map.getTexture(context));
	}
	
	/**
	 * 常量总最先传
	 * @param	type
	 */
	private function _uploadUniformDigits(context:Context3D,type:String):Void
	{
		var digits:Vector<Vector<Float>> = getUniformList(type).getDigits();
		
		if (digits == null)
		    return;
			
		for (i in 0...digits.length)
		{
			context.setProgramConstantsFromVector(getProgramType(type), i, digits[i]);
		}
	}
	
	public function setUniform(type:String,name:String, data:Vector<Float>):Void
	{
		var uniform:Uniform = Lib.as(getUniformList(type).getVariable(name), Uniform);
		if (uniform != null)
		{
			uniform.setVector(data);
		}
	}
	
	public function getUniform(type:String,name:String):Uniform
	{
		return Lib.as(getUniformList(type).getVariable(name),Uniform);
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
			uniform.setBinding(bd);
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
	 * 内部使用
	 * @param	name
	 * @param	buffer
	 * @param	offset 为-1的话会自动设置为内部偏移量
	 */
	public function setAttribute(context:Context3D,name:String, buffer:VertexBuffer3D):Void
	{
		context.setVertexBufferAt(_attributeList.getIndex(name), buffer, _attributeList.getLocation(name), _attributeList.getFormat(name));
	}
	
	/**
	 * 
	 */
	public function validate():Void
	{
		_attributeList.validate();
		_vUniformList.validate();
		_fUniformList.validate();
		_textureList.validate();
	}
	
	public function destroy():Void
	{
		ShaderManager.instance.unregisterShader(name);
	}
	
	/**
	 * 设置系统绑定的Uniform
	 */
	public function setUniformBinding(binds:Vector<UniformBindingHelp>):Void
	{
		for (i in 0...binds.length)
		{
			var help:UniformBindingHelp = binds[i];
			bindUniform(help.type, help.name, help.bind);
		}
	}
}