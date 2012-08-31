package three.renderers;

import js.Dom;
import three.lights.Light;
import three.lights.DirectionalLight;
import three.lights.SpotLight;
import three.math.Color;
import UserAgentContext;
/**
 * ...
 * @author 
 */

class WebGLRenderer implements IRenderer
{
	public var domElement:Dynamic;
	public var context:WebGLRenderingContext;

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
	
	private var _canvas:Dynamic;
	
	private var _clearColor:Color;

	public function new(parameters:Dynamic = null) 
	{
		if (parameters == null)
			parameters = { };
	}
	
	public function render():Void
	{
		
	}
	
	public function allocateShadows(lights:Array<Light>):Void 
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
		//try {
//
			//if (!( _gl = _canvas.getContext('experimental-webgl', {
				//alpha : _alpha,
				//premultipliedAlpha : _premultipliedAlpha,
				//antialias : _antialias,
				//stencil : _stencil,
				//preserveDrawingBuffer : _preserveDrawingBuffer
			//}) )) {
//
				//throw 'Error creating WebGL context.';
//
			//}
//
		//} catch ( error ) {
//
			//console.error(error);
//
		//}
//
		//_glExtensionTextureFloat = _gl.getExtension('OES_texture_float');
		//_glExtensionStandardDerivatives = _gl.getExtension('OES_standard_derivatives');
//
		//_glExtensionTextureFilterAnisotropic = _gl.getExtension('EXT_texture_filter_anisotropic') || _gl.getExtension('MOZ_EXT_texture_filter_anisotropic') || _gl.getExtension('WEBKIT_EXT_texture_filter_anisotropic');
//
		//if (!_glExtensionTextureFloat) {
//
			//console.log('THREE.WebGLRenderer: Float textures not supported.');
//
		//}
//
		//if (!_glExtensionStandardDerivatives) {
//
			//console.log('THREE.WebGLRenderer: Standard derivatives not supported.');
//
		//}
//
		//if (!_glExtensionTextureFilterAnisotropic) {
//
			//console.log('THREE.WebGLRenderer: Anisotropic texture filtering not supported.');
//
		//}
	}
	
	public function setDefaultGLState():Void
	{
		context.clearColor(0, 0, 0, 1);
		context.clearDepth(1);
		context.clearStencil(0);

		context.enable(context.DEPTH_TEST);
		context.depthFunc(context.LEQUAL);

		context.frontFace(context.CCW);
		context.cullFace(context.BACK);
		context.enable(context.CULL_FACE);

		context.enable(context.BLEND);
		context.blendEquation(context.FUNC_ADD);
		context.blendFunc(context.SRC_ALPHA, context.ONE_MINUS_SRC_ALPHA);

		context.clearColor(_clearColor.r, _clearColor.g, _clearColor.b, _clearColor.a);
	}
}