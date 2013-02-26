package org.angle3d.shader.hgal.core;

/**
 * 变量类型
 */
class VarType
{
	public static inline var TYPE_FLOAT:String = "float";
	public static inline var TYPE_VEC2:String = "vec2";
	public static inline var TYPE_VEC3:String = "vec3";
	public static inline var TYPE_VEC4:String = "vec4";
	public static inline var TYPE_MAT3:String = "mat3";
	public static inline var TYPE_MAT4:String = "mat4";
	
	public static inline var TYPE_TEXTURE:String = "texture";

	/**
	 * 类型是否是矩阵
	 * @param	type
	 * @return
	 */
	public static function isMat(type:String):Bool
	{
		return type == TYPE_MAT3 || type == TYPE_MAT4;
	}
	
	/**
	 * 需要偏移
	 * @param	type
	 * @return
	 */
	public static function needOffset(type:String):Bool
	{
		return type != TYPE_MAT3 && type != TYPE_MAT4 && type != TYPE_VEC4;
	}
	
	public static function getLength(varType:String):Int
	{
		switch(varType)
		{
			case VarType.TYPE_FLOAT:
				return 1;
			case VarType.TYPE_VEC2:
				return 2;
			case VarType.TYPE_VEC3:
				return 3;
			case VarType.TYPE_VEC4:
				return 4;
			case VarType.TYPE_MAT3:
				return 12;
			case VarType.TYPE_MAT4:
				return 16;
			default:
				return 0;
		}
	}
	
	/**
	 * 获取其占用寄存器数量
	 * @param	varType
	 * @return
	 */
	public static function getRegisterCount(varType:String):Int
	{
		switch(varType)
		{
			case VarType.TYPE_MAT3:
				return 3;
			case VarType.TYPE_MAT4:
				return 4;
			default:
				return 1;
		}
	}
}