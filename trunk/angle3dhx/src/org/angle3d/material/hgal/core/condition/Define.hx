package org.angle3d.material.hgal.core.condition;

/**
 * 条件编译中条件
 * @author andy
 */
class Define 
{
	private var operator:Int;
	private var keywords:Array<String>;

	public function new() 
	{
	}
	
	public function parse(source:String):Void
	{
		if (source.indexOf("&") != -1)
		{
			keywords = source.split("&");
			operator = DefineOperator.ADD;
		}
		else if (source.indexOf("|") != -1)
		{
			keywords = source.split("|");
			operator = DefineOperator.OR;
		}
		else
		{
			keywords = [source];
			operator = DefineOperator.NONE;
		}
	}
	
	/**
	 * 是否符合条件
	 * @param	keys
	 * @return
	 */
	public function execute(keys:Array<String>):Bool
	{
		if (operator == DefineOperator.NONE)
		{
			return (untyped keys.indexOf(keywords[0]) > -1);
		}
		else if (operator == DefineOperator.ADD)
		{
			//keys必须包含keywords中所有元素
			for (i in 0...keywords.length)
			{
				if (untyped keys.indexOf(keywords[i]) == -1)
				{
					return false;
				}
			}
			
			return true;
		}
		else //if (operator == DefineOperator.OR)
		{
			//keys只需包含keywords中任意一个元素
			for (i in 0...keywords.length)
			{
				if (untyped keys.indexOf(keywords[i]) > -1)
				{
					return true;
				}
			}
			
			return false;
		}
		
		return false;
	}
	
}