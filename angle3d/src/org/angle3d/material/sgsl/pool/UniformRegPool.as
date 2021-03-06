package org.angle3d.material.sgsl.pool
{

	import org.angle3d.material.sgsl.node.reg.RegNode;
	import org.angle3d.material.sgsl.node.reg.UniformReg;
	import org.angle3d.material.shader.ShaderProfile;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.utils.Assert;

	/**
	 * 目前只接受vec4,mat3,mat4和对应的数组类型
	 * 常量寄存器池
	 * 首先需要收集所有的常数，然后才可以锁定其他类型的变量
	 * @author andy
	 */
	public class UniformRegPool extends RegPool
	{
		private var _pool:Vector.<int>;

		private var _constants:Vector.<Number>;

		private var shaderType:String;

		public function UniformRegPool(profile:String, shaderType:String)
		{
			this.shaderType = shaderType;

			super(profile);

			_pool = new Vector.<int>(mRegLimit, true);

			_constants = new Vector.<Number>();
		}

		override protected function getRegLimit():uint
		{
			if (shaderType == ShaderType.VERTEX)
			{
				if (mProfile == ShaderProfile.BASELINE_EXTENDED)
				{
					return 250;
				}
				else
				{
					return 128;
				}
			}
			else
			{
				if (mProfile == "baselineExtended")
				{
					return 64;
				}
				else
				{
					return 28;
				}
			}
		}

		/**
		 * 一次性注册所有Uniform
		 */
		override public function build():void
		{
			//常量总是放在最前面
			registerConstants();

			super.build();
		}

		/**
		 * 在遍历主函数时主动添加常量到UniformPool中
		 * 添加常量
		 * @param	value
		 */
		public function addConstant(value:Number):void
		{
			if (_constants.indexOf(value) == -1)
			{
				_constants.push(value);
			}
		}

		public function getConstantIndex(value:Number):int
		{
			var index:int = _constants.indexOf(value);
			return int(index / 4);
		}

		public function getConstantMask(value:Number):String
		{
			var index:int = _constants.indexOf(value);
			var register:int = int(index / 4);
			var order:int = index - register * 4;
			var str:String = "xyzw";
			return str.substr(order, 1);
		}

		/**
		 * 返回常量数组，每4个分为一组,不够的补齐
		 * @return
		 */
		public function getConstants():Vector.<Vector.<Number>>
		{
			var cLength:int = _constants.length;
			if (cLength == 0)
			{
				return null;
			}

			var count:int = Math.ceil(cLength / 4);
			var result:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>(count, true);
			for (var i:int = 0; i < count; i++)
			{
				var list:Vector.<Number> = new Vector.<Number>(4, true);
				for (var j:int = 0; j < 4; j++)
				{
					if (i * 4 + j < cLength)
					{
						list[j] = _constants[j];
					}
					else //不足的部分用0填充
					{
						list[j] = 0.0;
					}
				}
				result[i] = list;
			}

			return result;
		}

		/**
		 * 锁定常量占用的寄存器
		 */
		private function registerConstants():void
		{
			//clear pool
			for (var i:int = 0; i < mRegLimit; i++)
			{
				_pool[i] = 0;
			}

			var cLength:int = _constants.length;
			if (cLength > 0)
			{
				var count:int = Math.ceil(cLength / 4);
				for (i = 0; i < count; i++)
				{
					_pool[i] = 1;
				}
			}
		}

		override public function clear():void
		{
			super.clear();

			for (var i:int = 0; i < mRegLimit; i++)
			{
				_pool[i] = 0;
			}

			_constants.length = 0;
		}

		/**
		 * 设置value寄存器位置
		 * @param value
		 */
		override public function register(node:RegNode):void
		{
			var uniformReg:UniformReg = node as UniformReg;

			CF::DEBUG
			{
				Assert.assert(uniformReg != null && !uniformReg.registered, uniformReg.name + "不能注册多次");
			}

			var size:int = int(uniformReg.size / 4);
			for (var i:int = 0; i < mRegLimit; i++)
			{
				if (_pool[i] == 0)
				{
					uniformReg.index = i;
					for (var j:int = 0; j < size; j++)
					{
						_pool[int(i + j)] = 1;
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

