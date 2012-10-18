package org.angle3d.manager
{

	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.utils.Dictionary;
	
	import org.angle3d.material.sgsl.OpCodeManager;
	import org.angle3d.material.sgsl.SgslCompiler;
	import org.angle3d.material.sgsl.node.FunctionNode;
	import org.angle3d.material.sgsl.parser.SgslParser;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.utils.Logger;

	/**
	 * 注册和注销Shader管理
	 * @author andy
	 */
	public class ShaderManager
	{
		public static var _instance : ShaderManager;
		
		public static function get instance():ShaderManager
		{
			return _instance;
		}
		
		public static function init(profile:String,context3D:Context3D):void
		{
			_instance = new ShaderManager(profile,context3D);
		}

		private var _shaderMap : Dictionary; //<String,Shader>;
		private var _programMap : Dictionary; //<String,Program3D>;
		private var _shaderRegisterCount : Dictionary; //<String,int>;
		
		private var _context3D:Context3D;
		private var _profile:String;
		
		private var _sgslParser:SgslParser;
		private var _shaderCompiler : SgslCompiler;
		private var _opCodeManager:OpCodeManager;
		
		private var _customFunctionMap : Dictionary;

		public function ShaderManager(profile:String,context3D:Context3D)
		{
			_profile = profile;
			_context3D = context3D;
			
			_shaderMap = new Dictionary();
			_programMap = new Dictionary();
			_shaderRegisterCount = new Dictionary();

			_opCodeManager = new OpCodeManager(_profile);
			_sgslParser = new SgslParser();
			_shaderCompiler = new SgslCompiler(_sgslParser,_opCodeManager);
			
			_initCustomFunctions();
		}
		
		public function getCustomFunctionMap() : Dictionary
		{
			return _customFunctionMap;
		}
		
		/**
		 * 编译自定义函数
		 *
		 * etaRatio2 = etaRatio*etaRatio;
		 * etaRatio3 = 1 - etaRatio2;
		 * function refract(vec3 incident,vec3 normal,vec3 etaRatio)
		 */
		//		function refract(vec3 incident,vec3 normal,float etaRatio,float etaRatio2,float etaRatio3){
		//			float t_dotNI = dot3(normal,incident);
		//			float t_dotNI2 = mul(t_dotNI,t_dotNI);
		//			float t_eta2dot2 = mul(etaRatio2,t_dotNI2);
		//			float t_k = add(etaRatio3,t_eta2dot2);
		//			float t_bool = greaterThanEqual(t_k,0.0);
		//			float t_sqrtk = sqrt(t_k);
		//			float t_tmp = mul(etaRatio,t_dotNI);
		//			t_tmp = add(t_tmp,t_sqrtk);
		//			vec3 t_vec0 = mul(incident,etaRatio);
		//			vec3 t_vec1 = mul(t_tmp,normal);
		//			vec3 t_result = sub(t_vec0,t_vec1);
		//			return mul(t_result,t_bool);  //乘以t_bool就会出现结果不正确，为什么？
		//		}
		//TODO 约束模式有几个函数用不了，需要自己自定义这几个函数
		private function _initCustomFunctions() : void
		{
			_customFunctionMap = new Dictionary();
			
			var source : String = <![CDATA[
				/* common help function */

				/*#ifdef(CONSTRAINED){
				}*/

				function tan(float value){
					float t_sin = sin(value);
					float t_cos = cos(value);
					return divide(t_sin,t_cos);
				}
				
				function greaterThan(float x,float y){
					return lessThan(y,x);
				}
				
				function clamp(float value,float minVal,float maxVal){
					float t_local = max(value,minVal);
					return min(t_local,maxVal);
				}
				function floor(float value){
					float t_local = frc(value);
					return sub(value,t_local);
				}
				function ceil(float value){
					float t_local_frc = frc(value);
					float t_local_int = sub(value,t_local_frc);
					float t_local_2 = lessThan(0.0,t_local_frc);
					return add(t_local_int,t_local_2);
				}
				function round(float value){
					float t_local_frc = frc(value);
					float t_local_int = sub(value,t_local_frc);
					float t_local_2 = greaterEqual(t_local_frc,0.5);
					return add(t_local_int,t_local_2);
				}
				function distance3(vec3 source1,vec3 source2){
					float t_local = dot3(source1,source2);
					return sqrt(t_local);
				}
				function distance4(vec4 source1,vec4 source2){
					float t_local = dot4(source1,source2);
					return sqrt(t_local);
				}
				function length3(vec3 source1){
					float t_local = dot3(source1,source1);
					return sqrt(t_local);
				}
				function length4(vec4 source1){
					float t_local = dot4(source1,source1);
					return sqrt(t_local);
				}
				function mix(float source1,float source2,float percent1,float percent2){
					float t_local1 = mul(source1,percent1);
					float t_local2 = mul(source2,percent2);
					return add(t_local1,t_local2);
				}
				function reflect(vec3 incident,vec3 normal){
					float t_dot = dot3(normal,incident);
					t_dot = mul(t_dot,2.0);
					vec3 t_vec = mul(normal,t_dot);
					return sub(incident,t_vec);
				}
				function refract(vec3 incident,vec3 normal,vec3 etaRatio){
					/** 
					 *	refract
					 */
					float t_dotNI = dot3(normal,incident);
					float t_dotNI2 = mul(t_dotNI,t_dotNI);
					float t_eta2dot2 = mul(etaRatio.y,t_dotNI2);
					float t_k = add(etaRatio.z,t_eta2dot2);
					float t_sqrtk = sqrt(t_k);
					float t_tmp = mul(etaRatio.x,t_dotNI);
					t_tmp = add(t_tmp,t_sqrtk);
					vec3 t_vec0 = mul(incident,etaRatio.x);
					vec3 t_vec1 = mul(t_tmp,normal);
					return sub(t_vec0,t_vec1);
				}
				function sign(float source1){
					float t_local0;
					float t_local1;
					float t_local2;
					float t_local3;
					t_local0 = notEqual(source1,0.0);
					t_local1 = lessThan(source1,0.0);
					t_local1 = negate(t_local1);
					t_local2 = lessThan(0.0,source1);
					t_local3 = add(t_local1,t_local2);
					return mul(t_local0,t_local3);
				}
				function maxDot(vec3 normal,vec3 light,float maxValue){
					float t_local = dot3(normal,light);
					return max(t_local,maxValue);
				}
				function pack(float depth){
				
				}
				function unpack(vec4 color){
				
				}
				]]>;
			
			var functionList : Vector.<FunctionNode> = _sgslParser.execFunctions(source);
			
			var fLength : int = functionList.length;
			for (var i : int = 0; i < fLength; i++)
			{
				functionList[i].renameTempVar();
				_customFunctionMap[functionList[i].name] = functionList[i];
			}
			
			for (i = 0; i < fLength; i++)
			{
				functionList[i].replaceCustomFunction(_customFunctionMap);
			}
		}

		
		public function get opCodeManager():OpCodeManager
		{
			return _opCodeManager;
		}

		public function isRegistered(key : String) : Boolean
		{
			return _shaderMap[key] != undefined;
		}

		public function getShader(key : String) : Shader
		{
			return _shaderMap[key];
		}

		/**
		 * 注册一个Shader
		 * @param	key
		 * @param	sources Array<String>
		 * @param	conditions Array<Array<String>>
		 */
		public function registerShader(key : String, sources : Array, conditions : Vector.<Vector.<String>> = null) : Shader
		{
			var shader : Shader = _shaderMap[key];
			if (shader == null)
			{
				shader = _shaderCompiler.complie(sources, conditions);
				shader.name = key;
				_shaderMap[key] = shader;
			}

			//使用次数+1
			if (_shaderRegisterCount[key] != undefined &&
				!isNaN(_shaderRegisterCount[key]))
			{
				_shaderRegisterCount[key] += 1;
			}
			else
			{
				_shaderRegisterCount[key] = 1;
			}

			CF::DEBUG
			{
				Logger.log("[REGISTER SHADER]" + key + " count:" + _shaderRegisterCount[key]);
			}

			return shader;
		}

		/**
		 * 注销一个Shader,Shader引用为0时销毁对应的Progame3D
		 * @param	key
		 */
		public function unregisterShader(key : String) : void
		{
			if (_programMap[key] == undefined)
			{
				return;
			}

			var registerCount : int = _shaderRegisterCount[key];
			if (registerCount == 1)
			{
				delete _shaderMap[key];
				delete _shaderRegisterCount[key];

				var program : Program3D = _programMap[key];
				if (program != null)
				{
					program.dispose();
				}
				delete _programMap[key];
			}
			else
			{
				_shaderRegisterCount[key] = registerCount - 1;

				CF::DEBUG
				{
					Logger.log("[UNREGISTER SHADER]" + key + " count:" + _shaderRegisterCount[key]);
				}
			}
		}

		public function getProgram(key : String) : Program3D
		{
			if (_programMap[key] == undefined)
			{
				var shader : Shader = _shaderMap[key];
				if (shader == null)
				{
					return null;
				}

				var program : Program3D = _context3D.createProgram();
				program.upload(shader.vertexData, shader.fragmentData);
				_programMap[key] = program;
			}
			return _programMap[key];
		}
	}
}
