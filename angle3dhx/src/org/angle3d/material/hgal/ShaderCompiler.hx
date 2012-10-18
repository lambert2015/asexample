package org.angle3d.material.hgal;
import flash.Lib;
import flash.utils.ByteArray;
import flash.utils.Endian;
import flash.Vector;
import org.angle3d.material.hgal.core.Code;
import org.angle3d.material.hgal.core.CodeParam;
import org.angle3d.material.hgal.core.CompileData;
import org.angle3d.material.hgal.core.Lexer;
import org.angle3d.material.hgal.core.OpCode;
import org.angle3d.material.hgal.core.reg.Reg;
import org.angle3d.material.hgal.core.TexFlag;
import org.angle3d.material.shader.Shader;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.material.shader.ShaderVarType;
import org.angle3d.utils.Assert;
import org.angle3d.utils.HashMap;
import org.angle3d.utils.Logger;

/**
 * Shader编译器
 * @author andy
 */
//TODO 添加数组类型
class ShaderCompiler 
{
	public static inline var MAX_OPCODES:Int = 200;
	
	private var _map:HashMap<String,Int>;
	
	private var _lexer:Lexer;
	
	private var _vertexData:CompileData;
	
	private var _fragmentData:CompileData;
	
	public function new() 
	{
		_map = new HashMap<String,Int>();
		_map.setValue("x", 0);
		_map.setValue("y", 1);
		_map.setValue("z", 2);
		_map.setValue("w", 3);
		_map.setValue("r", 0);
		_map.setValue("g", 1);
		_map.setValue("b", 2);
		_map.setValue("a", 3);
		
		_lexer = new Lexer();

		_vertexData = new CompileData(ShaderType.VERTEX);
		_fragmentData = new CompileData(ShaderType.FRAGMENT);
	}
	
	/**
	 * 编译并传递数据到Shader中
	 * @param	shader
	 * @param	sources
	 * @param	conditions
	 * @return
	 */
	public function complie(sources:Array<String>, conditions:Array<Array<String>> = null):Shader
	{
		var shader:Shader = new Shader();
		
		_vertexData.clear();
		_lexer.parse(_vertexData, sources[0], conditions != null ? conditions[0] : null);
		
		_fragmentData.clear();
		_fragmentData.copyVaryingFrom(_vertexData);
		_lexer.parse(_fragmentData,sources[1],conditions != null ? conditions[1] : null);
		
		_addVariables(_vertexData, shader);
		_addVariables(_fragmentData, shader);
		
		shader.vertexData = writeByteArray(_vertexData);
		shader.fragmentData = writeByteArray(_fragmentData);
		
		shader.validate();
		
		#if debug
		Logger.log("Vertex Agal:\n" + getAgal(ShaderType.VERTEX) + "\n");
		Logger.log("Fragment Agal:\n" + getAgal(ShaderType.FRAGMENT)+"\n");
		#end
		
		return shader;
	}
	
	private function getAgal(shaderType:String):String
	{
		var data:CompileData;
		if (shaderType == ShaderType.VERTEX)
		{
			data = _vertexData;
		}
		else
		{
			data = _fragmentData;
		}
		
		var codes:Vector<Code> = data.codes;
		
		var source:Array<String> = [];
		for (i in 0...codes.length)
		{
			source.push(codes[i].toAgal(data.uniformPool));
		}
		return source.join("\n");
	}
	
	/**
	 * 传递Shader中对应的变量名和其大小
	 * @param	data
	 * @param	shader
	 */
	private function _addVariables(data:CompileData,shader:Shader):Void
	{
		var type:String = data.shaderType;

		shader.setDigits(type, data.uniformPool.getDigits());
		
		var variable:Reg;
		var variables:Vector<Reg> = data.uniformPool.getRegs();
		for (i in 0...variables.length)
		{
			variable = variables[i];
			shader.addVariable(type, ShaderVarType.UNIFORM, variable.name, variable.size);
		}

		if (type == ShaderType.VERTEX)
		{
			variables = data.attributePool.getRegs();
			for (i in 0...variables.length)
			{
				variable = variables[i];
				shader.addVariable(type, ShaderVarType.ATTRIBUTE, variable.name, variable.size);
			}
		}
		else
		{
			variables = data.texturePool.getRegs();
			for (i in 0...variables.length)
			{
				variable = variables[i];
				shader.addVariable(type, ShaderVarType.TEXTURE, variable.name, variable.size);
			}
		}
	}

	private function writeByteArray(data:CompileData):ByteArray
	{
		var byteArray:ByteArray = new ByteArray();
		byteArray.endian = Endian.LITTLE_ENDIAN;
		byteArray.position = 0;
		
		writeHeader(data.shaderType == ShaderType.FRAGMENT, byteArray);
		
		var codes:Vector<Code> = data.codes;
		var count:Int = codes.length;
		
		#if debug
		Assert.assert(count <= MAX_OPCODES, "too many opcodes. maximum is " + MAX_OPCODES + ".");
		#end
		
		for (i in 0...count)
		{
			writeCode(codes[i], byteArray);
		}
		
		return byteArray;
	}
	
