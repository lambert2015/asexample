package org.angle3d.material.sgsl
{
	import org.angle3d.utils.Assert;

	public class DataType
	{
		public static const FLOAT : String = "float";
		public static const VEC2 : String = "vec2";
		public static const VEC3 : String = "vec3";
		public static const VEC4 : String = "vec4";
		public static const MAT3 : String = "mat3";
		public static const MAT4 : String = "mat4";
		public static const SAMPLER2D : String = "sampler2D";
		public static const SAMPLERCUBE : String = "samplerCube";

//		public static const SAMPLER3D : String = "sampler3D";

		/**
		 * 类型是否是矩阵
		 * @param	type
		 * @return
		 */
		public static function isMat(dataType : String) : Boolean
		{
			return dataType == MAT3 || dataType == MAT4;
		}

		/**
		 * 需要偏移
		 * @param	type
		 * @return
		 */
		public static function isNeedOffset(dataType : String) : Boolean
		{
			return dataType == FLOAT || dataType == VEC2 || dataType == VEC3;
		}

		public static function getSize(dataType : String) : int
		{
			switch (dataType)
			{
				case DataType.FLOAT:
					return 1;
				case DataType.VEC2:
					return 2;
				case DataType.VEC3:
					return 3;
				case DataType.VEC4:
					return 4;
				case DataType.MAT3:
					return 12;
				case DataType.MAT4:
					return 16;
				case DataType.SAMPLER2D:
				case DataType.SAMPLERCUBE:
					return 0;
			}
			CF::DEBUG
			{
				Assert.assert(false, dataType + "是未知类型");
			}
			return -1;
		}

		/**
		 * 获取其占用寄存器数量
		 * @param	varType
		 * @return
		 */
		public static function getRegisterCount(dataType : String) : int
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

