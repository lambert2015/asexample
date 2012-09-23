package three.renderers;

import js.Boot;
import js.Dom;
import js.Lib;
import three.core.Geometry;
import three.lights.Light;
import three.lights.DirectionalLight;
import three.lights.SpotLight;
import three.lights.PointLight;
import three.lights.AmbientLight;
import three.materials.Material;
import three.math.Color;
import three.math.Vector2;
import three.math.Vector3;
import three.math.Vector4;
import three.math.Matrix4;
import three.math.MathUtil;
import three.core.Frustum;
import three.core.Face3;
import three.core.Face4;
import three.core.Object3D;
import three.core.BoundingBox;
import three.core.BoundingSphere;
import three.renderers.plugins.LensFlarePlugin;
import three.renderers.plugins.ShadowMapPlugin;
import three.renderers.plugins.SpritePlugin;
import three.scenes.Fog;
import three.scenes.FogExp2;
import three.scenes.IFog;
import three.scenes.Scene;
import three.objects.SkinnedMesh;
import three.cameras.Camera;
import three.textures.Texture;
import three.materials.Material;
import three.materials.MeshBasicMaterial;
import three.materials.MeshLambertMaterial;
import three.materials.MeshNormalMaterial;
import three.materials.MeshPhongMaterial;
import three.materials.ShaderMaterial;
import three.materials.LineBasicMaterial;
import three.materials.*;
import three.textures.DataTexture;
import three.textures.Texture;
import three.ThreeGlobal;
import three.utils.Logger;
import three.utils.BoolUtil;
import UserAgentContext;
/**
 * ...
 * @author 
 */

class WebGLRenderer implements IRenderer
{
	public var domElement:Dynamic;
	public var gl:WebGLRenderingContext;

	// clearing

	public var autoClear:Bool;
	public var autoClearColor:Bool;
	public var autoClearDepth:Bool;
	public var autoClearStencil:Bool;

	// scene graph

	public var sortObjects:Bool;

	public var autoUpdateObjects:Bool;
	public var autoUpdateScene:Bool;

	// physically based shading

	public var gammaInput:Bool;
	public var gammaOutput:Bool;
	public var physicallyBasedShading:Bool;

	// shadow map

	public var shadowMapEnabled:Bool;
	public var shadowMapAutoUpdate:Bool;
	public var shadowMapSoft:Bool;
	public var shadowMapCullFrontFaces:Bool;
	public var shadowMapDebug:Bool;
	public var shadowMapCascade:Bool;

	// morphs

	public var maxMorphTargets:Int;
	public var maxMorphNormals:Int;

	// flags

	public var autoScaleCubemaps:Bool;

	// custom render plugins

	public var renderPluginsPre:Array<IPreRenderPlugin>;
	public var renderPluginsPost:Array<IPostRenderPlugin>;

	// info

	public var info:Dynamic;
	
	private var _canvas:HTMLCanvasElement;
	
	private var _clearColor:Color;
	
	private var _precision:String;
	
	private var _alpha:Bool;
	
	private var _premultipliedAlpha:Bool;
	
	private var _antialias:Bool;
	
	private var _stencil:Bool;
	
	private var _preserveDrawingBuffer:Bool;
	
	private var _maxLights:Int;
	
	private var _frustum:Frustum;
	
	private var _projScreenMatrix:Matrix4;
	private var _projScreenMatrixPS:Matrix4;
	private var _vector3:Vector4;
	
	private var _direction:Vector3;
	
	private var _lightsNeedUpdate:Bool;
	private var _lights:LightsDef;
	
	private var shadowMapPlugin:ShadowMapPlugin;
	
	public function new(parameters:Dynamic = null) 
	{
		if (parameters == null)
			parameters = { };
			
		_canvas = parameters.canvas != null ? parameters.canvas : cast(Lib.document.createElement('canvas'),HTMLCanvasElement);

		_precision = parameters.precision != null ? parameters.precision : 'highp';

		_alpha = parameters.alpha != null ? parameters.alpha : true;
		_premultipliedAlpha = parameters.premultipliedAlpha != null ? parameters.premultipliedAlpha : true;
		_antialias = parameters.antialias != null ? parameters.antialias : false;
		_stencil = parameters.stencil != null ? parameters.stencil : true;
		_preserveDrawingBuffer = parameters.preserveDrawingBuffer != null ? parameters.preserveDrawingBuffer : false;

		_clearColor = parameters.clearColor != null ? new Color(parameters.clearColor) : new Color(0x00000000);

		_maxLights = parameters.maxLights != null ? parameters.maxLights : 4;
		
		// public properties

		this.domElement = _canvas;
		
		// clearing
		this.autoClear = true;
		this.autoClearColor = true;
		this.autoClearDepth = true;
		this.autoClearStencil = true;

		// scene graph
		this.sortObjects = true;

		this.autoUpdateObjects = true;
		this.autoUpdateScene = true;

		// physically based shading

		this.gammaInput = false;
		this.gammaOutput = false;
		this.physicallyBasedShading = false;

		// shadow map

		this.shadowMapEnabled = false;
		this.shadowMapAutoUpdate = true;
		this.shadowMapSoft = true;
		this.shadowMapCullFrontFaces = true;
		this.shadowMapDebug = false;
		this.shadowMapCascade = false;

		// morphs

		this.maxMorphTargets = 8;
		this.maxMorphNormals = 4;

		// flags

		this.autoScaleCubemaps = true;

		// custom render plugins

		this.renderPluginsPre = [];
		this.renderPluginsPost = [];

		// info

		this.info = {
			memory : {
				programs : 0,
				geometries : 0,
				textures : 0
			},
			render : {
				calls : 0,
				vertices : 0,
				faces : 0,
				points : 0
			}
		};

		// frustum
		_frustum = new Frustum();

		// camera matrices cache

		_projScreenMatrix = new Matrix4(); 
		_projScreenMatrixPS = new Matrix4(); 
		_vector3 = new Vector4();

		// light arrays cache

		_direction = new Vector3(); 
		_lightsNeedUpdate = true; 
		_lights = {

			ambient : [0, 0, 0],
			directional : {
				length : 0,
				colors : [],
				positions : []
			},
			point : {
				length : 0,
				colors : [],
				positions : [],
				distances : []
			},
			spot : {
				length : 0,
				colors : [],
				positions : [],
				distances : [],
				directions : [],
				angles : [],
				exponents : []
			}
		};

		// initialize
		initGL();

		setDefaultGLState();

		// GPU capabilities

		_maxVertexTextures = gl.getParameter(gl.MAX_VERTEX_TEXTURE_IMAGE_UNITS);
		_maxTextureSize = gl.getParameter(gl.MAX_TEXTURE_SIZE); 
		_maxCubemapSize = gl.getParameter(gl.MAX_CUBE_MAP_TEXTURE_SIZE);

		_maxAnisotropy = _glExtensionTextureFilterAnisotropic != null ? gl.getParameter(_glExtensionTextureFilterAnisotropic.MAX_TEXTURE_MAX_ANISOTROPY_EXT) : 0;

		_supportsVertexTextures = (_maxVertexTextures > 0 );
		_supportsBoneTextures = _supportsVertexTextures && _glExtensionTextureFloat;
		
		
		// default plugins (order is important)
		this.shadowMapPlugin = new ShadowMapPlugin();
		this.addPrePlugin(this.shadowMapPlugin);
		
		this.addPostPlugin(new SpritePlugin());
		this.addPostPlugin(new LensFlarePlugin());
	}
	
	private var _glExtensionTextureFloat:Bool;
	private var _glExtensionStandardDerivatives:Bool;
	private var _glExtensionTextureFilterAnisotropic:Dynamic;
	
	private var _maxVertexTextures:Int;
	private var _maxTextureSize:Int;
	private var _maxCubemapSize:Int;
	
	private var _maxAnisotropy:Int;
	private var _supportsVertexTextures:Bool;
	private var _supportsBoneTextures:Bool;
	
	private var _currentCamera:Camera;
	public function renderPlugins(plugins:Array<IPlugin>, scene:Scene, camera:Camera):Void
	{
		if (plugins.length == 0)
			return;

		for (i in 0...plugins.length) 
		{
			// reset state for plugin (to start from clean slate)
			_currentProgram = null;
			_currentCamera = null;

			_oldBlending = -1;
			_oldDepthTest = false;
			_oldDepthWrite = false;
			_oldDoubleSided = false;
			_oldFlipSided = false;
			_currentGeometryGroupHash = -1;
			_currentMaterialId = -1;

			_lightsNeedUpdate = true;

			plugins[i].render(scene, camera, _currentWidth, _currentHeight);

			// reset state after plugin (anything could have changed)

			_currentProgram = null;
			_currentCamera = null;

			_oldBlending = -1;
			_oldDepthTest = false;
			_oldDepthWrite = false;
			_oldDoubleSided = false;
			_oldFlipSided = false;
			_currentGeometryGroupHash = -1;
			_currentMaterialId = -1;

			_lightsNeedUpdate = true;

		}
	}
	
	public function render(scene:Scene, camera:Camera, renderTarget:WebGLRenderTarget, forceClear:Bool = false):Void
	{
		
	}
	
	public function setMaterialShaders(material:Material, shaders:ShaderDef):Void
	{
		material.uniforms = UniformsUtils.clone(shaders.uniforms);
		material.vertexShader = shaders.vertexShader;
		material.fragmentShader = shaders.fragmentShader;
	}

