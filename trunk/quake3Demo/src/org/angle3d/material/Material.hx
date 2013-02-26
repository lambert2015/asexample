package org.angle3d.material;
import flash.display3D.textures.TextureBase;
import org.angle3d.math.Vector3f;
import flash.Lib;
import flash.Vector;
import org.angle3d.light.AmbientLight;
import org.angle3d.light.DirectionalLight;
import org.angle3d.light.Light;
import org.angle3d.light.LightList;
import org.angle3d.light.LightType;
import org.angle3d.light.PointLight;
import org.angle3d.light.SpotLight;
import org.angle3d.math.Color;
import org.angle3d.math.Vector4f;
import org.angle3d.renderer.IRenderer;
import org.angle3d.renderer.RenderManager;
import org.angle3d.scene.Geometry;
import org.angle3d.shader.TextureVar;
import org.angle3d.shader.Shader;
import org.angle3d.shader.ShaderType;
import org.angle3d.shader.ShaderVar;
import org.angle3d.shader.Uniform;
import org.angle3d.shader.UniformList;
import org.angle3d.utils.Assert;

import org.angle3d.utils.HashMap;
/**
 * <code>Material</code> describes the rendering style for a given 
 * {@link Geometry}. 
 * 
 * <p>A material is essentially a list of {@link MatParam parameters}, those parameters
 * map to uniforms which are defined in a shader. 
 * Setting the parameters can modify the behavior of a shader.
 * 
 * @author Kirill Vainer
 */
class Material 
{
	private static var nullDirLight:Vector<Float> = Vector.ofArray([0.0, -1.0, 0.0, -1.0]);
	
	private static var additiveLight:RenderState;
	
	private static var depthOnly:RenderState;
	
	/**
	 * 特殊函数，用于执行一些static变量的定义等(有这个函数时，static变量预先赋值必须也放到这里面)
	 */
	static function __init__():Void
	{
		depthOnly = new RenderState();
		depthOnly.setDepthTest(true);
		depthOnly.setDepthWrite(true);
		depthOnly.setFaceCullMode(FaceCullMode.Back);
		depthOnly.setColorWrite(false);
		
		additiveLight = new RenderState();
		additiveLight.setBlendMode(BlendMode.AlphaAdditive);
		additiveLight.setDepthWrite(false);
	}
	
	
	private var lightMode:Int;
	
	private var renderState:RenderState;
	
	private var shader:Shader;
	
	private var additionalState:RenderState;
    private var mergedRenderState:RenderState;
	
	private var transparent:Bool;
	private var receivesShadows:Bool;
	
	private var matParams:HashMap<String,MatParam>;
	private var textureParams:HashMap<String,MatParamTexture>;

	public function new() 
	{
		transparent = false;
		receivesShadows = false;

		lightMode = LightMode.MultiPass;
		mergedRenderState = new RenderState();
	}
	
	public function setLightMode(mode:Int):Void
	{
		this.lightMode = mode;
	}
	
	public function setShader(shader:Shader):Void
	{
		this.shader = shader;
		
		matParams = new HashMap<String,MatParam>();
		
		var uniforms:Vector<Uniform> = shader.getUnBindUniforms(ShaderType.VERTEX);
		for (i in 0...uniforms.length)
		{
			addParam(ShaderType.VERTEX, uniforms[i].name, null);
		}

		uniforms = shader.getUnBindUniforms(ShaderType.FRAGMENT);
		for (i in 0...uniforms.length)
		{
			addParam(ShaderType.FRAGMENT, uniforms[i].name, null);
		}
		
		textureParams = new HashMap<String,MatParamTexture>();
		var variables:Vector<ShaderVar> = shader.getTextureList().getVariables();
		for (i in 0...variables.length)
		{
			addTextureParam(variables[i].name,variables[i].getLocation(), null);
		}
	}
	
