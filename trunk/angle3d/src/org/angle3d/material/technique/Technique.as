package org.angle3d.material.technique
{

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	import org.angle3d.manager.ShaderManager;
	import org.angle3d.material.RenderState;
	import org.angle3d.material.TechniqueDef;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.UniformBindingHelp;
	import org.angle3d.scene.mesh.MeshType;

	/**
	 * Technique可能对应多个Shader
	 * @author andy
	 */
	public class Technique
	{
		public var def:TechniqueDef;

		private var _name:String;

		protected var _shaderMap:Dictionary; //<String,Shader>;
		protected var _optionMap:Dictionary; //<String,Array>;

		protected var _renderState:RenderState;

		protected var _requiresLight:Boolean;

		protected var _keys:Array = [];

		public function Technique()
		{
			_initInternal();

			var className:String = getQualifiedClassName(this);
			var index:int = className.lastIndexOf("::");
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
		public function updateShader(shader:Shader):void
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

				var option:Vector.<Vector.<String>> = _optionMap[key];

				shader = ShaderManager.instance.registerShader(key, [vstr, fstr], option);

				shader.setUniformBindings(getBindUniforms(lightType, meshType));
				shader.setAttributeBindings(getBindAttributes(lightType, meshType));

				_shaderMap[key] = shader;
			}

			return shader;
		}

		protected function _initInternal():void
		{
			_shaderMap = new Dictionary();
			_optionMap = new Dictionary();

			_renderState = new RenderState();
			_requiresLight = false;
		}

		public function get requiresLight():Boolean
		{
			return _requiresLight;
		}

		public function set requiresLight(value:Boolean):void
		{
			_requiresLight = value;
		}

		protected function getBindUniforms(lightType:String = "none", meshType:String = "static"):Vector.<UniformBindingHelp>
		{
			return null;
		}

		protected function getBindAttributes(lightType:String = "none", meshType:String = "static"):Dictionary
		{
			return null;
		}

		protected function getVertexSource():String
		{
			return "";
		}

		protected function getFragmentSource():String
		{
			return "";
		}

		protected function getOption(lightType:String = "none", meshType:String = "static"):Vector.<Vector.<String>>
		{
			var results:Vector.<Vector.<String>> = new Vector.<Vector.<String>>(2, true);
			results[0] = new Vector.<String>();
			results[1] = new Vector.<String>();

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

		protected function getKey(lightType:String = "none", meshType:String = "static"):String
		{
			return _name;
		}
	}
}

