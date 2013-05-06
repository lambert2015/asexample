package quake3.net ;
import nme.net.URLLoaderDataFormat;

class BinaryDataLoader extends DataLoader
{
	public function new()
	{
		super(URLLoaderDataFormat.BINARY);
	}
}