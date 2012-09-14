package three.renderers;

import js.Dom;
import js.Lib;
import three.lights.Light;
import three.lights.DirectionalLight;
import three.lights.SpotLight;
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
import three.scenes.Scene;
import three.cameras.Camera;
import three.Three;
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
							}),WebGLRenderingContext);

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
	
	public function setRenderTarget(renderTarget:WebGLRenderTarget):Void
	{
		if (renderTarget == null)
			return;	
		var isCube:Bool = Std.is(renderTarget, WebGLRenderTargetCube);
		
		if (renderTarget.__webglFramebuffer == null)
		{
			renderTarget.depthBuffer = true;
			renderTarget.stencilBuffer = true;
			
			renderTarget.__webglTexture = gl.createTexture();
			
			// Setup texture, create render and frame buffers
			var isTargetPowerOfTow = MathUtil.isPow2(renderTarget.width) &&
									MathUtil.isPow2(renderTarget.height);
			var glFormat:GLenum = Three.paramThreeToGL(renderTarget.format, gl);
			var glType:GLenum = Three.paramThreeToGL(renderTarget.type, gl);
			
			if (isCube)
			{
				renderTarget.__webglFramebuffer = [];
				renderTarget.__webglRenderbuffer = [];
				
				gl.bindTexture(gl.TEXTURE_CUBE_MAP, renderTarget.__webglTexture);
				setTextureParameters(gl.TEXTURE_CUBE_MAP, renderTarget, isTargetPowerOfTow);
				
				for (i in 0...6)
				{
					renderTarget.__webglFramebuffer[i] = gl.createFramebuffer();
					renderTarget.__webglRenderbuffer[i] = gl.createRenderbuffer();
					
					gl.texImage2D(gl.TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, glFormat, renderTarget.width, renderTarget.height, 0, glFormat, glType, null);
					
					setupFrameBuffer(renderTarget.__webglFramebuffer[i], renderTarget, gl.TEXTURE_CUBE_MAP_POSITIVE_X + i);
					setupRenderBuffer(renderTarget.__webglRenderbuffer[i], renderTarget);
				}
				
				if (isTargetPowerOfTow)
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
}