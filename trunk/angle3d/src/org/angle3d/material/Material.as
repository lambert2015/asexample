package org.angle3d.material
{

	import flash.display3D.Context3DTriangleFace;

	import org.angle3d.material.technique.Technique;
	import org.angle3d.math.Color;
	import org.angle3d.math.FastMath;

	/**
	 * <code>Material</code> describes the rendering style for a given
	 * {@link Geometry}.
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

		private var _techniques:Vector.<Technique>;

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

		public function clone():Material
		{
			var mat:Material = new Material();
			return mat;
		}
	}
}

