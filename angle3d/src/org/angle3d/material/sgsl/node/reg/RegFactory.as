package org.angle3d.material.sgsl.node.reg
{
	import org.angle3d.material.sgsl.DataType;
	import org.angle3d.material.sgsl.RegType;
	import org.angle3d.utils.Assert;

	public class RegFactory
	{
		public static function create(name:String, regType:String, dataType:String, isArray:Boolean=false, arraySize:int=0):RegNode
		{
			//简单的语法检查
			CF::DEBUG
			{
				if (isArray)
				{
					Assert.assert(arraySize > 0, "数组大小必须大于0");
					Assert.assert(regType == RegType.UNIFORM, "只有Uniform才可以使用数组类型");
					Assert.assert(dataType == DataType.VEC4 || dataType == DataType.MAT3 || dataType == DataType.MAT4, "数组类型只能使用vec4,mat3或者mat4");
				}

//				if (dataType == DataType.MAT3 ||
//					dataType == DataType.MAT4 ||
//					dataType == DataType.SAMPLER2D ||
//					dataType == DataType.SAMPLERCUBE)
//				{
//					Assert.assert(regType == RegType.UNIFORM,
//						"mat3,mat4,sampler2D,samplerCube数据类型只能在Uniform中使用");
//				}

				if (regType == RegType.VARYING)
				{
					Assert.assert(dataType == DataType.VEC4, "Varying只能使用vec4数据类型");
				}

				if (regType == RegType.OUTPUT)
				{
					Assert.assert(false, "output不需要定义");
				}
			}

			switch (regType)
			{
				case RegType.ATTRIBUTE:
					return new AttributeReg(dataType, name);
				case RegType.TEMP:
					return new TempReg(dataType, name);
				case RegType.UNIFORM:
					if (dataType == DataType.SAMPLER2D || dataType == DataType.SAMPLERCUBE)
					{
						return new TextureReg(dataType, name);
					}
					else
					{
						return new UniformReg(dataType, name, isArray, arraySize);
					}
				case RegType.VARYING:
					return new VaryingReg(dataType, name);
			}

			CF::DEBUG
			{
				Assert.assert(false, regType + "不是已知类型");
			}

			return null;
		}
	}
}

