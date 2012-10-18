package org.angle3d.animation
{
	import org.angle3d.utils.TempVars;

	/**
	 * SkeletonAnimControl is a Spatial control that allows manipulation
	 * of skeletal animation.
	 *
	 */
	public class SkeletonAnimControl extends AnimControl
	{
		/**
		 * Skeleton object must contain corresponding data for the targets' weight buffers.
		 */
		public var skeleton : Skeleton;

		public function SkeletonAnimControl(skeleton : Skeleton)
		{
			super();

			this.skeleton = skeleton;
			this.skeleton.resetAndUpdate();

		}
		
		override protected function controlUpdate(tpf : Number) : void
		{
			if(mNumchannels > 0)
			{
				skeleton.reset();
				
				var tempVars : TempVars = TempVars.getTempVars();
				
				for (var i : int = 0; i < mNumchannels; i++)
				{
					mChannels[i].update(tpf, tempVars);
				}
				
				//释放临时变量
				tempVars.release();
				
				skeleton.update();
			}
			
			
		}
	}
}
