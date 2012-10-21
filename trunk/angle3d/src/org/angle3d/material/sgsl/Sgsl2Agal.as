package org.angle3d.material.sgsl
{
	import flash.media.Video;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.math.FastMath;

	public class Sgsl2Agal
	{
		private var _codeMap:Dictionary;

		private var _swizzleMap:Dictionary;

		private var _shaderType:String;

		private var _data:ByteArray;

		public function Sgsl2Agal()
		{
			_codeMap = new Dictionary();
			_codeMap[0x00] = "mov";
			_codeMap[0x01] = "add";
			_codeMap[0x02] = "sub";
			_codeMap[0x03] = "mul";
			_codeMap[0x04] = "div";
			_codeMap[0x05] = "rcp";
			_codeMap[0x06] = "min";
			_codeMap[0x07] = "max";
			_codeMap[0x08] = "frc";
			_codeMap[0x09] = "sqt";
			_codeMap[0x0a] = "rsq";
			_codeMap[0x0b] = "pow";
			_codeMap[0x0c] = "log";
			_codeMap[0x0d] = "exp";
			_codeMap[0x0e] = "nrm";
			_codeMap[0x0f] = "sin";
			_codeMap[0x10] = "cos";
			_codeMap[0x11] = "crs";
			_codeMap[0x12] = "dp3";
			_codeMap[0x13] = "dp4";
			_codeMap[0x14] = "abs";
			_codeMap[0x15] = "neg";
			_codeMap[0x16] = "sat";
			_codeMap[0x17] = "m33";
			_codeMap[0x18] = "m44";
			_codeMap[0x19] = "m34";

//			_codeMap[0x1a] = "ifz";
//			_codeMap[0x1b] = "inz";
//			_codeMap[0x1c] = "ife";
//			_codeMap[0x1d] = "ine";
//			_codeMap[0x1e] = "ifg";
//			_codeMap[0x1f] = "ifl";
//			_codeMap[0x20] = "ieg";
//			_codeMap[0x21] = "iel";
//			_codeMap[0x22] = "els";
//			_codeMap[0x23] = "elf";
//			_codeMap[0x24] = "rep";
//			_codeMap[0x25] = "erp";
//			_codeMap[0x26] = "brk";

			_codeMap[0x27] = "kil";
			_codeMap[0x28] = "tex";
			_codeMap[0x29] = "sge";
			_codeMap[0x2a] = "slt";

//			_codeMap[0x2b] = "sgn";
			_codeMap[0x2c] = "seq";
			_codeMap[0x2d] = "sne";

			_swizzleMap = new Dictionary();
			_swizzleMap[0] = "x";
			_swizzleMap[1] = "y";
			_swizzleMap[2] = "z";
			_swizzleMap[3] = "w";
		}

		public function toAgal(data:ByteArray):String
		{
			_data = data;

			_data.position = 0;

			_data.readUnsignedByte(); // tag version
			_data.readUnsignedInt(); // AGAL version, big endian, bit pattern will be 0x01000000
			_data.readUnsignedByte(); // tag program id

			_shaderType = (_data.readUnsignedByte() == 0) ? ShaderType.VERTEX : ShaderType.FRAGMENT;

			var agal:String = "";
			var index:int;
			var code:int;
			var offset:int;
			while (data.position < data.length)
			{
				var elements:Array = [];

				var opcode:String = _codeMap[data.readUnsignedInt()];

				addElement(elements, opcode);

				addElement(elements, readDest());

				//source0
				addElement(elements, readSrc());

				//source1
				var source1:String;
				if (opcode == "tex")
				{
					source1 = readTexture();
				}
				else
				{
					source1 = readSrc();
				}
				addElement(elements, source1);

				agal += elements.join(" ") + "\n";
			}

			return agal;
		}

		private function addElement(list:Array, element:String):void
		{
			if (element.length > 0)
			{
				list.push(element);
			}
		}

		private function getRegPrex(code:uint):String
		{
			switch (code)
			{
				case 0x0:
					return "va";
				case 0x1:
					return _shaderType == ShaderType.VERTEX ? "vc" : "fc";
				case 0x2:
					return _shaderType == ShaderType.VERTEX ? "vt" : "ft";
				case 0x3:
					return _shaderType == ShaderType.VERTEX ? "op" : "oc";
				case 0x4:
					return "v";
				case 0x5:
					return "fs";
			}
			return "";
		}

		private function readTexture():String
		{
			var index:int = _data.readUnsignedShort();
			var lod:int = _data.readUnsignedByte();
			_data.readUnsignedByte();
			_data.readUnsignedByte();

			var dimension:int = _data.readUnsignedByte() >> 4 & 0xf;

			var value:int = _data.readUnsignedByte();

			var wrap:int = value >> 4 & 0xf;

			value = _data.readUnsignedByte();

			var mipmap:int = value & 0xf;
			var filter:int = value >> 4 & 0xf;

			var option:Array = [];
			if (dimension == 0)
			{
				option.push("2d");
			}
			else if (dimension == 1)
			{
				option.push("cube");
			}
//			else if (dimension == 2)
//			{
//				option.push("3d");
//			}

			if (wrap == 0)
			{
				option.push("clamp");
			}
			else if (wrap == 1)
			{
				option.push("wrap");
			}

			if (mipmap == 0)
			{
				option.push("nomip");
			}
			else if (mipmap == 1)
			{
				option.push("mipnearest");
			}
			else if (mipmap == 2)
			{
				option.push("miplinear");
			}

			if (filter == 0)
			{
				option.push("nearest");
			}
			else if (filter == 1)
			{
				option.push("linear");
			}

			if (lod > 0)
			{
				option.push(lod * 8);
			}

			return "fs" + index + " <" + option.join(",") + ">";
		}

		private function readDest():String
		{
			var result:String = "";

			var dest:uint = _data.readUnsignedInt();
			//dest为0代表没有
			if (dest != 0)
			{
				_data.position -= 4;

				var index:int = _data.readShort();
				var maskBits:int = _data.readUnsignedByte();
				var code:int = _data.readUnsignedByte();

				if (code == 0x3)
				{
					result = getRegPrex(code);
				}
				else
				{
					result = getRegPrex(code) + index;
				}

				var mask:String = "";
				//0x0f时包含所有mask,可不写
				if (maskBits != 0x0f)
				{
					for (var i:int = 0; i < 4; i++)
					{
						var t:int = maskBits & (1 << i);
						if (t > 0)
						{
							mask += _swizzleMap[FastMath.log2(t)];
						}
					}
				}

				if (mask.length > 0)
				{
					result += "." + mask;
				}
			}
			return result;
		}

		private function readSrc():String
		{
			var result:String = "";
			var a:int = _data.readInt();
			var b:int = _data.readInt();
			if (a != 0 || b != 0)
			{
				_data.position -= 8;

				var index:int = _data.readShort();
				var offset:int = _data.readUnsignedByte();
				var swizzleBits:int = _data.readUnsignedByte();
				var code:int = _data.readUnsignedByte();
				var accessCode:int = _data.readUnsignedByte();
				var accessCompBits:int = _data.readUnsignedByte();
				var direct:Boolean = _data.readUnsignedByte() == 0;
				if (direct)
				{
					result = getRegPrex(code) + index;
				}
				else
				{
					result = getRegPrex(code) + "[";
					result += getRegPrex(accessCode) + index + "." + _swizzleMap[accessCompBits];
					result += " + " + offset + "]";
				}

				var swizzle:String = "";
				//如何最后几个字符相同的话，可以只保留一个
				if (swizzleBits != 0xe4)
				{
					for (var i:int = 0; i < 4; i++)
					{
						var t:int = swizzleBits >> (i * 2) & 3;
						swizzle += _swizzleMap[t];
					}
				}
				if (swizzle.length > 0)
				{
					result += "." + optimizeSwizzle(swizzle);
				}
			}
			return result;
		}

		/**
		 * 如何尾部有几个字符相同的话，去掉最后相同的部分,只保留一个
		 */
		private function optimizeSwizzle(swizzle:String):String
		{
			var size:int = swizzle.length;
			if (size < 1)
			{
				return swizzle;
			}

			var char:String = swizzle.charAt(size - 1);
			while (swizzle.charAt(size - 2) == char)
			{
				swizzle = swizzle.slice(0, size - 1);
				size = swizzle.length;
				if (size < 2)
				{
					break;
				}
			}
			return swizzle;
		}
	}
}

