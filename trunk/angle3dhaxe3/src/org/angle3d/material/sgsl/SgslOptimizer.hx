﻿package org.angle3d.material.sgsl;

import flash.utils.Dictionary;

import org.angle3d.manager.ShaderManager;
import org.angle3d.material.sgsl.node.agal.AgalNode;
import org.angle3d.material.sgsl.node.BranchNode;
import org.angle3d.material.sgsl.node.FunctionNode;
import org.angle3d.material.sgsl.node.LeafNode;
import org.angle3d.material.sgsl.node.reg.RegNode;

/**
 * 对生成的BranchNode进行处理
 * 具体分为两方面工作
 * 一个是根据条件替换预编译部分
 * 另外一个是替换掉自定义函数
 * @author andy
 *
 */
class SgslOptimizer
{
	public function new()
	{
	}

	/**
	 * 这里主要做几件事情
	 * 1、根据条件编译去掉不需要的代码
	 * 2、替换用户自定义函数
	 * 3、输出SgslData
	 */
	public function exec(data:SgslData, tree:BranchNode, defines:Vector<String>):Void
	{
		var cloneTree:BranchNode = tree; //.clone() as BranchNode;

		//条件过滤
		cloneTree.filter(defines);

		var customFunctionMap:Dictionary = new Dictionary();

		var mainFunction:FunctionNode;

		//保存所有自定义函数
		var children:Vector<LeafNode> = cloneTree.children;
		var cLength:Int = children.length;
		for (i in 0...cLength)
		{
			var child:LeafNode = children[i];
			if (Std.is(child,FunctionNode))
			{
				if (child.name == "main")
				{
					mainFunction = cast child;
				}
				else
				{
					if (customFunctionMap[child.name] != undefined)
					{
						throw new Error("自定义函数" + child.name + "定义重复");
					}
					customFunctionMap[child.name] = child;
				}
			}
			else
			{
				data.addReg(cast child);
			}
		}

		//复制系统自定义函数到字典中
		var systemMap:Dictionary = ShaderManager.instance.getCustomFunctionMap();
		var key:String;
		for (key in systemMap)
		{
			customFunctionMap[key] = systemMap[key];
		}

		//替换main中自定义函数
		mainFunction.replaceCustomFunction(customFunctionMap);

		//找出mainFunction中的RegNode
		children = mainFunction.children;
		cLength = children.length;
		for (i in 0...cLength)
		{
			child = children[i];
			if (Std.is(child, RegNode))
			{
				data.addReg(cast child);
			}
			else
			{
				data.addNode(cast child);
			}
		}

		data.build();

		//删除自定义函数
//			var func : FunctionNode;
//			for each (func in customFunctionMap)
//			{
//				cloneTree.removeChild(func);
//			}
//
//			trace(cloneTree.toString());
//
//			customFunctionMap = null;
//
//			return cloneTree;
	}
}


