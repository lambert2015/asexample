package examples.sgsl
{
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import org.angle3d.manager.ShaderManager;
	
	import org.angle3d.app.SimpleApplication;
	import org.angle3d.material.sgsl.OpCodeManager;
	import org.angle3d.material.sgsl.SgslCompiler;
	import org.angle3d.material.sgsl.parser.SgslParser;
	import org.angle3d.material.shader.Shader;

	public class SaveSgsl extends SimpleApplication
	{
		[Embed(source = "gpuparticle.vs", mimeType = "application/octet-stream")]
		private static var GPUParticleVS:Class;
		[Embed(source = "gpuparticle.fs", mimeType = "application/octet-stream")]
		private static var GPUParticleFS:Class;
		
		private var shader:Shader;

		public function SaveSgsl()
		{
			
		}
		
		override protected function initialize(width : int, height : int) : void
		{
			super.initialize(width, height);
			
			var vertexSrc:String = getVertexSource();
			
			var fragmentSrc:String = getFragmentSource();
			
			shader = ShaderManager.instance.registerShader("gpuparticle",[vertexSrc, fragmentSrc]);

			this.stage.addEventListener(MouseEvent.CLICK, _saveData);
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
		
		private var count:int = 0;

		private function _saveData(e:MouseEvent):void
		{
			if (count == 0)
			{
				new FileReference().save(shader.vertexData, "vertex.sgsl");
			}
			else
			{
				new FileReference().save(shader.fragmentData, "fragment.sgsl");
			}

			count++;
			if (count > 1)
			{
				count = 0;
			}
		}
	}
}

