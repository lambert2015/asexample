package org.angle3d.material
{
	import flash.utils.Dictionary;

	import org.angle3d.material.technique.Technique;
	import org.angle3d.math.Color;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Vector2f;
	import org.angle3d.math.Vector3f;
	import org.angle3d.math.Vector4f;
	import org.angle3d.texture.TextureMapBase;
	import org.angle3d.texture.TextureType;

	/**
	 * 一个Material可能有多个Technique
	 * @author weilichuang
	 *
	 */
	public class Material2
	{
		public var name:String;

		private var name:String;
		private var def:MaterialDef;

		private var transparent:Boolean = false;
		private var receivesShadows:Boolean = false;

		private var sortingId:int = -1;

		private var paramValues:Dictionary;
		private var technique:Technique;
		private var techniques:Dictionary;

		private var nextTexUnit:int = 0;

		public function Material2(def:MaterialDef)
		{
			this.def = def;

			paramValues = new Dictionary();
			techniques = new Dictionary();
		}

		/**
		 * Get the material definition (j3md file info) that <code>this</code>
		 * material is implementing.
		 *
		 * @return the material definition this material implements.
		 */
		public function getMaterialDef():MaterialDef
		{
			return def;
		}

		/**
		 * Check if setting the parameter given the type and name is allowed.
		 * @param type The type that the "set" function is designed to set
		 * @param name The name of the parameter
		 */
		private function checkSetParam(type:String, name:String):void
		{
			var paramDef:MatParam = def.getMaterialParam(name);
			if (paramDef == null)
			{
				throw new Error("Material parameter is not defined: " + name);
			}
//			if (type != null && paramDef.type != type) {
//				logger.log(Level.WARNING, "Material parameter being set: {0} with "
//					+ "type {1} doesn''t match definition types {2}", name, type, paramDef.type);
//			}
		}

		/**
		 * Pass a parameter to the material shader.
		 *
		 * @param name the name of the parameter defined in the material definition (j3md)
		 * @param type the type of the parameter {@link VarType}
		 * @param value the value of the parameter
		 */
		public function setParam(name:String, type:String, value:Object):void
		{
			checkSetParam(type, name);

			if (VarType.isTextureType(type))
			{
				setTextureParam(name, type, value as TextureMapBase);
			}
			else
			{
				var val:MatParam = getParam(name);
				if (val == null)
				{
					var paramDef:MatParam = def.getMaterialParam(name);
					paramValues.put(name, new MatParam(type, name, value));
				}
				else
				{
					val.value = value;
				}

				if (technique != null)
				{
					technique.notifyParamChanged(name, type, value);
				}
			}
		}

		/**
		 * Returns the parameter set on this material with the given name,
		 * returns <code>null</code> if the parameter is not set.
		 *
		 * @param name The parameter name to look up.
		 * @return The MatParam if set, or null if not set.
		 */
		public function getParam(name:String):MatParam
		{
			return paramValues[name];
		}

		/**
		 * Clear a parameter from this material. The parameter must exist
		 * @param name the name of the parameter to clear
		 */
		public function clearParam(name:String):void
		{
			checkSetParam(null, name);

			var matParam:MatParam = getParam(name);
			if (matParam == null)
			{
				return;
			}

			paramValues.remove(name);
			if (matParam is MatParamTexture)
			{
				var texUnit:int = MatParamTexture(matParam).index;
				nextTexUnit--;
				var param:MatParam;
				for each (param in paramValues)
				{
					if (param is MatParamTexture)
					{
						var texParam:MatParamTexture = param as MatParamTexture;
						if (texParam.index > texUnit)
						{
							texParam.index = texParam.index - 1;
						}
					}
				}
				sortingId = -1;
			}
			if (technique != null)
			{
				technique.notifyParamChanged(name, null, null);
			}
		}


		/**
		 * Set a texture parameter.
		 *
		 * @param name The name of the parameter
		 * @param type The variable type {@link VarType}
		 * @param value The texture value of the parameter.
		 *
		 * @throws IllegalArgumentException is value is null
		 */
		public function setTextureParam(name:String, type:String, value:TextureMapBase):void
		{
			if (value == null)
			{
				throw new Error();
			}

			checkSetParam(type, name);
			var val:MatParamTexture = getTextureParam(name);
			if (val == null)
			{
				paramValues.put(name, new MatParamTexture(type, name, value, nextTexUnit++));
			}
			else
			{
				val.texture = value;
			}

			if (technique != null)
			{
				technique.notifyParamChanged(name, type, nextTexUnit - 1);
			}

			// need to recompute sort ID
			sortingId = -1;
		}

		/**
		 * Returns the texture parameter set on this material with the given name,
		 * returns <code>null</code> if the parameter is not set.
		 *
		 * @param name The parameter name to look up.
		 * @return The MatParamTexture if set, or null if not set.
		 */
		public function getTextureParam(name:String):MatParamTexture
		{
			var param:MatParam = paramValues[name];
			if (param is MatParamTexture)
			{
				return param as MatParamTexture;
			}
			return null;
		}

		/**
		 * Pass a texture to the material shader.
		 *
		 * @param name the name of the texture defined in the material definition
		 * (j3md) (for example Texture for Lighting.j3md)
		 * @param value the Texture object previously loaded by the asset manager
		 */
		public function setTexture(name:String, value:TextureMapBase):void
		{
			if (value == null)
			{
				// clear it
				clearParam(name);
				return;
			}

			var paramType:String = null;
			switch (value.getType())
			{
				case TextureType.TwoDimensional:
					paramType = VarType.TEXTURE2D
					break;
				case TextureType.CubeMap:
					paramType = VarType.TEXTURECUBEMAP;
					break;
				default:
					throw new Error("Unknown texture type: " + value.getType());
			}

			setTextureParam(name, paramType, value);
		}

		/**
		 * Pass a Matrix4f to the material shader.
		 *
		 * @param name the name of the matrix defined in the material definition (j3md)
		 * @param value the Matrix4f object
		 */
		public function setMatrix4(name:String, value:Matrix4f):void
		{
			setParam(name, VarType.MATRIX4, value);
		}

		/**
		 * Pass a boolean to the material shader.
		 *
		 * @param name the name of the boolean defined in the material definition (j3md)
		 * @param value the boolean value
		 */
		public function setBoolean(name:String, value:Boolean):void
		{
			setParam(name, VarType.BOOLEAN, value);
		}

		/**
		 * Pass a float to the material shader.
		 *
		 * @param name the name of the float defined in the material definition (j3md)
		 * @param value the float value
		 */
		public function setFloat(name:String, value:Number):void
		{
			setParam(name, VarType.FLOAT, value);
		}

		/**
		 * Pass an int to the material shader.
		 *
		 * @param name the name of the int defined in the material definition (j3md)
		 * @param value the int value
		 */
		public function setInt(name:String, value:int):void
		{
			setParam(name, VarType.FLOAT, value);
		}

		/**
		 * Pass a Color to the material shader.
		 *
		 * @param name the name of the color defined in the material definition (j3md)
		 * @param value the ColorRGBA value
		 */
		public function setColor(name:String, value:Color):void
		{
			setParam(name, VarType.VECTOR4, value);
		}

		/**
		 * Pass a Vector2f to the material shader.
		 *
		 * @param name the name of the Vector2f defined in the material definition (j3md)
		 * @param value the Vector2f value
		 */
		public function setVector2(name:String, value:Vector2f):void
		{
			setParam(name, VarType.VECTOR2, value);
		}

		/**
		 * Pass a Vector3f to the material shader.
		 *
		 * @param name the name of the Vector3f defined in the material definition (j3md)
		 * @param value the Vector3f value
		 */
		public function setVector3(name:String, value:Vector3f):void
		{
			setParam(name, VarType.VECTOR3, value);
		}

		/**
		 * Pass a Vector4f to the material shader.
		 *
		 * @param name the name of the Vector4f defined in the material definition (j3md)
		 * @param value the Vector4f value
		 */
		public function setVector4(name:String, value:Vector4f):void
		{
			setParam(name, VarType.VECTOR4, value);
		}

		/**
		 * Check if the transparent value marker is set on this material.
		 * @return True if the transparent value marker is set on this material.
		 * @see #setTransparent(boolean)
		 */
		public function isTransparent():Boolean
		{
			return transparent;
		}

		/**
		 * Set the transparent value marker.
		 *
		 * <p>This value is merely a marker, by itself it does nothing.
		 * Generally model loaders will use this marker to indicate further
		 * up that the material is transparent and therefore any geometries
		 * using it should be put into the {@link Bucket#Transparent transparent
		 * bucket}.
		 *
		 * @param transparent the transparent value marker.
		 */
		public function setTransparent(transparent:Boolean):void
		{
			this.transparent = transparent;
		}

		/**
		 * Check if the material should receive shadows or not.
		 *
		 * @return True if the material should receive shadows.
		 *
		 * @see Material#setReceivesShadows(boolean)
		 */
		public function isReceivesShadows():Boolean
		{
			return receivesShadows;
		}

		/**
		 * Set if the material should receive shadows or not.
		 *
		 * <p>This value is merely a marker, by itself it does nothing.
		 * Generally model loaders will use this marker to indicate
		 * the material should receive shadows and therefore any
		 * geometries using it should have the {@link ShadowMode#Receive} set
		 * on them.
		 *
		 * @param receivesShadows if the material should receive shadows or not.
		 */
		public function setReceivesShadows(receivesShadows:Boolean):void
		{
			this.receivesShadows = receivesShadows;
		}
	}
}
