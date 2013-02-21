package examples.material
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	import org.angle3d.io.MaterialLoader;

	public class MaterialDefTest extends Sprite
	{
		[Embed(source = "unshaded.xml", mimeType = "application/octet-stream")]
		private static var UnShadedData:Class;

		[Embed(source = "unshaded.json", mimeType = "application/octet-stream")]
		private static var UnShadedJsonData:Class;

		public function MaterialDefTest()
		{
			super();

			var ba:ByteArray = new UnShadedJsonData();

			var materialLoader:MaterialLoader = new MaterialLoader();
			materialLoader.parse(ba.readUTFBytes(ba.length));
		}
	}
}
