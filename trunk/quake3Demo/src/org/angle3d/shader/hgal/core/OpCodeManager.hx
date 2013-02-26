package org.angle3d.shader.hgal.core;
import flash.Vector;
import org.angle3d.utils.Assert;
import org.angle3d.utils.HashMap;
/**
 * mov	0x00	move	move data from source1 to destination, componentwise
 * add	0x01	add	destination = source1 + source2, componentwise
 * sub	0x02	subtract	destination = source1 - source2, componentwise
 * mul	0x03	multiply	destination = source1 * source2, componentwise
 * div	0x04	divide	destination = source1 / source2, componentwise
 * rcp	0x05	reciprocal	destination = 1/source1, componentwise
 * min	0x06	minimum	destination = minimum(source1,source2), componentwise
 * max	0x07	maximum	destination = maximum(source1,source2), componentwise
 * frc	0x08	fractional	destination = source1 - (float)floor(source1), componentwise
 * sqt	0x09	square root	destination = sqrt(source1), componentwise
 * rsq	0x0a	reciprocal root	destination = 1/sqrt(source1), componentwise
 * pow	0x0b	power	destination = pow(source1,source2), componentwise
 * log	0x0c	logarithm	destination = log_2(source1), componentwise
 * exp	0x0d	exponential	destination = 2^source1, componentwise
 * nrm	0x0e	normalize	destination = normalize(source1), componentwise (produces only a 3 component result, destination must be masked to .xyz or less)
 * sin	0x0f	sine	destination = sin(source1), componentwise
 * cos	0x10	cosine	destination = cos(source1), componentwise
 * crs	0x11	cross product	
 *                            destination.x = source1.y * source2.z - source1.z * source2.y
 *                            destination.y = source1.z * source2.x - source1.x * source2.z
 *                            destination.z = source1.x * source2.y - source1.y * source2.x  
 *                            (produces only a 3 component result, destination must be masked to .xyz or less)
 * dp3	0x12	dot product	destination = source1.x*source2.x + source1.y*source2.y + source1.z*source2.z
 * dp4	0x13	dot product	destination = source1.x*source2.x + source1.y*source2.y + source1.z*source2.z + source1.w*source2.w
 * abs	0x14	absolute	destination = abs(source1), componentwise
 * neg	0x15	negate	destination = -source1, componentwise
 * sat	0x16	saturate	destination = maximum(minimum(source1,1),0), componentwise
 * m33	0x17	multiply matrix 3x3	
 *                            destination.x = (source1.x * source2[0].x) + (source1.y * source2[0].y) + (source1.z * source2[0].z)
 *                            destination.y = (source1.x * source2[1].x) + (source1.y * source2[1].y) + (source1.z * source2[1].z)
 *                            destination.z = (source1.x * source2[2].x) + (source1.y * source2[2].y) + (source1.z * source2[2].z)   
 *                            (produces only a 3 component result, destination must be masked to .xyz or less)
 * m44	0x18	multiply matrix 4x4	
 *                            destination.x = (source1.x * source2[0].x) + (source1.y * source2[0].y) + (source1.z * source2[0].z) + (source1.w * source2[0].w)
 *                            destination.y = (source1.x * source2[1].x) + (source1.y * source2[1].y) + (source1.z * source2[1].z) + (source1.w * source2[1].w)
 *                            destination.z = (source1.x * source2[2].x) + (source1.y * source2[2].y) + (source1.z * source2[2].z) + (source1.w * source2[2].w)
 *                            destination.w = (source1.x * source2[3].x) + (source1.y * source2[3].y) + (source1.z * source2[3].z) + (source1.w * source2[3].w)
     
 * m34	0x19	multiply matrix 3x4	
 *                            destination.x = (source1.x * source2[0].x) + (source1.y * source2[0].y) + (source1.z * source2[0].z) + (source1.w * source2[0].w)
 *                            destination.y = (source1.x * source2[1].x) + (source1.y * source2[1].y) + (source1.z * source2[1].z) + (source1.w * source2[1].w)
 *                            destination.z = (source1.x * source2[2].x) + (source1.y * source2[2].y) + (source1.z * source2[2].z) + (source1.w * source2[2].w) 
 *                            (produces only a 3 component result, destination must be masked to .xyz or less)
 * kil	0x27	kill/discard (fragment shader only)	If single scalar source component is less than zero, fragment is discarded and not drawn to the frame buffer. (Destination register must be set to all 0)
 * tex	0x28	texture sample (fragment shader only)	destination equals load from texture source2 at coordinates source1. In this case, source2 must be in sampler format.
 * sge	0x29	set-if-greater-equal	destination = source1 >= source2 ? 1 : 0, componentwise
 * slt	0x2a	set-if-less-than	destination = source1 < source2 ? 1 : 0, componentwise
 * seq	0x2c	set-if-equal	destination = source1 == source2 ? 1 : 0, componentwise
 * sne	0x2d	set-if-not-equal	destination = source1 != source2 ? 1 : 0, componentwise
 */
