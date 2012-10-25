package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author 
	 */
	public class ReadAgal extends Sprite 
	{
		[Embed(source = "vertex.agal",mimeType="application/octet-stream")]
		private static var data : Class;
		
		public function ReadAgal() 
		{
			var b2a:ByteArray2Agal = new ByteArray2Agal();
			var agal:String = b2a.toAgal(new data());
			trace(agal);
		}
		
	}

}