package three.materials;
import three.utils.Logger;
import three.math.Color;
import three.math.Vector3;
import three.ThreeGlobal;
import three.textures.Texture;
import three.lights.Light;
import UserAgentContext;
/**
 * ...
 * @author andy
 */

class Material 
{
	public static var MaterialCount:Int = 0;

	public var id:Int;
	public var name:String;
	
	public var side:Int;
	
	public var opacity:Float;
	public var transparent:Bool;
	
	public var blending:Int;
	
	public var blendSrc:Int;
	public var blendDst:Int;
	public var blendEquation:Int;
	
	public var depthTest:Bool;
	public var depthWrite:Bool;
	
	public var polygonOffset:Bool;
	public var polygonOffsetFactor:Float;
	public var polygonOffsetUnits:Int;
	
	public var alphaTest:Int = 0;
	
	public var overdraw:Bool;
	
	public var visible:Bool;
	
	public var needsUpdate:Bool;
	
	public var uniforms:Dynamic;
	public var vertexShader:String;
	public var fragmentShader:String;
	public var program:WebGLProgram;
	
	public var uniformsList:Dynamic;
	
	public var skinning:Bool;
	
	public var morphTargets:Dynamic;
	public var morphNormals:Dynamic;
	
	public var envMap:Texture;
	public var map:Texture;
	public var lightMap:Texture;
	public var bumpMap:Texture;
	public var specularMap:Texture;
	
	public var fog:Bool;
	
	public var sizeAttenuation:Float;
	
	public var vertexColors:Array<Float>;
	
	public var lights:Array<Light>;
	
	public var metal:Dynamic;
	public var perPixel:Dynamic;
	public var wrapAround:Dynamic;
	
	public var _shadowPass:Bool;
	public function new() 
	{
		this.id = MaterialCount++;

		this.name = '';

		this.side = ThreeGlobal.FrontSide;

		this.opacity = 1;
		this.transparent = false;

		this.blending = ThreeGlobal.NormalBlending;

		this.blendSrc = ThreeGlobal.SrcAlphaFactor;
		this.blendDst = ThreeGlobal.OneMinusSrcAlphaFactor;
		this.blendEquation = ThreeGlobal.AddEquation;

		this.depthTest = true;
		this.depthWrite = true;

		this.polygonOffset = false;
		this.polygonOffsetFactor = 0;
		this.polygonOffsetUnits = 0;

		this.alphaTest = 0;

		this.overdraw = false;
		// Boolean for fixing antialiasing gaps in CanvasRenderer

		this.visible = true;

		this.needsUpdate = true;
	}
	
	public function setValues(values:Dynamic):Void
	{
		if (values == null)
			return;
		
		var fields:Array<String> = Type.getClassFields(values);
		for (key in fields)
		{
			var newValue = Reflect.field(values, key);
			
			if (newValue == null) 
			{
				Logger.warn('Material: \'' + key + '\' parameter is undefined.');
				continue;
			}
			
			if (Reflect.hasField(this,key))
			{
				var currentValue = Reflect.field(values, key);
				
				if (Std.is(currentValue, Color) && Std.is(newValue, Color)) 
				{
					untyped currentValue.copy(newValue);
				} 
				else if ( Std.is(currentValue, Color) && Std.is(newValue,Float)) 
				{
					untyped currentValue.setHex(newValue);
				} 
				else if ( Std.is(currentValue, Vector3) && Std.is(newValue,Vector3)) 
				{
					untyped currentValue.copy(newValue);
				} 
				else 
				{
					Reflect.setField(this, key, newValue);
				}
			}
		}
	}

	public function clone(?material:Material = null):Material 
	{
		if (material == null)
			material = new Material();

		material.name = this.name;

		material.side = this.side;

		material.opacity = this.opacity;
		material.transparent = this.transparent;

		material.blending = this.blending;

		material.blendSrc = this.blendSrc;
		material.blendDst = this.blendDst;
		material.blendEquation = this.blendEquation;

		material.depthTest = this.depthTest;
		material.depthWrite = this.depthWrite;

		material.polygonOffset = this.polygonOffset;
		material.polygonOffsetFactor = this.polygonOffsetFactor;
		material.polygonOffsetUnits = this.polygonOffsetUnits;

		material.alphaTest = this.alphaTest;

		material.overdraw = this.overdraw;

		material.visible = this.visible;

		return material;
	}
}