	public function setProgram(camera:Camera, lights:Array<Light>, fog:Fog, material:Material, object:Dynamic):WebGLProgram
	{
		if (material.needsUpdate) 
		{
			if (material.program != null)
				this.deallocateMaterial(material);

			this.initMaterial(material, lights, fog, object);
			material.needsUpdate = false;
		}

		if (material.morphTargets != null) 
		{
			if (object.__webglMorphTargetInfluences == null) 
			{
				object.__webglMorphTargetInfluences = new Float32Array(this.maxMorphTargets);
			}
		}

		var refreshMaterial:Bool = false;

		var program:WebGLProgram = material.program, 
		p_uniforms:Dynamic = program.uniforms, 
		m_uniforms:Dynamic = material.uniforms;

		if (program != _currentProgram) 
		{
			gl.useProgram(program);
			_currentProgram = program;
			refreshMaterial = true;
		}

		if (material.id != _currentMaterialId) 
		{
			_currentMaterialId = material.id;
			refreshMaterial = true;
		}

		if (refreshMaterial || camera != _currentCamera) 
		{
			gl.uniformMatrix4fv(p_uniforms.projectionMatrix, false, camera._projectionMatrixArray);

			if (camera != _currentCamera)
				_currentCamera = camera;

		}

		if (refreshMaterial) 
		{
			// refresh uniforms common to several materials
			if (fog != null && material.fog != null) 
			{
				refreshUniformsFog(m_uniforms, fog);
			}

			if ( Std.is(material, MeshPhongMaterial) || 
				Std.is(material, MeshLambertMaterial) || 
				material.lights != null) 
			{
				if (_lightsNeedUpdate) 
				{
					setupLights(program, lights);
					_lightsNeedUpdate = false;
				}

				refreshUniformsLights(m_uniforms, _lights);
			}

			if ( Std.is(material,MeshBasicMaterial) || 
				Std.is(material,MeshLambertMaterial) || 
				Std.is(material,MeshPhongMaterial) )
			{
				refreshUniformsCommon(m_uniforms, material);
			}

			// refresh single material specific uniforms

			if ( Std.is(material, LineBasicMaterial)) 
			{
				refreshUniformsLine(m_uniforms, material);
			} 
			else if ( Std.is(material,ParticleBasicMaterial)) 
			{
				refreshUniformsParticle(m_uniforms, material);
			} 
			else if ( Std.is(material,MeshPhongMaterial)) 
			{
				refreshUniformsPhong(m_uniforms, material);
			} 
			else if ( Std.is(material,MeshLambertMaterial))
			{
				refreshUniformsLambert(m_uniforms, material);
			} 
			else if ( Std.is(material,MeshDepthMaterial)) 
			{
				m_uniforms.mNear.value = camera.near;
				m_uniforms.mFar.value = camera.far;
				m_uniforms.opacity.value = material.opacity;
			} 
			else if ( Std.is(material,MeshNormalMaterial)) 
			{
				m_uniforms.opacity.value = material.opacity;
			}

			if (object.receiveShadow && !material._shadowPass) 
			{
				refreshUniformsShadow(m_uniforms, lights);
			}

			// load common uniforms

			loadUniformsGeneric(program, material.uniformsList);

			// load material specific uniforms
			// (shader material also gets them for the sake of genericity)

			if ( Std.is(material, ShaderMaterial) || 
				Std.is(material,MeshPhongMaterial) || 
				material.envMap != null) 
			{
				if (p_uniforms.cameraPosition != null) 
				{
					var position:Vector3 = camera.matrixWorld.getPosition();
					gl.uniform3f(p_uniforms.cameraPosition, position.x, position.y, position.z);
				}
			}

			if ( Std.is(material, MeshPhongMaterial) || 
				Std.is(material,MeshLambertMaterial) || 
				Std.is(material,ShaderMaterial) || 
				material.skinning) 
			{
				if (p_uniforms.viewMatrix != null) 
				{
					gl.uniformMatrix4fv(p_uniforms.viewMatrix, false, camera._viewMatrixArray);
				}
			}

		}

		if (material.skinning) 
		{
			if (_supportsBoneTextures && object.useVertexTexture) 
			{
				if (p_uniforms.boneTexture != null) 
				{
					// shadowMap texture array starts from 6
					// texture unit 12 should leave space for 6 shadowmaps
					var textureUnit:Int = 12;
					gl.uniform1i(p_uniforms.boneTexture, textureUnit);
					this.setTexture(object.boneTexture, textureUnit);
				}
			} 
			else 
			{
				if (p_uniforms.boneGlobalMatrices != null) 
				{
					gl.uniformMatrix4fv(p_uniforms.boneGlobalMatrices, false, object.boneMatrices);
				}
			}

		}

		loadUniformsMatrices(p_uniforms, object);

		if (p_uniforms.modelMatrix != null) 
		{
			gl.uniformMatrix4fv(p_uniforms.modelMatrix, false, object.matrixWorld.elements);
		}

		return program;

	}
	
	public function allocateBones(object:Dynamic):Int
	{
		if (_supportsBoneTextures && object != null && object.useVertexTexture)
		{
			return 1024;
		}
		else
		{
			// default for when object is not specified
			// ( for example when prebuilding shader
			//   to be used with multiple objects )
			//
			// 	- leave some extra space for other uniforms
			//  - limit here is ANGLE's 254 max uniform vectors
			//    (up to 54 should be safe)

			var nVertexUniforms:Int = gl.getParameter(gl.MAX_VERTEX_UNIFORM_VECTORS);
			var nVertexMatrices:Int = Math.floor((nVertexUniforms - 20 ) / 4);

			var maxBones:Int = nVertexMatrices;

			if (object != null && Std.is(object,SkinnedMesh)) 
			{
				var skinnedMesh:SkinnedMesh = cast(object, SkinnedMesh);
				maxBones = Std.int(Math.min(skinnedMesh.bones.length, maxBones));
				if (maxBones < skinnedMesh.bones.length) 
				{
					Logger.warn("WebGLRenderer: too many bones - " + skinnedMesh.bones.length + ", this GPU supports just " + maxBones + " (try OpenGL instead of ANGLE)");
				}
			}
			return maxBones;
		}
	}
	public function allocateLights(lights:Array<Light>):Dynamic
	{
		var light:Light;
		var pointLights:Int;
		var spotLights:Int;
		var dirLights:Int;
		var maxDirLights:Int;
		var maxPointLights:Int;
		var maxSpotLights:Int;
		
		dirLights = pointLights = spotLights = maxDirLights = maxPointLights = maxSpotLights = 0;
		
		for ( i in 0...lights.length)
		{
			light = lights[i];
			
			if (light.onlyShadow)
				continue;
				
			if (Std.is(light, DirectionalLight))
			{
				dirLights++;
			}
			else if (Std.is(light, PointLight))
			{
				pointLights++;
			}
			else if (Std.is(light, SpotLight))
			{
				spotLights++;
			}
		}
		
		if (pointLights + spotLights + dirLights <= _maxLights)
		{
			maxDirLights = dirLights;
			maxPointLights = pointLights;
			maxSpotLights = spotLights;
		}
		else
		{
			// this is not really correct
			maxDirLights = Math.ceil(_maxLights * dirLights / (pointLights + dirLights));
			maxPointLights = _maxLights - maxDirLights;
			maxSpotLights = maxPointLights;
		}
		
		return {
			'directional' : maxDirLights,
			'point' : maxPointLights,
			'spot' : maxSpotLights
		};
	}
	
	public function allocateShadows(lights:Array<Light>):Int 
	{
		var light:Light; 
		var maxShadows:Int = 0;

		for ( l in 0...lights.length) 
		{
			light = lights[l];

			if (!light.castShadow)
				continue;

			if ( Std.is(light,SpotLight))
				maxShadows++;
				
			if ( Std.is(light,DirectionalLight) && !cast(light,DirectionalLight).shadowCascade)
				maxShadows++;
		}

		return maxShadows;
	}
	
	public function initGL():Void
	{
		try 
		{
			 gl = cast(_canvas.getContext('experimental-webgl', 
							{
								alpha : _alpha,
								premultipliedAlpha : _premultipliedAlpha,
								antialias : _antialias,
								stencil : _stencil,
								preserveDrawingBuffer : _preserveDrawingBuffer
							}), WebGLRenderingContext);
			
			ThreeGlobal.gl = gl;

			if (gl != null) 
			{
				throw 'Error creating WebGL context.';
			}

		} catch ( error:String ) 
		{
			//console.error(error);
		}

		_glExtensionTextureFloat = cast(gl.getExtension('OES_texture_float'),Bool);
		_glExtensionStandardDerivatives = cast(gl.getExtension('OES_standard_derivatives'),Bool);

		if (gl.getExtension('EXT_texture_filter_anisotropic') != null)
		{
			_glExtensionTextureFilterAnisotropic = gl.getExtension('EXT_texture_filter_anisotropic');
		}
		else if (gl.getExtension('MOZ_EXT_texture_filter_anisotropic') != null)
		{
			_glExtensionTextureFilterAnisotropic = gl.getExtension('MOZ_EXT_texture_filter_anisotropic');
		}
		else if (gl.getExtension('MOZ_EXT_texture_filter_anisotropic') != null)
		{
			_glExtensionTextureFilterAnisotropic = gl.getExtension('WEBKIT_EXT_texture_filter_anisotropic');
		}

		if (!_glExtensionTextureFloat) 
		{
			Logger.log('WebGLRenderer: Float textures not supported.');
		}

		if (!_glExtensionStandardDerivatives) 
		{
			Logger.log('WebGLRenderer: Standard derivatives not supported.');
		}

		if (!_glExtensionTextureFilterAnisotropic) 
		{
			Logger.log('WebGLRenderer: Anisotropic texture filtering not supported.');
		}
	}
	
	public function setDefaultGLState():Void
	{
		gl.clearColor(0, 0, 0, 1);
		gl.clearDepth(1);
		gl.clearStencil(0);

		gl.enable(gl.DEPTH_TEST);
		gl.depthFunc(gl.LEQUAL);

		gl.frontFace(gl.CCW);
		gl.cullFace(gl.BACK);
		gl.enable(gl.CULL_FACE);

		gl.enable(gl.BLEND);
		gl.blendEquation(gl.FUNC_ADD);
		gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);