	/**
     * Check if the transparent value marker is set on this material.
     * @return True if the transparent value marker is set on this material.
     * @see #setTransparent(boolean)
     */
    public function isTransparent():Bool 
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
    public function setTransparent(transparent:Bool):Void
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
    public function isReceivesShadows():Bool
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
    public function setReceivesShadows(receivesShadows:Bool):Void
	{
        this.receivesShadows = receivesShadows;
    }
	
	/**
     * Acquire the additional {@link RenderState render state} to apply
     * for this material.
     *
     * <p>The first call to this method will create an additional render
     * state which can be modified by the user to apply any render
     * states in addition to the ones used by the renderer. Only render
     * states which are modified in the additional render state will be applied.
     *
     * @return The additional render state.
     */
    public function getAdditionalRenderState():RenderState
	{
        if (additionalState == null) 
		{
            additionalState = RenderState.ADDITIONAL.clone();
        }
		
        return additionalState;
    }
	
	public function clone():Material
	{
		var mat:Material = new Material();
		mat.setShader(this.shader);
		if (additionalState != null)
		{
			mat.additionalState = this.additionalState.clone();
		}
		
		var params:Array<MatParam> = matParams.toArray();
		for (param in params) 
		{
            mat.addParam(param.type, param.name, param.value);
        }
		
		var texParams:Array<MatParamTexture> = textureParams.toArray();
		for (param in texParams) 
		{
            mat.addTextureParam(param.name, param.index, param.texture);
        }
		
		return mat;
	}
	
	/**
	 * 添加一个MatParam
	 * @param	type
	 * @param	name
	 * @param	value
	 */
	private function addParam(type:String, name:String, value:Vector<Float>):Void
	{
		var param:MatParam = new MatParam(type, name, value);
		
		#if debug
		if (matParams.containsKey(type + "_" + name))
		{
			Assert.assert(false, "已经包含此参数" + type + "," + name);
		}
		#end
		
		matParams.setValue(type + "_" + name, param);
	}
	
	private function addTextureParam(name:String,index:Int,value:TextureBase):Void
	{
		var param:MatParamTexture = new MatParamTexture(name,index,value);
		
		#if debug
		if (textureParams.containsKey(name))
		{
			Assert.assert(false, "已经包含此参数" + name);
		}
		#end
		
		textureParams.setValue(name, param);
	}
	
	/**
     * Pass a texture to the material shader.
     *
     * @param name the name of the texture defined in the material definition
     * @param value the Texture object 
     */
	public function setTexture(name:String, value:TextureBase):Void
	{
		var param:MatParamTexture = getTextureParam(name);
		param.texture = value;
	}
	
	/**
     * Pass a parameter to the material shader.
     *
	 * @param type the shader type
     * @param name the name of the parameter defined in the material definition
     * @param value the value of the parameter
     */
	public function setParam(type:String, name:String, value:Vector<Float>):Void
	{
		var param:MatParam = getParam(type, name);
		param.value = value;
	}
	
	/**
     * Returns the parameter set on this material with the given name,
     * returns <code>null</code> if the parameter is not set.
     *
     * @param name The parameter name to look up.
     * @return The MatParam if set, or null if not set.
     */
	public inline function getParam(type:String, name:String):MatParam
	{
		//这样命名是为了避免Vertex和Fragment中有重名的参数
		return matParams.getValue(type + "_" + name);
	}
	
	public inline function getTextureParam(name:String):MatParamTexture
	{
		return textureParams.getValue(name);
	}
	
	public function updateUniformParam(type:String,paramName:String, value:Vector<Float>):Void
	{
		var uniform:Uniform = shader.getUniform(type, paramName);
		uniform.setVector(value);
	}
	
	public function updateTextureParam(paramName:String, value:TextureBase):Void
	{
		var tex:TextureVar = shader.getTextureVar(paramName);
		tex.setTexture(value);
	}
	