class OpCodeManager 
{
	public static inline var OP_SCALAR:UInt = 0x1;
	public static inline var OP_INC_NEST:UInt = 0x2;
	public static inline var OP_DEC_NEST:UInt = 0x4;
	public static inline var OP_SPECIAL_TEX:UInt = 0x8;
	public static inline var OP_SPECIAL_MATRIX:UInt = 0x10;
	public static inline var OP_FRAG_ONLY:UInt = 0x20;
	public static inline var OP_VERT_ONLY:UInt = 0x40;
	public static inline var OP_NO_DEST:UInt = 0x80;
		
	private static var COUNT:Int = 0;
	
	private static var _instance:OpCodeManager;
	
	public static function getInstance():OpCodeManager
	{
		if (_instance == null)
		{
			_instance = new OpCodeManager();
		}
		return _instance;
	}
	
	private var _opCodeMap:HashMap<String,OpCode>;
	
	private var _customCodeMap:HashMap<String,CustomOpCode>;
	private var _customFuncMap:HashMap<String,String->Array<String>->Array<Array<String>>>;

	public function new() 
	{
		_opCodeMap = new HashMap<String,OpCode>();
		
		_customCodeMap = new HashMap<String,CustomOpCode>();
		_customFuncMap = new HashMap<String,String->Array<String>->Array<Array<String>>>();
		
		_initCodes();
	}
	
	private function _initCodes():Void
	{
		addCode("mov", 2, 0x00, 0);
		addCode("add", 3, 0x01, 0);
		addCode("sub", 3, 0x02, 0, ["subtract"]);
		addCode("mul", 3, 0x03, 0, ["multiply"]);
		addCode("div", 3, 0x04, 0, ["divide"]);
		addCode("rcp", 2, 0x05, 0, ["reciprocal"]);
		addCode("min", 3, 0x06, 0);
		addCode("max", 3, 0x07, 0);
		addCode("frc", 2, 0x08, 0, ["fract"]);
		addCode("sqt", 2, 0x09, 0, ["sqrt"]);
		addCode("rsq", 2, 0x0a, 0, ["invSqrt"]);
		addCode("pow", 3, 0x0b, 0);
		addCode("log", 2, 0x0c, 0);
		addCode("exp", 2, 0x0d, 0);
		addCode("nrm", 2, 0x0e, 0, ["normalize"]);
		addCode("sin", 2, 0x0f, 0);
		addCode("cos", 2, 0x10, 0);
		addCode("crs", 3, 0x11, 0, ["cross", "crossProduct"]);
		
		addCode("dp3", 3, 0x12, 0, ["dot3", "dotProduct3"]);
		addCode("dp4", 3, 0x13, 0, ["dot4", "dotProduct4"]);
		
		addCode("abs", 2, 0x14, 0);
		addCode("neg", 2, 0x15, 0, ["negate"]);
		addCode("sat", 2, 0x16, 0, ["saturate"]);
		
		addCode("m33", 3, 0x17, OP_SPECIAL_MATRIX);
		addCode("m44", 3, 0x18, OP_SPECIAL_MATRIX);
		addCode("m34", 3, 0x19, OP_SPECIAL_MATRIX);
		
		//not available in agal version 1
		//addCode("ifz", 1, 0x1a, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
		//addCode("inz", 1, 0x1b, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
		//addCode("ife", 2, 0x1c, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
		//addCode("ine", 2, 0x1d, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
		//addCode("ifg", 2, 0x1e, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
		//addCode("ifl", 2, 0x1f, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
		//addCode("ieg", 2, 0x20, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
		//addCode("iel", 2, 0x21, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
		//addCode("els", 0, 0x22, OP_NO_DEST | OP_INC_NEST | OP_DEC_NEST);
		//addCode("elf", 0, 0x23, OP_NO_DEST | OP_DEC_NEST);
		//addCode("rep", 1, 0x24, OP_NO_DEST | OP_INC_NEST | OP_SCALAR);
		//addCode("erp", 0, 0x25, OP_NO_DEST | OP_DEC_NEST);
		//addCode("brk", 0, 0x26, OP_NO_DEST);
		
		
		addCode("kil", 1, 0x27, OP_NO_DEST | OP_FRAG_ONLY, ["kill", "discard"]);
		addCode("tex", 3, 0x28, OP_FRAG_ONLY | OP_SPECIAL_TEX, ["texture"]);
		
		addCode("sge", 3, 0x29, 0, ["greaterEqual", "step"]);
		addCode("slt", 3, 0x2a, 0, ["lessThan"]);
		
		//not available in agal version 1
		//addCode("sgn", 2, 0x2b, 0);
		
		addCode("seq", 3, 0x2c, 0, ["equal"]);
		addCode("sne", 3, 0x2d, 0, ["notEqual"]);
		
		addCustomCode("clamp", 4, _custom_clamp);
		addCustomCode("floor", 2, _custom_floor);
		addCustomCode("ceil", 2, _custom_ceil);
		addCustomCode("round", 2, _custom_round);
		addCustomCode("distance3", 3, _custom_distance3);
		addCustomCode("distance4", 3, _custom_distance4);
		addCustomCode("length3", 2, _custom_length3);
		addCustomCode("length4", 2, _custom_length4);
		addCustomCode("mix", 5, _custom_mix);
		addCustomCode("mix3", 5, _custom_mix3);
		addCustomCode("mix4", 5, _custom_mix4);
		addCustomCode("reflect", 3, _custom_reflect);
		addCustomCode("lessThanEqual", 3, _custom_lessThanEqual);
		addCustomCode("sign", 2, _custom_sign);
		addCustomCode("maxDot", 4, _custom_maxDot);
		addCustomCode("computeDiffuse", 3, _custom_computeDiffuse);
		addCustomCode("computeSpecular", 5, _custom_computeSpecular);
	}
	
