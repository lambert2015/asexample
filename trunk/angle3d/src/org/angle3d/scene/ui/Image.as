package org.angle3d.scene.ui
{
	import org.angle3d.material.MaterialTexture;
	import org.angle3d.math.Vector3f;
	import org.angle3d.renderer.queue.QueueBucket;
	import org.angle3d.scene.CullHint;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.shape.Quad;
	import org.angle3d.texture.TextureMapBase;

	/**
	 * A Image represents a 2D image drawn on the screen.
	 * It can be used to represent sprites or other background elements.
	 */
	public class Image extends Geometry
	{
		private var mWidth:Number;
		private var mHeight:Number;

		public function Image(name:String, flipY:Boolean)
		{
			super(name, new Quad(1, 1, flipY));

			this.localQueueBucket=QueueBucket.Gui;
			this.localCullHint=CullHint.Never;
		}

		public function setSize(width:Number, height:Number):void
		{
			mWidth=width;
			mHeight=height;
			setScaleXYZ(mWidth, mHeight, 1);
		}

		public function setPosition(x:Number, y:Number):void
		{
			var z:Number=this.getTranslation().z;
			this.setTranslationXYZ(x, y, z);
		}

		public function setTexture(texture:TextureMapBase, useAlpha:Boolean):void
		{
			if (mMaterial == null)
			{
				mMaterial=new MaterialTexture(texture);
				this.setMaterial(mMaterial);
			}
			(mMaterial as MaterialTexture).texture=texture;
		}
	}
}
