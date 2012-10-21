package org.angle3d.scene.mesh
{
	CF::DEBUG
	{
		import org.angle3d.utils.Assert;
	}

	public class VertexBuffer
	{
		private var mCount:int;

		private var mDirty:Boolean;

		private var mType:String;

		private var mData:Vector.<Number>;

		private var mComponents:int;

		public function VertexBuffer(type:String)
		{
			mType=type;

			mCount=0;
			mDirty=true;
		}

		public function get components():int
		{
			return mComponents;
		}

		/**
		 *
		 * @param	data
		 * @param	components
		 */
		public function setData(data:Vector.<Number>, components:int):void
		{
			mData=data;

			mComponents=components;

			CF::DEBUG
			{
				Assert.assert(mComponents >= 1 && mComponents <= 4, "_components长度应该在1～4之间");
			}

			mCount=int(mData.length / mComponents);

			dirty=true;
		}

		public function updateData(data:Vector.<Number>):void
		{
			mData=data;

			CF::DEBUG
			{
				Assert.assert(int(mData.length / mComponents) == mCount, "更新的数组长度应该和之前相同");
			}

			dirty=true;
		}

		public function getData():Vector.<Number>
		{
			return mData;
		}

		public function clean():void
		{
			dirty=true;
			mData=null;
		}

		/**
		 * 销毁
		 */
		public function destroy():void
		{
			mData=null;
		}

		public function get count():int
		{
			return mCount;
		}

		public function get type():String
		{
			return mType;
		}

		public function get dirty():Boolean
		{
			return mDirty;
		}

		/**
		 * Internal use only. Indicates that the object has changed
		 * and its state needs to be updated.
		 */
		public function set dirty(value:Boolean):void
		{
			mDirty=value;
		}
	}
}

