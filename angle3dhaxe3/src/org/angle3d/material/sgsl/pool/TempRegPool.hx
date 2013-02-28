package org.angle3d.material.sgsl.pool
{
	import org.angle3d.material.sgsl.node.reg.RegNode;
	import org.angle3d.material.sgsl.node.reg.TempReg;
	import org.angle3d.material.shader.ShaderProfile;
	import org.angle3d.utils.Assert;

	/**
	 * 临时变量寄存器池
	 * @author andy
	 */
	class TempRegPool extends RegPool
	{
		private var _pool:Vector<int>;

		public function TempRegPool(profile:String)
		{
			super(profile);

			_pool = new Vector<int>(4 * mRegLimit, true);
		}

		override private function getRegLimit():uint
		{
			if (mProfile == ShaderProfile.BASELINE_EXTENDED)
			{
				return 26;
			}
			return 8;
		}

		override public function clear():Void
		{
			super.clear();
			for (var i:Int = 0; i < 32; i++)
			{
				_pool[i] = 0;
			}
		}

		override public function build():Void
		{
		}

		/**
		 * 设置tVar寄存器位置
		 * @param	tVar 对应的临时变量
		 */
		override public function register(node:RegNode):Void
		{
			CF::DEBUG
			{
				Assert.assert(!node.registered, node.name + "不能注册多次");
			}

			var i:Int;
			var freeList:Vector<TempFree>;
			var fLength:Int;
			var m:Int;

			var size:Int = node.size;

			CF::DEBUG
			{
				Assert.assert(size > 0, "size至少要大于0");
			}

			var tVar:TempReg = (node as TempReg);

			//除了矩阵外，其他类型的临时变量不能跨越寄存器，只能存在于某个寄存器中
			//小于3时，可以在任意位置寻找
			if (size < 3)
			{
				for (i = 0; i < 8; i++)
				{
					freeList = _getFreesAt(i);
					fLength = freeList.length;
					for (m = 0; m < fLength; m++)
					{
						//空闲空间大于等于需要的大小
						if (freeList[m].size >= size)
						{
							_registerVar(tVar, i, freeList[m].offset, size);
							return;
						}
					}
				}
			}
			else if (size == 3)
			{
				//因为nrm,crs等函数不容许使用w,所以只能找前3位是空余的寄存器
				for (i = 0; i < 8; i++)
				{
					freeList = _getFreesAt(i);
					fLength = freeList.length;
					for (m = 0; m < fLength; m++)
					{
						var free:TempFree = freeList[m];
						//空闲空间大于等于需要的大小,并且无偏移
						if (free.size >= size && free.offset == 0)
						{
							_registerVar(tVar, i, free.offset, size);
							return;
						}
					}
				}
			}
			else
			{
				//vec4,mat3,mat4
				var matLength:Int = int(size / 4);

				//防止出界
				var range:Int = 9 - matLength;
				for (i = 0; i < range; i++)
				{
					//连续多个寄存器可用
					if (isFreeFrom(i, i + matLength))
					{
						_registerVar(tVar, i, 0, size);
						return;
					}
				}
			}

			CF::DEBUG
			{
				Assert.assert(false, "未能找到空闲位置，寄存器已满");
			}
		}

		/**
		 * 注册一个临时变量
		 * @param	tVar
		 * @param	index 起始寄存器位置
		 * @param	offset 偏移量
		 * @param	size 需要注册的寄存器大小
		 */
		private function _registerVar(reg:TempReg, index:Int, offset:Int, size:Int):Void
		{
			reg.index = index;
			reg.offset = offset;
			_registerPool(index * 4 + offset, size);
		}

		/**
		 * 注册某一段位置
		 * @param	start 起始点 绝对起始点
		 * @param	size 长度
		 */
		private function _registerPool(start:Int, size:Int):Void
		{
			var end:Int = start + size;
			for (var i:Int = start; i < end; i++)
			{
				//setAt(i);
				_pool[i] = 1;
			}
		}

		/**
		 * 是否已注册
		 * @param	pos
		 * @return
		 */
		private function isRegistered(pos:Int):Bool
		{
			return _pool[pos] == 1;
		}

		/**
		 * 注册某个位置
		 * @param	pos
		 */
		private function setAt(pos:Int):Void
		{
			_pool[pos] = 1;
		}

		/**
		 * 取消注册某个位置
		 * @param	pos
		 */
		private function clearAt(pos:Int):Void
		{
			_pool[pos] = 0;
		}

		/**
		 * 获取某个寄存器连续的空闲位置(一个寄存器中可能会有2个空闲空间)
		 * @param	index
		 * @return Array 每两位代表一个连续空间，分别表示起始位置和大小
		 */
		private function _getFreesAt(index:Int):Vector<TempFree>
		{
			index *= 4;

			var list:Vector<TempFree> = new Vector<TempFree>();

			var tempFree:TempFree = null;

			//是否是空闲地址
			var isFirst:Bool = true;
			var freeSize:Int = 0;

			for (var j:Int = 0; j < 4; j++)
			{
				//此地址空闲
				if (_pool[index + j] == 0)
				{
					if (isFirst)
					{
						//写入起始位置
						tempFree = new TempFree();
						tempFree.offset = j;
						list.push(tempFree);
						isFirst = false;
					}
					freeSize++;
				}
				else
				{
					//freeSize > 0代表之前有个连续空闲空间，加入其大小
					if (freeSize > 0)
					{
						tempFree.size = freeSize;
					}
					isFirst = true;
					freeSize = 0;
				}
			}

			//设置最后一个连续空间的大小
			if (freeSize > 0)
			{
				tempFree.size = freeSize;
			}

			return list;
		}

		/**
		 * 某个寄存器是否完全空闲
		 * @param	index
		 * @return
		 */
		private function isFreeAt(index:Int):Bool
		{
			index *= 4;

			var value:Int = 0;
			for (var i:Int = 0; i < 4; i++)
			{
				value += _pool[index + i];
			}

			return (value == 0);
		}

		/**
		 * 从start到end位置寄存器都未使用
		 * @param	start 开始寄存器位置
		 * @param	end 结束寄存器位置
		 * @return
		 */
		private function isFreeFrom(start:Int, end:Int):Bool
		{
			for (var i:Int = start; i < end; i++)
			{
				if (!isFreeAt(i))
				{
					return false;
				}
			}
			return true;
		}

		/**
		 * 释放value占用的寄存器位置
		 * @param	value
		 */
		override public function logout(value:RegNode):Void
		{
			var tReg:TempReg = (value as TempReg);

			CF::DEBUG
			{
				Assert.assert(tReg != null, value.name + "不是临时变量");
			}

			var start:Int = tReg.index * 4 + tReg.offset;
			var length:Int = start + tReg.size;
			for (var i:Int = start; i < length; i++)
			{
				//clearAt(i);
				_pool[i] = 0;
			}
		}

		/**
		 * 测试用
		 * @return
		 */
		public function toString():String
		{
			var str:String = "TempRegisterPool\n[\n ";
			for (var i:Int = 0; i < 8; i++)
			{
				var line:String = "";
				for (var j:Int = 0; j < 4; j++)
				{
					line += _pool[i * 4 + j] + "\t";
				}
				str += line + "\n";
			}
			return str;
		}

	}
}

final class TempFree
{
	public var offset:Int;
	public var size:Int;
}