	/**
	 * 添加原生函数
	 * @param	name  原名
	 * @param	nicknames 别名列表
	 */
	private inline function addCode(name:String, numRegister : UInt, emitCode : UInt, flags : UInt, nicknames:Array<String> = null):Void
	{
		var code:OpCode = new OpCode(name, numRegister, emitCode, flags, nicknames);

		_opCodeMap.setValue(name, code);
		
		//昵称也对应同一个code
		if (nicknames != null)
		{
			for (i in 0...nicknames.length)
			{
				_opCodeMap.setValue(nicknames[i], code);
			}
		}
	}
	
	public inline function getCode(name:String):OpCode
	{
		var code:OpCode = _opCodeMap.getValue(name);
		
		#if debug
		Assert.assert(code != null, name + "操作符未找到，请检查脚本");
		#end
		
		return code;
	}
	
	/**
	 * 是否是自定义OpCode
	 * @param	name
	 * @return
	 */
	public inline function isCustomCode(name:String):Bool
	{
		return _customCodeMap.containsKey(name);
	}
	
	public inline function containCode(name:String):Bool
	{
		return _opCodeMap.containsKey(name);
	}
	
	/**
	 * 添加自定义操作符
	 * @param	name 操作符名字
	 * @param	numRegister 参数数量，包含赋值对象
	 * @param	source 根据操作符返回的语句
	 */
	public function addCustomCode(name:String,numRegister:UInt,func:String->Array<String>->Array<Array<String>>):Void
	{
		Assert.assert(!_customCodeMap.containsKey(name), "Already contain the custom code name");
		
		_customCodeMap.setValue(name, new CustomOpCode(name, numRegister));
		_customFuncMap.setValue(name, func);
	}
	
	/**
	 * 翻译自定义opCode
	 * @param	name opCode name
	 * @param	target 赋值对象
	 * @param	params 参数列表
	 * @return 数组分为两个部分，第一部分是定义的临时变量列表，第二部分是生成的语句列表
	 */
	public function translateCustomCode(name:String, target:String, params:Array<String>):Array<Array<String>>
	{
		var func = _customFuncMap.getValue(name);
		
		Assert.assert(func != null, "Can not find the custom opcode" + name);
		if (func != null)
		{
			return func(target, params);
		}
		
		return null;
	}
	
	//自定义函数代码中不能包括自定义函数
	
