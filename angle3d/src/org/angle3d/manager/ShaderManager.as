package org.angle3d.manager
{

	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.angle3d.material.sgsl.OpCodeManager;
	import org.angle3d.material.sgsl.SgslCompiler;
	import org.angle3d.material.sgsl.node.FunctionNode;
	import org.angle3d.material.sgsl.parser.SgslParser;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderProfile;
	import org.angle3d.utils.Logger;

	/**
	 * 注册和注销Shader管理
	 * @author andy
	 */
	public class ShaderManager
	{
		public static var _instance:ShaderManager;

		public static function get instance():ShaderManager
		{
			return _instance;
		}

		public static function init(context3D:Context3D, profile:String):void
		{
			_instance = new ShaderManager(context3D, profile);
		}

		private var mShaderMap:Dictionary; //<String,Shader>;
		private var mProgramMap:Dictionary; //<String,Program3D>;
		private var mShaderRegisterCount:Dictionary; //<String,int>;

		private var mContext3D:Context3D;
		private var mProfile:String;

		private var mSgslParser:SgslParser;
		private var mShaderCompiler:SgslCompiler;
		private var mOpCodeManager:OpCodeManager;

		private var mCustomFunctionMap:Dictionary;

		public function ShaderManager(context3D:Context3D, profile:String)
		{
			mContext3D = context3D;
			mProfile = profile;

			mShaderMap = new Dictionary();
			mProgramMap = new Dictionary();
			mShaderRegisterCount = new Dictionary();

			mOpCodeManager = new OpCodeManager(mProfile);
			mSgslParser = new SgslParser();
			mShaderCompiler = new SgslCompiler(mProfile, mSgslParser, mOpCodeManager);

			_initCustomFunctions();
		}

		public function getCustomFunctionMap():Dictionary
		{
			return mCustomFunctionMap;
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
		[Embed(source = "customOpCode.txt", mimeType = "application/octet-stream")]
		private static var CustomOpCodeAsset:Class;

		private function _initCustomFunctions():void
		{
			mCustomFunctionMap = new Dictionary();

			var ba:ByteArray = new CustomOpCodeAsset();
			var source:String = ba.readUTFBytes(ba.length);


			var defines:Vector.<String> = new Vector.<String>();
			if (mProfile == ShaderProfile.BASELINE_EXTENDED)
			{
				defines.push(ShaderProfile.BASELINE);
				defines.push(ShaderProfile.BASELINE_EXTENDED);
			}
			else if (mProfile == ShaderProfile.BASELINE)
			{
				defines.push(ShaderProfile.BASELINE);
			}
			else if (mProfile == ShaderProfile.BASELINE_CONSTRAINED)
			{
				defines.push(ShaderProfile.BASELINE_CONSTRAINED);
			}

			var functionList:Vector.<FunctionNode> = mSgslParser.execFunctions(source, defines);

			var fLength:int = functionList.length;
			for (var i:int = 0; i < fLength; i++)
			{
				functionList[i].renameTempVar();
				mCustomFunctionMap[functionList[i].name] = functionList[i];
			}

			for (i = 0; i < fLength; i++)
			{
				functionList[i].replaceCustomFunction(mCustomFunctionMap);
			}
		}


		public function get opCodeManager():OpCodeManager
		{
			return mOpCodeManager;
		}

		public function isRegistered(key:String):Boolean
		{
			return mShaderMap[key] != undefined;
		}

		public function getShader(key:String):Shader
		{
			return mShaderMap[key];
		}

		/**
		 * 注册一个Shader
		 * @param	key
		 * @param	sources Array<String>
		 * @param	conditions Array<Array<String>>
		 */
		public function registerShader(key:String, sources:Array, conditions:Vector.<Vector.<String>> = null):Shader
		{
			var shader:Shader = mShaderMap[key];
			if (shader == null)
			{
				shader = mShaderCompiler.complie(sources, conditions);
				shader.name = key;
				mShaderMap[key] = shader;
			}

			//使用次数+1
			if (mShaderRegisterCount[key] != undefined && !isNaN(mShaderRegisterCount[key]))
			{
				mShaderRegisterCount[key] += 1;
			}
			else
			{
				mShaderRegisterCount[key] = 1;
			}

			CF::DEBUG
			{
				Logger.log("[REGISTER SHADER]" + key + " count:" + mShaderRegisterCount[key]);
			}

			return shader;
		}

		/**
		 * 注销一个Shader,Shader引用为0时销毁对应的Progame3D
		 * @param	key
		 */
		public function unregisterShader(key:String):void
		{
			if (mProgramMap[key] == undefined)
			{
				return;
			}

			var registerCount:int = mShaderRegisterCount[key];
			if (registerCount == 1)
			{
				delete mShaderMap[key];
				delete mShaderRegisterCount[key];

				var program:Program3D = mProgramMap[key];
				if (program != null)
				{
					program.dispose();
				}
				delete mProgramMap[key];
			}
			else
			{
				mShaderRegisterCount[key] = registerCount - 1;

				CF::DEBUG
				{
					Logger.log("[UNREGISTER SHADER]" + key + " count:" + mShaderRegisterCount[key]);
				}
			}
		}

		public function getProgram(key:String):Program3D
		{
			if (mProgramMap[key] == undefined)
			{
				var shader:Shader = mShaderMap[key];
				if (shader == null)
				{
					return null;
				}

				var program:Program3D = mContext3D.createProgram();
				program.upload(shader.vertexData, shader.fragmentData);
				mProgramMap[key] = program;
			}
			return mProgramMap[key];
		}
	}
}

