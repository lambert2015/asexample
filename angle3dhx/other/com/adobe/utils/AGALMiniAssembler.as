package com.adobe.utils
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.getTimer;

	public class AGALMiniAssembler
	{
		protected static const USE_NEW_SYNTAX:Boolean = false;

		protected static const REGEXP_OUTER_SPACES:RegExp = /^\s+|\s+$/g;

		protected static const COMPONENTS:Object = {"x": 0, "y": 1, "z": 2, "w": 3, "r": 0, "g": 1, "b": 2, "a": 3};

		private static var initialized:Boolean = false;

		private var debug:Boolean = false;

		private var isFrag:Boolean;
		private var nest:int;
		private var opsCount:int;

		public function AGALMiniAssembler(debug:Boolean = true):void
		{
			this.debug = debug;
			if (!initialized)
				init();
		}

		public function assemble(mode:String, source:String):ByteArray
		{
			var start:int = getTimer();

			isFrag = (mode == FRAGMENT);
			nest = 0;
			opsCount = 0;

			var agalcode:ByteArray = new ByteArray();

			writeHeader(agalcode);

			var lines:Array = source.replace(/[\f\n\r\v]+/g, "\n").split("\n");
			var lng:int = lines.length;
			for (var i:int = 0; i < lng; i++)
			{
				var line:String = removeComment(trim(lines[i]));
				writeLine(line,agalcode);
			}

			log("Assemble time: " + (getTimer() - start) + "ms");

			return agalcode;
		}

		private function debugInfo(agalcode:ByteArray):void
		{
			var dbgLine:String = "generated bytecode:";
			var agalLength:uint = agalcode.length;
			for ( var index:uint = 0; index < agalLength; index++ )
			{
				if ( !( index % 16 ) )
					dbgLine += "\n";
				if ( !( index % 4 ) )
					dbgLine += " ";

				var byteStr:String = agalcode[ index ].toString( 16 );
				if ( byteStr.length < 2 )
					byteStr = "0" + byteStr;

				dbgLine += byteStr;
			}
			trace( dbgLine );
		}


		/**
		 * Agal头部
		 * @param	isFrag
		 * @param	data
		 */
		private function writeHeader(data:ByteArray):void
		{
			data.endian = Endian.LITTLE_ENDIAN;
			data.position = 0;
			data.writeByte(0xa0); // tag version
			data.writeUnsignedInt(0x1); // AGAL version, big endian, bit pattern will be 0x01000000
			data.writeByte(0xa1); // tag program id
			data.writeByte(isFrag ? 1 : 0); // vertex or fragment

			debugInfo(data);
		}

		private function writeLine(line:String,data:ByteArray):void
		{
			opsCount++;
			assert(opsCount > MAX_OPCODES, "too many opcodes. maximum is " + MAX_OPCODES + ".");

			// 找到opCode
			var array:Array = line.match(/^\w{3}/ig);
			var opFound:OpCode = getOpCode(array[0]);
			assert(opFound == null, line + " can`t find opCode");

			//只有tex时才需要收集
			if (opFound.isTexture())
			{
				//收集texture选项部分
				// grab options
				var optsi:int = line.search(/<.*>/g);
				var opts:Array;
				if (optsi != -1)
				{
					opts = line.slice(optsi).match(/([\w\.\-\+]+)/gi);
					line = line.slice(0, optsi);
				}
			}

			line = removeStringFrom(line, opFound.name);

			//TODO 这里不明白是什么意思
			//估计是用于计算条件判断和循环嵌套的深度用的。
			// nesting check
			if (opFound.flags & OP_DEC_NEST)
			{
				nest--;
				assert(nest < 0, "conditional closes without open.");
			}
			if (opFound.flags & OP_INC_NEST)
			{
				nest++;
				assert(nest > MAX_NESTING, "nesting to deep, maximum allowed is " + MAX_NESTING + ".");
			}

			assert(opFound.isFragOnly() && !isFrag, "opcode is only allowed in fragment programs.");

			log("emit opcode= " + opFound);

			data.writeUnsignedInt(opFound.emitCode);

			debugInfo(data);

			// get operands, use regexp
			var regs:Array = getRegs(line);

			//参数数量必须相同
			var regLength:uint = regs.length;

			assert(regLength != opFound.numRegister, "wrong number of operands. found " + regLength + " but expected " + opFound.numRegister + ".");

			var pad:uint = 160; //64 + 64 + 32;
			for (var j:int = 0; j < regLength; j++)
			{
				var regStr:String = regs[j];

				var isRelative:Boolean = false;
				//主要用于矩阵的情况下，例如vc[va3.x+1].xyz
				var relreg:Array = regStr.match(/\[.*\]/ig);
				if (relreg.length > 0)
				{
					//替换后便成vc0.xyz
					regStr = regStr.replace(relreg[0], "0");
					isRelative = true;
				}

				var regFound:Register = getRegister(regStr);
				assert(regFound == null, "could not parse operand " + j + " (" + regs[j] + ").");
				//output the registers
				log(regFound);

				if (isFrag)
				{
					assert(!regFound.isFragEnable(), "register operand " + j + " (" + regStr + ") only allowed in vertex programs.");
					assert(isRelative, "register operand " + j + " (" + regStr + ") relative adressing not allowed in fragment programs.");
				}
				else
				{
					assert(!regFound.isVertEnable(), "register operand " + j + " (" + regStr + ") only allowed in fragment programs.");
				}

				regStr = removeStringFrom(regStr, regFound.name);

				//如果使用[]中括号的话需要根据relreg获得index
				//两种情况下获得的index也不同
				//vc[va3.x+1].xyz情况下获得的是3
				//vc2.xyz获得的是2
				var idxmatch:Array = isRelative ? relreg[0].match(/\d+/) : regStr.match(/\d+/);
				var regidx:uint = 0;
				if (idxmatch != null)
					regidx = uint(idxmatch[0]);

				assert(regFound.range < regidx, "register operand " + j + " (" + regStr + ") index exceeds limit of " + (regFound.range + 1) + ".");

				//xyz
				var maskmatch:Array = regStr.match(/(\.[xyzwrgba]{1,4})/);

				//第一个参数是赋值目标
				var isDest:Boolean = (j == 0 && !opFound.noDest());

				//第三个参数是Texture
				var isSampler:Boolean = (j == 2 && opFound.isTexture());

				assert(isDest && isRelative, "relative can not be destination");

				var regmask:uint = 0;
				if (maskmatch != null)
				{
					regmask = 0;
					var index:uint;
					//.xyz
					var mask:String = maskmatch[0];
					var maskLength:uint = mask.length;
					for (var k:int = 1; k < maskLength; k++)
					{
						index = getComponentIndex(mask.charAt(k));

						if (isDest)
							regmask |= 1 << index;
						else
							regmask |= index << ((k - 1) << 1);
					}

					if (!isDest)
					{
						while(k <= 4)
						{
							regmask |= index << ((k - 1) << 1); // repeat last	
							k++;
						}
					}
				}
				else
				{
					regmask = isDest ? 0xf : 0xe4; // id swizzle or mask						
				}

				log("  emit argcode= " + regFound + "[" + regidx + "][" + regmask + "]");

				if (isDest)
				{
					data.writeShort(regidx);
					debugInfo(data);
					data.writeByte(regmask);
					debugInfo(data);
					data.writeByte(regFound.emitCode);
					debugInfo(data);
					pad -= 32;
				}
				else if (isSampler)
				{
					writeTexture(regidx, opts, data);
					pad -= 64;
				}
				else
				{
					var reltype:uint = 0;
					var reloffset:int = 0;
					var relsel:uint = 0;
					if (isRelative)
					{
						//relreg[0] [va2.x+3]
						var relname:Array = relreg[0].match(/[A-Za-z]{1,2}/ig);
						var regFoundRel:Register = getRegister(relname[0]);

						assert(regFoundRel == null, "bad index register");

						reltype = regFoundRel.emitCode;

						//.x
						var selmatch:Array = relreg[0].match(/(\.[xyzwrgba]{1,1})/);
						assert(selmatch.length == 0, "bad index register select");

						relsel = getComponentIndex(selmatch[0].charAt(1));

						//+3
						var relofs:Array = relreg[0].match(/\+\d{1,3}/ig);
						if (relofs.length > 0)
						{
							//3
							reloffset = relofs[0];

							assert(reloffset < 0 || reloffset > 255, "index offset " + reloffset + " out of bounds. [0..255]");
						}

						log("RELATIVE: type=" + reltype + "==" + relname[0] + " sel=" + relsel + "==" + selmatch[0] + " idx=" + regidx + " offset=" + reloffset);
					}

					if (j == 0)
					{
						data.writeUnsignedInt(0);
						pad -= 32;
					}

					data.writeShort(regidx);
					data.writeByte(reloffset);
					data.writeByte(regmask);
					data.writeByte(regFound.emitCode);
					data.writeByte(reltype);
					data.writeShort(isRelative ? (relsel | (1 << 15)) : 0);

					pad -= 64;
				}
			}

			// pad unused regs
			for (j = 0; j < pad; j += 8)
			{
				data.writeByte(0);
			}
		}

		/**
		 *
		 * @param regIndex 注册位置
		 * @param opts
		 * @param data
		 *
		 */
		private function writeTexture(regIndex:int, opts:Array, data:ByteArray):void
		{
			log("  emit sampler");

			var samplerbits:uint = 5; // type 5 
			var optsLength:uint = opts.length;
			var bias:Number = 0;
			for (var i:int = 0; i < optsLength; i++)
			{
				log("    opt: " + opts[i]);
				var sampler:Sampler = SAMPLEMAP[opts[i]];
				if (sampler == null)
				{
					// todo check that it's a number...
					//trace( "Warning, unknown sampler option: "+opts[k] );
					bias = Number(opts[i]);
					log("    bias: " + bias);
				}
				else
				{
					if (sampler.flag != SAMPLER_SPECIAL_SHIFT)
						samplerbits &= ~(0xf << sampler.flag);
					samplerbits |= sampler.mask << sampler.flag;
				}
			}
			data.writeShort(regIndex);
			data.writeByte(int(bias * 8.0));
			data.writeByte(0);
			data.writeUnsignedInt(samplerbits);

			log("    bits: " + (samplerbits - 5));
		}

		/**
		 * 获取一行代码中的参数
		 */
		private function getRegs(source:String):Array
		{
			if (USE_NEW_SYNTAX)
				return source.match(/vc\[([vif][acost]?)(\d*)?(\.[xyzwrgba](\+\d{1,3})?)?\](\.[xyzwrgba]{1,4})?|([vif][acost]?)(\d*)?(\.[xyzwrgba]{1,4})?/gi);
			else
				return source.match(/vc\[([vof][actps]?)(\d*)?(\.[xyzwrgba](\+\d{1,3})?)?\](\.[xyzwrgba]{1,4})?|([vof][actps]?)(\d*)?(\.[xyzwrgba]{1,4})?/gi);
		}

		private function getRegister(regStr:String):Register
		{
			var res:Array = regStr.match(/^\b[A-Za-z]{1,2}/ig);
			return REGMAP[res[0]];
		}

		private function getOpCode(name:String):OpCode
		{
			return OPMAP[name];
		}

		/**
		 * 删除前后空格
		 */
		private function trim(source:String):String
		{
			return source.replace(REGEXP_OUTER_SPACES, "");
		}

		/**
		 * 删除注释
		 */
		private function removeComment(source:String):String
		{
			var startcomment:int = source.search("//");
			if (startcomment != -1)
			{
				return source.slice(0, startcomment);
			}
			else
			{
				return source;
			}
		}

		private function getComponentIndex(key:String):int
		{
			var index:int = COMPONENTS[key];
			if (index >= 3)
				index = 3;
			return index;
		}

		/**
		 * 从source中删除第一个符合removed条件的文字，返回新的字符串
		 * @param source 源字符串
		 * @param removed 需要删除的文本
		 * @return 新的字符串
		 *
		 */
		private function removeStringFrom(source:String, removed:String):String
		{
			return source.slice(source.search(removed) + removed.length);
		}

		private function assert(value:Boolean, message:String):void
		{
			if (value)
			{
				throw new Error(message);
			}
		}

		private function log(value:*):void
		{
			if (debug)
				trace(value);
		}

		static private function init():void
		{
			initialized = true;

			// Fill the dictionaries with opcodes and registers
			OPMAP[MOV] = new OpCode(MOV, 2, 0x00, 0);
			OPMAP[ADD] = new OpCode(ADD, 3, 0x01, 0);
			OPMAP[SUB] = new OpCode(SUB, 3, 0x02, 0);
			OPMAP[MUL] = new OpCode(MUL, 3, 0x03, 0);
			OPMAP[DIV] = new OpCode(DIV, 3, 0x04, 0);
			OPMAP[RCP] = new OpCode(RCP, 2, 0x05, 0);
			OPMAP[MIN] = new OpCode(MIN, 3, 0x06, 0);
			OPMAP[MAX] = new OpCode(MAX, 3, 0x07, 0);
			OPMAP[FRC] = new OpCode(FRC, 2, 0x08, 0);
			OPMAP[SQT] = new OpCode(SQT, 2, 0x09, 0);
			OPMAP[RSQ] = new OpCode(RSQ, 2, 0x0a, 0);
			OPMAP[POW] = new OpCode(POW, 3, 0x0b, 0);
			OPMAP[LOG] = new OpCode(LOG, 2, 0x0c, 0);
			OPMAP[EXP] = new OpCode(EXP, 2, 0x0d, 0);
			OPMAP[NRM] = new OpCode(NRM, 2, 0x0e, 0);
			OPMAP[SIN] = new OpCode(SIN, 2, 0x0f, 0);
			OPMAP[COS] = new OpCode(COS, 2, 0x10, 0);
			OPMAP[CRS] = new OpCode(CRS, 3, 0x11, 0);
			OPMAP[DP3] = new OpCode(DP3, 3, 0x12, 0);
			OPMAP[DP4] = new OpCode(DP4, 3, 0x13, 0);
			OPMAP[ABS] = new OpCode(ABS, 2, 0x14, 0);
			OPMAP[NEG] = new OpCode(NEG, 2, 0x15, 0);
			OPMAP[SAT] = new OpCode(SAT, 2, 0x16, 0);
			OPMAP[M33] = new OpCode(M33, 3, 0x17, OP_SPECIAL_MATRIX);
			OPMAP[M44] = new OpCode(M44, 3, 0x18, OP_SPECIAL_MATRIX);
			OPMAP[M34] = new OpCode(M34, 3, 0x19, OP_SPECIAL_MATRIX);
			//OPMAP[IFZ] = new OpCode(IFZ, 1, 0x1a, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
			//OPMAP[INZ] = new OpCode(INZ, 1, 0x1b, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
			//OPMAP[IFE] = new OpCode(IFE, 2, 0x1c, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
			//OPMAP[INE] = new OpCode(INE, 2, 0x1d, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
			//OPMAP[IFG] = new OpCode(IFG, 2, 0x1e, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
			//OPMAP[IFL] = new OpCode(IFL, 2, 0x1f, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
			//OPMAP[IEG] = new OpCode(IEG, 2, 0x20, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
			//OPMAP[IEL] = new OpCode(IEL, 2, 0x21, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
			//OPMAP[ELS] = new OpCode(ELS, 0, 0x22, OP_NO_DEST | OP_INC_NEST | OP_DEC_NEST);
			//OPMAP[EIF] = new OpCode(EIF, 0, 0x23, OP_NO_DEST | OP_DEC_NEST);
			//OPMAP[REP] = new OpCode(REP, 1, 0x24, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
			//OPMAP[ERP] = new OpCode(ERP, 0, 0x25, OP_NO_DEST | OP_DEC_NEST);
			//OPMAP[BRK] = new OpCode(BRK, 0, 0x26, OP_NO_DEST);
			OPMAP[KIL] = new OpCode(KIL, 1, 0x27, OP_NO_DEST | OP_FRAG_ONLY);
			OPMAP[TEX] = new OpCode(TEX, 3, 0x28, OP_FRAG_ONLY | OP_SPECIAL_TEX);
			OPMAP[SGE] = new OpCode(SGE, 3, 0x29, 0);
			OPMAP[SLT] = new OpCode(SLT, 3, 0x2a, 0);
			//OPMAP[SGN] = new OpCode(SGN, 2, 0x2b, 0);
			OPMAP[SEQ] = new OpCode(SEQ, 3, 0x2c, 0);
			OPMAP[SNE] = new OpCode(SNE, 3, 0x2d, 0);

			REGMAP[VA] = new Register(VA, "vertex attribute", 0x0, 7, REG_VERT | REG_READ);
			REGMAP[VC] = new Register(VC, "vertex constant", 0x1, 127, REG_VERT | REG_READ);
			REGMAP[VT] = new Register(VT, "vertex temporary", 0x2, 7, REG_VERT | REG_WRITE | REG_READ);
			REGMAP[VO] = new Register(VO, "vertex output", 0x3, 0, REG_VERT | REG_WRITE);
			REGMAP[I] = new Register(I, "varying", 0x4, 7, REG_VERT | REG_FRAG | REG_READ | REG_WRITE);
			REGMAP[FC] = new Register(FC, "fragment constant", 0x1, 27, REG_FRAG | REG_READ);
			REGMAP[FT] = new Register(FT, "fragment temporary", 0x2, 7, REG_FRAG | REG_WRITE | REG_READ);
			REGMAP[FS] = new Register(FS, "texture sampler", 0x5, 7, REG_FRAG | REG_READ);
			REGMAP[FO] = new Register(FO, "fragment output", 0x3, 0, REG_FRAG | REG_WRITE);

			SAMPLEMAP[D2] = new Sampler(D2, SAMPLER_DIM_SHIFT, 0);
			SAMPLEMAP[D3] = new Sampler(D3, SAMPLER_DIM_SHIFT, 2);
			SAMPLEMAP[CUBE] = new Sampler(CUBE, SAMPLER_DIM_SHIFT, 1);
			SAMPLEMAP[MIPNEAREST] = new Sampler(MIPNEAREST, SAMPLER_MIPMAP_SHIFT, 1);
			SAMPLEMAP[MIPLINEAR] = new Sampler(MIPLINEAR, SAMPLER_MIPMAP_SHIFT, 2);
			SAMPLEMAP[MIPNONE] = new Sampler(MIPNONE, SAMPLER_MIPMAP_SHIFT, 0);
			SAMPLEMAP[NOMIP] = new Sampler(NOMIP, SAMPLER_MIPMAP_SHIFT, 0);
			SAMPLEMAP[NEAREST] = new Sampler(NEAREST, SAMPLER_FILTER_SHIFT, 0);
			SAMPLEMAP[LINEAR] = new Sampler(LINEAR, SAMPLER_FILTER_SHIFT, 1);
			SAMPLEMAP[CENTROID] = new Sampler(CENTROID, SAMPLER_SPECIAL_SHIFT, 1 << 0);
			SAMPLEMAP[SINGLE] = new Sampler(SINGLE, SAMPLER_SPECIAL_SHIFT, 1 << 1);
			SAMPLEMAP[DEPTH] = new Sampler(DEPTH, SAMPLER_SPECIAL_SHIFT, 1 << 2);
			SAMPLEMAP[REPEAT] = new Sampler(REPEAT, SAMPLER_REPEAT_SHIFT, 1);
			SAMPLEMAP[WRAP] = new Sampler(WRAP, SAMPLER_REPEAT_SHIFT, 1);
			SAMPLEMAP[CLAMP] = new Sampler(CLAMP, SAMPLER_REPEAT_SHIFT, 0);
		}

		// ======================================================================
		//	Constants
		// ----------------------------------------------------------------------
		private static const OPMAP:Dictionary = new Dictionary();
		private static const REGMAP:Dictionary = new Dictionary();
		private static const SAMPLEMAP:Dictionary = new Dictionary();

		private static const MAX_NESTING:int = 4;
		private static const MAX_OPCODES:int = 256;

		private static const FRAGMENT:String = "fragment";
		private static const VERTEX:String = "vertex";

		// masks and shifts
		private static const SAMPLER_DIM_SHIFT:uint = 12;
		private static const SAMPLER_SPECIAL_SHIFT:uint = 16;
		private static const SAMPLER_REPEAT_SHIFT:uint = 20;
		private static const SAMPLER_MIPMAP_SHIFT:uint = 24;
		private static const SAMPLER_FILTER_SHIFT:uint = 28;

		// regmap flags
		private static const REG_WRITE:uint = 0x1;
		private static const REG_READ:uint = 0x2;
		private static const REG_FRAG:uint = 0x20;
		private static const REG_VERT:uint = 0x40;

		// opmap flags
		private static const OP_SCALAR:uint = 0x1;
		private static const OP_INC_NEST:uint = 0x2;
		private static const OP_DEC_NEST:uint = 0x4;
		private static const OP_SPECIAL_TEX:uint = 0x8;
		private static const OP_SPECIAL_MATRIX:uint = 0x10;
		private static const OP_FRAG_ONLY:uint = 0x20;
		private static const OP_VERT_ONLY:uint = 0x40;
		private static const OP_NO_DEST:uint = 0x80;

		// opcodes
		private static const MOV:String = "mov";
		private static const ADD:String = "add";
		private static const SUB:String = "sub";
		private static const MUL:String = "mul";
		private static const DIV:String = "div";
		private static const RCP:String = "rcp";
		private static const MIN:String = "min";
		private static const MAX:String = "max";
		private static const FRC:String = "frc";
		private static const SQT:String = "sqt";
		private static const RSQ:String = "rsq";
		private static const POW:String = "pow";
		private static const LOG:String = "log";
		private static const EXP:String = "exp";
		private static const NRM:String = "nrm";
		private static const SIN:String = "sin";
		private static const COS:String = "cos";
		private static const CRS:String = "crs";
		private static const DP3:String = "dp3";
		private static const DP4:String = "dp4";
		private static const ABS:String = "abs";
		private static const NEG:String = "neg";
		private static const SAT:String = "sat";
		private static const M33:String = "m33";
		private static const M44:String = "m44";
		private static const M34:String = "m34";
//		private static const IFZ:String = "ifz";
//		private static const INZ:String = "inz";
//		private static const IFE:String = "ife";
//		private static const INE:String = "ine";
//		private static const IFG:String = "ifg";
//		private static const IFL:String = "ifl";
//		private static const IEG:String = "ieg";
//		private static const IEL:String = "iel";
//		private static const ELS:String = "els";
//		private static const EIF:String = "eif";
//		private static const REP:String = "rep";
//		private static const ERP:String = "erp";
//		private static const BRK:String = "brk";
		private static const KIL:String = "kil";
		private static const TEX:String = "tex";
		private static const SGE:String = "sge";
		private static const SLT:String = "slt";
//		private static const SGN:String = "sgn";
		private static const SEQ:String = "seq";
		private static const SNE:String = "sne";

		// registers
		private static const VA:String = "va";
		private static const VC:String = "vc";
		private static const VT:String = "vt";
		private static const VO:String = USE_NEW_SYNTAX ? "vo" : "op";
		private static const I:String = USE_NEW_SYNTAX ? "i" : "v";
		private static const FC:String = "fc";
		private static const FT:String = "ft";
		private static const FS:String = "fs";
		private static const FO:String = USE_NEW_SYNTAX ? "fo" : "oc";

		// samplers
		private static const D2:String = "2d";
		private static const D3:String = "3d";
		private static const CUBE:String = "cube";
		private static const MIPNEAREST:String = "mipnearest";
		private static const MIPLINEAR:String = "miplinear";
		private static const MIPNONE:String = "mipnone";
		private static const NOMIP:String = "nomip";
		private static const NEAREST:String = "nearest";
		private static const LINEAR:String = "linear";
		private static const CENTROID:String = "centroid";
		private static const SINGLE:String = "single";
		private static const DEPTH:String = "depth";
		private static const REPEAT:String = "repeat";
		private static const WRAP:String = "wrap";
		private static const CLAMP:String = "clamp";
	}
}

