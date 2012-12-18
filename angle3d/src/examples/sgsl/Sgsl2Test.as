package examples.sgsl
{
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;

	import org.angle3d.app.SimpleApplication;
	import org.angle3d.manager.ShaderManager;
	import org.angle3d.material.shader.Shader;

	public class Sgsl2Test extends SimpleApplication
	{
		[Embed(source = "gpuparticle2.vs", mimeType = "application/octet-stream")]
		private static var GPUParticleVS:Class;
		[Embed(source = "gpuparticle2.fs", mimeType = "application/octet-stream")]
		private static var GPUParticleFS:Class;

		private var shader:Shader;

		public function Sgsl2Test()
		{
			super();
		}

		override protected function initialize(width:int, height:int):void
		{
			super.initialize(width, height);

			var vertexSrc:String = getVertexSource();

			var fragmentSrc:String = getFragmentSource();

			shader = ShaderManager.instance.registerShader("gpuparticle", [vertexSrc, fragmentSrc]);
		}

		protected function getVertexSource():String
		{
			var ba:ByteArray = new GPUParticleVS();
			return ba.readUTFBytes(ba.length);
		}

		protected function getFragmentSource():String
		{
			var ba:ByteArray = new GPUParticleFS();
			return ba.readUTFBytes(ba.length);
		}
	}
}
