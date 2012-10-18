package org.angle3d.material.hgal.core.condition;
import org.angle3d.utils.StringUtil;

/**
 * 条件编译
 * 支持if,elseif,else,end
 * @author andy
 */

class ConditionalCompilation 
{
	private var _curCondition:Condition;
	private var _define:Define;
	
	public function new() 
	{
		_define = new Define();
	}

	public function parse(list:Array<String>, keys:Array<String>):Array<String>
	{
		if (keys == null)
		{
			keys = [];
		}
		
		var result:Array<String> = [];
		
		_curCondition = null;

		for (i in 0...list.length)
		{
			var line:String = list[i];
			
			//条件
			if (line.charAt(0) == "#")
			{
				var arr:Array<String> = StringUtil.trim(line).split(" ");
				
				var name:String = arr[0].toLowerCase();
	
				if (name == "#if")
				{
					_define.parse(arr[1]);
					
					var newCondition = new Condition();
					newCondition.type = ConditionType.IF_TYPE;
					newCondition.parent = _curCondition;
					newCondition.match = _define.execute(keys);
					_curCondition = newCondition;
				}
				else if (name == "#elseif")
				{
					_define.parse(arr[1]);
					
					_curCondition.type = ConditionType.ELSE_IF_TYPE;
					_curCondition.match = _define.execute(keys);
				}
				else if (name == "#else")
				{
					_curCondition.type = ConditionType.ELSE_TYPE;
				}
				else //if (name == "#end")
				{
					_curCondition = _curCondition.parent;
				}
			}
			else if (_curCondition == null || _curCondition.match)
			{
				//没有条件或者符合条件
				result.push(line);
			}
		}
		return result;
	}
}