package org.angle3d.animation
{
	import flash.utils.Dictionary;
	
	import org.angle3d.scene.control.AbstractControl;
	import org.angle3d.utils.TempVars;

	/**
	 * AnimControl is a Spatial control that allows manipulation
	 * of animation.
	 *
	 */
	//TODO 事件改用AS3Signals
	public class AnimControl extends AbstractControl
	{

		/**
		 * List of animations
		 */
		protected var mAnimationMap:Dictionary;

		/**
		 * Animation channels
		 */
		protected var mChannels:Vector.<AnimChannel>;
		
		protected var mNumchannels:int;


		public function AnimControl()
		{
			super();

			mAnimationMap = new Dictionary();

			mChannels = new Vector.<AnimChannel>();
			mNumchannels=0;
		}

		public function addAnimation(name:String, animation:Animation):void
		{
			mAnimationMap[name] = animation;
		}

		public function getAnimation(name:String):Animation
		{
			return mAnimationMap[name];
		}
		
		public function getAnimationLength( name:String):Number 
		{
			var a:Animation = mAnimationMap.get(name);
			if (a == null) 
			{
				throw new Error("The animation " + name
					+ " does not exist in this AnimControl");
			}
			
			return a.time;
		}

		public function removeChannel(channel:AnimChannel):void
		{
			var index:int = mChannels.indexOf(channel);
			if (index > -1)
			{
				mChannels.splice(index, 1);
				mNumchannels--;
			}
		}

		/**
		 * Create a new animation channel, by default assigned to all bones
		 * in the skeleton.
		 *
		 * @return A new animation channel for this <code>AnimControl</code>.
		 */
		public function createChannel():AnimChannel
		{
			var channel:AnimChannel = new AnimChannel(this);
			mChannels.push(channel);
			mNumchannels++;
			return channel;
		}

		/**
		 * Internal use only.
		 */
		override protected function controlUpdate(tpf:Number):void
		{
			if(mNumchannels > 0)
			{
				var tempVars:TempVars = TempVars.getTempVars();
				
				for (var i:int = 0; i < mNumchannels; i++)
				{
					mChannels[i].update(tpf, tempVars);
				}
				
				//释放临时变量
				tempVars.release();
			}
		}
	}
}