	/**
	 * Agal头部
	 * @param	isFrag
	 * @param	data
	 */
	private inline function writeHeader(isFrag:Bool,data:ByteArray):Void
	{
		data.writeByte(0xa0); // tag version
		data.writeUnsignedInt(0x1); // AGAL version, big endian, bit pattern will be 0x01000000
		data.writeByte(0xa1); // tag program id
		data.writeByte(isFrag ? 1 : 0); // vertex or fragment
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
	 * @param opts
	 * @param data
	 *
	 */
	private inline function writeTexture(regIndex:Int, flag:TexFlag, data:ByteArray):Void
	{
		data.writeShort(regIndex);//16 bits
		data.writeByte(flag.getLod());//8 bits
		data.writeByte(0);//8 bits
		data.writeByte(5);//8 bits
		
		var bits:UInt = flag.getTexFlagsBits();
		
		data.writeByte(bits & 0xFF);
		data.writeByte((bits >> 8) & 0xFF);
		data.writeByte(bits >> 16);
	}
	
	private function writeCode(code:Code,data:ByteArray):Void
	{
		var opCode:OpCode = code.opCode;
		
		data.writeUnsignedInt(opCode.emitCode);
		
		//dest 长度为32
		var dest:CodeParam = code.dest;
		if (dest != null)
		{
			data.writeShort(dest.reg.index);
			data.writeByte(maskBits(dest.swizzle));
			data.writeByte(dest.reg.emitCode);
		}
		else
		{
			data.writeUnsignedInt(0);
		}
		
		var pad:Int = 128; //64 + 64;
		
		var params:Vector<CodeParam> = code.getParams();
		for (i in 0...params.length)
		{
			var param:CodeParam = params[i];
			if (param.isTexture())
			{
				writeTexture(param.reg.index, param.texFlag, data);
				pad -= 64;
			}
			else
			{
				var isRelative:Bool = param.isRelative();

				//TODO 这里不确定是否正确
				var offset:Int = 0;
				if (isRelative)
				{
					//FIXME 是否需要加上param.reg.index
					//offset = param.reg.index + param.access.offset;
					offset = param.access.offset;
				}
				
				
				var index:Int = param.reg.index;
				//矩阵，数组之类的会有偏移
				//mat[3],其真正注册位置需要加上3
				//TODO need test
				if (!isRelative && param.access != null)
				{
					index += param.access.offset;
				}
				
				data.writeShort(index);
				data.writeByte(offset);
				data.writeByte(swizzleBits(param.swizzle));
				data.writeByte(param.reg.emitCode);
				
				if (isRelative)
				{
					data.writeByte(param.access.reg.emitCode);
					data.writeShort((getCharIndex(param.access.component) | (1 << 15)));
				}
				else
				{
					data.writeByte(0);
					data.writeShort(0);
				}
				
				pad -= 64;
			}
		}

		// pad unused regs
		var j:Int = 0;
		while (j < pad)
		{
			data.writeByte(0);
			j += 8;
		}
	}
	
	
	#if debug
	private function debugInfo(agalcode:ByteArray):Void
	{
		var dbgLine:String = "generated bytecode:";
		for (index in 0...agalcode.length)
		{
			if ( ( index % 16 ) == 0 )
				dbgLine += "\n";
			if ( ( index % 4 ) == 0)
				dbgLine += " ";
					
			var byteStr:String = untyped agalcode[index].toString(16);
			if ( byteStr.length < 2 )
				byteStr = "0" + byteStr;
			
			dbgLine += byteStr;
		}
		Lib.trace( dbgLine );
	}
	#end
	
	private inline function getCharIndex(char:String):Int
	{
		return _map.getValue(char.toLowerCase());
	}
	
	private function maskBits( m : Array<String> ):UInt
	{
		if ( m == null ) 
		   return 0x0f;
		   
		var bits:UInt = 0;
		for(i in 0...m.length)
		{
			bits |= 1 << getCharIndex(m[i]);
		}
		return bits;
	}

	private function swizzleBits( list : Array<String> ):UInt
	{
		if ( list == null ) 
		   return 0 | (1 << 2) | (2 << 4) | (3 << 6); //0xe4
		   
		#if debug
		Assert.assert(list.length <= 4, "s的长度不能超过4");
		#end
		   
		var bits:UInt = 0;
		var p:Int = 0;
		var last:Int = 0;
		for (i in 0...list.length)
		{
			last = getCharIndex(list[i]);
			bits |= last << p;
			p += 2;
		}
		
		// repeat last component
		while ( p < 8 ) 
		{
			bits |= last << p;
			p += 2;
		}
		return bits;
	}
}