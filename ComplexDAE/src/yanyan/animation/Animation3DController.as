package yanyan.animation
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * 控制所有骨骼节点的动画转换更新 
	 * 
	 * @author harry
	 * @date 11.05 2012
	 * 
	 */
	public class Animation3DController
	{
		protected var mJointsChannel:Vector.<Animation3DChannel> = null;
		
		public function Animation3DController()
		{
			mJointsChannel = new Vector.<Animation3DChannel>();
			mClipsList = new Vector.<Animation3DClip>();
			
			mDictClipsName = new Dictionary();
		}
		
		/*
		 * 添加Joint对应的动画通道
		 *
		 * 
		 */
		public function addChannel(c:Animation3DChannel):void
		{
			mJointsChannel.push( c );
		}
		
		
		/*
		 * 添加时间轴上一段时间所决定的剪辑 
		 * 
		 * 
		 */
		protected var mClipsList:Vector.<Animation3DClip> = null;
		protected var mDictClipsName:Dictionary = null;
		public function addClips(name:String, clip:Animation3DClip):void
		{
			if( mClipsList.indexOf(clip) != -1 )
			{
				mJointsChannel.push( clip );
				mDictClipsName[name] = clip;
			}
		}
		
		/*
		 * 控制剪辑的更新
		 * 
		 * 
		 */
		protected var _mIsPlaying:Boolean = false;
		protected var _mIsPause:Boolean = false;
		protected var _mPlayClipName:String = '';
		protected var _mCurrentTimeStamp:Number = .0;
		protected var _mCurrentTimelineStamp:Number = .0;
		protected var _mCurrentClipName:String = '';
		
		public var mAnimationTotalTime:Number = 0.0;
		public var mAnimationDelayStartTime:Number = .0;
		public var mAnimationFPS:uint = 0;
		
		public function play(clipName:String='all', mode:uint=0):void
		{
			if( !mJointsChannel.length )
				return;
			
			if( clipName != 'all' && !mDictClipsName[clipName] )
			{
				trace('$error: ','cannot find this clip.');
				return;
			}
			
			_mIsPlaying = true;
			_mCurrentClipName = clipName;
			
			// start count time
			_mCurrentTimeStamp = getTimer();
			
			if( _mCurrentClipName == 'all' )
				_mCurrentTimelineStamp = .0;
			else
				_mCurrentTimelineStamp = Animation3DClip( mDictClipsName[clipName] ).mStartTime;
			
			trace("info: ","start play animation, clipName=",_mCurrentClipName);
		}
		
		public function stop():void
		{
			_mIsPlaying = false;
			_mIsPause = false;
		}
		
		public function resume():void
		{
			_mIsPause = false;
		}
		
		public function pause():void
		{
			_mIsPause = true;
		}
		
		public function get isPlaying():Boolean {return _mIsPlaying;}
		
		public function get isPause():Boolean {return _mIsPause;}
		
		/*
		 * 更新动画控制器 
		 * 
		 * 
		 */
		public function update():void
		{
			if( !isPlaying || isPause )
				return;
			
			// get time delta
			var t:Number = getTimer();
			var deltaTime:Number = t - _mCurrentTimeStamp;
			deltaTime = Math.max(0, deltaTime);
			
			// loop animation
			if( _mCurrentTimelineStamp > mAnimationTotalTime+mAnimationDelayStartTime )
				_mCurrentTimelineStamp = 0.0;
				
			_mCurrentTimelineStamp += deltaTime/1000;
			_mCurrentTimeStamp = t;
			
			
			// update animation channel
			for each(var c:Animation3DChannel in mJointsChannel)
				c.interpolate( _mCurrentTimelineStamp );
				
			//trace('info: ',"update animation clip, include all channel. time=", _mCurrentTimelineStamp);
		}
	}
}