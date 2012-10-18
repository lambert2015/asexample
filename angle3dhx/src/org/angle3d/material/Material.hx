package org.angle3d.material;
import flash.Vector;
import org.angle3d.material.technique.Technique;
import org.angle3d.math.Color;
import org.angle3d.math.FastMath;

/**
 * <code>Material</code> describes the rendering style for a given 
 * {@link Geometry}. 
 * 
 */
class Material 
{
	/**
	 * 特殊函数，用于执行一些static变量的定义等(有这个函数时，static变量预先赋值必须也放到这里面)
	 */
	static function __init__():Void
	{
	}
	
	public var cullMode:Int;
	public var doubleSide:Bool;
	
	public var emissiveColor:Color;
	public var ambientColor:Color;
	public var diffuseColor:Color;
	public var specularColor:Color;
	
	private var _alpha:Float;
	public var alpha(_getAlpha, _setAlpha):Float;

	public var _techniques:Vector<Technique>;

	public function new() 
	{
		_techniques = new Vector<Technique>();
		
		emissiveColor = new Color(0, 0, 0, 1);
		ambientColor = new Color(1, 1, 1, 0);
		diffuseColor = new Color(1, 1, 1, 1);
		specularColor = new Color(1, 1, 1, 1);
		
		doubleSide = false;
		cullMode = FaceCullMode.Back;
		
		_alpha = 1.0;
	}
	
	public function getTechniques():Vector<Technique>
	{
		return _techniques;
	}
	
	public inline function getTechniqueAt(i:Int):Technique
	{
		return _techniques[i];
	}
	
	public inline function addTechnique(t:Technique):Void
	{
		_techniques.push(t);
	}
	
	private function _setAlpha(alpha:Float):Float
	{
		_alpha = FastMath.fclamp(alpha, 0.0, 1.0);
		//这里这样是不对的，临时测试用
		if (_alpha < 1)
		{
			getTechniqueAt(0).getRenderState().applyBlendMode = true;
			getTechniqueAt(0).getRenderState().blendMode = BlendMode.AlphaAdditive;
		}
		else
		{
			getTechniqueAt(0).getRenderState().applyBlendMode = false;
			//getTechniqueAt(0).getRenderState().blendMode = BlendMode.AlphaAdditive;
		}
		return _alpha;
	}
	
	private function _getAlpha():Float
	{
		return _alpha;
	}
	
	public function clone():Material
	{
		var mat:Material = new Material();
		return mat;
	}
}