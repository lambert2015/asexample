package org.angle3d.material.sgsl
{

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;

	import org.angle3d.material.sgsl.node.AgalNode;
	import org.angle3d.material.sgsl.node.ArrayAccessNode;
	import org.angle3d.material.sgsl.node.AtomNode;
	import org.angle3d.material.sgsl.node.BranchNode;
	import org.angle3d.material.sgsl.node.ConditionIfNode;
	import org.angle3d.material.sgsl.node.ConstantNode;
	import org.angle3d.material.sgsl.node.FunctionCallNode;
	import org.angle3d.material.sgsl.node.LeafNode;
	import org.angle3d.material.sgsl.node.reg.AttributeReg;
	import org.angle3d.material.sgsl.node.reg.RegNode;
	import org.angle3d.material.sgsl.node.reg.TempReg;
	import org.angle3d.material.sgsl.parser.SgslParser;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderProfile;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.material.shader.ShaderVarType;
	import org.angle3d.utils.Assert;
	import org.angle3d.utils.Logger;

	/**
	 * Stage3D Shader Language(sgsl) Complier
	 * Shader编译器
	 * @author andy
	 */
//TODO 添加数组类型
	public class SgslCompiler
	{
		private var MAX_OPCODES:int = 200;

		private var _swizzleMap:Dictionary;

		private var _regCodeMap:Dictionary;

		private var _vertexData:SgslData;

		private var _fragmentData:SgslData;

		private var _byteArray:ByteArray;

		private var _sgsl2Agal:Sgsl2Agal;

		private var _parser:SgslParser;

		private var _optimizer:SgslOptimizer;

		private var _compiled:Boolean;

		private var _opCodeManager:OpCodeManager;

		public var profile:String;

		public function SgslCompiler(profile:String, sgslParser:SgslParser, opCodeManager:OpCodeManager)
		{
			this.profile = profile;

			MAX_OPCODES = (profile == ShaderProfile.BASELINE_EXTENDED) ? 1024 : 200;

			_parser = sgslParser;
			_opCodeManager = opCodeManager;

			_swizzleMap = new Dictionary();
			_swizzleMap["x"] = 0;
			_swizzleMap["y"] = 1;
			_swizzleMap["z"] = 2;
			_swizzleMap["w"] = 3;
			_swizzleMap["r"] = 0;
			_swizzleMap["g"] = 1;
			_swizzleMap["b"] = 2;
			_swizzleMap["a"] = 3;
			_swizzleMap[0] = "x";
			_swizzleMap[1] = "y";
			_swizzleMap[2] = "z";
			_swizzleMap[3] = "w";

			_initEmitCodes();

			_compiled = false;

			_optimizer = new SgslOptimizer();

			_sgsl2Agal = new Sgsl2Agal();

			_vertexData = new SgslData(profile, ShaderType.VERTEX);
			_fragmentData = new SgslData(profile, ShaderType.FRAGMENT);
		}

		/**
		 * 编译并传递数据到Shader中
		 * @param	shader
		 * @param	sources
		 * @param	conditions
		 * @return
		 */
		public function complie(sources:Array, predefines:Vector.<Vector.<String>> = null):Shader
		{
			_compiled = false;

			var shader:Shader = new Shader();

			_vertexData.clear();
			var tree:BranchNode = _parser.exec(sources[0]);
			_optimizer.exec(_vertexData, tree, predefines != null ? predefines[0] : null);

			_fragmentData.clear();
			_fragmentData.shareWith(_vertexData);
			tree = _parser.exec(sources[1]);
			_optimizer.exec(_fragmentData, tree, predefines != null ? predefines[1] : null);


			_updateShader(_vertexData, shader);
			_updateShader(_fragmentData, shader);

			shader.vertexData = assemble(_vertexData);
			shader.fragmentData = assemble(_fragmentData);

			shader.build();

			_compiled = true;

			CF::DEBUG
			{
				Logger.log("Vertex Agal:\n" + _sgsl2Agal.toAgal(shader.vertexData) + "\n");
				Logger.log("Fragment Agal:\n" + _sgsl2Agal.toAgal(shader.fragmentData) + "\n");
			}

			return shader;
		}

		private function _initEmitCodes():void
		{
			_regCodeMap = new Dictionary();
			_regCodeMap[RegType.ATTRIBUTE] = 0x0;
			_regCodeMap[RegType.UNIFORM] = 0x1;
			_regCodeMap[RegType.TEMP] = 0x2;
			_regCodeMap[RegType.OUTPUT] = 0x3;
			_regCodeMap[RegType.VARYING] = 0x4;
			//_regCodeMap[RegType.TEXTURE] = 0x5;
			_regCodeMap[RegType.DEPTH] = 0x6;
		}

		[Inline]
		private final function getRegCode(reg:RegNode):uint
		{
			return _regCodeMap[reg.regType];
		}

		/**
		 * 更新Shader中对应的变量名和其大小
		 * @param	data
		 * @param	shader
		 */
		private function _updateShader(data:SgslData, shader:Shader):void
		{
			var shaderType:String = data.shaderType;

			shader.setConstants(shaderType, data.uniformPool.getConstants());

			var regList:Vector.<RegNode> = data.uniformPool.getRegs();

			var varType:int = ShaderVarType.UNIFORM;
			var count:int = regList.length;
			for (var i:int = 0; i < count; i++)
			{
				var reg:RegNode = regList[i];
				shader.addVariable(shaderType, varType, reg.name, reg.size);
			}

			if (shaderType == ShaderType.VERTEX)
			{
				regList = data.attributePool.getRegs();
				varType = ShaderVarType.ATTRIBUTE;
			}
			else
			{
				regList = data.texturePool.getRegs();
				varType = ShaderVarType.TEXTURE;
			}

			count = regList.length;
			for (i = 0; i < count; i++)
			{
				reg = regList[i];
				shader.addVariable(shaderType, varType, reg.name, reg.size);
			}
		}

		private var _currentData:SgslData;

		private function assemble(data:SgslData):ByteArray
		{
			_currentData = data;

			_byteArray = new ByteArray();
			_byteArray.endian = Endian.LITTLE_ENDIAN;
			_byteArray.position = 0;

			writeHeader(data.shaderType == ShaderType.FRAGMENT);

			var nodes:Vector.<AgalNode> = data.nodes;
			var count:int = nodes.length;

			CF::DEBUG
			{
				Assert.assert(count <= MAX_OPCODES, "too many opcodes. maximum is " + MAX_OPCODES + ".");
			}

			for (var i:int = 0; i < count; i++)
			{
				writeNode(nodes[i]);
			}

			return _byteArray;
		}

		/**
		 * Agal头部
		 * @param	isFrag
		 * @param	data
		 */
		private function writeHeader(isFrag:Boolean):void
		{
			var version:uint = (profile == ShaderProfile.BASELINE_EXTENDED) ? 0x2 : 0x1;
			_byteArray.writeByte(0xa0); // tag version
			_byteArray.writeUnsignedInt(version); // AGAL version, big endian, bit pattern will be 0x01000000
			_byteArray.writeByte(0xa1); // tag program id
			_byteArray.writeByte(isFrag ? 1 : 0); // vertex or fragment
		}

		/**
		 *
		 * 63.............................................................0
		 * FFFFMMMMWWWWSSSSDDDD--------TTTT--------BBBBBBBBNNNNNNNNNNNNNNNN
		 * N = Sampler register number (16 bits)
		 * B = Texture level-of-detail (LOD) bias, signed integer, scale by 8. The floating point value used is b/8.0 (8 bits)
		 * T = Register type, must be 5, Sampler (4 bits)
		 * F = Filter (0=nearest,1=linear) (4 bits)
		 * M = Mipmap (0=disable,1=nearest, 2=linear)
		 * W = Wrapping (0=clamp,1=repeat)
		 * S = Special flag bits (must be 0)
		 * D = Dimension (0=2D, 1=Cube)
		 * @param regIndex 注册位置
		 * @param flag
		 *
		 */
		private function writeTexture(regIndex:int, flag:TexFlag):void
		{
			_byteArray.writeShort(regIndex); //16 bits
			_byteArray.writeByte(flag.lod); //8 bits
			_byteArray.writeByte(0); //8 bits
			_byteArray.writeByte(5); //8 bits

			var bits:uint = flag.getTexFlagsBits();

			_byteArray.writeByte(bits & 0xFF);
			_byteArray.writeByte((bits >> 8) & 0xFF);
			_byteArray.writeByte(bits >> 16);
		}

		/**
		 * 数组类型会有个偏移量需要加上
		 * @param node
		 */
		private function getRegisterIndex(node:AtomNode):int
		{
			var reg:RegNode = _currentData.getRegNode(node.name);
			if (node is ArrayAccessNode)
			{
				return reg.index + (node as ArrayAccessNode).offset;
			}
			return reg.index;
		}

		private function writeConditionIfNode(node:ConditionIfNode):void
		{
			var opCode:OpCode;
			var source0:AtomNode;
			var source1:AtomNode;

			switch (node.compareMethod)
			{
				case "==":
					opCode = _opCodeManager.getCode("ife");
					source0 = node.children[0] as AtomNode;
					source1 = node.children[1] as AtomNode;
					break;
				case "!=":
					opCode = _opCodeManager.getCode("ine");
					source0 = node.children[0] as AtomNode;
					source1 = node.children[1] as AtomNode;
					break;
				case ">=":
					opCode = _opCodeManager.getCode("ifg");
					source0 = node.children[0] as AtomNode;
					source1 = node.children[1] as AtomNode;
					break;
				case "<=":
					opCode = _opCodeManager.getCode("ifg");
					source0 = node.children[1] as AtomNode;
					source1 = node.children[0] as AtomNode;
					break;
				case "<":
					opCode = _opCodeManager.getCode("ifl");
					source0 = node.children[0] as AtomNode;
					source1 = node.children[1] as AtomNode;
					break;
				case ">":
					opCode = _opCodeManager.getCode("ifl");
					source0 = node.children[1] as AtomNode;
					source1 = node.children[0] as AtomNode;
					break;
			}


			_byteArray.writeUnsignedInt(opCode.emitCode);
			writeDest(null);
			writeSrc(source0);
			writeSrc(source1);
		}

		private function writeNode(node:AgalNode):void
		{
			if (node is ConditionIfNode)
			{
				var ifNode:ConditionIfNode = node as ConditionIfNode;
				writeConditionIfNode(ifNode);
				return;
			}

			var opCode:OpCode;
			var numChildren:int = node.numChildren;
			var children:Vector.<LeafNode> = node.children;

			//if end
			if (numChildren == 0)
			{
				opCode = _opCodeManager.getCode(node.name);

				_byteArray.writeUnsignedInt(opCode.emitCode);

				writeDest(null);
				writeSrc(null);
				writeSrc(null);
				return;
			}

			var dest:AtomNode;
			//kill(vt0.w)
			if (numChildren == 1)
			{
				dest = null;
				opCode = _opCodeManager.getCode(children[0].name);
			}
			else
			{
				dest = children[0] as AtomNode;
				if (children[1] is FunctionCallNode)
				{
					opCode = _opCodeManager.getCode(children[1].name);
				}
				else
				{
					opCode = _opCodeManager.movCode;
				}
			}

			_byteArray.writeUnsignedInt(opCode.emitCode);

			writeDest(dest);

			var source0:LeafNode = children[1];
			if (source0 is AtomNode)
			{
				writeSrc(source0 as AtomNode);
				writeSrc(null);
			}
			else
			{
				var fc:FunctionCallNode = (source0 as FunctionCallNode);
				var fChildren:Vector.<LeafNode> = fc.children;
				var fLength:int = fChildren.length;

				if (_opCodeManager.isTexture(fc.name))
				{
					writeSrc(fChildren[0] as AtomNode);

					//提取出参数
					var flags:Array = [];
					for (var i:int = 2; i < fLength; i++)
					{
						flags.push(fChildren[i].name);
					}

					var texFlag:TexFlag = new TexFlag();
					texFlag.parseFlags(flags);

					if (fc.name == "texture2D")
					{
						texFlag.dimension = 0;
					}
					else if (fc.name == "textureCube")
					{
						texFlag.dimension = 1;
					}
//					else if (fc.name == "texture3D")
//					{
//						texFlag.dimension = 2;
//					}

					var fcReg:RegNode = _currentData.getRegNode(fChildren[1].name);

					writeTexture(fcReg.index, texFlag);
				}
				else
				{
					for (i = 0; i < fLength; i++)
					{
						writeSrc(fChildren[i] as AtomNode);
					}

					if (fLength < 2)
					{
						writeSrc(null);
					}
				}
			}
		}

		/**
		 * The [destination] field is 32 bits in size:
		 * 31.............................0
		 * ----TTTT----MMMMNNNNNNNNNNNNNNNN
		 * T = Register type (4 bits)
		 * M = Write mask (4 bits)
		 * N = Register number (16 bits)
		 * - = undefined, must be 0
		 */
		private function writeDest(dest:AtomNode):void
		{
			if (dest == null)
			{
				_byteArray.writeUnsignedInt(0);
				return;
			}

			var reg:RegNode = _currentData.getRegNode(dest.name);
			_byteArray.writeShort(getRegisterIndex(dest));
			_byteArray.writeByte(maskBits(reg, dest.mask));
			_byteArray.writeByte(getRegCode(reg));
		}

		/**
		 * The [source] field is 64 bits in size:
		 *
		 * 63.............................................................0
		 * D-------------QQ----IIII----TTTTSSSSSSSSOOOOOOOONNNNNNNNNNNNNNNN
		 *
		 * D = Direct=0/Indirect=1 for direct Q and I are ignored, 1bit
		 * Q = Index register component select (2 bits)
		 * I = Index register type (4 bits)
		 * T = Register type (4 bits)
		 * S = Swizzle (8 bits, 2 bits per component)
		 * O = Indirect offset (8 bits)
		 * N = Register number (16 bits)
		 * - = undefined, must be 0
		 */
		private function writeSrc(node:AtomNode):void
		{
			if (node == null)
			{
				_byteArray.writeInt(0);
				_byteArray.writeInt(0);
				return;
			}

			var reg:RegNode;

			var registerIndex:int;
			if (node.isRelative())
			{
				reg = _currentData.getRegNode(node.name);
				var relativeNode:ArrayAccessNode = node as ArrayAccessNode;

				//TODO 这里的offset可能不正确，是否需要加上reg.index呢
				var relOffset:int = relativeNode.offset + reg.index;

				var accessReg:RegNode = _currentData.getRegNode(relativeNode.access.name);

				registerIndex = getRegisterIndex(relativeNode.access);

				_byteArray.writeShort(registerIndex);
				_byteArray.writeByte(relOffset);
				_byteArray.writeByte(swizzleBits(reg, relativeNode.mask));

				//haxe format agal里面这个和下一个写的位置与AGALMiniAssembler中写的相反，需要测试测试
				_byteArray.writeByte(getRegCode(reg));
				_byteArray.writeByte(getRegCode(accessReg));
				_byteArray.writeShort((getCharIndex(relativeNode.access.mask) | (1 << 15)));
			}
			else
			{
				var swizzleBit:int;
				var regCode:int;

				if (node is ConstantNode)
				{
					var constantNode:ConstantNode = node as ConstantNode;

					registerIndex = _currentData.getConstantIndex(constantNode.value);
					swizzleBit = swizzleBits(null, _currentData.getConstantMask(constantNode.value));
					regCode = _regCodeMap[RegType.UNIFORM];
				}
				else
				{
					reg = _currentData.getRegNode(node.name);
					registerIndex = getRegisterIndex(node);
					swizzleBit = swizzleBits(reg, node.mask);
					regCode = getRegCode(reg);
				}

				_byteArray.writeShort(registerIndex);
				_byteArray.writeByte(0);
				_byteArray.writeByte(swizzleBit);
				_byteArray.writeByte(regCode);
				_byteArray.writeByte(0);
				_byteArray.writeShort(0);
			}
		}


		CF::DEBUG
		{
			private function readString(data:ByteArray, size:int):String
			{
				var result:String = "";
				var start:int = data.position;
				var end:int = size + start;
				for (var i:int = start; i < end; i++)
				{
					var byteStr:String = data[i].toString(16);
					if (byteStr.length < 2)
						byteStr = "0" + byteStr;

					result += byteStr;
				}

				data.position += size;

				return result;
			}

			private function getAgalInfo(data:ByteArray):String
			{
				data.position = 0;

				var result:String = "agal bytecode:\n";

				//header
				result += readString(data, 7) + "\n";

				var count:int = int((data.length - 7) / 24);
				for (var i:int = 0; i < count; i++)
				{
					//opcode
					result += readString(data, 4);
					result += " ";
					//dest
					result += readString(data, 4);
					result += " ";
					//source0
					result += readString(data, 8);
					result += " ";
					//source1
					result += readString(data, 8);
					result += "\n";
				}
				return result;
			}
		}

		private function getCharIndex(char:String):int
		{
			return _swizzleMap[char.toLowerCase()];
		}

		private function maskBits(reg:RegNode, swizzle:String):uint
		{
			var comps:String = getRealSwizzle(reg, swizzle);

			if (comps == null || comps.length == 0)
				return 0x0f;

			var bits:uint = 0;
			var length:int = comps.length;
			for (var i:int = 0; i < length; i++)
			{
				bits |= 1 << getCharIndex(comps.charAt(i));
			}
			return bits;
		}

		/**
		 *
		 * @param list Array<String>
		 * @return
		 *
		 */
		private function swizzleBits(reg:RegNode, swizzle:String):uint
		{
			var comps:String = getRealSwizzle(reg, swizzle);

			if (comps == null || comps.length == 0)
				return 0xe4; //0 | (1 << 2) | (2 << 4) | (3 << 6)

			CF::DEBUG
			{
				Assert.assert(comps.length <= 4, "comps的长度不能超过4");
			}

			var bits:uint = 0;
			var p:int = 0;
			var last:int = 0;
			var sLength:int = comps.length;
			for (var i:int = 0; i < sLength; i++)
			{
				last = getCharIndex(comps.charAt(i));
				bits |= last << p;
				p += 2;
			}

			// repeat last component
			while (p < 8)
			{
				bits |= last << p;
				p += 2;
			}
			return bits;
		}

		private var _xyzw:String = "xyzw";

		private function getTempRegSwizzle(tempReg:TempReg, swizzle:String):String
		{
			if (swizzle == null || swizzle.length == 0)
			{
				return _xyzw.slice(tempReg.offset, tempReg.offset + tempReg.size);
			}

			var result:String = "";
			var sLength:int = swizzle.length;
			for (var i:int = 0; i < sLength; i++)
			{
				var index:int = _swizzleMap[swizzle.charAt(i)] + tempReg.offset;
				result += _swizzleMap[index];
			}

			return result;
		}

		private function getRealSwizzle(reg:RegNode, swizzle:String):String
		{
			if (reg == null)
			{
				return swizzle;
			}

			//貌似有点问题
			if ((reg is TempReg) && DataType.isNeedOffset(reg.dataType))
			{
				return getTempRegSwizzle(reg as TempReg, swizzle);
			}
			else if (swizzle == null || swizzle.length == 0)
			{
				if (reg is AttributeReg)
				{
					var typeSize:int = reg.size;
					if (typeSize < 2)
					{
						return _xyzw.slice(0, typeSize);
					}
				}
				return "";
			}
			else
			{
				return swizzle;
			}
		}
	}
}

