package org.angle3d.material.shader
{

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.angle3d.manager.ShaderManager;
	import org.angle3d.renderer.IRenderer;

	/**
	 * 一个Shader是一个Technique中的一个实现，Technique根据不同的条件生成不同的Shader
	 */
	//TODO 优化
	public class Shader
	{
		//vertex
		private var _vUniformList:UniformList;
		private var _attributeList:AttributeList;

		//fragment
		private var _fUniformList:UniformList;
		private var _textureList:ShaderVariableList;

		private var _bindUniforms:Vector.<Uniform>;

		private var _bindAttributes:Dictionary;

		public var vertexData:ByteArray;
		public var fragmentData:ByteArray;

		public var name:String;

		public function Shader()
		{
			_attributeList = new AttributeList();
			_vUniformList = new UniformList();
			_fUniformList = new UniformList();
			_textureList = new ShaderVariableList();

			_bindUniforms = new Vector.<Uniform>();
			_bindAttributes = new Dictionary();
		}

		public function addVariable(shaderType:String, type:int, name:String, size:int):void
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
		public function setConstants(shaderType:String, digits:Vector.<Vector.<Number>>):void
		{
			var list:UniformList = getUniformList(shaderType);

			list.setConstants(digits);
		}

		public function getTextureVar(name:String):TextureVariable
		{
			return _textureList.getVariable(name) as TextureVariable;
		}

		//TODO 添加方法根据类型来获得AttributeVar
		public function getAttributeByName(name:String):AttributeVar
		{
			return _attributeList.getVariable(name) as AttributeVar;
		}

		[Inline]
		public final function getTextureList():ShaderVariableList
		{
			return _textureList;
		}

		[Inline]
		public final function getUniformList(shaderType:String):UniformList
		{
			return (shaderType == ShaderType.VERTEX) ? _vUniformList : _fUniformList;
		}

		private var mShaderTypes:Array = [ShaderType.VERTEX, ShaderType.FRAGMENT];

		public function upload(render:IRenderer):void
		{
			//上传贴图
			var textures:Vector.<ShaderVariable> = _textureList.getVariables();
			var vLength:int = textures.length;
			for (i = 0; i < vLength; i++)
			{
				var tex:TextureVariable = textures[i] as TextureVariable;
				render.setTextureAt(tex.location, tex.textureMap);
			}
			
			for (var i:int = 0; i < 2; i++)
			{
				var type:String = mShaderTypes[i];

				//上传常量
				_uploadConstants(render, type);

				//其他自定义数据
				var list:UniformList = getUniformList(type);
				var uniforms:Vector.<ShaderVariable> = list.getUniforms();
				var size:int = uniforms.length;
				var uniform:Uniform;
				for (var j:int = 0; j < size; j++)
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
		private function _uploadConstants(render:IRenderer, shaderType:String):void
		{
			var digits:Vector.<Vector.<Number>> = getUniformList(shaderType).getConstants();

			if (digits == null)
				return;

			var length:int = digits.length;
			for (var i:int = 0; i < length; i++)
			{
				render.setShaderConstants(shaderType, i, digits[i], 1);
			}
		}

		public function setUniform(type:String, name:String, data:Vector.<Number>):void
		{
			var uniform:Uniform = getUniform(type, name);
			if (uniform != null)
			{
				uniform.setVector(data);
			}
		}

		public function getUniform(type:String, name:String):Uniform
		{
			return getUniformList(type).getVariable(name) as Uniform;
		}

		public function getAttributes():Dictionary
		{
			return _bindAttributes;
		}

		public function bindAttribute(bufferType:String, name:String):void
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
		public function bindUniform(type:String, name:String, bd:int):void
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
		public function getBindUniforms():Vector.<Uniform>
		{
			return _bindUniforms;
		}

		/**
		 *
		 */
		public function validate():void
		{
			_attributeList.validate();
			_vUniformList.validate();
			_fUniformList.validate();
			_textureList.validate();
		}

		public function destroy():void
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
		public function setUniformBindings(binds:Vector.<UniformBindingHelp>):void
		{
			var bLength:int = binds.length;
			for (var i:int = 0; i < bLength; i++)
			{
				var help:UniformBindingHelp = binds[i];
				bindUniform(help.shaderType, help.name, help.bindType);
			}
		}

		/**
		 * 设置系统绑定的Attribute
		 */
		public function setAttributeBindings(attributeMap:Dictionary):void
		{
			var bufferType:String;
			for (bufferType in attributeMap)
			{
				bindAttribute(bufferType, attributeMap[bufferType]);
			}
		}
	}
}

