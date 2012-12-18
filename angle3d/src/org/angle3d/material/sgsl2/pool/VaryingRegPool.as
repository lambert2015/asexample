package org.angle3d.material.sgsl2.pool
{

	import org.angle3d.material.sgsl.DataType;
	import org.angle3d.material.sgsl.node.reg.RegNode;
	import org.angle3d.material.shader.ShaderProfile;
	import org.angle3d.utils.Assert;

	/**
	 * 变化寄存器池
	 * @author andy
	 */
	public class VaryingRegPool extends RegPool
	{
		private var _pool:Vector.<int>;

		public function VaryingRegPool(profile:String)
		{
			super(profile);

			_pool = new Vector.<int>(mRegLimit, true);
		}

		override protected function getRegLimit():uint
		{
			if (mProfile == ShaderProfile.BASELINE_EXTENDED)
			{
				return 10;
			}
			return 8;
		}

		override public function clear():void
		{
			super.clear();

			for (var i:int = 0; i < mRegLimit; i++)
			{
				_pool[i] = 0;
			}
		}

		/**
		 * 设置tVar寄存器位置
		 * @param	tVar 对应的临时变量
		 */
		override public function register(node:RegNode):void
		{
			CF::DEBUG
			{
				Assert.assert(!node.registered, node.name + "不能注册多次");
			}

			//TODO 应该尽量避免传递Mat4,Mat3，大部分情况下没必要
			var size:int = DataType.getRegisterCount(node.dataType);
			for (var i:int = 0; i < mRegLimit; i++)
			{
				if (_pool[i] == 0)
				{
					node.index = i;
					for (var j:int = 0; j < size; j++)
					{
						_pool[i + j] = 1;
					}
					return;
				}
			}

			CF::DEBUG
			{
				Assert.assert(false, "未能找到下一个空闲位置，寄存器已满");
			}
		}
	}
}

