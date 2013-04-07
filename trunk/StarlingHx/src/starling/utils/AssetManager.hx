package starling.utils;

import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.FileReference;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.system.ImageDecodingPolicy;
import flash.system.LoaderContext;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.Vector;
import flash.utils.clearTimeout;
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;
import flash.utils.setTimeout;

import starling.core.Starling;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

/** The AssetManager handles loading and accessing a variety of asset types. You can 
 *  add assets directly (via the 'add...' methods) or asynchronously via a queue. This allows
 *  you to deal with assets in a unified way, no matter if they are loaded from a file, 
 *  directory, URL, or from an embedded object.
 *  
 *  <p>If you load files from disk, the following types are supported:
 *  <code>png, jpg, atf, mp3, xml, fnt</code></p>
 */    
class AssetManager
{
	private const SUPPORTED_EXTENSIONS:Vector<String> = 
		new <String>["png", "jpg", "jpeg", "atf", "mp3", "xml", "fnt"]; 
	
	private var mScaleFactor:Float;
	private var mUseMipMaps:Bool;
	private var mCheckPolicyFile:Bool;
	private var mVerbose:Bool;
	
	private var mRawAssets:Array;
	private var mTextures:Dictionary;
	private var mAtlases:Dictionary;
	private var mSounds:Dictionary;
	
	/** helper objects */
	private var sNames:Vector<String> = new <String>[];
	
	/** Create a new AssetManager. The 'scaleFactor' and 'useMipmaps' parameters define
	 *  how enqueued bitmaps will be converted to textures. */
	public function new(scaleFactor:Float=1, useMipmaps:Bool=false)
	{
		mVerbose = false;
		mScaleFactor = scaleFactor > 0 ? scaleFactor : Starling.contentScaleFactor;
		mUseMipMaps = useMipmaps;
		mCheckPolicyFile = false;
		mRawAssets = [];
		mTextures = new Dictionary();
		mAtlases = new Dictionary();
		mSounds = new Dictionary();
	}
	
	/** Disposes all contained textures. */
	public function dispose():Void
	{
		for each (var texture:Texture in mTextures)
			texture.dispose();
		
		for each (var atlas:TextureAtlas in mAtlases)
			atlas.dispose();
	}
	
	// retrieving
	
	/** Returns a texture with a certain name. The method first looks through the directly
	 *  added textures; if no texture with that name is found, it scans through all 
	 *  texture atlases. */
	public function getTexture(name:String):Texture
	{
		if (name in mTextures) return mTextures[name];
		else
		{
			for each (var atlas:TextureAtlas in mAtlases)
			{
				var texture:Texture = atlas.getTexture(name);
				if (texture) return texture;
			}
			return null;
		}
	}
	
	/** Returns all textures that start with a certain string, sorted alphabetically
	 *  (especially useful for "MovieClip"). */
	public function getTextures(prefix:String="", result:Vector<Texture>=null):Vector<Texture>
	{
		if (result == null) result = new <Texture>[];
		
		for each (var name:String in getTextureNames(prefix, sNames))
			result.push(getTexture(name));
		
		sNames.length = 0;
		return result;
	}
	
	/** Returns all texture names that start with a certain string, sorted alphabetically. */
	public function getTextureNames(prefix:String="", result:Vector<String>=null):Vector<String>
	{
		if (result == null) result = new <String>[];
		
		for (var name:String in mTextures)
			if (name.indexOf(prefix) == 0)
				result.push(name);                
		
		for each (var atlas:TextureAtlas in mAtlases)
			atlas.getNames(prefix, result);
		
		result.sort(Array.CASEINSENSITIVE);
		return result;
	}
	
	/** Returns a texture atlas with a certain name, or null if it's not found. */
	public function getTextureAtlas(name:String):TextureAtlas
	{
		return mAtlases[name] as TextureAtlas;
	}
	
	/** Returns a sound with a certain name. */
	public function getSound(name:String):Sound
	{
		return mSounds[name];
	}
	
	/** Returns all sound names that start with a certain string, sorted alphabetically. */
	public function getSoundNames(prefix:String=""):Vector<String>
	{
		var names:Vector<String> = new <String>[];
		
		for (var name:String in mSounds)
			if (name.indexOf(prefix) == 0)
				names.push(name);
		
		return names.sort(Array.CASEINSENSITIVE);
	}
	
	/** Generates a new SoundChannel object to play back the sound. This method returns a 
	 *  SoundChannel object, which you can access to stop the sound and to control volume. */ 
	public function playSound(name:String, startTime:Float=0, loops:Int=0, 
							  transform:SoundTransform=null):SoundChannel
	{
		if (name in mSounds)
			return getSound(name).play(startTime, loops, transform);
		else 
			return null;
	}
	
