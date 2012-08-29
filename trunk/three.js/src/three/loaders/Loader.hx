package three.loaders;
import js.Lib;
import js.Dom;
import three.materials.Material;
import three.materials.ShaderMaterial;
/**
 * ...
 * @author 
 */

class Loader 
{
	public var showStatus:Bool;
	
	public var statusDomElement:HtmlDom;

	public function new() 
	{
		
	}
	
	public function addStatusElement():HtmlDom
	{
		var e:HtmlDom = Lib.document.createElement("div");
		
		e.style.position = "absolute";
		e.style.right = "0px";
		e.style.top = "0px";
		e.style.fontSize = "0.8em";
		e.style.textAlign = "left";
		e.style.background = "rgba(0,0,0,0.25)";
		e.style.color = "#fff";
		e.style.width = "120px";
		e.style.padding = "0.5em 0.5em 0.5em 0.5em";
		e.style.zIndex = 1000;

		e.innerHTML = "Loading ...";

		return e;
	}
	
	public function updateProgress(progress:Dynamic):Void
	{
		var message:String = "Loaded ";
		if (progress.total != null)
		{
			message += (progress.loaded / progress.total).toFixed(0) + "%";
		}
		else
		{
			message += (progress.loaded / 1000).toFixed(2) + " KB";
		}
		
		this.statusDomElement.innerHTML = message;
	}
	
	public function extractUrlBase(url:String):String
	{
		var parts:Array<String> = url.split('/');
		parts.pop();
		return (parts.length < 1 ? '.' : parts.join('/') ) + '/';
	}
	
	public function initMaterials(scope:Dynamic, materials:Array<Material>, texturepath:String):Void
	{
		scope.materials = [];
		
		for (i in 0...materials.length)
		{
			scope.materials[i] = createMaterial(materials[i], texturepath);
		}
	}
	
	public function hasNormals(scope:Dynamic):Bool
	{
		var m:Material;
		for (i in 0...scope.materials.length) 
		{
			m = scope.materials[i];

			if (Std.is(m,ShaderMaterial))
				return true;
		}

		return false;
	}
	
	public static function createMaterial(m:Material, texturePath:String):Material
	{
		
	}
	
}