package org.angle3d.material
{

	import flash.display3D.Context3DTriangleFace;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Vector3f;
	import org.angle3d.math.Vector4f;

	import org.angle3d.material.technique.Technique;
	import org.angle3d.math.Color;
	import org.angle3d.math.FastMath;
	import org.angle3d.texture.TextureMapBase;

	/**
	 * <code>Material</code> describes the rendering style for a given <code>Geometry</code>.
	 * <p>A material is essentially a list of {@link MatParam parameters},
	 * those parameters map to uniforms which are defined in a shader.
	 * Setting the parameters can modify the behavior of a
	 * shader.
	 * <p/>
	 * 
	 */
	public class Material
	{
		private var mCullMode:String;

		private var mEmissiveColor:Color;
		private var mAmbientColor:Color;
		private var mDiffuseColor:Color;
		private var mSpecularColor:Color;

		private var mAlpha:Number;

		protected var sortingId:int = -1;

		protected var _techniques:Vector.<Technique>;

		public function Material()
		{
			_techniques = new Vector.<Technique>();

			mEmissiveColor = new Color(0, 0, 0, 1);
			mAmbientColor = new Color(1, 1, 1, 0);
			mDiffuseColor = new Color(1, 1, 1, 1);
			mSpecularColor = new Color(1, 1, 1, 1);

			mCullMode = Context3DTriangleFace.FRONT;

			mAlpha = 1.0;
		}

		public function set skinningMatrices(data:Vector.<Number>):void
		{

		}

		public function set influence(value:Number):void
		{

		}

		public function set cullMode(mode:String):void
		{
			if (mCullMode == mode)
				return;

			mCullMode = mode;

			var size:int = _techniques.length;
			for (var i:int = 0; i < size; i++)
			{
				_techniques[i].renderState.cullMode = mode;
			}
		}

		public function get cullMode():String
		{
			return mCullMode;
		}

		public function set doubleSide(value:Boolean):void
		{
			if (value)
			{
				mCullMode = Context3DTriangleFace.NONE;
			}

			var size:int = _techniques.length;
			for (var i:int = 0; i < size; i++)
			{
				_techniques[i].renderState.cullMode = mCullMode;
			}
		}

		public function get doubleSide():Boolean
		{
			return mCullMode == Context3DTriangleFace.NONE;
		}

		public function getTechniques():Vector.<Technique>
		{
			return _techniques;
		}

		public function getTechniqueAt(i:int):Technique
		{
			return _techniques[i];
		}

		public function addTechnique(t:Technique):void
		{
			_techniques.push(t);
		}

		public function set alpha(alpha:Number):void
		{
			mAlpha = FastMath.fclamp(alpha, 0.0, 1.0);
		}

		public function get alpha():Number
		{
			return mAlpha;
		}

		public function getSortId():int
		{
			return sortingId;
		}

		public function clone():Material
		{
			var mat:Material = new Material();
			return mat;
		}

		public function setInt(key:String, value:int):void
		{
			// TODO Auto Generated method stub

		}

		public function setFloat(key:String, value:Number):void
		{
			// TODO Auto Generated method stub

		}

		public function setColor(key:String, color:Color):void
		{

		}

		public function setTexture(key:String, texture:TextureMapBase):void
		{

		}
		
		public function setMatrix4(key:String, matrix4:Matrix4f):void
		{
			
		}
		
		public function setVector4(key:String, vec:Vector4f):void
		{
			
		}
		
		public function setVector3(key:String, vec:Vector3f):void
		{
			
		}
	}
}