	// direct adding
	
	/** Register a texture under a certain name. It will be available right away. */
	public function addTexture(name:String, texture:Texture):Void
	{
		log("Adding texture '" + name + "'");
		
		if (name in mTextures)
			throw new Error("Duplicate texture name: " + name);
		else
			mTextures[name] = texture;
	}
	
	/** Register a texture atlas under a certain name. It will be available right away. */
	public function addTextureAtlas(name:String, atlas:TextureAtlas):Void
	{
		log("Adding texture atlas '" + name + "'");
		
		if (name in mAtlases)
			throw new Error("Duplicate texture atlas name: " + name);
		else
			mAtlases[name] = atlas;
	}
	
	/** Register a sound under a certain name. It will be available right away. */
	public function addSound(name:String, sound:Sound):Void
	{
		log("Adding sound '" + name + "'");
		
		if (name in mSounds)
			throw new Error("Duplicate sound name: " + name);
		else
			mSounds[name] = sound;
	}
	
	// removing
	
	/** Removes a certain texture, optionally disposing it. */
	public function removeTexture(name:String, dispose:Bool=true):Void
	{
		if (dispose && name in mTextures)
			mTextures[name].dispose();
		
		delete mTextures[name];
	}
	
	/** Removes a certain texture atlas, optionally disposing it. */
	public function removeTextureAtlas(name:String, dispose:Bool=true):Void
	{
		if (dispose && name in mAtlases)
			mAtlases[name].dispose();
		
		delete mAtlases[name];
	}
	
	/** Removes a certain sound. */
	public function removeSound(name:String):Void
	{
		delete mSounds[name];
	}
	
	/** Removes assets of all types and empties the queue. */
	public function purge():Void
	{
		for each (var texture:Texture in mTextures)
			texture.dispose();
		
		for each (var atlas:TextureAtlas in mAtlases)
			atlas.dispose();
		
		mRawAssets.length = 0;
		mTextures = new Dictionary();
		mAtlases = new Dictionary();
		mSounds = new Dictionary();
	}
	
	// queued adding
	
	/** Enqueues one or more raw assets; they will only be available after successfully 
	 *  executing the "loadQueue" method. This method accepts a variety of different objects:
	 *  
	 *  <ul>
	 *    <li>Strings containing an URL to a local or remote resource. Supported types:
	 *        <code>png, jpg, atf, mp3, fnt, xml</code> (texture atlas).</li>
	 *    <li>Instances of the File class (AIR only) pointing to a directory or a file.
	 *        Directories will be scanned recursively for all supported types.</li>
	 *    <li>Classes that contain <code>static</code> embedded assets.</li>
	 *  </ul>
	 *  
	 *  Suitable object names are extracted automatically: A file named "image.png" will be
	 *  accessible under the name "image". When enqueuing embedded assets via a class, 
	 *  the variable name of the embedded object will be used as its name. An exception
	 *  are texture atlases: they will have the same name as the actual texture they are
	 *  referencing.
	 */
	public function enqueue(...rawAssets):Void
	{
		for each (var rawAsset:Dynamic in rawAssets)
		{
			if (rawAsset is Array)
			{
				enqueue.apply(this, rawAsset);
			}
			else if (rawAsset is Class)
			{
				var typeXml:XML = describeType(rawAsset);
				var childNode:XML;
				
				if (mVerbose)
					log("Looking for static embedded assets in '" + 
						(typeXml.@name).split("::").pop() + "'"); 
				
				for each (childNode in typeXml.constant.(@type == "Class"))
					enqueueWithName(rawAsset[childNode.@name], childNode.@name);
				
				for each (childNode in typeXml.variable.(@type == "Class"))
					enqueueWithName(rawAsset[childNode.@name], childNode.@name);
			}
			else if (getQualifiedClassName(rawAsset) == "flash.filesystem::File")
			{
				if (!rawAsset["exists"])
				{
					log("File or directory not found: '" + rawAsset["url"] + "'");
				}
				else if (!rawAsset["isHidden"])
				{
					if (rawAsset["isDirectory"])
						enqueue.apply(this, rawAsset["getDirectoryListing"]());
					else
					{
						var extension:String = rawAsset["extension"].toLowerCase();
						if (SUPPORTED_EXTENSIONS.indexOf(extension) != -1)
							enqueueWithName(rawAsset["url"]);
						else
							log("Ignoring unsupported file '" + rawAsset["name"] + "'");
					}
				}
			}
			else if (rawAsset is String)
			{
				enqueueWithName(rawAsset);
			}
			else
			{
				log("Ignoring unsupported asset type: " + getQualifiedClassName(rawAsset));
			}
		}
	}
	
