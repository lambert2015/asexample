package examples.sgsl
{
	import flash.utils.ByteArray;
	import org.angle3d.app.SimpleApplication;
	import org.angle3d.material.sgsl.node.BranchNode;
	import org.angle3d.material.sgsl.parser.SgslParser;
	import org.angle3d.material.shader.Shader;


	public class Sgsl2Test extends SimpleApplication
	{
		[Embed(source = "test.vs", mimeType = "application/octet-stream")]
		private static var testVS:Class;
		[Embed(source = "test.fs", mimeType = "application/octet-stream")]
		private static var testFS:Class;

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
			
			var sgslParser:SgslParser = new SgslParser();
			var node:BranchNode = sgslParser.exec(vertexSrc);
		}

		protected function getVertexSource():String
		{
			var ba:ByteArray = new testVS();
			return ba.readUTFBytes(ba.length);
		}

		protected function getFragmentSource():String
		{
			var ba:ByteArray = new testFS();
			return ba.readUTFBytes(ba.length);
		}
	}
}
