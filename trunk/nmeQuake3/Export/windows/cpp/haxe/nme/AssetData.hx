package nme;


import nme.Assets;


class AssetData {

	
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var path = new #if haxe3 Map <String, #else Hash <#end String> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();
	
	private static var initialized:Bool = false;
	
	
	public static function initialize ():Void {
		
		if (!initialized) {
			
			path.set ("libraries/library.swf", "libraries/library.swf");
			type.set ("libraries/library.swf", Reflect.field (AssetType, "binary".toUpperCase ()));
			
			library.set ("library", Reflect.field (LibraryType, "swf".toUpperCase ()));
			
			initialized = true;
			
		}
		
	}
	
	
}