	/**
     * Uploads the lights in the light list as two uniform arrays.<br/><br/>
     *      * <p>
     * <code>uniform vec4 g_LightColor[numLights];</code><br/>
     * // g_LightColor.rgb is the diffuse/specular color of the light.<br/>
     * // g_Lightcolor.a is the type of light, 0 = Directional, 1 = Point, <br/>
     * // 2 = Spot. <br/>
     * <br/>
     * <code>uniform vec4 g_LightPosition[numLights];</code><br/>
     * // g_LightPosition.xyz is the position of the light (for point lights)<br/>
     * // or the direction of the light (for directional lights).<br/>
     * // g_LightPosition.w is the inverse radius (1/r) of the light (for attenuation) <br/>
     * </p>
     */
	private function updateLightListUniforms(shader:Shader, g:Geometry, numLights:Int):Void
	{
		// this shader does not do lighting, ignore.
		if (numLights == 0)
		{
			return;
		}
		
		var lightList:LightList = g.getWorldLightList();
		
		var lightColor:Uniform = shader.getUniform(ShaderType.VERTEX, "u_LightColor");
		var lightPos:Uniform = shader.getUniform(ShaderType.VERTEX, "u_LightPosition");
		var lightDir:Uniform = shader.getUniform(ShaderType.VERTEX, "u_LightDirection");
		
		var lightColorVec:Vector<Float> = new Vector<Float>(numLights * 4);
		var lightPosVec:Vector<Float> = new Vector<Float>(numLights * 4);
		var lightDirVec:Vector<Float> = new Vector<Float>(numLights * 4);
		
		var ambientColor:Uniform = shader.getUniform(ShaderType.VERTEX, "u_Ambient");
		ambientColor.setColor(lightList.getAmbientColor());
		
		var lightIndex:Int = 0;
		for (i in 0...numLights)
		{
			var size:Int = lightList.getSize();
			if (size <= i)
			{
				for (j in 0...4)
				{
					lightColorVec[lightIndex * 4 + j] = 0.0;
					lightPosVec[lightIndex * 4 + j] = 0.0;
				}
				
			}
			else
			{
				var light:Light = lightList.getLightAt(i);
				var color:Color = light.getColor();
				
				lightColorVec[i * 4 + 0] = color.r;
				lightColorVec[i * 4 + 1] = color.g;
				lightColorVec[i * 4 + 2] = color.b;
				lightColorVec[i * 4 + 3] = light.getType();
				
				switch(light.getType())
				{
					case LightType.Directional:
						
						var dl:DirectionalLight = Lib.as(light, DirectionalLight);
						var dir:Vector3f = dl.getDirection();
					
						lightPosVec[lightIndex * 4 + 0] = dir.x;
						lightPosVec[lightIndex * 4 + 1] = dir.y;
						lightPosVec[lightIndex * 4 + 2] = dir.z;
						lightPosVec[lightIndex * 4 + 3] = -1;
						
				case LightType.Point:
					
					var pl:PointLight = Lib.as(light, PointLight);
					var pos:Vector3f = pl.getPosition();
					var invRadius:Float = pl.getInvRadius();
					
					lightPosVec[lightIndex * 4 + 0] = pos.x;
					lightPosVec[lightIndex * 4 + 1] = pos.y;
					lightPosVec[lightIndex * 4 + 2] = pos.z;
					lightPosVec[lightIndex * 4 + 3] = invRadius;
					
				case LightType.Spot:
					var sl:SpotLight = Lib.as(light, SpotLight);
					var pos:Vector3f = sl.getPosition();
					var dir:Vector3f = sl.getDirection();
					var invRange:Float = sl.getInvSpotRange();
					var spotAngleCos:Float = sl.getPackedAngleCos();
					
					lightPosVec[lightIndex * 4 + 0] = pos.x;
					lightPosVec[lightIndex * 4 + 1] = pos.y;
					lightPosVec[lightIndex * 4 + 2] = pos.z;
					lightPosVec[lightIndex * 4 + 3] = invRange;
					
					lightDirVec[lightIndex * 4 + 0] = dir.x;
					lightDirVec[lightIndex * 4 + 1] = dir.y;
					lightDirVec[lightIndex * 4 + 2] = dir.z;
					lightDirVec[lightIndex * 4 + 3] = spotAngleCos;
				case LightType.Ambient:
					// skip this light. Does not increase lightIndex
					continue;
				default:
					Assert.assert(false, "Unknown type of light: " + light.getType());
			    }
			}
			
			lightIndex++;
		}
		
		while (lightIndex < numLights)
		{
			for (j in 0...4)
			{
				lightColorVec[lightIndex * 4 + j] = 0.0;
				lightPosVec[lightIndex * 4 + j] = 0.0;
			}	
			
			lightIndex++;
		}
	}

