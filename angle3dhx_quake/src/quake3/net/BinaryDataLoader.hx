package quake3.net ;
import flash.net.URLLoaderDataFormat;

class BinaryDataLoader extends DataLoader
{
	public function new()
	{
		super(URLLoaderDataFormat.BINARY);
	}
}