	/**
	 * 一个自定义方法clamp(x,minVal,maxVal)
	 * 这句话t_color.x = clamp(t_tex.x,0.0,1.0)翻译后应该为
	 * temp float t_clamp_result;//临时变量定义
	 * t_clamp_result = max(x,minVal)
	 * t_clamp_result = min(t_clamp_result,maxVal)
	 * t_color.x = t_clamp_result
	 */
	
    /**
	 * lessThanEqual(x,y) 
	 * if(x<=y) ? 1 : 0;
	 * @param	params
	 * @return
	 */
	private function _custom_lessThanEqual(target:String,params:Array<String>):Array<Array<String>>
	{
		var t0:String = _createTempVar("t_lessThanEqual_lessThan");
		var t1:String = _createTempVar("t_lessThanEqual_equal");
		
		var code:Array<String> = [_createSource(t0, "lessThan", [params[0],params[1]]), 
		                          _createSource(t1, "equal", [params[0], params[1]]),
								  _createSource(target, "add", [t0, t1])];   
			   
	    return [[_getTempDef(VarType.TYPE_FLOAT, t0),
		         _getTempDef(VarType.TYPE_FLOAT, t1)], 
				code];
	}
	
	/**
	 * clamp(value,minVal,maxVal)
	 * @param	params
	 * @return
	 */
	private function _custom_clamp(target:String,params:Array<String>):Array<Array<String>>
	{
		var t0:String = _createTempVar("t_clamp_local");
		
		var code:Array<String> = [_createSource(t0, "max", [params[0],params[1]]), 
		                          _createSource(target, "min", [t0, params[2]])];   
			   
	    return [[_getTempDef(VarType.TYPE_FLOAT, t0)], code];
	}
	
	/**
	 * floor(value)
	 * @param	params
	 * @return
	 */
	private function _custom_floor(target:String,params:Array<String>):Array<Array<String>>
	{
		var t0:String = _createTempVar("t_floor_local");
		
		var code:Array<String> = [_createSource(t0, "frc", [params[0]]), 
		                          _createSource(target, "sub", [params[0], t0])];   
			   
	    return [[_getTempDef(VarType.TYPE_FLOAT, t0)], 
		        code];		
	}
	
	/**
	 * ceil(value)
	 * @param	params
	 * @return
	 */
	private function _custom_ceil(target:String,params:Array<String>):Array<Array<String>>
	{
		var t0:String = _createTempVar("t_ceil_local_frc");
		var t1:String = _createTempVar("t_ceil_local_int");
		var t2:String = _createTempVar("t_ceil_local_2");
		
		var code:Array<String> = [_createSource(t0, "frc", [params[0]]),  //余数部分
		                          _createSource(t1, "sub", [params[0], t0]), //整数部分
						          _createSource(t2, "lessThan", ["0.0",t0]), //t_ceil_local_frc > 0时加1
		                          _createSource(target, "add", [t1, t2])]; 

	    return [[_getTempDef(VarType.TYPE_FLOAT, t0), 
		         _getTempDef(VarType.TYPE_FLOAT, t1), 
		         _getTempDef(VarType.TYPE_FLOAT, t2)],
				code];	
	}
	
	/**
	 * round(value)
	 * @param	params
	 * @return
	 */
	private function _custom_round(target:String,params:Array<String>):Array<Array<String>>
	{
		var t0:String = _createTempVar("t_round_local_frc");
		var t1:String = _createTempVar("t_round_local_int");
		var t2:String = _createTempVar("t_round_local_2");
		
		var code:Array<String> = [_createSource(t0, "frc", [params[0]]),
		                          _createSource(t1, "sub", [params[0], t0]),
						          _createSource(t2, "greaterEqual", [t0, "0.5"]),
		                          _createSource(target, "add", [t1, t2])]; 

	    return [[_getTempDef(VarType.TYPE_FLOAT, t0),
		        _getTempDef(VarType.TYPE_FLOAT, t1),
		        _getTempDef(VarType.TYPE_FLOAT, t2)],
				code];	
	}
	
	/**
	 * distance3(source1,source2)
	 * @param	params
	 * @return
	 */
	private function _custom_distance3(target:String,params:Array<String>):Array<Array<String>>
	{
		var t0:String = _createTempVar("t_distance3_local");
		
		var code:Array<String> = [_createSource(t0, "dot3", [params[0], params[1]]),
		                          _createSource(target, "sqrt", [t0])];   
			   
	    return [[_getTempDef(VarType.TYPE_FLOAT, t0)], 
		code];	
	}
	
