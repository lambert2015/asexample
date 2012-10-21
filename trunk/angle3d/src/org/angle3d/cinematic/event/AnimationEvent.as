package org.angle3d.cinematic.event
{
	import org.angle3d.animation.AnimChannel;
	import org.angle3d.animation.AnimControl;
	import org.angle3d.scene.Spatial;

	//TODO 继续添加内容
	public class AnimationEvent extends AbstractCinematicEvent
	{
		protected var channel:AnimChannel;
		protected var animationName:String;
		protected var modelName:String;

		public function AnimationEvent(model:Spatial, animationName:String, initialDuration:Number=10, mode:int=0)
		{
			super(initialDuration, mode);

			modelName=model.name;
			this.animationName=animationName;
			initialDuration=(model.getControlByClass(AnimControl) as AnimControl).getAnimationLength(animationName);
		}
	}
}
