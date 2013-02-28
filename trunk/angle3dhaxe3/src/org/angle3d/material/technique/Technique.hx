package org.angle3d.material.technique
{

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import org.angle3d.manager.ShaderManager;
	import org.angle3d.material.RenderState;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.UniformBindingHelp;
	import org.angle3d.material.TechniqueDef;
	import org.angle3d.scene.mesh.MeshType;


	/**
	 * Technique可能对应多个Shader
	 * @author andy
	 */
	class Technique
	{
		public var def:TechniqueDef;

		private var _name:String;

		private var _shaderMap:Dictionary; //<String,Shader>;
		private var _optionMap:Dictionary; //<String,Array>;

		private var _renderState:RenderState;

		private var _requiresLight:Bool;

		private var _keys:Array = [];

		public function Technique()
		{
			_initInternal();

			var className:String = getQualifiedClassName(this);
			var index:Int = className.lastIndexOf("::");
			_name = className.slice(index + 2);
		}

		public final function get name():String
		{
			return _name;
		}

		public function get renderState():RenderState
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
		final public function getShader(lightType:String = "none", meshType:String = "static"):Shader
		{
			var key:String = getKey(lightType, meshType);

			var shader:Shader = _shaderMap[key];

			if (shader == null)
			{
				if (_optionMap[key] == undefined)
				{
					_optionMap[key] = getOption(lightType, meshType);
				}

				var vstr:String = getVertexSource();
				var fstr:String = getFragmentSource();

				var option:Vector<Vector<String>> = _optionMap[key];

				shader = ShaderManager.instance.registerShader(key, [vstr, fstr], option);

				shader.setUniformBindings(getBindUniforms(lightType, meshType));
				shader.setAttributeBindings(getBindAttributes(lightType, meshType));

				_shaderMap[key] = shader;
			}

			return shader;
		}

		private function _initInternal():Void
		{
			_shaderMap = new Dictionary();
			_optionMap = new Dictionary();

			_renderState = new RenderState();
			_requiresLight = false;
		}

		public function get requiresLight():Bool
		{
			return _requiresLight;
		}

		public function set requiresLight(value:Bool):Void
		{
			_requiresLight = value;
		}

		private function getBindUniforms(lightType:String = "none", meshType:String = "static"):Vector<UniformBindingHelp>
		{
			return null;
		}

		private function getBindAttributes(lightType:String = "none", meshType:String = "static"):Dictionary
		{
			return null;
		}

		private function getVertexSource():String
		{
			return "";
		}

		private function getFragmentSource():String
		{
			return "";
		}

		private function getOption(lightType:String = "none", meshType:String = "static"):Vector<Vector<String>>
		{
			var results:Vector<Vector<String>> = new Vector<Vector<String>>(2, true);
			results[0] = new Vector<String>();
			results[1] = new Vector<String>();

			if (meshType == MeshType.MT_KEYFRAME)
			{
				results[0].push("USE_KEYFRAME");
			}
			else if (meshType == MeshType.MT_SKINNING)
			{
				results[0].push("USE_SKINNING");
			}

			return results;
		}

		private function getKey(lightType:String = "none", meshType:String = "static"):String
		{
			return _name;
		}

		/**
		 * Called by the material to tell the technique a parameter was modified.
		 * Specify <code>null</code> for value if the param is to be cleared.
		 */
		public function notifyParamChanged(paramName:String, type:String, value:Object):Void
		{
			// Check if there's a define binding associated with this
			// parameter.
			var defineName:String = def.getShaderParamDefine(paramName);
			if (defineName != null)
			{
				// There is a define. Change it on the define list.
				// The "needReload" variable will determine
				// if the shader will be reloaded when the material
				// is rendered.

//				if (value == null)
//				{
//					// Clear the define.
//					needReload = defines.remove(defineName) || needReload;
//				}
//				else
//				{
//					// Set the define.
//					needReload = defines.set(defineName, type, value) || needReload;
//				}
			}
		}
	}
}

