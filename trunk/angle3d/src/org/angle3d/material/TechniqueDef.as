package org.angle3d.material
{
	import flash.utils.Dictionary;
	
	/**
	 * Describes a technique definition.
	 * 
	 * @author Kirill Vainer
	 */
	public class TechniqueDef
	{
		public var lightMode:int = LightMode.Disable;
		public var shadowMode:int = ShadowMode.Disable;
		
		private var worldBinds:Vector.<String>;
		private var defineParams:Dictionary;
		
		private var renderState:RenderState;
		private var forcedRenderState:RenderState;
		
		/**
		 *  the language of the vertex shader used in this technique.
		 */
		public var vertLanguage:String;
		/**
		 *  the language of the fragment shader used in this technique.
		 */
		public var fragLanguage:String;
		
		public var name:String;
		public function TechniqueDef(name:String)
		{
			this.name = name;
		}
		
		/**
		 * Returns the render state that this technique is using
		 * @return the render state that this technique is using
		 * @see #setRenderState(com.jme3.material.RenderState) 
		 */
		public function getRenderState():RenderState
		{
			return renderState;
		}

		/**
		 * Sets the render state that this technique is using.
		 * 
		 * @param renderState the render state that this technique is using.
		 * 
		 * @see RenderState
		 */
		public function setRenderState(renderState:RenderState):void 
		{
			this.renderState = renderState;
		}
		
		public function getForcedRenderState():RenderState
		{
			return forcedRenderState;
		}
		
		public function setForcedRenderState(renderState:RenderState):void 
		{
			this.forcedRenderState = renderState;
		}
		
		/**
		 * Returns the define name which the given material parameter influences.
		 * 
		 * @param paramName The parameter name to look up
		 * @return The define name
		 * 
		 * @see #addShaderParamDefine(java.lang.String, java.lang.String) 
		 */
		public function getShaderParamDefine(paramName:String):String
		{
			if (defineParams == null) 
			{
				return null;
			}
			return defineParams[paramName];
		}

		/**
		 * Adds a define linked to a material parameter.
		 * <p>
		 * Any time the material parameter on the parent material is altered,
		 * the appropriate define on the technique will be modified as well. 
		 * See the method 
		 * {@link DefineList#set(java.lang.String, com.jme3.shader.VarType, java.lang.Object) }
		 * on the exact details of how the material parameter changes the define.
		 * 
		 * @param paramName The name of the material parameter to link to.
		 * @param defineName The name of the define parameter, e.g. USE_LIGHTING
		 */
		public function addShaderParamDefine(paramName:String,defineName:String):void
		{
			if (defineParams == null) 
			{
				defineParams = new Dictionary();
			}
			defineParams[paramName] = defineName;
		}
		
		/**
		 * Adds a new world parameter by the given name.
		 * 
		 * @param name The world parameter to add.
		 * @return True if the world parameter name was found and added
		 * to the list of world parameters, false otherwise.
		 */
		public function addWorldParam(name:String):Boolean 
		{
			if (worldBinds == null)
			{
				worldBinds = new Vector.<String>();
			}
			
			//需要检查是否有这个绑定参数
			worldBinds.push(name);
			return true;
		}
		
		/**
		 * Returns a list of world parameters that are used by this
		 * technique definition.
		 * 
		 * @return The list of world parameters
		 */
		public function getWorldBindings():Vector.<String>
		{
			return worldBinds;
		}
	}
}