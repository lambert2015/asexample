package examples.material
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	public class MaterialDefTest extends Sprite
	{
		[Embed(source = "unshaded.xml", mimeType = "application/octet-stream")]
		private static var UnShadedData:Class;

		[Embed(source = "unshaded.json", mimeType = "application/octet-stream")]
		private static var UnShadedJsonData:Class;

		public function MaterialDefTest()
		{
			super();

			var ba:ByteArray = new UnShadedData();
			var xml:XML = XML(ba.readUTFBytes(ba.length));

			trace(xml.techniques[0].technique[0].bind.@data);

			ba = new UnShadedJsonData();
			var jsonObj:Object = JSON.parse(ba.readUTFBytes(ba.length));
			trace(jsonObj);
		}
	}
}
