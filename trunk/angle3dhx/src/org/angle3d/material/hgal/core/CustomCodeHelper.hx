package org.angle3d.material.hgal.core;
import flash.utils.RegExp;
import org.angle3d.utils.StringUtil;

/**
 * 替换自定义函数，返回最终代码
 * @author andy
 */

class CustomCodeHelper 
{

	public function new() 
	{
		
	}
	
	/**
	 * 返回的数组，第一个是临时变量数组，第二个是转换后的code
	 * @param	list
	 * @return Array<Array<String>>
	 */
	public function replace(list:Array<String>):Array<Array<String>>
	{
		var result:Array<Array<String>>  = new Array<Array<String>>();
		result[0] = new Array<String>();
		result[1] = new Array<String>();
		
		for (i in 0...list.length)
		{
			//去掉空格
			var line:String = StringUtil.removeSpace(list[i]);
		
			var arr:Array<Array<String>> = _getRealCodes(line);
			if (arr != null)
			{
				result[0] = result[0].concat(arr[0]);
				result[1] = result[1].concat(arr[1]);
			}
			else
			{
				//不是自定义函数则直接加入原句
				result[1].push(line);
			}
		}
		
		return result;
	}
	
	/**
	 * 如果是自定义函数，替换成对应代码
	 * @return 真实代码
	 */
	//TODO 这里的判断方法不太科学，应该用判断opcode的方式来判断是否是自定义
	private function _getRealCodes(line:String):Array<Array<String>>
	{
		//kil时的特殊情况，非自定义
		if (line.indexOf("=") == -1)
		{
			return null;
		}
		
		var words:Array<String> = line.split("=");
		
		//无operation的情况 vt0 = vt1，非自定义
		if (words[1].indexOf("(") == -1) 
		{
			return null;
		}

		//max(vt1,vt2)
		var reg:RegExp = new RegExp("([a-z][a-z0-9]*)\\((.*)\\)", "gi");
				
		var data = reg.exec(words[1]);//[max(vt1,vt2),max,{vt1,vt2}]
		
		//是否是自定义函数
		if (!OpCodeManager.instance.isCustomCode(data[1]))
		{
			return null;
		}

		//括号内的部分
		var paramStr:String = data[2];
		var params:Array<String> = paramStr.split(",");
		return OpCodeManager.instance.translateCustomCode(data[1], words[0], params);
	}
	
}