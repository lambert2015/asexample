﻿package org.angle3d.material.sgsl.node;

import flash.utils.Dictionary;

class LeafNode
{
	public var type:Int;
	public var name:String;

	public function new(name:String = "")
	{
		this.name = name;
	}

	public function renameLeafNode(map:Dictionary):Void
	{
		if (map[this.name] != undefined)
		{
			this.name = map[this.name];
		}
	}

	public function replaceLeafNode(paramMap:Dictionary):Void
	{

	}

	public function clone():LeafNode
	{
		return new LeafNode(name);
	}

	public function toString(level:Int = 0):String
	{
		return name;
	}

	private function getSpace(level:Int):String
	{
		var space:String = "";
		for (i in 0...level)
			space += "   ";
		return space;
	}
}