		gl.clearColor(_clearColor.r, _clearColor.g, _clearColor.b, _clearColor.a);
	}
	
	public function supportsVertexTextures():Bool
	{
		return _supportsVertexTextures;
	}
	
	public function getMaxAnisotropy():Int
	{
		return _maxAnisotropy;
	}
	
	public function setSize(width:Int, height:Int):Void
	{
		_canvas.width = width;
		_canvas.height = height;
		
		setViewport(0, 0, _canvas.width, _canvas.height);
	}
	
	private var _viewportX:Int;
	private var _viewportY:Int;
	private var _viewportWidth:Int;
	private var _viewportHeight:Int;
	public function setViewport(x:Int, y:Int, width:Int, height:Int):Void
	{
		_viewportX = x;
		_viewportY = y;
		_viewportWidth = width;
		_viewportHeight = height;
		
		gl.viewport(_viewportX, _viewportY, _viewportWidth, _viewportHeight);
	}
	
	public function setScissor(x:Int, y:Int, width:Int, height:Int):Void
	{
		gl.scissor(x, y, width, height);
	}
	
	public function enableScissorTest(enable:Bool):Void
	{
		if (enable)
		{
			gl.enable(gl.SCISSOR_TEST);
		}
		else
		{
			gl.disable(gl.SCISSOR_TEST);
		}
	}
	
	public function setClearColor(color:Int):Void
	{
		_clearColor.setRGBA(color);
		
		gl.clearColor(_clearColor.r, _clearColor.g, _clearColor.b, _clearColor.a);
	}
	
	public function getClearColor():Color
	{
		return _clearColor;
	}
	
	public function clear(color:Bool, depth:Bool, stencil:Bool):Void
	{
		var bits:Int = 0;
		
		if (color)
			bits |= gl.COLOR_BUFFER_BIT;
		if (depth)
			bits |= gl.DEPTH_BUFFER_BIT;
		if (stencil)
			bits |= gl.STENCIL_BUFFER_BIT;
		
		gl.clear(bits);
	}
	
	public function clearTarget(renderTarget:WebGLRenderTarget, color:Bool, depth:Bool, stencil:Bool):Void
	{
		this.setRenderTarget(renderTarget);
		this.clear(color, depth, stencil);
	}
	
	private var _currentFramebuffer:WebGLFramebuffer;
	private var _currentWidth:Int;
	private var _currentHeight:Int;
	public function setRenderTarget(renderTarget:WebGLRenderTarget):Void
	{
		if (renderTarget == null)
			return;	
		var isCube:Bool = Std.is(renderTarget, WebGLRenderTargetCube);
		
		if (renderTarget != null && renderTarget.__webglFramebuffer == null)
		{
			renderTarget.depthBuffer = true;
			renderTarget.stencilBuffer = true;
			
			renderTarget.__webglTexture = gl.createTexture();
			
			// Setup texture, create render and frame buffers
			var isTargetPowerOfTwo = MathUtil.isPow2(renderTarget.width) &&
									MathUtil.isPow2(renderTarget.height);
			var glFormat:GLenum = ThreeGlobal.paramThreeToGL(renderTarget.format);
			var glType:GLenum = ThreeGlobal.paramThreeToGL(renderTarget.type);
			
			if (isCube)
			{
				renderTarget.__webglFramebuffer = [];
				renderTarget.__webglRenderbuffer = [];
				
				gl.bindTexture(gl.TEXTURE_CUBE_MAP, renderTarget.__webglTexture);
				setTextureParameters(gl.TEXTURE_CUBE_MAP, renderTarget, isTargetPowerOfTwo);
				
				for (i in 0...6)
				{
					renderTarget.__webglFramebuffer[i] = gl.createFramebuffer();
					renderTarget.__webglRenderbuffer[i] = gl.createRenderbuffer();
					
					gl.texImage2D(gl.TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, glFormat, renderTarget.width, renderTarget.height, 0, glFormat, glType, null);
					
					setupFrameBuffer(renderTarget.__webglFramebuffer[i], renderTarget, gl.TEXTURE_CUBE_MAP_POSITIVE_X + i);
					setupRenderBuffer(renderTarget.__webglRenderbuffer[i], renderTarget);
				}
				
				if (isTargetPowerOfTwo)
					gl.generateMipmap(gl.TEXTURE_CUBE_MAP);
			}
			else
			{
				renderTarget.__webglFramebuffer[0] = gl.createFramebuffer();
				renderTarget.__webglRenderbuffer[0] = gl.createRenderbuffer();
				
				gl.bindTexture(gl.TEXTURE_2D, renderTarget.__webglTexture);
				setTextureParameters(gl.TEXTURE_2D, renderTarget, isTargetPowerOfTwo);
				
				gl.texImage2D(gl.TEXTURE_2D, 0, glFormat, renderTarget.width, renderTarget.height, 0, glFormat, glType, null);

				setupFrameBuffer(renderTarget.__webglFramebuffer[0], renderTarget, gl.TEXTURE_2D);
				setupRenderBuffer(renderTarget.__webglRenderbuffer[0], renderTarget);

				if (isTargetPowerOfTwo)
					gl.generateMipmap(gl.TEXTURE_2D);
			}
			
			//Release everything
			if (isCube)
			{
				gl.bindTexture(gl.TEXTURE_CUBE_MAP, null);
			}
			else
			{
				gl.bindTexture(gl.TEXTURE_2D, null);
			}
			
			gl.bindRenderbuffer(gl.RENDERBUFFER, null);
			gl.bindFramebuffer(gl.FRAMEBUFFER, null);
		}
		
		var framebuffer:WebGLFramebuffer;
		var width:Int, height:Int, vx:Int, vy:Int;
		if (renderTarget != null)
		{
			if (isCube)
			{
				framebuffer = renderTarget.__webglFramebuffer[cast(renderTarget,WebGLRenderTargetCube).activeCubeFace];
			}
			else
			{
				framebuffer = renderTarget.__webglFramebuffer[0];
			}
			
			width = renderTarget.width;
			height = renderTarget.height;
			
			vx = 0;
			vy = 0;
		}
		else
		{
			framebuffer = null;
			
			width = _viewportWidth;
			height = _viewportHeight;
			
			vx = _viewportX;
			vy = _viewportY;
		}
		
		if (framebuffer != _currentFramebuffer)
		{
			gl.bindFramebuffer(gl.FRAMEBUFFER, framebuffer);
			gl.viewport(vx, vy, width, height);
			
			_currentFramebuffer = framebuffer;
		}
		
		_currentWidth = width;
		_currentHeight = height;
	}
	
	public function clampToMaxSize(image:Image, maxSize:Int):HTMLCanvasElement
	{
		if (image.width <= maxSize && image.height <= maxSize) 
		{
			return image;
		}

		// Warning: Scaling through the canvas will only work with images that use
		// premultiplied alpha.

		var maxDimension:Float = Math.max(image.width, image.height);
		var newWidth:Int = Math.floor(image.width * maxSize / maxDimension);
		var newHeight:Int = Math.floor(image.height * maxSize / maxDimension);

		var canvas:HTMLCanvasElement = cast(document.createElement('canvas'),HTMLCanvasElement);
		canvas.width = newWidth;
		canvas.height = newHeight;

		var ctx:CanvasRenderingContext2D = cast(canvas.getContext("2d"),CanvasRenderingContext2D);
		ctx.drawImage(image, 0, 0, image.width, image.height, 0, 0, newWidth, newHeight);

		return canvas;
	}
	
	public function setCubeTexture(texture:Texture, slot:Int):Void
	{
		if (texture.image.length == 6) 
		{
			if (texture.needsUpdate) 
			{
				if (!texture.image.__webglTextureCube) 
				{
					texture.image.__webglTextureCube = gl.createTexture();
				}

				gl.activeTexture(gl.TEXTURE0 + slot);
				gl.bindTexture(gl.TEXTURE_CUBE_MAP, texture.image.__webglTextureCube);

				gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, BoolUtil.toInt(texture.flipY));

				var cubeImage:Array<Dynamic> = [];

				for (i in 0...6) 
				{
					if (this.autoScaleCubemaps)
					{
						cubeImage[i] = clampToMaxSize(texture.image[i], _maxCubemapSize);
					} 
					else
					{
						cubeImage[i] = texture.image[i];
					}
				}

				var image = cubeImage[0], 
				isImagePowerOfTwo = MathUtil.isPowerOfTwo(image.width) && 
									MathUtil.isPowerOfTwo(image.height), 
				glFormat = ThreeGlobal.paramThreeToGL(texture.format), 
				glType = ThreeGlobal.paramThreeToGL(texture.type);

				setTextureParameters(gl.TEXTURE_CUBE_MAP, texture, isImagePowerOfTwo);

				for (i in 0...6) 
				{
					gl.texImage2D(gl.TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, glFormat, glFormat, glType, cubeImage[i]);
				}

				if (texture.generateMipmaps && isImagePowerOfTwo) 
				{
					gl.generateMipmap(gl.TEXTURE_CUBE_MAP);
				}

				texture.needsUpdate = false;

				if (texture.onUpdate != null)
					texture.onUpdate();

			} 
			else 
			{
				gl.activeTexture(gl.TEXTURE0 + slot);
				gl.bindTexture(gl.TEXTURE_CUBE_MAP, texture.image.__webglTextureCube);
			}
		}
	}

	public function setCubeTextureDynamic(texture:Texture, slot:Int):Void
	{
		gl.activeTexture(gl.TEXTURE0 + slot);
		gl.bindTexture(gl.TEXTURE_CUBE_MAP, texture.__webglTexture);
	}
	
	public function setupFrameBuffer(framebuffer:WebGLFramebuffer, renderTarget:WebGLRenderTarget, textureTarget:GLenum):Void
	{
		gl.bindFramebuffer(gl.FRAMEBUFFER, framebuffer);
		gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, textureTarget, renderTarget.__webglTexture, 0);
	}
	
	public function setupRenderBuffer(renderbuffer:WebGLRenderbuffer, renderTarget:WebGLRenderTarget):Void
	{
		gl.bindRenderbuffer(gl.RENDERBUFFER, renderbuffer);
		if (renderTarget.depthBuffer && !renderTarget.stencilBuffer)
		{
			gl.renderbufferStorage(gl.RENDERBUFFER, gl.DEPTH_COMPONENT16, renderTarget.width, renderTarget.height);
			gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.DEPTH_ATTACHMENT, gl.RENDERBUFFER, renderbuffer);
			
			/* For some reason this is not working. Defaulting to RGBA4.
			 } else if( ! renderTarget.depthBuffer && renderTarget.stencilBuffer ) {

			 _gl.renderbufferStorage( _gl.RENDERBUFFER, _gl.STENCIL_INDEX8,
			renderTarget.width, renderTarget.height );
			 _gl.framebufferRenderbuffer( _gl.FRAMEBUFFER, _gl.STENCIL_ATTACHMENT,
			_gl.RENDERBUFFER, renderbuffer );
			 */
		}
		else if(renderTarget.depthBuffer && renderTarget.stencilBuffer)
		{
			gl.renderbufferStorage(gl.RENDERBUFFER, gl.DEPTH_STENCIL, renderTarget.width, renderTarget.height);
			gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.DEPTH_STENCIL_ATTACHMENT, gl.RENDERBUFFER, renderbuffer);
		}
		else
		{
			gl.renderbufferStorage(gl.RENDERBUFFER, gl.RGBA4, renderTarget.width, renderTarget.height);
		}
	}
	
	public function setTextureParameters(textureType:GLenum, texture:Texture, isImagePowerOfTwo:Bool):Void 
	{
		if (isImagePowerOfTwo) 
		{
			gl.texParameteri(textureType, gl.TEXTURE_WRAP_S, ThreeGlobal.paramThreeToGL(texture.wrapS));
			gl.texParameteri(textureType, gl.TEXTURE_WRAP_T, ThreeGlobal.paramThreeToGL(texture.wrapT));

			gl.texParameteri(textureType, gl.TEXTURE_MAG_FILTER, ThreeGlobal.paramThreeToGL(texture.magFilter));
			gl.texParameteri(textureType, gl.TEXTURE_MIN_FILTER, ThreeGlobal.paramThreeToGL(texture.minFilter));
		} 
		else 
		{
			gl.texParameteri(textureType, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri(textureType, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);

			gl.texParameteri(textureType, gl.TEXTURE_MAG_FILTER, ThreeGlobal.filterFallback(texture.magFilter));
			gl.texParameteri(textureType, gl.TEXTURE_MIN_FILTER, ThreeGlobal.filterFallback(texture.minFilter));
		}

		if (_glExtensionTextureFilterAnisotropic && texture.type != ThreeGlobal.FloatType) 
		{
			if (texture.anisotropy > 1 || texture.__oldAnisotropy <= 0) 
			{
				gl.texParameterf(textureType, _glExtensionTextureFilterAnisotropic.TEXTURE_MAX_ANISOTROPY_EXT, 
								Math.min(texture.anisotropy, _maxAnisotropy));
				texture.__oldAnisotropy = texture.anisotropy;
			}
		}
	}
	
	public function updateRenderTargetMipmap(renderTarget:WebGLRenderTarget):Void
	{
		if (Std.is(renderTarget, WebGLRenderTargetCube))
		{
			gl.bindTexture(gl.TEXTURE_CUBE_MAP, renderTarget.__webglTexture);
			gl.generateMipmap(gl.TEXTURE_CUBE_MAP);
			gl.bindTexture(gl.TEXTURE_CUBE_MAP, null);
		}
		else
		{
			gl.bindTexture(gl.TEXTURE_2D, renderTarget.__webglTexture);
			gl.generateMipmap(gl.TEXTURE_2D);
			gl.bindTexture(gl.TEXTURE_2D, null);
		}
	}
	
	public function addPostPlugin(plugin:IPostRenderPlugin):Void
	{
		plugin.init(this);
		this.renderPluginsPost.push(plugin);
	}
	
	public function addPrePlugin(plugin:IPreRenderPlugin):Void
	{
		plugin.init(this);
		this.renderPluginsPre.push(plugin);
	}
	
	private var _currentProgram:WebGLProgram;
	private var _oldBlending:Int;
	private var _oldDepthTest:Bool;
	private var _oldDepthWrite:Bool;
	private var _currentGeometryGroupHash:Int;
	private var _currentMaterialId:Int;
	private var _oldDoubleSided:Bool;
	private var _oldFlipSided:Bool;
	public function updateShadowMap(scene:Scene, camera:Camera):Void
	{
		_currentProgram = null;
		_oldBlending = -1;
		_oldDepthTest = false;
		_oldDepthWrite = false;
		_currentGeometryGroupHash = -1;
		_currentMaterialId = -1;
		_lightsNeedUpdate = true;
		_oldDoubleSided = false;
		_oldFlipSided = false;

		this.shadowMapPlugin.update(scene, camera);
	}
	
	// Internal functions
	// Buffer allocation
	private function createParticleBuffers(geometry:Geometry):Void
	{
		geometry.__webglVertexBuffer = gl.createBuffer();
		geometry.__webglColorBuffer = gl.createBuffer();
		
		this.info.geometries++;
	}
	
	private function createLineBuffers(geometry:Geometry):Void
	{
		geometry.__webglVertexBuffer = gl.createBuffer();
		geometry.__webglColorBuffer = gl.createBuffer();

		this.info.memory.geometries++;
	}
	
	private function createRibbonBuffers(geometry:Geometry):Void
	{
		geometry.__webglVertexBuffer = gl.createBuffer();
		geometry.__webglColorBuffer = gl.createBuffer();

		this.info.memory.geometries++;
	}
	
	private function createMeshBuffers(geometryGroup:Dynamic):Void 
	{
		//geometryGroup.__webglVertexBuffer = gl.createBuffer();
		//geometryGroup.__webglNormalBuffer = gl.createBuffer();
		//geometryGroup.__webglTangentBuffer = gl.createBuffer();
		//geometryGroup.__webglColorBuffer = gl.createBuffer();
		//geometryGroup.__webglUVBuffer = gl.createBuffer();
		//geometryGroup.__webglUV2Buffer = gl.createBuffer();
//
		//geometryGroup.__webglSkinVertexABuffer = gl.createBuffer();
		//geometryGroup.__webglSkinVertexBBuffer = gl.createBuffer();
		//geometryGroup.__webglSkinIndicesBuffer = gl.createBuffer();
		//geometryGroup.__webglSkinWeightsBuffer = gl.createBuffer();
//
		//geometryGroup.__webglFaceBuffer = gl.createBuffer();
		//geometryGroup.__webglLineBuffer = gl.createBuffer();
//
		//if (geometryGroup.numMorphTargets) 
		//{
			//geometryGroup.__webglMorphTargetsBuffers = [];
//
			//for ( m in 0...geometryGroup.numMorphTargets) 
			//{
				//geometryGroup.__webglMorphTargetsBuffers.push(gl.createBuffer());
			//}
		//}
//
		//if (geometryGroup.numMorphNormals) 
		//{
			//geometryGroup.__webglMorphNormalsBuffers = [];
//
			//for ( m in 0...geometryGroup.numMorphNormals) 
			//{
				//geometryGroup.__webglMorphNormalsBuffers.push(gl.createBuffer());
			//}
		//}
		//this.info.memory.geometries++;
	}
	
	// Buffer deallocation

	private function deleteParticleBuffers(geometry:Geometry):Void
	{
		gl.deleteBuffer(geometry.__webglVertexBuffer);
		gl.deleteBuffer(geometry.__webglColorBuffer);

		this.info.memory.geometries--;
	}

	private function deleteLineBuffers(geometry:Geometry):Void
	{
		gl.deleteBuffer(geometry.__webglVertexBuffer);
		gl.deleteBuffer(geometry.__webglColorBuffer);

		this.info.memory.geometries--;
	}

	private function deleteRibbonBuffers(geometry:Geometry):Void
	{
		gl.deleteBuffer(geometry.__webglVertexBuffer);
		gl.deleteBuffer(geometry.__webglColorBuffer);

		this.info.memory.geometries--;
	}

	private function deleteMeshBuffers(geometryGroup:Dynamic):Void 
	{
		//gl.deleteBuffer(geometryGroup.__webglVertexBuffer);
		//gl.deleteBuffer(geometryGroup.__webglNormalBuffer);
		//gl.deleteBuffer(geometryGroup.__webglTangentBuffer);
		//gl.deleteBuffer(geometryGroup.__webglColorBuffer);
		//gl.deleteBuffer(geometryGroup.__webglUVBuffer);
		//gl.deleteBuffer(geometryGroup.__webglUV2Buffer);
//
		//gl.deleteBuffer(geometryGroup.__webglSkinVertexABuffer);
		//gl.deleteBuffer(geometryGroup.__webglSkinVertexBBuffer);
		//gl.deleteBuffer(geometryGroup.__webglSkinIndicesBuffer);
		//gl.deleteBuffer(geometryGroup.__webglSkinWeightsBuffer);
//
		//gl.deleteBuffer(geometryGroup.__webglFaceBuffer);
		//gl.deleteBuffer(geometryGroup.__webglLineBuffer);
//
		//if (geometryGroup.numMorphTargets) 
		//{
			//for ( m in 0...geometryGroup.numMorphTargets) 
			//{
				//gl.deleteBuffer(geometryGroup.__webglMorphTargetsBuffers[m]);
			//}
		//}
//
		//if (geometryGroup.numMorphNormals) 
		//{
			//for ( m in 0...geometryGroup.numMorphNormals) 
			//{
				//gl.deleteBuffer(geometryGroup.__webglMorphNormalsBuffers[m]);
			//}
		//}
//
		//if (geometryGroup.__webglCustomAttributesList) 
		//{
			//for (var id in geometryGroup.__webglCustomAttributesList ) 
			//{
				//gl.deleteBuffer(geometryGroup.__webglCustomAttributesList[id].buffer);
			//}
		//}
//
		//this.info.memory.geometries--;
	}

	// Buffer initialization
	// Deallocation
	//public function deallocateObject(object):Void 
	//{
		//if (!object.__webglInit)
			//return;
//
		//object.__webglInit = false;
		//delete object._modelViewMatrix;
		//delete object._normalMatrix;
		//delete object._normalMatrixArray;
		//delete object._modelViewMatrixArray;
		//delete object._modelMatrixArray;
//
		//if ( object instanceof THREE.Mesh) 
		//{
			//for (var g in object.geometry.geometryGroups ) 
			//{
				//deleteMeshBuffers(object.geometry.geometryGroups[g]);
			//}
		//} 
		//else if ( object instanceof THREE.Ribbon) 
		//{
			//deleteRibbonBuffers(object.geometry);
//
		//} 
		//else if ( object instanceof THREE.Line) 
		//{
			//deleteLineBuffers(object.geometry);
		//} 
		//else if ( object instanceof THREE.ParticleSystem) 
		//{
			//deleteParticleBuffers(object.geometry);
		//}
	//}
//
	//public function deallocateTexture(texture):Void 
	//{
//
		//if (!texture.__webglInit)
			//return;
//
		//texture.__webglInit = false;
		//_gl.deleteTexture(texture.__webglTexture);
//
		//_this.info.memory.textures--;
//
	//};
//
	//public function deallocateRenderTarget(renderTarget):Void 
	//{
//
		//if (!renderTarget || !renderTarget.__webglTexture)
			//return;
//
		//_gl.deleteTexture(renderTarget.__webglTexture);
//
		//if ( renderTarget instanceof THREE.WebGLRenderTargetCube) {
//
			//for (var i = 0; i < 6; i++) {
//
				//_gl.deleteFramebuffer(renderTarget.__webglFramebuffer[i]);
				//_gl.deleteRenderbuffer(renderTarget.__webglRenderbuffer[i]);
//
			//}
//
		//} else {
//
			//_gl.deleteFramebuffer(renderTarget.__webglFramebuffer);
			//_gl.deleteRenderbuffer(renderTarget.__webglRenderbuffer);
//
		//}
//
	//};
//
	private var _programs:Array<ProgramInfo>;
	public function deallocateMaterial(material:Material):Void 
	{
		var program:WebGLProgram = material.program;

		if (program == null)
			return;

		material.program = null;

		 //only deallocate GL program if this was the last use of shared program
		 //assumed there is only single copy of any program in the _programs list
		 //(that's how it's constructed)

		var programInfo:ProgramInfo;
		var deleteProgram:Bool = false;
		for ( i in 0..._programs.length) 
		{
			programInfo = _programs[i];

			if (programInfo.program == program) 
			{
				programInfo.usedTimes--;
				if (programInfo.usedTimes == 0) 
				{
					deleteProgram = true;
				}
				break;
			}
		}

		if (deleteProgram) 
		{
			 //avoid using array.splice, this is costlier than creating new array from
			 //scratch

			var newPrograms:Array<ProgramInfo> = [];
			for ( i in 0..._programs.length) 
			{
				programInfo = _programs[i];
				if (programInfo.program != program) 
				{
					newPrograms.push(programInfo);
				}
			}

			_programs = newPrograms;

			gl.deleteProgram(program);

			this.info.memory.programs--;
		}
	}
	
	public function setTexture(texture:Texture, slot:Int):Void
	{
		if (texture.needsUpdate) 
		{
			if (!texture.__webglInit) 
			{
				texture.__webglInit = true;
				texture.__webglTexture = gl.createTexture();

				this.info.memory.textures++;
			}

			gl.activeTexture(gl.TEXTURE0 + slot);
			gl.bindTexture(gl.TEXTURE_2D, texture.__webglTexture);

			gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, BoolUtil.toInt(texture.flipY));
			gl.pixelStorei(gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, BoolUtil.toInt(texture.premultiplyAlpha));

			var image:Image = texture.image, 
			isImagePowerOfTwo = MathUtil.isPowerOfTwo(image.width) && 
								MathUtil.isPowerOfTwo(image.height), 
			glFormat:GLenum = ThreeGlobal.paramThreeToGL(texture.format), 
			glType:GLenum = ThreeGlobal.paramThreeToGL(texture.type);

			setTextureParameters(gl.TEXTURE_2D, texture, isImagePowerOfTwo);

			if ( Std.is(texture,DataTexture)) 
			{
				gl.texImage2D(gl.TEXTURE_2D, 0, glFormat, image.width, image.height, 0, glFormat, glType, image.data);
			} 
			else 
			{
				gl.texImage2D(gl.TEXTURE_2D, 0, glFormat, glFormat, glType, texture.image);
			}

			if (texture.generateMipmaps && isImagePowerOfTwo)
				gl.generateMipmap(gl.TEXTURE_2D);

			texture.needsUpdate = false;

			if (texture.onUpdate != null)
				texture.onUpdate();

		} 
		else 
		{
			gl.activeTexture(gl.TEXTURE0 + slot);
			gl.bindTexture(gl.TEXTURE_2D, texture.__webglTexture);
		}
	}
	
	// Materials

	public function initMaterial(material:Material, lights:Array<Light>, 
								fog:Dynamic, object:Dynamic):Void
	{
		var u, a, identifiers, i, parameters, maxLightCount, maxBones, maxShadows;

		var shaderID:String = "";
		if ( Std.is(material, MeshDepthMaterial))
		{
			shaderID = 'depth';
		} 
		else if ( Std.is(material, MeshNormalMaterial))
		{
			shaderID = 'normal';
		} 
		else if ( Std.is(material, MeshBasicMaterial)) 
		{
			shaderID = 'basic';
		} 
		else if ( Std.is(material, MeshLambertMaterial)) 
		{
			shaderID = 'lambert';
		} 
		else if ( Std.is(material, MeshPhongMaterial)) 
		{
			shaderID = 'phong';
		} 
		else if ( Std.is(material, LineBasicMaterial)) 
		{
			shaderID = 'basic';
		} 
		else if ( Std.is(material, ParticleBasicMaterial)) 
		{
			shaderID = 'particle_basic';
		}

		if (shaderID != "") 
		{
			setMaterialShaders(material, ShaderLib.getShaderDef(shaderID));
		}

		// heuristics to create shader parameters according to lights in the scene
		// (not to blow over maxLights budget)

		maxLightCount = allocateLights(lights);

		maxShadows = allocateShadows(lights);

		maxBones = allocateBones(object);

		parameters = {

			map : material.map,
			envMap : material.envMap,
			lightMap : material.lightMap,
			bumpMap : material.bumpMap,
			specularMap : material.specularMap,

			vertexColors : material.vertexColors,

			fog : fog,
			useFog : material.fog,

			sizeAttenuation : material.sizeAttenuation,

			skinning : material.skinning,
			maxBones : maxBones,
			useVertexTexture : _supportsBoneTextures && object && object.useVertexTexture,
			boneTextureWidth : object && object.boneTextureWidth,
			boneTextureHeight : object && object.boneTextureHeight,

			morphTargets : material.morphTargets,
			morphNormals : material.morphNormals,
			maxMorphTargets : this.maxMorphTargets,
			maxMorphNormals : this.maxMorphNormals,

			maxDirLights : maxLightCount.directional,
			maxPointLights : maxLightCount.point,
			maxSpotLights : maxLightCount.spot,

			maxShadows : maxShadows,
			shadowMapEnabled : this.shadowMapEnabled && object.receiveShadow,
			shadowMapSoft : this.shadowMapSoft,
			shadowMapDebug : this.shadowMapDebug,
			shadowMapCascade : this.shadowMapCascade,

			alphaTest : material.alphaTest,
			metal : material.metal,
			perPixel : material.perPixel,
			wrapAround : material.wrapAround,
			doubleSided : material.side == ThreeGlobal.DoubleSide
		};

		material.program = buildProgram(shaderID, material.fragmentShader, material.vertexShader, material.uniforms, material.attributes, parameters);

		var attributes:Dynamic = material.program.attributes;

		if (attributes.position >= 0)
			gl.enableVertexAttribArray(attributes.position);
		if (attributes.color >= 0)
			gl.enableVertexAttribArray(attributes.color);
		if (attributes.normal >= 0)
			gl.enableVertexAttribArray(attributes.normal);
		if (attributes.tangent >= 0)
			gl.enableVertexAttribArray(attributes.tangent);

		if (material.skinning && 
			attributes.skinVertexA >= 0 && 
			attributes.skinVertexB >= 0 && 
			attributes.skinIndex >= 0 && 
			attributes.skinWeight >= 0) 
		{
			gl.enableVertexAttribArray(attributes.skinVertexA);
			gl.enableVertexAttribArray(attributes.skinVertexB);
			gl.enableVertexAttribArray(attributes.skinIndex);
			gl.enableVertexAttribArray(attributes.skinWeight);
		}

		if (material.attributes) 
		{
			for (a in material.attributes ) 
			{
				if (attributes[a] != null && attributes[a] >= 0)
					gl.enableVertexAttribArray(attributes[a]);
			}
		}

		if (material.morphTargets) 
		{
			material.numSupportedMorphTargets = 0;

			var id:String;
			var base:String = "morphTarget";
			for ( i in 0...this.maxMorphTargets) 
			{
				id = base + i;
				if (untyped attributes[id] >= 0) 
				{
					gl.enableVertexAttribArray(untyped attributes[id]);
					material.numSupportedMorphTargets++;
				}
			}
		}

		if (material.morphNormals) 
		{
			material.numSupportedMorphNormals = 0;

			var id:String;
			var base:String = "morphNormal";
			for ( i in 0...this.maxMorphNormals) 
			{
				id = base + i;
				if (attributes[id] >= 0) 
				{
					gl.enableVertexAttribArray(attributes[id]);
					material.numSupportedMorphNormals++;
				}
			}
		}

		material.uniformsList = [];

		for (u in material.uniforms ) 
		{
			material.uniformsList.push([material.uniforms[u], u]);
		}

	}
	
	public function setupMatrices(object:Object3D, camera:Camera):Void
	{
		object._modelViewMatrix.multiply(camera.matrixWorldInverse, object.matrixWorld);

		object._normalMatrix.getInverse(object._modelViewMatrix);
		object._normalMatrix.transpose();
	}
	
	// Uniforms (refresh uniforms objects)

	private function refreshUniformsCommon(uniforms:Dynamic, material:Material):Void
	{
		uniforms.opacity.value = material.opacity;

		if (this.gammaInput) 
		{
			uniforms.diffuse.value.copyGammaToLinear(material.color);
		} 
		else 
		{
			uniforms.diffuse.value = material.color;
		}

		uniforms.map.texture = material.map;
		uniforms.lightMap.texture = material.lightMap;
		uniforms.specularMap.texture = material.specularMap;

		if (material.bumpMap != null) 
		{
			uniforms.bumpMap.texture = material.bumpMap;
			uniforms.bumpScale.value = material.bumpScale;
		}

		// uv repeat and offset setting priorities
		//	1. color map
		//	2. specular map
		//	3. bump map

		var uvScaleMap:Texture;

		if (material.map != null) 
		{
			uvScaleMap = material.map;
		} 
		else if (material.specularMap != null) 
		{
			uvScaleMap = material.specularMap;
		} 
		else if (material.bumpMap != null) 
		{
			uvScaleMap = material.bumpMap;
		}

		if (uvScaleMap  != null) 
		{
			var offset:Vector2 = uvScaleMap.offset;
			var repeat:Vector2 = uvScaleMap.repeat;
			uniforms.offsetRepeat.value.set(offset.x, offset.y, repeat.x, repeat.y);
		}

		uniforms.envMap.texture = material.envMap;
		uniforms.flipEnvMap.value = (Std.is(material.envMap, WebGLRenderTargetCube) ) ? 1 : -1;

		if (this.gammaInput) 
		{
			//uniforms.reflectivity.value = material.reflectivity * material.reflectivity;
			uniforms.reflectivity.value = material.reflectivity;
		} 
		else 
		{
			uniforms.reflectivity.value = material.reflectivity;
		}

		uniforms.refractionRatio.value = material.refractionRatio;
		uniforms.combine.value = material.combine;
		uniforms.useRefract.value = material.envMap != null && Std.is(material.envMap.mapping,CubeRefractionMapping);
	}

	private function refreshUniformsLine(uniforms:Dynamic, material:Material):Void
	{
		uniforms.diffuse.value = material.color;
		uniforms.opacity.value = material.opacity;
	}

	private function refreshUniformsParticle(uniforms:Dynamic, material:Material):Void
	{
		uniforms.psColor.value = material.color;
		uniforms.opacity.value = material.opacity;
		uniforms.size.value = material.size;
		uniforms.scale.value = _canvas.height / 2.0;
		// TODO: Cache this.

		uniforms.map.texture = material.map;
	}

	private function refreshUniformsFog(uniforms:Dynamic, fog:IFog):Void
	{
		uniforms.fogColor.value = fog.color;

		if ( Std.is(fog, Fog)) 
		{
			var fog:Fog = cast(fog, Flog);
			uniforms.fogNear.value = fog.near;
			uniforms.fogFar.value = fog.far;
		} 
		else if ( Std.is(fog,FogExp2)) 
		{
			uniforms.fogDensity.value = cast(fog,FogExp2).density;
		}
	}

	private function refreshUniformsPhong(uniforms:Dynamic, material:Material):Void
	{
		uniforms.shininess.value = material.shininess;

		if (this.gammaInput) 
		{
			uniforms.ambient.value.copyGammaToLinear(material.ambient);
			uniforms.emissive.value.copyGammaToLinear(material.emissive);
			uniforms.specular.value.copyGammaToLinear(material.specular);
		} 
		else 
		{
			uniforms.ambient.value = material.ambient;
			uniforms.emissive.value = material.emissive;
			uniforms.specular.value = material.specular;
		}

		if (material.wrapAround) 
		{
			uniforms.wrapRGB.value.copy(material.wrapRGB);
		}
	}

	private function refreshUniformsLambert(uniforms:Dynamic, material:Material):Void
	{
		if (this.gammaInput) 
		{
			uniforms.ambient.value.copyGammaToLinear(material.ambient);
			uniforms.emissive.value.copyGammaToLinear(material.emissive);
		} 
		else 
		{
			uniforms.ambient.value = material.ambient;
			uniforms.emissive.value = material.emissive;
		}

		if (material.wrapAround) 
		{
			uniforms.wrapRGB.value.copy(material.wrapRGB);
		}
	}

	private function refreshUniformsLights(uniforms:Dynamic, lights:LightsDef):Void
	{
		uniforms.ambientLightColor.value = lights.ambient;

		uniforms.directionalLightColor.value = lights.directional.colors;
		uniforms.directionalLightDirection.value = lights.directional.positions;

		uniforms.pointLightColor.value = lights.point.colors;
		uniforms.pointLightPosition.value = lights.point.positions;
		uniforms.pointLightDistance.value = lights.point.distances;

		uniforms.spotLightColor.value = lights.spot.colors;
		uniforms.spotLightPosition.value = lights.spot.positions;
		uniforms.spotLightDistance.value = lights.spot.distances;
		uniforms.spotLightDirection.value = lights.spot.directions;
		uniforms.spotLightAngle.value = lights.spot.angles;
		uniforms.spotLightExponent.value = lights.spot.exponents;
	}

	private function refreshUniformsShadow(uniforms:Dynamic, lights:Array<Light>):Void
	{
		if (uniforms.shadowMatrix) 
		{
			var j = 0;
			for (i in 0...lights.length) 
			{
				var light:Light = lights[i];

				if (!light.castShadow)
					continue;

				if ( Std.is(light, SpotLight) || 
					(Std.is(light, DirectionalLight) && !light.shadowCascade ))
				{
					uniforms.shadowMap.texture[j] = light.shadowMap;
					uniforms.shadowMapSize.value[j] = light.shadowMapSize;

					uniforms.shadowMatrix.value[j] = light.shadowMatrix;

					uniforms.shadowDarkness.value[j] = light.shadowDarkness;
					uniforms.shadowBias.value[j] = light.shadowBias;

					j++;
				}
			}
		}
	}

	// Uniforms (load to GPU)

	private function loadUniformsMatrices(uniforms:Dynamic, object:Object3D):Void
	{
		gl.uniformMatrix4fv(uniforms.modelViewMatrix, false, object._modelViewMatrix.elements);

		if (uniforms.normalMatrix != null) 
		{
			gl.uniformMatrix3fv(uniforms.normalMatrix, false, object._normalMatrix.elements);
		}
	}

	private function loadUniformsGeneric(program:WebGLProgram, uniforms:Array<Uniform>):Void
	{
		var uniform:Uniform; 
		var value:Dynamic; 
		var type:String;
		var location:WebGLUniformLocation;
		var texture:Dynamic;
		var offset:Int;

		for ( j in 0...uniforms.length) 
		{
			location = program.uniforms[uniforms[ j ][1]];
			if (location != null)
				continue;

			uniform = uniforms[ j ][0];

			type = uniform.type;
			value = uniform.value;

			if (type == "i") 
			{
				// single integer
				gl.uniform1i(location, value);
			} 
			else if (type == "f") 
			{
				// single float
				gl.uniform1f(location, value);
			} 
			else if (type == "v2") 
			{
				var vec2:Vector2 = cast(value, Vector2);
				// single THREE.Vector2
				gl.uniform2f(location, vec2.x, vec2.y);
			} 
			else if (type == "v3") 
			{
				var vec3:Vector3 = cast(value, Vector3);
				// single THREE.Vector3
				gl.uniform3f(location, vec3.x, vec3.y, vec3.z);
			} 
			else if (type == "v4") 
			{
				var vec4:Vector4 = cast(value, Vector4);
				// single THREE.Vector4
				gl.uniform4f(location, vec4.x, vec4.y, vec4.z, vec4.w);
			} 
			else if (type == "c") 
			{
				var color:Color = cast(value, Color);
				// single THREE.Color
				gl.uniform3f(location, color.r, color.g, color.b);
			} 
			else if (type == "iv1") 
			{
				// flat array of integers (JS or typed array)
				gl.uniform1iv(location, value);
			} 
			else if (type == "iv") 
			{
				// flat array of integers with 3 x N size (JS or typed array)
				gl.uniform3iv(location, value);
			} 
			else if (type == "fv1")
			{
				// flat array of floats (JS or typed array)
				gl.uniform1fv(location, value);
			} 
			else if (type == "fv") 
			{
				// flat array of floats with 3 x N size (JS or typed array)
				gl.uniform3fv(location, value);
			} 
			else if (type == "v2v") 
			{
				var arr:Array<Vector2> = cast(value, Array);
				// array of THREE.Vector2
				if (uniform._array == null) 
				{
					uniform._array = new Float32Array(2 * arr.length);
				}

				for ( i in 0...arr.length) 
				{
					offset = i * 2;

					uniform._array[offset] = arr[i].x;
					uniform._array[offset + 1] = arr[i].y;
				}
				gl.uniform2fv(location, uniform._array);
			}
			else if (type == "v3v") 
			{
				var arr:Array<Vector3> = cast(value, Array);
				// array of THREE.Vector3
				if (uniform._array == null) 
				{
					uniform._array = new Float32Array(3 * arr.length);
				}

				for ( i in 0...arr.length) 
				{
					offset = i * 3;

					uniform._array[offset] = arr[i].x;
					uniform._array[offset + 1] = arr[i].y;
					uniform._array[offset + 2] = arr[i].z;
				}
				gl.uniform3fv(location, uniform._array);
			} 
			else if (type == "v4v") 
			{
				var arr:Array<Vector4> = cast(value, Array);
				// array of THREE.Vector4
				if (uniform._array == null) 
				{
					uniform._array = new Float32Array(4 * arr.length);
				}

				for ( i in 0...arr.length) 
				{
					offset = i * 4;

					uniform._array[offset] = arr[i].x;
					uniform._array[offset + 1] = arr[i].y;
					uniform._array[offset + 2] = arr[i].z;
					uniform._array[offset + 3] = arr[i].w;
				}

				gl.uniform4fv(location, uniform._array);
			} 
			else if (type == "m4") 
			{
				// single THREE.Matrix4
				if (uniform._array == null) 
				{
					uniform._array = new Float32Array(16);
				}

				value.flattenToArray(uniform._array);
				gl.uniformMatrix4fv(location, false, uniform._array);
			} 
			else if (type == "m4v") 
			{
				var arr:Array<Matrix4> = cast(value, Array);
				// array of THREE.Matrix4
				if (uniform._array == null) 
				{
					uniform._array = new Float32Array(16 * arr.length);
				}

				for ( i in 0...arr.length) 
				{
					value[i].flattenToArrayOffset(uniform._array, i * 16);
				}
				gl.uniformMatrix4fv(location, false, uniform._array);
			} 
			else if (type == "t") 
			{
				// single THREE.Texture (2d or cube)
				gl.uniform1i(location, value);
				texture = uniform.texture;
				if (texture == null)
					continue;
				if (Std.is(texture.image,Array) && texture.image.length == 6) 
				{
					setCubeTexture(texture, value);
				} 
				else if ( Std.is(texture,WebGLRenderTargetCube)) 
				{
					setCubeTextureDynamic(texture, value);
				} 
				else 
				{
					this.setTexture(texture, value);
				}
			} 
			else if (type == "tv") 
			{
				// array of THREE.Texture (2d)
				if (uniform._array == null) 
				{
					uniform._array = [];
					for ( i in 0...uniform.texture.length) 
					{
						uniform._array[i] = value + i;
					}
				}

				gl.uniform1iv(location, uniform._array);

				for ( i in 0...uniform.texture.length) 
				{
					texture = uniform.texture[i];
					if (!texture)
						continue;
					this.setTexture(texture, uniform._array[i]);
				}
			}
		}
	}

	private function setupLights(program:WebGLProgram, lights:Array<Light>):Void
	{

		var light:Light;
		var color:Color;
		var intensity:Float;
		var r:Float = 0, g:Float = 0, b:Float = 0; 
		var n, 
		position,
		distance, zlights = _lights, 
		dcolors = zlights.directional.colors, 
		dpositions = zlights.directional.positions, 
		pcolors = zlights.point.colors, 
		ppositions = zlights.point.positions, 
		pdistances = zlights.point.distances, 
		scolors = zlights.spot.colors, 
		spositions = zlights.spot.positions, 
		sdistances = zlights.spot.distances, 
		sdirections = zlights.spot.directions, 
		sangles = zlights.spot.angles, 
		sexponents = zlights.spot.exponents, 
		dlength = 0, 
		plength = 0, 
		slength = 0, 
		doffset = 0, 
		poffset = 0, 
		soffset = 0;

		for ( l in 0...lights.length) 
		{
			light = lights[l];

			if (light.onlyShadow || !light.visible)
				continue;

			color = light.color;
			intensity = light.intensity;
			distance = light.distance;

			if ( Std.is(light, AmbientLight)) 
			{
				if (this.gammaInput)
				{
					r += color.r * color.r;
					g += color.g * color.g;
					b += color.b * color.b;
				} 
				else 
				{
					r += color.r;
					g += color.g;
					b += color.b;
				}
			}
			else if ( Std.is(light, DirectionalLight)) 
			{
				doffset = dlength * 3;
				if (this.gammaInput) 
				{
					dcolors[doffset] = color.r * color.r * intensity * intensity;
					dcolors[doffset + 1] = color.g * color.g * intensity * intensity;
					dcolors[doffset + 2] = color.b * color.b * intensity * intensity;
				} 
				else 
				{
					dcolors[doffset] = color.r * intensity;
					dcolors[doffset + 1] = color.g * intensity;
					dcolors[doffset + 2] = color.b * intensity;
				}

				_direction.copy(light.matrixWorld.getPosition());
				_direction.subSelf(light.target.matrixWorld.getPosition());
				_direction.normalize();

				dpositions[doffset] = _direction.x;
				dpositions[doffset + 1] = _direction.y;
				dpositions[doffset + 2] = _direction.z;

				dlength += 1;

			}
			else if ( Std.is(light, PointLight)) 
			{
				poffset = plength * 3;
				if (this.gammaInput) 
				{
					pcolors[poffset] = color.r * color.r * intensity * intensity;
					pcolors[poffset + 1] = color.g * color.g * intensity * intensity;
					pcolors[poffset + 2] = color.b * color.b * intensity * intensity;
				} 
				else 
				{
					pcolors[poffset] = color.r * intensity;
					pcolors[poffset + 1] = color.g * intensity;
					pcolors[poffset + 2] = color.b * intensity;
				}

				position = light.matrixWorld.getPosition();

				ppositions[poffset] = position.x;
				ppositions[poffset + 1] = position.y;
				ppositions[poffset + 2] = position.z;

				pdistances[plength] = distance;

				plength += 1;

			} 
			else if ( Std.is(light, SpotLight)) 
			{
				var spotLight:SpotLight = cast(light, SpotLight);
				
				soffset = slength * 3;

				if (this.gammaInput) 
				{
					scolors[soffset] = color.r * color.r * intensity * intensity;
					scolors[soffset + 1] = color.g * color.g * intensity * intensity;
					scolors[soffset + 2] = color.b * color.b * intensity * intensity;
				} 
				else 
				{
					scolors[soffset] = color.r * intensity;
					scolors[soffset + 1] = color.g * intensity;
					scolors[soffset + 2] = color.b * intensity;
				}

				position = spotLight.matrixWorld.getPosition();

				spositions[soffset] = position.x;
				spositions[soffset + 1] = position.y;
				spositions[soffset + 2] = position.z;

				sdistances[slength] = distance;

				_direction.copy(position);
				_direction.subSelf(light.target.matrixWorld.getPosition());
				_direction.normalize();

				sdirections[soffset] = _direction.x;
				sdirections[soffset + 1] = _direction.y;
				sdirections[soffset + 2] = _direction.z;

				sangles[slength] = Math.cos(spotLight.angle);
				sexponents[slength] = spotLight.exponent;

				slength += 1;
			}
		}

		// null eventual remains from removed lights
		// (this is to avoid if in shader)

		for ( l in dlength * 3...dcolors.length)
			dcolors[l] = 0.0;
		for ( l in plength * 3...pcolors.length)
			pcolors[l] = 0.0;
		for ( l in slength * 3...scolors.length)
			scolors[l] = 0.0;

		zlights.directional.length = dlength;
		zlights.point.length = plength;
		zlights.spot.length = slength;

		zlights.ambient[0] = r;
		zlights.ambient[1] = g;
		zlights.ambient[2] = b;

	}
	
	// GL state setting

	public function setFaceCulling(cullFace:String, frontFace:String):Void 
	{
		if (cullFace != "") 
		{
			if (frontFace == "ccw") 
			{
				gl.frontFace(gl.CCW);
			}
			else 
			{
				gl.frontFace(gl.CW);
			}

			if (cullFace == "back") 
			{
				gl.cullFace(gl.BACK);
			} 
			else if (cullFace == "front") 
			{
				gl.cullFace(gl.FRONT);
			} 
			else 
			{
				gl.cullFace(gl.FRONT_AND_BACK);
			}

			gl.enable(gl.CULL_FACE);

		} 
		else 
		{
			gl.disable(gl.CULL_FACE);
		}
	}

	public function setMaterialFaces(material:Material):Void 
	{

		var doubleSided:Bool = material.side == ThreeGlobal.DoubleSide;
		var flipSided:Bool = material.side == ThreeGlobal.BackSide;

		if (_oldDoubleSided != doubleSided) 
		{
			if (doubleSided) 
			{
				gl.disable(gl.CULL_FACE);
			} 
			else 
			{
				gl.enable(gl.CULL_FACE);
			}

			_oldDoubleSided = doubleSided;
		}

		if (_oldFlipSided != flipSided) 
		{
			if (flipSided) 
			{
				gl.frontFace(gl.CW);
			} 
			else 
			{
				gl.frontFace(gl.CCW);
			}
			_oldFlipSided = flipSided;
		}
	}

	public function setDepthTest(depthTest:Bool):Void
	{
		if (_oldDepthTest != depthTest) 
		{
			if (depthTest) 
			{
				gl.enable(gl.DEPTH_TEST);
			} 
			else 
			{
				gl.disable(gl.DEPTH_TEST);
			}
			_oldDepthTest = depthTest;
		}
	}

	public function setDepthWrite(depthWrite:Bool):Void
	{
		if (_oldDepthWrite != depthWrite)
		{
			gl.depthMask(depthWrite);
			_oldDepthWrite = depthWrite;
		}
	}

	private var _oldLineWidth:Float;
	public function setLineWidth(width:Float):Void
	{
		if (width != _oldLineWidth) 
		{
			gl.lineWidth(width);

			_oldLineWidth = width;
		}
	}

	private var _oldPolygonOffset:Float;
	private var _oldPolygonOffsetFactor:Float;
	private var _oldPolygonOffsetUnits:Int;
	public function setPolygonOffset(polygonoffset:Float, factor:Float, units:Int):Void
	{
		if (_oldPolygonOffset != polygonoffset) 
		{
			if (polygonoffset > 0) 
			{
				gl.enable(gl.POLYGON_OFFSET_FILL);
			} 
			else 
			{
				gl.disable(gl.POLYGON_OFFSET_FILL);
			}

			_oldPolygonOffset = polygonoffset;
		}

		if (polygonoffset > 0 && 
			(_oldPolygonOffsetFactor != factor || 
			_oldPolygonOffsetUnits != units )) 
		{
			gl.polygonOffset(factor, units);

			_oldPolygonOffsetFactor = factor;
			_oldPolygonOffsetUnits = units;
		}
	}

	private var _oldBlendEquation:Int;
	private var _oldBlendSrc:Int;
	private var _oldBlendDst:Int;
	public function setBlending(blending:Int, blendEquation:Int, blendSrc:Int, blendDst:Int):Void
	{
		if (blending != _oldBlending)
		{
			if (blending == ThreeGlobal.NoBlending) 
			{
				gl.disable(gl.BLEND);
			} 
			else if (blending == ThreeGlobal.AdditiveBlending) 
			{
				gl.enable(gl.BLEND);
				gl.blendEquation(gl.FUNC_ADD);
				gl.blendFunc(gl.SRC_ALPHA, gl.ONE);
			} 
			else if (blending == ThreeGlobal.SubtractiveBlending) 
			{
				// TODO: Find blendFuncSeparate() combination
				gl.enable(gl.BLEND);
				gl.blendEquation(gl.FUNC_ADD);
				gl.blendFunc(gl.ZERO, gl.ONE_MINUS_SRC_COLOR);
			} 
			else if (blending == ThreeGlobal.MultiplyBlending) 
			{
				// TODO: Find blendFuncSeparate() combination
				gl.enable(gl.BLEND);
				gl.blendEquation(gl.FUNC_ADD);
				gl.blendFunc(gl.ZERO, gl.SRC_COLOR);
			}
			else if (blending == ThreeGlobal.CustomBlending) 
			{
				gl.enable(gl.BLEND);
			}
			else 
			{
				gl.enable(gl.BLEND);
				gl.blendEquationSeparate(gl.FUNC_ADD, gl.FUNC_ADD);
				gl.blendFuncSeparate(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA, gl.ONE, gl.ONE_MINUS_SRC_ALPHA);
			}

			_oldBlending = blending;
		}

		if (blending == ThreeGlobal.CustomBlending) 
		{
			if (blendEquation != _oldBlendEquation) 
			{
				gl.blendEquation(ThreeGlobal.paramThreeToGL(blendEquation));

				_oldBlendEquation = blendEquation;
			}

			if (blendSrc != _oldBlendSrc || blendDst != _oldBlendDst) 
			{
				gl.blendFunc(ThreeGlobal.paramThreeToGL(blendSrc), ThreeGlobal.paramThreeToGL(blendDst));

				_oldBlendSrc = blendSrc;
				_oldBlendDst = blendDst;
			}
		}
		else 
		{
			_oldBlendEquation = null;
			_oldBlendSrc = null;
			_oldBlendDst = null;
		}
	}

	// Shaders
	private static var _programs_counter:Int = 0;
	public function buildProgram(shaderID:String, 
								fragmentShader:String, vertexShader:String, 
								uniforms:Dynamic, 
								attributes:Dynamic, parameters:Dynamic):WebGLProgram
	{

		var p, pl, program; 
		var code:String;
		var chunks:Array<Dynamic> = [];

		// Generate code
		if (shaderID != "") 
		{
			chunks.push(shaderID);
		} 
		else 
		{
			chunks.push(fragmentShader);
			chunks.push(vertexShader);
		}

		
		for (p in parameters ) 
		{
			chunks.push(p);
			chunks.push(parameters[p]);
		}

		code = chunks.join("");

		// Check if code has been already compiled

		for ( p in 0..._programs.length) 
		{
			var programInfo:ProgramInfo = _programs[p];

			if (programInfo.code == code) 
			{
				//Logger.log( "Code already compiled." /*: \n\n" + code*/ );
				programInfo.usedTimes++;
				return programInfo.program;
			}
		}

		//Logger.log( "building new program " );

		//

		program = gl.createProgram();

		var prefix_vertex = ["precision " + _precision + " float;", 
		_supportsVertexTextures ? "#define VERTEX_TEXTURES" : "", 
		this.gammaInput ? "#define GAMMA_INPUT" : "", 
		this.gammaOutput ? "#define GAMMA_OUTPUT" : "", 
		this.physicallyBasedShading ? "#define PHYSICALLY_BASED_SHADING" : "",
		"#define MAX_DIR_LIGHTS " + parameters.maxDirLights,
		"#define MAX_POINT_LIGHTS " + parameters.maxPointLights,
		"#define MAX_SPOT_LIGHTS " + parameters.maxSpotLights,
		"#define MAX_SHADOWS " + parameters.maxShadows,
		"#define MAX_BONES " + parameters.maxBones,
		parameters.map ? "#define USE_MAP" : "",
		parameters.envMap ? "#define USE_ENVMAP" : "",
		parameters.lightMap ? "#define USE_LIGHTMAP" : "",
		parameters.bumpMap ? "#define USE_BUMPMAP" : "",
		parameters.specularMap ? "#define USE_SPECULARMAP" : "", parameters.vertexColors ? "#define USE_COLOR" : "", parameters.skinning ? "#define USE_SKINNING" : "",
		parameters.useVertexTexture ? "#define BONE_TEXTURE" : "",
		parameters.boneTextureWidth ? "#define N_BONE_PIXEL_X " + parameters.boneTextureWidth.toFixed(1) : "",
		parameters.boneTextureHeight ? "#define N_BONE_PIXEL_Y " + parameters.boneTextureHeight.toFixed(1) : "",
		parameters.morphTargets ? "#define USE_MORPHTARGETS" : "",
		parameters.morphNormals ? "#define USE_MORPHNORMALS" : "",
		parameters.perPixel ? "#define PHONG_PER_PIXEL" : "",
		parameters.wrapAround ? "#define WRAP_AROUND" : "",
		parameters.doubleSided ? "#define DOUBLE_SIDED" : "",
		parameters.shadowMapEnabled ? "#define USE_SHADOWMAP" : "",
		parameters.shadowMapSoft ? "#define SHADOWMAP_SOFT" : "",
		parameters.shadowMapDebug ? "#define SHADOWMAP_DEBUG" : "",
		parameters.shadowMapCascade ? "#define SHADOWMAP_CASCADE" : "",
		parameters.sizeAttenuation ? "#define USE_SIZEATTENUATION" : "",
		"uniform mat4 modelMatrix;", "uniform mat4 modelViewMatrix;",
		"uniform mat4 projectionMatrix;", "uniform mat4 viewMatrix;",
		"uniform mat3 normalMatrix;", "uniform vec3 cameraPosition;",
		"attribute vec3 position;", "attribute vec3 normal;",
		"attribute vec2 uv;", "attribute vec2 uv2;", "#ifdef USE_COLOR",
		"attribute vec3 color;", "#endif", "#ifdef USE_MORPHTARGETS",
		"attribute vec3 morphTarget0;", "attribute vec3 morphTarget1;",
		"attribute vec3 morphTarget2;", "attribute vec3 morphTarget3;",
		"#ifdef USE_MORPHNORMALS", "attribute vec3 morphNormal0;",
		"attribute vec3 morphNormal1;", 
		"attribute vec3 morphNormal2;",
		"attribute vec3 morphNormal3;", 
		"#else", "attribute vec3 morphTarget4;",
		"attribute vec3 morphTarget5;", 
		"attribute vec3 morphTarget6;", 
		"attribute vec3 morphTarget7;", 
		"#endif", "#endif", 
		"#ifdef USE_SKINNING", 
		"attribute vec4 skinVertexA;", 
		"attribute vec4 skinVertexB;", 
		"attribute vec4 skinIndex;", 
		"attribute vec4 skinWeight;", 
		"#endif", ""].join("\n");

		var prefix_fragment = ["precision " + _precision + " float;", 
		parameters.bumpMap ? "#extension GL_OES_standard_derivatives : enable" : "",
		"#define MAX_DIR_LIGHTS " + parameters.maxDirLights,
		"#define MAX_POINT_LIGHTS " + parameters.maxPointLights,
		"#define MAX_SPOT_LIGHTS " + parameters.maxSpotLights,
		"#define MAX_SHADOWS " + parameters.maxShadows,
		parameters.alphaTest ? "#define ALPHATEST " + parameters.alphaTest : "",
		this.gammaInput ? "#define GAMMA_INPUT" : "",
		this.gammaOutput ? "#define GAMMA_OUTPUT" : "",
		this.physicallyBasedShading ? "#define PHYSICALLY_BASED_SHADING" : "",
		(parameters.useFog && parameters.fog ) ? "#define USE_FOG" : "",
		(parameters.useFog && Std.is(parameters.fog,FogExp2) ) ? "#define FOG_EXP2" : "",
		parameters.map ? "#define USE_MAP" : "", parameters.envMap ? "#define USE_ENVMAP" : "",
		parameters.lightMap ? "#define USE_LIGHTMAP" : "", parameters.bumpMap ? "#define USE_BUMPMAP" : "",
		parameters.specularMap ? "#define USE_SPECULARMAP" : "", parameters.vertexColors ? "#define USE_COLOR" : "",
		parameters.metal ? "#define METAL" : "", parameters.perPixel ? "#define PHONG_PER_PIXEL" : "",
		parameters.wrapAround ? "#define WRAP_AROUND" : "",
		parameters.doubleSided ? "#define DOUBLE_SIDED" : "",
		parameters.shadowMapEnabled ? "#define USE_SHADOWMAP" : "",
		parameters.shadowMapSoft ? "#define SHADOWMAP_SOFT" : "",
		parameters.shadowMapDebug ? "#define SHADOWMAP_DEBUG" : "", 
		parameters.shadowMapCascade ? "#define SHADOWMAP_CASCADE" : "",
		"uniform mat4 viewMatrix;", "uniform vec3 cameraPosition;",
		""].join("\n");

		var glFragmentShader:WebGLShader = getShader("fragment", prefix_fragment + fragmentShader);
		var glVertexShader:WebGLShader = getShader("vertex", prefix_vertex + vertexShader);

		gl.attachShader(program, glVertexShader);
		gl.attachShader(program, glFragmentShader);

		gl.linkProgram(program);

		if (!gl.getProgramParameter(program, gl.LINK_STATUS)) 
		{
			Logger.error("Could not initialise shader\n" + "VALIDATE_STATUS: " + 
							gl.getProgramParameter(program, gl.VALIDATE_STATUS) + 
							", gl error [" + gl.getError() + "]");
		}

		// clean up
		gl.deleteShader(glFragmentShader);
		gl.deleteShader(glVertexShader);

		//console.log( prefix_fragment + fragmentShader );
		//console.log( prefix_vertex + vertexShader );

		program.uniforms = {};
		program.attributes = {};

		var identifiers, u, a, i;

		// cache uniform locations

		identifiers = ['viewMatrix', 
						'modelViewMatrix', 
						'projectionMatrix', 
						'normalMatrix', 
						'modelMatrix', 
						'cameraPosition', 
						'morphTargetInfluences'];

		if (parameters.useVertexTexture) 
		{
			identifiers.push('boneTexture');
		} 
		else 
		{
			identifiers.push('boneGlobalMatrices');
		}

		for (u in uniforms ) 
		{
			identifiers.push(u);
		}

		cacheUniformLocations(program, identifiers);

		// cache attributes locations

		identifiers = ["position", 
						"normal", 
						"uv", 
						"uv2", 
						"tangent", 
						"color", 
						"skinVertexA", 
						"skinVertexB", 
						"skinIndex", 
						"skinWeight"];

		for ( i in 0...parameters.maxMorphTargets) 
		{
			identifiers.push("morphTarget" + i);
		}

		for ( i in 0...parameters.maxMorphNormals) 
		{
			identifiers.push("morphNormal" + i);
		}

		for (a in attributes ) 
		{
			identifiers.push(a);
		}

		cacheAttributeLocations(program, identifiers);

		program.id = _programs_counter++;
		
		var pInfo:ProgramInfo = {
			program : program,
			code : code,
			usedTimes : 1
		};

		_programs.push(pInfo);

		this.info.memory.programs = _programs.length;

		return program;
	}
	
	// Shader parameters cache
	public function cacheUniformLocations(program:WebGLProgram, identifiers:Array<String>):Void
	{
		var id:String;
		for ( i in 0...identifiers.length) 
		{
			id = identifiers[i];
			program.uniforms[id] = gl.getUniformLocation(program, id);
		}
	}

	public function cacheAttributeLocations(program:WebGLProgram, identifiers:Array<String>):Void
	{
		var id:String;
		for ( i in 0...identifiers.length) 
		{
			id = identifiers[i];
			program.attributes[id] = gl.getAttribLocation(program, id);
		}
	}

	public function addLineNumbers(source:String):String
	{
		var chunks:Array<String> = source.split("\n");
		for (i in 0...chunks.length) 
		{
			// Chrome reports shader errors on lines
			// starting counting from 1
			chunks[i] = (i + 1 ) + ": " + chunks[i];
		}
		return chunks.join("\n");
	}

	public function getShader(type:String, source:String):WebGLShader
	{
		var shader:WebGLShader;
		if (type == "fragment") 
		{
			shader = gl.createShader(gl.FRAGMENT_SHADER);
		} 
		else if (type == "vertex") 
		{
			shader = gl.createShader(gl.VERTEX_SHADER);
		}

		gl.shaderSource(shader, source);
		gl.compileShader(shader);

		if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) 
		{
			Logger.error(gl.getShaderInfoLog(shader));
			Logger.error(addLineNumbers(source));
			return null;
		}
		return shader;
	}
}