	/**
	 * 多重灯光渲染
	 * @param	shader
	 * @param	g
	 * @param	rm
	 */
	private function renderMultipassLighting(shader:Shader, g:Geometry, rm:RenderManager):Void
	{
		var r:IRenderer = rm.getRenderer();
		var lightList:LightList = g.getWorldLightList();
		var numLight:Int = lightList.getSize();
		
		var lightDir:Uniform = shader.getUniform(ShaderType.VERTEX, "u_LightDirection");
		var lightColor:Uniform = shader.getUniform(ShaderType.VERTEX, "u_LightColor");
		var lightPos:Uniform = shader.getUniform(ShaderType.VERTEX, "u_LightPosition");
		var ambientColor:Uniform = shader.getUniform(ShaderType.VERTEX, "u_Ambient");
		
		
		var isFirstLight:Bool = true;
		var isSecondLight:Bool = false;
		
		for (i in 0...numLight)
		{
			var l:Light = lightList.getLightAt(i);
			if (Std.is(l, AmbientLight))
			{
				continue;
			}
			
			if (isFirstLight)
			{
				// set ambient color for first light only
				ambientColor.setColor(lightList.getAmbientColor());
				isFirstLight = false;
				isSecondLight = true;
			}
			else if (isSecondLight)
			{
				ambientColor.setColor(Color.Black);
				// apply additive blending for 2nd and future lights
				r.applyRenderState(additiveLight);
				isSecondLight = false;
			}
			
			var tmpLightDirection:Vector<Float> = new Vector<Float>(4,true);
			var tmpLightPosition:Vector<Float> = new Vector<Float>(4,true);

			var colors:Vector<Float> = l.getColor().toUniform();
			colors[3] = l.getType();
			lightColor.setVector(colors);
			
			switch(l.getType())
			{
				case LightType.Directional:
					var dl:DirectionalLight = Lib.as(l, DirectionalLight);
					var dir:Vector3f = dl.getDirection();
					
					tmpLightPosition[0] = dir.x;
					tmpLightPosition[1] = dir.y;
					tmpLightPosition[2] = dir.z;
					tmpLightPosition[3] = -1;
					lightPos.setVector(tmpLightPosition);
					
					tmpLightDirection[0] = 0;
					tmpLightDirection[1] = 0;
					tmpLightDirection[2] = 0;
					tmpLightDirection[3] = 0;
					lightDir.setVector(tmpLightDirection);
					
				case LightType.Point:
					
					var pl:PointLight = Lib.as(l, PointLight);
					var pos:Vector3f = pl.getPosition();
					var invRadius:Float = pl.getInvRadius();
					
					tmpLightPosition[0] = pos.x;
					tmpLightPosition[1] = pos.y;
					tmpLightPosition[2] = pos.z;
					tmpLightPosition[3] = invRadius;
					lightPos.setVector(tmpLightPosition);
					
					tmpLightDirection[0] = 0;
					tmpLightDirection[1] = 0;
					tmpLightDirection[2] = 0;
					tmpLightDirection[3] = 0;
					lightDir.setVector(tmpLightDirection);
					
				case LightType.Spot:
					
					var sl:SpotLight = Lib.as(l, SpotLight);
					var pos:Vector3f = sl.getPosition();
					var dir:Vector3f = sl.getDirection();
					var invRange:Float = sl.getInvSpotRange();
					var spotAngleCos:Float = sl.getPackedAngleCos();
					
					tmpLightPosition[0] = pos.x;
					tmpLightPosition[1] = pos.y;
					tmpLightPosition[2] = pos.z;
					tmpLightPosition[3] = invRange;
					lightPos.setVector(tmpLightPosition);
					
					var tmpVec:Vector4f = new Vector4f();
					tmpVec.setTo(dir.x, dir.y, dir.z, 0);
					
					rm.getCamera().getViewMatrix().multVec4(tmpVec, tmpVec);
					
					//We transform the spot directoin in view space here to save 5 varying later in the lighting shader
                    //one vec4 less and a vec4 that becomes a vec3
                    //the downside is that spotAngleCos decoding happen now in the frag shader.
					tmpLightDirection[0] = tmpVec.x;
					tmpLightDirection[1] = tmpVec.y;
					tmpLightDirection[2] = tmpVec.z;
					tmpLightDirection[3] = spotAngleCos;
					
					lightDir.setVector(tmpLightDirection);
					
				default:
					Assert.assert(false, "Unknown type of light: " + l.getType());
			}

			r.setShader(shader);
			r.renderMesh(g.getMesh(), g.getLodLevel(), 1);
		}
		
		if (isFirstLight && numLight > 0)
		{
			// There are only ambient lights in the scene. Render
            // a dummy "normal light" so we can see the ambient
			ambientColor.setVector(lightList.getAmbientColor().toUniform());
			lightColor.setVector(Color.BlackNoAlpha.toUniform());
			lightPos.setVector(nullDirLight);
			r.setShader(shader);
			r.renderMesh(g.getMesh(), g.getLodLevel(), 1);
		}
	}
	