	/** Enqueues a single asset with a custom name that can be used to access it later. 
	 *  If you don't pass a name, it's attempted to generate it automatically.
	 *  @returns the name under which the asset was registered. */
	public function enqueueWithName(asset:Dynamic, name:String=null):String
	{
		if (name == null) name = getName(asset);
		log("Enqueuing '" + name + "'");
		
		mRawAssets.push({
			name: name,
			asset: asset
		});
		
		return name;
	}
	
	/** Loads all enqueued assets asynchronously. The 'onProgress' function will be called
	 *  with a 'ratio' between '0.0' and '1.0', with '1.0' meaning that it's complete.
	 *
	 *  @param onProgress: <code>function(ratio:Float):Void;</code> 
	 */
	public function loadQueue(onProgress:Function):Void
	{
		if (Starling.context == null)
			throw new Error("The Starling instance needs to be ready before textures can be loaded.");
		
		var xmls:Vector<XML> = new <XML>[];
		var numElements:Int = mRawAssets.length;
		var currentRatio:Float = 0.0;
		var timeoutID:UInt;
		
		resume();
		
		function resume():Void
		{
			currentRatio = mRawAssets.length ? 1.0 - (mRawAssets.length / numElements) : 1.0;
			
			if (mRawAssets.length)
				timeoutID = setTimeout(processNext, 1);
			else
				processXmls();
			
			if (onProgress != null)
				onProgress(currentRatio);
		}
		
		function processNext():Void
		{
			var assetInfo:Dynamic = mRawAssets.pop();
			clearTimeout(timeoutID);
			loadRawAsset(assetInfo.name, assetInfo.asset, xmls, progress, resume);
		}
		
		function processXmls():Void
		{
			// xmls are processed seperately at the end, because the textures they reference
			// have to be available for other XMLs. Texture atlases are processed first:
			// that way, their textures can be referenced, too.
			
			xmls.sort(function(a:XML, b:XML):Int { 
				return a.localName() == "TextureAtlas" ? -1 : 1; 
			});
			
			for each (var xml:XML in xmls)
			{
				var name:String;
				var rootNode:String = xml.localName();
				
				if (rootNode == "TextureAtlas")
				{
					name = getName(xml.@imagePath.toString());
					
					var atlasTexture:Texture = getTexture(name);
					addTextureAtlas(name, new TextureAtlas(atlasTexture, xml));
					removeTexture(name, false);
				}
				else if (rootNode == "font")
				{
					name = getName(xml.pages.page.@file.toString());
					
					var fontTexture:Texture = getTexture(name);
					TextField.registerBitmapFont(new BitmapFont(fontTexture, xml));
					removeTexture(name, false);
				}
				else
					throw new Error("XML contents not recognized: " + rootNode);
			}
		}
		
		function progress(ratio:Float):Void
		{
			onProgress(currentRatio + (1.0 / numElements) * Math.min(1.0, ratio) * 0.99);
		}
	}
	
	private function loadRawAsset(name:String, rawAsset:Dynamic, xmls:Vector<XML>,
								  onProgress:Function, onComplete:Function):Void
	{
		var extension:String = null;
		
		if (rawAsset is Class)
		{
			var asset:Dynamic = new rawAsset();
			
			if (asset is Sound)
			{
				addSound(name, asset as Sound);
				onComplete();
			}
			else if (asset is Bitmap)
			{
				addBitmapTexture(name, asset as Bitmap);
				onComplete();
			}
			else if (asset is ByteArray)
			{
				var bytes:ByteArray = asset as ByteArray;
				var signature:String = String.fromCharCode(bytes[0], bytes[1], bytes[2]);
				
				if (signature == "ATF")
				{
					addTexture(name, Texture.fromAtfData(asset as ByteArray, mScaleFactor, 
						mUseMipMaps, onComplete));
				}
				else
				{
					xmls.push(new XML(bytes));
					onComplete();
				}
			}
			else
			{
				log("Ignoring unsupported asset type: " + getQualifiedClassName(asset));
				onComplete();
			}
		}
		else if (rawAsset is String)
		{
			var url:String = rawAsset as String;
			extension = url.split(".").pop().toLowerCase();
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			urlLoader.addEventListener(Event.COMPLETE, onUrlLoaderComplete);
			urlLoader.load(new URLRequest(url));
		}
		
		function onIoError(event:IOErrorEvent):Void
		{
			log("IO error: " + event.text);
			onComplete();
		}
		
		function onLoadProgress(event:ProgressEvent):Void
		{
			onProgress(event.bytesLoaded / event.bytesTotal);
		}
		
		function onUrlLoaderComplete(event:Event):Void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			var bytes:ByteArray = urlLoader.data as ByteArray;
			var sound:Sound;
			
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			urlLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			urlLoader.removeEventListener(Event.COMPLETE, onUrlLoaderComplete);
			
			switch (extension)
			{
				case "atf":
					addTexture(name, Texture.fromAtfData(bytes, mScaleFactor, mUseMipMaps, onComplete));
				case "fnt","xml":
					xmls.push(new XML(bytes));
					onComplete();
				case "mp3":
					sound = new Sound();
					sound.loadCompressedDataFromByteArray(bytes, bytes.length);
					addSound(name, sound);
					onComplete();
				default:
					var loaderContext:LoaderContext = new LoaderContext(mCheckPolicyFile);
					var loader:Loader = new Loader();
					loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
					loader.loadBytes(urlLoader.data as ByteArray, loaderContext);	
			}
		}
		
