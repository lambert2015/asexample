package yanyan.animation
{
	import flash.geom.Matrix3D;
	
	import yanyan.namespaces.collada;

	/**
	 * 针对骨骼节点的动画通道 
	 * 
	 * @date 11.05 2012
	 * @author harry
	 * 
	 */
	public class Animation3DChannel
	{
		private var mTimeList:Vector.<Number> = null;
		private var mKeyCurveValues:Vector.<Matrix3D> = null;
		private var mInterpolationsType:Vector.<String> = null;
		
		public var mAffectTargetId:String = '';
		public var mJointPointer:Joint3D = null;
		
		public function Animation3DChannel()
		{
			mTimeList = new Vector.<Number>;
			mKeyCurveValues = new Vector.<Matrix3D>;
			mInterpolationsType = new Vector.<String>;
			
		}
		
		public function parse(item:XML):Animation3DChannel
		{
			var sampler:XML = item.collada::sampler[0];
			if( !sampler )
			{
				// to check, animation.animation
				//
				// @NOTICE
				//
				item = item.collada::animation[0];
				sampler = item.collada::sampler[0];
			}
			
			var type:String, itemSource:XML;
			var itemSourceKey:String = '';
			
			for each(var input:XML in sampler.collada::input)
			{
				type = input.@semantic;
				itemSourceKey = input.@source.toString().substr(1);
				itemSource = item.collada::source.( @id == itemSourceKey )[0];
				var strValue:String = '';
				if( itemSource )
				{
					switch(type)
					{
						case 'INPUT':
							strValue = trimArrayElements(itemSource.collada::float_array.toString(), " ");
							mTimeList = Vector.<Number>( strValue.split(/\s+/) );
							break;
						case 'OUTPUT':
							strValue = trimArrayElements(itemSource.collada::float_array.toString(), " ");
							parseMatrix( strValue.split(/\s+/) );
							break;
						case 'INTERPOLATION':
							strValue = trimArrayElements(itemSource.collada::Name_array.toString(), " ");
							mInterpolationsType = Vector.<String>( strValue.split(/\s+/) );
							break;
					}
				}
			}
			
			// get bind bone's name
			var targetName:String = item.collada::channel.@target.toString();
			mAffectTargetId = targetName.substring(0, targetName.lastIndexOf("/") );
			
			return this;
		}
		
		private function parseMatrix(values:Array):void
		{
			var count:uint = values.length/16;
			var temp:Array = null;
			var matrix:Matrix3D, vector:Vector.<Number>
			for(var i:uint=0; i<count; i++)
			{
				temp = values.splice(0, 16);
				matrix = fromColladaArray( temp );
				mKeyCurveValues.push( matrix );
			}
		}
		
		private function fromColladaArray(a:Array):Matrix3D
		{
			var raw:Vector.<Number> = new Vector.<Number>(a.length);
			raw[0] = a[0];
			raw[1] = a[4];
			raw[2] = a[8];
			raw[3] = a[12];// x
			
			raw[4] = a[1];
			raw[5] = a[5];
			raw[6] = a[9];
			raw[7] = a[13];// y
			
			raw[8] = a[2];
			raw[9] = a[6];
			raw[10] = a[10];
			raw[11] = a[14];// z
			
			raw[12] = a[3];
			raw[13] = a[7];
			raw[14] = a[11];
			raw[15] = a[15];// 1
			
			var matrix:Matrix3D = new Matrix3D(raw);
			
			return matrix;
		}
		
		public function interpolate(time:Number):void
		{
			//if(mAffectTargetId == 'Dummy_Shoulder_L-node' )
				//trace('pause');
			
			// ...
			// 更新mJointPointer的transform
			//
			//
			//
			var animationTransform:Matrix3D = null;
			var intLeftKeyTimeIndex:int, intRightKeyTimeIndex:int;
			var count:uint = mTimeList.length;
			if( mTimeList[count-1] < time )
			{
				animationTransform = mKeyCurveValues[count-1];
			}
			else if( mTimeList[0] > time )
			{
				animationTransform = mKeyCurveValues[0];
			}
			else
			{
				for(var index:uint=0; index<count; index++)
				{
					if( mTimeList[index] <= time )
						intLeftKeyTimeIndex = index;
					
					if( mTimeList[count-1-index] >= time )
						intRightKeyTimeIndex = count-1-index;
				}
				
				if( intLeftKeyTimeIndex == intRightKeyTimeIndex )
					animationTransform = mKeyCurveValues[intLeftKeyTimeIndex];
				else
				{
					var alpha:Number = (time-mTimeList[intLeftKeyTimeIndex])/(mTimeList[intRightKeyTimeIndex]-mTimeList[intLeftKeyTimeIndex]);
					
					var interpolationType1:String = mInterpolationsType[intLeftKeyTimeIndex];
					var interpolationType2:String = mInterpolationsType[intRightKeyTimeIndex];
					if( interpolationType1 != "LINEAR" || interpolationType2 != "LINEAR" )
						throw new Error('error: interpolation type.');
					
					animationTransform = linearMatrix(mKeyCurveValues[intLeftKeyTimeIndex], mKeyCurveValues[intRightKeyTimeIndex], alpha);
				}
			}
			
			//if( mJointPointer.name == 'Bone37')
				//trace('pause!');
			
			if(mJointPointer)
				mJointPointer.transform.copyFrom( animationTransform );
		}
		
		protected function linearMatrix(m1:Matrix3D, m2:Matrix3D, alpha:Number):Matrix3D
		{
			var rawData:Vector.<Number> = new Vector.<Number>(16);
			for(var i:uint=0; i<16; i++)
				rawData[i] = m1.rawData[i]*alpha + (1.0-alpha)* m2.rawData[i];
			
			var blendMatrix:Matrix3D = new Matrix3D( rawData );
			return blendMatrix;
		}
		
		
		
		//
		//
		// String Utils
		//
		//
		//
		//
		private function trimArrayElements(value:String, delimiter:String):String
		{
			if (value != "" && value != null)
			{
				// first split it
				var items:Array = value.split(delimiter);
				
				// trim every elements
				var len:int = items.length;
				for (var i:int = 0; i < len; i++)
				{
					items[i] = trim(items[i]);
				}
				
				if (len > 0)
				{
					value = items.join(delimiter);
				}
			}
			
			return value;
		}
		
		private function trim(str:String):String
		{
			var startIndex:int = 0;
			while (isWhitespace(str.charAt(startIndex)))
				++startIndex;
			
			var endIndex:int = str.length - 1;
			while (isWhitespace(str.charAt(endIndex)))
				--endIndex;
			
			if (endIndex >= startIndex)
				return str.slice(startIndex, endIndex + 1);
			else
				return "";
		}
		
		private function isWhitespace(character:String):Boolean
		{
			switch (character)
			{
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;
					
				default:
					return false;
			}
		}
		
		
		
	}
}