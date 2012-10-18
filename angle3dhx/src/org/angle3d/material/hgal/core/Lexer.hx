package org.angle3d.material.hgal.core;

import flash.utils.RegExp;
import org.angle3d.material.hgal.core.condition.ConditionalCompilation;
import org.angle3d.material.hgal.core.reg.RegFactory;
import org.angle3d.utils.Assert;
import org.angle3d.utils.StringUtil;

/**
 * 语法分析器
 * 解析流程如下：
 * 1、根据条件编译选项筛选掉不需要的语句
 * 2、解析自定义函数，翻译为原生函数
 * 3、对每行语句进行拆分
 * 
 * @author andy 
 */
//TODO 整理
class Lexer 
{
	private var _data:CompileData;
	
	private var _shaderType:String;
	
	private var _condition:ConditionalCompilation;
	
	private var _customCodeHelper:CustomCodeHelper;
	
	public function new() 
	{
		_condition = new ConditionalCompilation();
		_customCodeHelper = new CustomCodeHelper();
	}
	
	/**
	 * 格式化source,删除无用空格、空行等
	 * @param	source
	 * @return
	 */
	private function _formatSource(source:String):String
	{
		source = StringUtil.replace(source, new RegExp("\t+", "gi"), " ");
		source = StringUtil.replace(source, new RegExp("(\\n\\s*)+", "gi"), "\n");
		return source;
	}

	/**
	 * 解析
	 * @param	source
	 * @param	conditions 编译条件
	 */
	public function parse(data:CompileData,source:String,conditions:Array<String> = null):Void
	{
		_data = data;
		_shaderType = _data.shaderType;
		
		//删除无用空格，换行
		source = _formatSource(source);
		
		//有可能只有主函数而没有变量定义
		//拆分为两部分，第一部分是变量定义，第二部分是主函数
		var list:Array<String> = StringUtil.splitAndTrim(source, "@main");
		
		#if debug
		Assert.assert(list.length > 0, "解析出错");
		#end
		
		var mainSource:String;
		
		//包含主函数和定义
		if (list.length > 1)
		{
			//解析变量定义
			var varLines:Array<String> = StringUtil.splitAndTrim( list[0], "\n" );
			
			varLines = _condition.parse(varLines, conditions);
			
			_parseVariable(varLines);
			
			mainSource = list[1];
		}
		else
		{
			mainSource = list[0];
		}
		
		var array:Array<String> = StringUtil.splitAndTrim(mainSource, "\n" );
		array = _condition.parse(array, conditions);

		var lines:Array<Array<String>> = _customCodeHelper.replace(array);
		//解析自定义函数中的临时变量
		_parseVariable(lines[0]);
		
		//解析主函数
		var mainLines:Array<String> = lines[1];
		for (i in 0...mainLines.length)
		{
			_parseLine(i, mainLines[i]);
		}
		
		_data.arrange();
	}
	
	/**
	 * 解析定义的变量，变量只能在此时定义，不能在主函数中定义
	 * @param	lines
	 */
	private function _parseVariable(list:Array<String>):Void
	{
		var length:Int = list.length;
		for (i in 0...length)
		{
			var source:String = StringUtil.trim(list[i]);

			var keys:Array<String> = StringUtil.splitAndTrim(source, " ");
			
			#if debug
			Assert.assert(keys.length >= 2, "变量定义的行应该拆分为2个以上部分");
			#end
			
			if (keys.length > 2)
			{
				_data.addReg(RegFactory.create(_shaderType, keys[2], keys[0], keys[1]));
			}
			else
			{
				_data.addReg(RegFactory.create(_shaderType,keys[1],keys[0]));
			}
		}
	}