	/**
     * Called by {@link RenderManager} to render the geometry by
     * using this material.
     *
     * @param geom The geometry to render
     * @param rm The render manager requesting the rendering
     */
	public function render(geom:Geometry, rm:RenderManager):Void
	{
		Assert.assert(shader != null, "Shader can not be null");
		
		var r:IRenderer = rm.getRenderer();

        if (lightMode == LightMode.MultiPass
                && geom.getWorldLightList().getSize() == 0) 
		{
            return;
        }
		
		if (rm.getForcedRenderState() != null)
		{
			r.applyRenderState(rm.getForcedRenderState());
		}
		else
		{
			if (renderState != null)
			{
				r.applyRenderState(renderState.copyMergedTo(additionalState, mergedRenderState));
			}
			else
			{
				r.applyRenderState(RenderState.DEFAULT.copyMergedTo(additionalState, mergedRenderState));
			}
		}
		
		// update camera and world matrices
        // NOTE: setWorldTransform should have been called already
        rm.updateUniformBindings(shader.getBindUniforms(ShaderType.VERTEX));
		rm.updateUniformBindings(shader.getBindUniforms(ShaderType.FRAGMENT));
		
		// setup textures and uniforms
		var params:Array<MatParam> = matParams.toArray();
        for (param in params) 
		{
            param.apply(r, this);
        }
		
		var texParams:Array<MatParamTexture> = textureParams.toArray();
		for (tparam in texParams) 
		{
            tparam.apply(r, this);
        }
		
		// send lighting information, if needed
		switch (lightMode)
		{
			case LightMode.SinglePass:
				updateLightListUniforms(shader, geom, 4);
			case LightMode.MultiPass:
                renderMultipassLighting(shader, geom, rm);
                // very important, notice the return statement!
                return;
		}
		
		// upload and bind shader
        r.setShader(shader);
		
		r.renderMesh(geom.getMesh(), geom.getLodLevel(), 1);
	}
}