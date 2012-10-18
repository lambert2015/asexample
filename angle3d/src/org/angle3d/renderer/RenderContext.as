package org.angle3d.renderer
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	
	import org.angle3d.material.BlendMode;

	/**
	 * Represents the current state of the graphics library. This public class is used
	 * internally to reduce state changes.
	 */
	public class RenderContext
	{
		/**
		 * If back-face culling is enabled.
		 */
		public var cullMode : String;

		/**
		 * If Depth testing is enabled.
		 */
		public var depthTest : Boolean;
		
		public var compareMode:String;

		public var colorWrite : Boolean;

		public var clipRectEnabled : Boolean;

		public var blendMode : int;

		public function RenderContext()
		{
			reset();
		}

		public function reset() : void
		{
			cullMode = Context3DTriangleFace.FRONT;
			depthTest = false;
			compareMode = Context3DCompareMode.LESS_EQUAL;
			colorWrite = false;
			clipRectEnabled = false;
			blendMode = BlendMode.Off;
		}
	}
}