		function onLoaderComplete(event:Event):Void
		{
			event.target.removeEventListener(Event.COMPLETE, onLoaderComplete);
			var content:Dynamic = event.target.content;
			
			if (content is Bitmap)
				addBitmapTexture(name, content as Bitmap);
			else
				throw new Error("Unsupported asset type: " + getQualifiedClassName(content));
			
			onComplete();
		}
	}
	
	// helpers
	
	/** This method is called by 'enqueue' to determine the name under which an asset will be
	 *  accessible; override it if you need a custom naming scheme. Typically, 'rawAsset' is 
	 *  either a String or a FileReference. Note that this method won't be called for embedded
	 *  assets. */
	protected function getName(rawAsset:Dynamic):String
	{
		var matches:Array;
		var name:String;
		
		if (rawAsset is String || rawAsset is FileReference)
		{
			name = rawAsset is String ? rawAsset as String : (rawAsset as FileReference).name;
			name = name.replace(/%20/g, " "); // URLs use '%20' for spaces
			matches = /(.*[\\\/])?(.+)(\.[\w]{1,4})/.exec(name);
			
			if (matches && matches.length == 4) return matches[2];
			else throw new ArgumentError("Could not extract name from String '" + rawAsset + "'");
		}
		else
		{
			name = getQualifiedClassName(rawAsset);
			throw new ArgumentError("Cannot extract names for objects of type '" + name + "'");
		}
	}
	
	/** This method is called during loading of assets when 'verbose' is activated. Per
	 *  default, it traces 'message' to the console. */
	protected function log(message:String):Void
	{
		if (mVerbose) trace("[AssetManager]", message);
	}
	
	/** This method is called during loading of assets when a bitmap texture is processed. 
	 *  Override it if you want to preprocess the bitmap in some way. */
	protected function addBitmapTexture(name:String, bitmap:Bitmap):Void
	{
		addTexture(name, Texture.fromBitmap(bitmap, mUseMipMaps, false, mScaleFactor));
	}
	
	// properties
	public var verbose(get, set):Bool;
	public var useMipMaps(get, set):Bool;
	public var scaleFactor(get, set):Float;
	public var checkPolicyFile(get, set):Bool;
	
	/** When activated, the class will trace information about added/enqueued assets. */
	private function get_verbose():Bool 
	{ 
		return mVerbose; 
	}
	private function set_verbose(value:Bool):Bool 
	{ 
		return mVerbose = value; 
	}
	
	/** For bitmap textures, this flag indicates if mip maps should be generated when they 
	 *  are loaded; for ATF textures, it indicates if mip maps are valid and should be
	 *  used. */
	private function get_useMipMaps():Bool 
	{ 
		return mUseMipMaps; 
	}
	private function set_useMipMaps(value:Bool):Bool 
	{ 
		return mUseMipMaps = value; 
	}
	
	/** Textures that are created from Bitmaps or ATF files will have the scale factor 
	 *  assigned here. */
	private function get_scaleFactor():Float 
	{ 
		return mScaleFactor; 
	}
	private function set_scaleFactor(value:Float):Float 
	{ 
		return mScaleFactor = value; 
	}
	
	/** Specifies whether a check should be made for the existence of a URL policy file before
	 *  loading an object from a remote server. More information about this topic can be found 
	 *  in the 'flash.system.LoaderContext' documentation. */
	private function get_checkPolicyFile():Bool 
	{ 
		return mCheckPolicyFile; 
	}
	private function set_checkPolicyFile(value:Bool):Bool 
	{ 
		return mCheckPolicyFile = value; 
	}
}