	/**
	 * distance4(source1,source2)
	 * @param	params
	 * @return
	 */
	private function _custom_distance4(target:String,params:Array<String>):Array<Array<String>>
	{
		var t0:String = _createTempVar("t_distance4_local");
		
	    var code:Array<String> = [_createSource(t0, "dot4", [params[0], params[1]]),
		                          _createSource(target, "sqrt", [t0])];
 
	    return [[_getTempDef(VarType.TYPE_FLOAT, t0)], 
		        code];	
	}
	
	
	/**
	 * length3(source1)
	 * @param	params
	 * @return
	 */
	private function _custom_length3(target:String,params:Array<String>):Array<Array<String>>
	{
		var t0:String = _createTempVar("t_length3_local");
		
		var code:Array<String> = [_createSource(t0, "dot3", [params[0], params[0]]),
		                          _createSource(target, "sqrt", [t0])];   
			   
	    return [[_getTempDef(VarType.TYPE_FLOAT, t0)], 
		        code];	
	}
	
	/**
	 * length4(source1)
	 * @param	params
	 * @return
	 */
	private function _custom_length4(target:String,params:Array<String>):Array<Array<String>>
	{
		var t0:String = _createTempVar("t_length4_local");
		
		var code:Array<String> = [_createSource(t0, "dot4", [params[0], params[0]]),
		                  _createSource(target, "sqrt", [t0])];   
			   
	    return [[_getTempDef(VarType.TYPE_FLOAT, t0)], 
		        code];	
	}
	
	
	/**
	 *  x * a + y * b
	 * mix(x,y,a,b)
	 * @param	params
	 * @return
	 */
	private function _custom_mix(target:String,params:Array<String>):Array<Array<String>>
	{
		var tx:String = _createTempVar("t_mix_x");
		var ty:String = _createTempVar("t_mix_y");
		
		var code:Array<String> = [_createSource(tx, "mul", [params[0], params[2]]),
						          _createSource(ty, "mul", [params[1], params[3]]),
						          _createSource(target, "add", [tx, ty])];
			   
	    return [[_getTempDef(VarType.TYPE_FLOAT, tx),
		         _getTempDef(VarType.TYPE_FLOAT, ty)], 
				code];	
	}
	
	/**
	 *  x * a + y * b
	 * mix3(x,y,a,b)
	 * @param	params
	 * @return
	 */
	private function _custom_mix3(target:String,params:Array<String>):Array<Array<String>>
	{
		var tx:String = _createTempVar("t_mix3_x");
		var ty:String = _createTempVar("t_mix3_y");
		
		var code:Array<String> = [_createSource(tx, "mul", [params[0], params[2]]),
						          _createSource(ty, "mul", [params[1], params[3]]),
						          _createSource(target, "add", [tx, ty])];
			   
	    return [[_getTempDef(VarType.TYPE_VEC3, tx),
		         _getTempDef(VarType.TYPE_VEC3, ty)], 
				code];	
	}
	
	/**
	 *  x * a + y * b
	 * mix3(x,y,a,b)
	 * @param	params
	 * @return
	 */
	private function _custom_mix4(target:String,params:Array<String>):Array<Array<String>>
	{
		var tx:String = _createTempVar("t_mix4_x");
		var ty:String = _createTempVar("t_mix4_y");
		
		var code:Array<String> = [_createSource(tx, "mul", [params[0], params[2]]),
						          _createSource(ty, "mul", [params[1], params[3]]),
						          _createSource(target, "add", [tx, ty])];
			   
	    return [[_getTempDef(VarType.TYPE_VEC4, tx),
		         _getTempDef(VarType.TYPE_VEC4, ty)], 
				code];	
	}
	
	/**
	 * For a given incident vector I and surface normal N reflect 
	 * returns the reflection direction calculated as I - 2.0 * dot(N, I) * N.
	 * N should be normalized in order to achieve the desired result.
	 * reflect(I,N)
	 * @param	params
	 * @return
	 */
	//TODO 这个是否正确
	private function _custom_reflect(target:String,params:Array<String>):Array<Array<String>>
	{
		var t_dot:String = _createTempVar("t_reflect_dot");
		var t_vector:String = _createTempVar("t_reflect_vector");
		
		var code:Array<String> = [_createSource(t_dot, "dot3", [params[0], params[1]]),
		                  _createSource(t_dot, "mul", [t_dot, "2"]),
						  _createSource(t_vector, "mul", [params[1], t_dot]),
						  _createSource(target, "sub", [params[0], t_vector])];
			   
	    return [[_getTempDef(VarType.TYPE_FLOAT,t_dot),
		         _getTempDef(VarType.TYPE_VEC3,t_vector)], 
		        code];	
	}
	