	/**
	 * kil需要特殊操作
	 * kil(vt0.x)
	 * vt0.xyz=max(vt1,vt2)
	 * mat[0].z=max(vt1.x,vt2.y)//矩阵的操作
	 * t_color=tex(sampler0,texcoord<linear,nomip,wrap,2d>)
	 * 解析分为几部分,
	 * 1、去除空格回车符等
	 * 2、先通过"="分成2块，前面那个就是destination.
	 * 3、对后面这块，先判断是否有括号。没有的话就是source1,无其他的了
	 * 4、通过正则表达式，得到max和(vt1,vt2),不包含()
	 * 5、对(vt1,vt2)，则通过","分割即可
	 * @param	source
	 */
	private function _parseLine(i:Int,source:String):Void
	{
		var manager:OpCodeManager = OpCodeManager.instance;
		
		var code:Code = new Code(_shaderType);

		//kil时的特殊情况 kil(value)
		if (source.indexOf("=") == -1)
		{
			var reg:RegExp = new RegExp("([a-z][a-z0-9]*)\\((.*)\\)", "gi");
			
			var data = reg.exec(source);//[kil(value),kil,value]
			
			code.opCode = manager.getCode(data[1]);
			code.addParam(_createCodeParam(data[2]));
		}
		else
		{
			var words:Array<String> = source.split("=");

			code.dest = _createCodeParam(words[0]);
			
			//无operation的情况 vt0 = vt1
			if (words[1].indexOf("(") == -1) 
			{
				code.opCode = null;
				code.addParam(_createCodeParam(words[1]));
			}
			else
			{
				//abs(vt1)
				//max(vt1,vt2)
				var reg:RegExp = new RegExp("([a-z][a-z0-9]*)\\((.*)\\)", "gi");
				
				var data = reg.exec(words[1]);
				//[max(vt1,vt2),max,{vt1,vt2}]
				
				code.opCode = manager.getCode(data[1]);

				//括号内的部分
				var paramStr:String = data[2];
				
				//这个实现不好
				var flags:Array<String> = null;
				if (code.opCode == manager.getCode("tex"))
				{
					//只有tex这种情况下会有<linear,nomip,wrap,2d>
					var reg:RegExp = new RegExp("\\<(.*)\\>", "g");
					var texFlag = reg.exec(paramStr);
					flags = texFlag[1].split(",");
						
					//删除<linear,nomip,wrap,2d>部分
					var index:Int = paramStr.indexOf("<");
					paramStr = paramStr.substr(0, index);
				}
				
				
				var params:Array<String> = paramStr.split(",");
				for ( i in 0...params.length)
				{
					if (flags != null && i == params.length - 1)
					{
						code.addParam(_createCodeParam(params[i],flags));
					}
					else
					{
						code.addParam(_createCodeParam(params[i]));
					}
				}
			}
		}
		
		//检查语句合法性
		#if debug
		code.checkValid();
		#end
		
		_data.addCode(code);
	}
	
	private function _splitString(source:String):Array<String>
	{
		var result:Array<String> = new Array<String>();
		for (i in 0...source.length)
		{
			result[i] = source.charAt(i).toLowerCase();
		}
		return result;
	}
	
	//如果希望支持纯数字数组，会有个问题。不能跨行存
	private function _createCodeParam(source:String, flags:Array<String> = null):CodeParam
	{
		//纯数字,会自动转换为CodeParam
		if (StringUtil.isDigit(source)) 
		{
			var value:Float = Std.parseFloat(source);
			
			_data.addDigit(value);
			
			return _data.getDigitParam(_shaderType, value);
		}
		
		var param:CodeParam = new CodeParam();
		
		//matrix[va_position.x+3].xyz
		var reg:RegExp = new RegExp("^(.*)\\[(.*)\\]\\.?([xyzwrgba]+)?$", "gi");
		var regExec = reg.exec(source);
		//regExec = [matrix[va_position.x+3],matrix,va_position.x+3];
		if (regExec != null)
		{
			param.reg = _data.getReg(regExec[1]);
			
			var access:Access = new Access();
			var accessStr:String = regExec[2];
			//matrix[3]
			if (StringUtil.isDigit(accessStr))
			{
				access.offset = Std.parseInt(accessStr);
			}
			else
			{
				//matrix[va_position.x+3] || matrix[va_position.x].xyz
				var array:Array<String> = accessStr.split("+");
				for (i in 0...array.length)
				{
					if (StringUtil.isDigit(array[i]))
					{
						access.offset = Std.parseInt(array[i]);
					}
					else
					{
						var list:Array<String> = array[i].split(".");
						access.reg = _data.getReg(list[0]);
						access.component = list[1];
					}
				}
				
				param.access = access;
			}
			
			//xyz
			if (regExec[3] != null)
			{
				param.swizzle = _splitString(regExec[3]);
			}
		}
		else
		{
			//其他只有vt0.x 或者 vt0两种情况
			var array:Array<String> = source.split(".");
			
			param.reg = _data.getReg(array[0]);
			
			if (array.length > 1)
			{
				param.swizzle = _splitString(array[1]);
			}
		}
		
		//只有tex这种情况下会有
		if (flags != null) 
		{
			param.setTexFlag(flags);
		}
		
		return param;
	}
}