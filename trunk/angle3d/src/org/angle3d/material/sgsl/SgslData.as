package org.angle3d.material.sgsl
{
	import flash.utils.Dictionary;

	import org.angle3d.material.sgsl.node.AgalNode;
	import org.angle3d.material.sgsl.node.ArrayAccessNode;
	import org.angle3d.material.sgsl.node.AtomNode;
	import org.angle3d.material.sgsl.node.ConstantNode;
	import org.angle3d.material.sgsl.node.FunctionCallNode;
	import org.angle3d.material.sgsl.node.LeafNode;
	import org.angle3d.material.sgsl.node.reg.OutputReg;
	import org.angle3d.material.sgsl.node.reg.RegNode;
	import org.angle3d.material.sgsl.node.reg.TempReg;
	import org.angle3d.material.sgsl.node.reg.TextureReg;
	import org.angle3d.material.sgsl.pool.AttributeRegPool;
	import org.angle3d.material.sgsl.pool.TempRegPool;
	import org.angle3d.material.sgsl.pool.TextureRegPool;
	import org.angle3d.material.sgsl.pool.UniformRegPool;
	import org.angle3d.material.sgsl.pool.VaryingRegPool;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.utils.Assert;

	/**
	 * ...
	 * @author andy
	 */
	public class SgslData
	{
		/**
		 * Shader类型
		 */
		public var shaderType:String;

		private var _nodes:Vector.<AgalNode>;

		public var attributePool:AttributeRegPool;
		public var uniformPool:UniformRegPool;
		public var varyingPool:VaryingRegPool;
		public var texturePool:TextureRegPool;

		private var _tempPool:TempRegPool;

		/**
		 * 所有变量的集合
		 */
		private var _regsMap:Dictionary;

		public function SgslData(shaderType:String)
		{
			this.shaderType = shaderType;

			_nodes = new Vector.<AgalNode>();

			_tempPool = new TempRegPool();
			uniformPool = new UniformRegPool(shaderType);
			varyingPool = new VaryingRegPool();
			if (shaderType == ShaderType.VERTEX)
			{
				attributePool = new AttributeRegPool();
			}
			else
			{
				texturePool = new TextureRegPool();
			}

			_regsMap = new Dictionary();
			var reg:OutputReg = new OutputReg();
			_regsMap[reg.name] = reg;
		}

		public function clear():void
		{
			_nodes.length = 0;

			_tempPool.clear();
			uniformPool.clear();
			if (shaderType == ShaderType.VERTEX)
			{
				attributePool.clear();
				varyingPool.clear();
			}
			else
			{
				texturePool.clear();
			}

			_regsMap = new Dictionary();
			var reg:OutputReg = new OutputReg();
			_regsMap[reg.name] = reg;
		}

		public function get nodes():Vector.<AgalNode>
		{
			return _nodes;
		}

		public function addNode(node:AgalNode):void
		{
			var reg:LeafNode;

			var children:Vector.<LeafNode> = node.children;
			var cLength:int = children.length;
			for (var i:int = 0; i < cLength; i++)
			{
				reg = children[i];

				if (reg is FunctionCallNode)
				{
					var regChildren:Vector.<LeafNode> = (reg as FunctionCallNode).children;
					var rLength:int = regChildren.length;
					for (var j:int = 0; j < rLength && j < 2; j++)
					{
						if (regChildren[j] is ConstantNode)
						{
							addConstantNode(regChildren[j] as ConstantNode);
						}
					}
				}
				else if (reg is ConstantNode)
				{
					addConstantNode(reg as ConstantNode);
				}
			}

			_nodes.push(node);
		}

		private function addConstantNode(node:ConstantNode):void
		{
			uniformPool.addConstant(node.value);
		}

		public function getConstantIndex(value:Number):int
		{
			return uniformPool.getConstantIndex(value);
		}

		public function getConstantMask(value:Number):String
		{
			return uniformPool.getConstantMask(value);
		}

		/**
		 * 共享Varying数据
		 * @param	other
		 */
		public function shareWith(vertexData:SgslData):void
		{
			CF::DEBUG
			{
				Assert.assert(vertexData.shaderType == ShaderType.VERTEX, "vertexData类型应该为" + ShaderType.VERTEX);
				Assert.assert(shaderType == ShaderType.FRAGMENT, "shareWith只能在Fragment中调用");
			}

			var pool:VaryingRegPool = vertexData.varyingPool;

			var regs:Vector.<RegNode> = pool.getRegs();
			var count:int = regs.length;
			for (var i:int = 0; i < count; i++)
			{
				addReg(regs[i]);
			}
		}

		/**
		 * 添加变量到对应的寄存器池中
		 * @param	value
		 */
		public function addReg(reg:RegNode):void
		{
			//忽略output
			CF::DEBUG
			{
				Assert.assert(reg != null, "变量不存在");
				Assert.assert(reg.regType != RegType.OUTPUT, "output不需要定义");
				Assert.assert(_regsMap[reg.name] == undefined, reg.name + "变量名定义重复");

				if (reg.regType == RegType.ATTRIBUTE)
				{
					Assert.assert(shaderType == ShaderType.VERTEX, "AttributeVar只能定义在Vertex中");
				}
				else if (reg is TextureReg)
				{
					Assert.assert(shaderType == ShaderType.FRAGMENT, "Texture只能定义在Fragment中");
				}
			}

			switch (reg.regType)
			{
				case RegType.ATTRIBUTE:
					attributePool.addReg(reg);
					break;
				case RegType.TEMP:
					_tempPool.addReg(reg);
					break;
				case RegType.UNIFORM:
					if (reg is TextureReg)
					{
						texturePool.addReg(reg);
					}
					else
					{
						uniformPool.addReg(reg);
					}
					break;
				case RegType.VARYING:
					varyingPool.addReg(reg);
					break;
			}
			_regsMap[reg.name] = reg;
		}

		/**
		 * 根据name获取对应的变量
		 * @param	name
		 * @return
		 */
		public function getRegNode(name:String):RegNode
		{
			return _regsMap[name];
		}

		/**
		 * 注册所有Reg，设置它们的位置
		 */
		public function build():void
		{
			if (shaderType == ShaderType.VERTEX)
			{
				attributePool.build();
				varyingPool.build();
			}
			else
			{
				texturePool.build();
			}
			uniformPool.build();


			//添加所有临时变量到一个数组中
			var tempList:Vector.<TempReg> = _getAllTempRegs();
			_registerTempReg(tempList);
		}

		/**
		 * 递归注册和释放临时变量
		 * @param	list
		 */
		private function _registerTempReg(list:Vector.<TempReg>):void
		{
			if (list.length > 0)
			{
				//取出第一个临时变量
				var reg:TempReg = list.shift();

				//未注册的需要注册
				if (!reg.registered)
				{
					_tempPool.register(reg);
				}

				//如果数组中剩余项不包含这个变量，也就代表无引用了
				if (list.indexOf(reg) == -1)
				{
					//可以释放其占用位置
					_tempPool.logout(reg);
				}

				//递归锁定和释放，直到数组为空
				_registerTempReg(list);
			}
		}

		/**
		 * 获得所有临时变量引用
		 * @return
		 */
		private function _getAllTempRegs():Vector.<TempReg>
		{
			var tempList:Vector.<TempReg> = new Vector.<TempReg>();
			var tLength:int = _nodes.length;
			for (var i:int = 0; i < tLength; i++)
			{
				tempList = tempList.concat(_checkNodeTempRegs(_nodes[i]));
			}
			return tempList;
		}

		private function _checkLeafTempReg(leaf:LeafNode, list:Vector.<TempReg>):void
		{
			if (leaf is ArrayAccessNode)
			{
				_addTempReg(leaf.name, list);

				var access:AtomNode = (leaf as ArrayAccessNode).access;
				if (access != null)
				{
					_addTempReg(access.name, list);
				}
			}
			else
			{
				_addTempReg(leaf.name, list);
			}
		}

		private function _addTempReg(name:String, list:Vector.<TempReg>):void
		{
			var reg:RegNode = getRegNode(name);
			if (reg is TempReg)
			{
				list.push(reg as TempReg);
			}
		}

		/**
		 * 获得node所有的临时变量引用
		 * @return
		 */
		private function _checkNodeTempRegs(node:AgalNode):Vector.<TempReg>
		{
			var list:Vector.<TempReg> = new Vector.<TempReg>();

			var leaf:LeafNode;

			var children:Vector.<LeafNode> = node.children;
			var cLength:int = children.length;
			for (var i:int = 0; i < cLength; i++)
			{
				leaf = children[i];
				if (leaf is FunctionCallNode)
				{
					var leafChildren:Vector.<LeafNode> = (leaf as FunctionCallNode).children;
					var rLength:int = leafChildren.length;
					for (var j:int = 0; j < rLength && j < 2; j++)
					{
						_checkLeafTempReg(leafChildren[j], list);
					}
				}
				else
				{
					_checkLeafTempReg(leaf, list);
				}
			}

			return list;
		}
	}
}

