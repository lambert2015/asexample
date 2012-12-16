package org.angle3d.material.sgsl
{
	import flash.utils.Dictionary;
	import org.angle3d.utils.Assert;

	public class DataType
	{
		public static const VOID:String = "void";
		public static const FLOAT:String = "float";
		public static const VEC2:String = "vec2";
		public static const VEC3:String = "vec3";
		public static const VEC4:String = "vec4";
		public static const MAT3:String = "mat3";
		public static const MAT4:String = "mat4";

		public static const SAMPLER2D:String = "sampler2D";
		public static const SAMPLERCUBE:String = "samplerCube";
		public static const SAMPLER3D:String = "sampler3D";

		public static var sizeDic:Dictionary = new Dictionary();
		{
			sizeDic[FLOAT] = 1;
			sizeDic[VEC2] = 2;
			sizeDic[VEC3] = 3;
			sizeDic[VEC4] = 4;
			sizeDic[MAT3] = 12;
			sizeDic[MAT4] = 16;
			sizeDic[SAMPLER2D] = 0;
			sizeDic[SAMPLERCUBE] = 0;
			sizeDic[SAMPLER3D] = 0;
		}

		/**
		 *
		 * @param dataType
		 * @return
		 *
		 */
		public static function isSampler(dataType:String):Boolean
		{
			return dataType == SAMPLER2D || dataType == SAMPLERCUBE || dataType == SAMPLERCUBE;
		}

		/**
		 * 类型是否是矩阵
		 * @param	type
		 * @return
		 */
		public static function isMat(dataType:String):Boolean
		{
			return dataType == MAT3 || dataType == MAT4;
		}

		/**
		 * 需要偏移
		 * @param	type
		 * @return
		 */
		public static function isNeedOffset(dataType:String):Boolean
		{
			return dataType == FLOAT || dataType == VEC2 || dataType == VEC3;
		}

		public static function getSize(dataType:String):int
		{
			CF::DEBUG
			{
				Assert.assert(sizeDic[dataType] != undefined, dataType + "是未知类型");
			}
			return sizeDic[dataType];
		}

		/**
		 * 获取其占用寄存器数量
		 * @param	varType
		 * @return
		 */
		public static function getRegisterCount(dataType:String):int
		{
			switch (dataType)
			{
				case DataType.MAT3:
					return 3;
				case DataType.MAT4:
					return 4;
				default:
					return 1;
			}
		}
	}
}

