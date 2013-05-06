package quake3.material;
import nme.display3D.textures.Texture;
import nme.display3D.textures.TextureBase;

class Material
{
	private var textures:Array<String>;

	public function new()
	{
		textures = new Array<String>();
	}

	/**
	* @param data
	* @param index
	*/
	public function addTextureNameAt(data : String, index : Int = 1) : Void
	{
		textures[index] = data;
	}
	
	public function getTextureNameAt(index:Int) : String
	{
		return textures[index];
	}
	
	public function getTextureAt(index:Int):TextureBase
	{
		var name:String = getTextureNameAt(index);
		return TextureManager.getInstance().getTexture(name);
	}
}