	/**
	 * sign(vec.x)
	 * vec.x > 0,return 1
	 * vec.x = 0,return 0
	 * vec.x < 0,return -1
	 * 
	 * @param	target
	 * @param	params
	 * @return
	 */
	private function _custom_sign(target:String,params:Array<String>):Array<Array<String>>
	{
		var t_v0:String = _createTempVar("t_sign_v0");
		var t_v1:String = _createTempVar("t_sign_v1");
		var t_v2:String = _createTempVar("t_sign_v2");
		var t_v3:String = _createTempVar("t_sign_v3");
		
		/**
		 * t_v0如果为0，结果为0
		 * 
		 */
		var code:Array<String> = [_createSource(t_v0, "notEqual", [params[0], "0.0"]),
		                  _createSource(t_v1, "lessThan", [params[0], "0.0"]),
						  _createSource(t_v1, "negate", [t_v1]),
						  _createSource(t_v2, "lessThan", ["0.0", params[0]]),
                          _createSource(t_v3, "add", [t_v1,t_v2]),
		                  _createSource(target, "mul", [t_v0, t_v3])];
			   
	    return [[_getTempDef(VarType.TYPE_FLOAT, t_v0),
		         _getTempDef(VarType.TYPE_FLOAT, t_v1),
				 _getTempDef(VarType.TYPE_FLOAT, t_v2),
		         _getTempDef(VarType.TYPE_FLOAT, t_v3)], 
		        code];	
	}
	
	/**
	 * maxDot(Vec3,Vec3,float):void
	 * target = max(dot(N,L),0)
	 * @param	target
	 * @param	params
	 * @return
	 */
	private function _custom_maxDot(target:String,params:Array<String>):Array<Array<String>>
	{
		var t0:String = _createTempVar("t_maxDot_0");
		
		var code:Array<String> = [_createSource(t0, "dot3", [params[0], params[1]]),
		                          _createSource(target, "max", [t0, params[2]])];
			   
	    return [[_getTempDef(VarType.TYPE_FLOAT, t0)], 
		        code];	
	}
	
	/**
	 * computeDiffuse(Vec3 lightdir,vec3 norm):Float
	 * @param	target float
	 * @param	params [Vec3,Vec3]
	 * @return 
	 */
	private function _custom_computeDiffuse(target:String,params:Array<String>):Array<Array<String>>
	{
		var tDot:String = _createTempVar("t_computeDiffuse_dot");

		var code:Array<String> = [_createSource(tDot, "dot3", [params[0], params[1]]),
		                          _createSource(target, "max", [tDot, "0.0"])];
			   
	    return [[_getTempDef(VarType.TYPE_FLOAT, tDot)], 
		        code];
	}
	
	/**
	 * ComputeSpecular(vec3 norm,vec3 viewdir,vec3 lightdir,float shiny):float
	 * @param	target float
	 * @param	params [Vec3,Vec3,Vec3,float]
	 * @return 
	 */
	private function _custom_computeSpecular(target:String,params:Array<String>):Array<Array<String>>
	{
		var tH:String = _createTempVar("t_computeSpecular_h");
		var tDot:String = _createTempVar("t_computeSpecular_dot");
		var tMax:String = _createTempVar("t_computeSpecular_max");

		var code:Array<String> = [_createSource(tH, "add", [params[1], params[2]]),
		                          _createSource(tH, "mul", [tH, "0.5"]),
		                          _createSource(tDot, "dot3", [tH, params[0]]),
		                          _createSource(tMax, "max", [tDot, "0.0"]),
								  _createSource(target, "pow", [tMax, params[3]])];
			   
	    return [[_getTempDef(VarType.TYPE_VEC3, tH),
		         _getTempDef(VarType.TYPE_FLOAT, tDot),
		         _getTempDef(VarType.TYPE_FLOAT, tMax)], 
		        code];
	}
	
	
	//避免多次调用同一个自定义函数出现临时变量重名的问题
	private inline function _createTempVar(name:String):String
	{
		return name + "_opcodeTmpVar_" + (COUNT++);
	}
	
	private inline function _getTempDef(type:String, name:String):String
	{
		return "temp " + type + " " + name + "\n";
	}
	
	private inline function _createSource(target:String,code:String,params:Array<String>):String
	{
		return target + "=" + code + "(" + params.join(",") + ")\n";
	}

}