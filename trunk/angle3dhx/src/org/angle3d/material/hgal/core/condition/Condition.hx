package org.angle3d.material.hgal.core.condition;
import flash.Vector;

/**
 * ...
 * @author andy
 */

class Condition 
{
	//条件当前类型,IF还是ELSE
	public var type:Int;

	//父条件
	public var parent:Condition;

	private var _match:Bool;
	public var match(__getMatch, __setMatch):Bool;

	public function new() 
	{
		parent = null;
		
		type = ConditionType.IF_TYPE;
		
		_match = false;
	}
	
	private function __getMatch():Bool
	{
		var selfMatch:Bool = false;
		
		if (type == ConditionType.IF_TYPE || type == ConditionType.ELSE_IF_TYPE)
		{
			selfMatch = _match;
		}
		else if (type == ConditionType.ELSE_TYPE)
		{
			selfMatch = !_match;
		}
		
		if (parent == null)
		{
			return selfMatch;
		}
		else
		{
			return parent.match && selfMatch;
		}
	}
	
	private function __setMatch(value:Bool):Bool
	{
		_match = value;
		return value;
	}
	
}