package three.renderers;

import js.Dom;
import js.Lib;
import three.core.Geometry;
import three.lights.Light;
import three.lights.DirectionalLight;
import three.lights.SpotLight;
import three.lights.PointLight;
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
import three.scenes.Scene;
import three.objects.SkinnedMesh;
import three.cameras.Camera;
import three.textures.Texture;
import three.ThreeGlobal;
import three.utils.Logger;
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
	private var _lights:Dynamic;
	
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
	
	public function render(scene:Scene, camera:Camera, renderTarget:WebGLRenderTarget, forceClear:Bool = false):Void
	{
		
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
	
	public function setTextureParameters(textureType:GLenum, texture:WebGLRenderTarget, isImagePowerOfTwo:Bool):Void 
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
	private var _oldDepthTest:Int;
	private var _oldDepthWrite:Int;
	private var _currentGeometryGroupHash:Int;
	private var _currentMaterialId:Int;
	private var _oldDoubleSided:Int;
	private var _oldFlipSided:Int;
	public function updateShadowMap(scene:Scene, camera:Camera):Void
	{
		_currentProgram = null;
		_oldBlending = -1;
		_oldDepthTest = -1;
		_oldDepthWrite = -1;
		_currentGeometryGroupHash = -1;
		_currentMaterialId = -1;
		_lightsNeedUpdate = true;
		_oldDoubleSided = -1;
		_oldFlipSided = -1;

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
	//public function deallocateMaterial(material):Void 
	//{
//
		//var program = material.program;
//
		//if (!program)
			//return;
//
		//material.program = undefined;
//
		// only deallocate GL program if this was the last use of shared program
		// assumed there is only single copy of any program in the _programs list
		// (that's how it's constructed)
//
		//var i, il, programInfo;
		//var deleteProgram = false;
//
		//for ( i = 0, il = _programs.length; i < il; i++) {
//
			//programInfo = _programs[i];
//
			//if (programInfo.program === program) {
//
				//programInfo.usedTimes--;
//
				//if (programInfo.usedTimes === 0) {
//
					//deleteProgram = true;
//
				//}
//
				//break;
//
			//}
//
		//}
//
		//if (deleteProgram) {
//
			// avoid using array.splice, this is costlier than creating new array from
			// scratch
//
			//var newPrograms = [];
//
			//for ( i = 0, il = _programs.length; i < il; i++) {
//
				//programInfo = _programs[i];
//
				//if (programInfo.program !== program) {
//
					//newPrograms.push(programInfo);
//
				//}
//
			//}
//
			//_programs = newPrograms;
//
			//_gl.deleteProgram(program);
//
			//_this.info.memory.programs--;
//
		//}
//
	//}

}