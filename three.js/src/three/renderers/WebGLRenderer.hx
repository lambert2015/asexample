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
	
	private var _clearColor:Color;
	
	private var _maxLights:Int;
	
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
		this.context = null;

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
		_frustum = new Frustum(),

		// camera matrices cache

		_projScreenMatrix = new Matrix4(), 
		_projScreenMatrixPS = new Matrix4(), 
		_vector3 = new THREE.Vector4(),

		// light arrays cache

		_direction = new Vector3(), 
		_lightsNeedUpdate = true, 
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

		var _glExtensionTextureFloat;
		var _glExtensionStandardDerivatives;
		var _glExtensionTextureFilterAnisotropic;

		initGL();

		setDefaultGLState();

		// GPU capabilities

		_maxVertexTextures = gl.getParameter(gl.MAX_VERTEX_TEXTURE_IMAGE_UNITS);
		_maxTextureSize = gl.getParameter(_gl.MAX_TEXTURE_SIZE); 
		_maxCubemapSize = gl.getParameter(_gl.MAX_CUBE_MAP_TEXTURE_SIZE);

		_maxAnisotropy = _glExtensionTextureFilterAnisotropic ? gl.getParameter(_glExtensionTextureFilterAnisotropic.MAX_TEXTURE_MAX_ANISOTROPY_EXT) : 0;

		_supportsVertexTextures = (_maxVertexTextures > 0 );
		_supportsBoneTextures = _supportsVertexTextures && _glExtensionTextureFloat;
	}
	
	private var _glExtensionTextureFloat:Bool;
	private var _glExtensionStandardDerivatives:Bool;
	private var _glExtensionTextureFilterAnisotropic:Bool;
	
	private var _maxVertexTextures:Int;
	private var _maxTextureSize:Int;
	private var _maxCubemapSize:Int;
	
	private var _maxVertexTextures:Int;
	private var _maxAnisotropy:Int;
	private var _supportsVertexTextures:Bool;
	private var _supportsBoneTextures:Bool;
	
	public function render():Void
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
		try {

			if (!( gl = _canvas.getContext('experimental-webgl', 
							{
								alpha : _alpha,
								premultipliedAlpha : _premultipliedAlpha,
								antialias : _antialias,
								stencil : _stencil,
								preserveDrawingBuffer : _preserveDrawingBuffer
							}))) 
			{
				throw 'Error creating WebGL context.';
			}

		} catch ( error ) {
			//console.error(error);
		}

		_glExtensionTextureFloat = gl.getExtension('OES_texture_float');
		_glExtensionStandardDerivatives = gl.getExtension('OES_standard_derivatives');

		_glExtensionTextureFilterAnisotropic = gl.getExtension('EXT_texture_filter_anisotropic') || 
											gl.getExtension('MOZ_EXT_texture_filter_anisotropic') || 
											gl.getExtension('WEBKIT_EXT_texture_filter_anisotropic');

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
}