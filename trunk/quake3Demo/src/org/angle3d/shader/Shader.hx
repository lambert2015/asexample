package org.angle3d.shader;

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.display3D.Program3D;
import flash.display3D.VertexBuffer3D;
import flash.Lib;
import flash.utils.ByteArray;
import flash.Vector;
import org.angle3d.shader.hgal.ShaderCompiler;
import org.angle3d.utils.Logger;

class Shader
{
	//vertex
	private var _vUniformList:UniformList;
	private var _attributeList:AttributeList;

	//fragment
	private var _fUniformList:UniformList;
	private var _textureList:ShaderVarList;
	
	private var _vBindUniforms:Vector<Uniform>;
	private var _fBindUniforms:Vector<Uniform>;

    private var _vertexSource:String;
	private var _fragmentSource:String;
	private var _compiler:ShaderCompiler;
	
	private var _vertexData:ByteArray;
	private var _fragmentData:ByteArray;

	/**
	 * 是否编译了
	 */
	private var _compiled:Bool;
	
	/**
	 * 是否改变了，改变后需要重新上传
	 */
	private var _needUpload:Bool;
	
	private var _program:Program3D;
	
	public function new() 
	{
		var debug:Bool = false;
		#if debug
		    debug = true;
		#end
		
		_attributeList = new AttributeList();
		_vUniformList = new UniformList();
		_fUniformList = new UniformList();
		_textureList = new ShaderVarList();
		
		_vBindUniforms = new Vector<Uniform>();
		_fBindUniforms = new Vector<Uniform>();
		
		_compiler = new ShaderCompiler();

		_compiled = false;
		_needUpload = true;
	}
	
	public function getProgram3D():Program3D
	{
		return _program;
	}
	
	public function setSource(vertex:String,fragment:String):Void
	{
		_vertexSource = vertex;
		_fragmentSource = fragment;
		compile();
	}
	
	public function setVertexData(data:ByteArray):Void
	{
		_vertexData = data;
	}
	
	public function getVertexData():ByteArray
	{
		return _vertexData;
	}
	
	public function setFragmentData(data:ByteArray):Void
	{
		_fragmentData = data;
	}
	
	public function getFragmentData():ByteArray
	{
		return _fragmentData;
	}


	public function addVariable(shaderType:String,type:ShaderVarType,name:String,size:Int):Void
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
	
	public function getUniformBinds(shaderType:String):Vector<Uniform>
	{
		return (shaderType == ShaderType.VERTEX) ? _vBindUniforms : _fBindUniforms;
	}

	public function uploadUniform(context:Context3D):Void
	{
		if (_needUpload)
		{
			uploadProgram(context);
		}
		
		context.setProgram(_program);
		
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
			context.setTextureAt(tex.getLocation(), tex.getTexture());
		}
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
		uniform.setVector(data);
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
	public function bindUniform(type:String,name:String, bd:UniformBinding):Void
	{
		var uniform:Uniform = getUniform(type, name);
		if (uniform != null)
		{
			uniform.setBinding(bd);
			getBindUniforms(type).push(uniform);
		}
	}

	/**
     * Returns a list of uniforms that implements the world parameters
     * that were requested by the material definition.
     * 
     * @return a list of uniforms implementing the world parameters.
     */
    public function getBindUniforms(type:String):Vector<Uniform>
	{
        if (type == ShaderType.VERTEX)
		{
			return _vBindUniforms;
		}
		else
		{
			return _fBindUniforms;
		}
    }
	
	/**
	 * 内部使用
	 * @param	name
	 * @param	buffer
	 * @param	offset 为-1的话会自动设置为内部偏移量
	 */
	public function setAttribute(context:Context3D,name:String, buffer:VertexBuffer3D, offset:Int = -1):Void
	{
		if (offset <= -1)
		{
			offset = _attributeList.getLocation(name);
		}
		context.setVertexBufferAt(_attributeList.getIndex(name), buffer, offset, _attributeList.getFormat(name));
	}
	
	/**
	 * 编译Shader
	 */
	private function compile():Void
	{
		#if debug
		var time:Int = Lib.getTimer();
		#end
		
		_compiler.complie(_vertexSource, _fragmentSource, this);
			
		arrange();
			
		setUniformBinding();
			
		_compiled = true;
		
		_needUpload = true;
		
		#if debug
		Logger.log("complie time = " + (Lib.getTimer() - time) + "ms");
		#end
	}
	
	/**
	 * 
	 */
	private function arrange():Void
	{
		_attributeList.arrange();
		_vUniformList.arrange();
		_fUniformList.arrange();
		_textureList.arrange();
	}
	
	/**
	 * 上传到GPU，内部使用
	 * @param	context
	 */
	public function uploadProgram(context:Context3D):Void
	{
		if (_program == null)
		{
			_program = context.createProgram();
		}
		
		if (_needUpload)
		{
			_program.upload(_vertexData, _fragmentData);
			
			_needUpload = false;
		}
	}
	
	/**
	 * 获取未系统绑定的Uniform
	 * @param	type
	 * @return
	 */
    public function getUnBindUniforms(type:String):Vector<Uniform>
	{
		var list:UniformList = getUniformList(type);
        
		var variables:Vector<ShaderVar> = list.getVariables();
		
		var results:Vector<Uniform> = new Vector<Uniform>();
		for (i in 0...variables.length)
		{
			var uniform:Uniform = Lib.as(variables[i], Uniform);
			if (uniform.getBinding() == null)
			{
				results.push(uniform);
			}
		}
		
		return results;
    }
	
	/**
	 * Shader是否已编译
	 * @return
	 */
	public function isCompiled():Bool
	{
		return _compiled;
	}
	
	/**
	 * 设置系统绑定的Uniform
	 */
	private function setUniformBinding():Void
	{
		
	}
}