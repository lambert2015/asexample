package quake3.material;
import nme.display.BitmapData;
import nme.display3D.Context3D;
import nme.display3D.Context3DTextureFormat;
import nme.display3D.textures.Texture;
import nme.display3D.textures.TextureBase;
import nme.errors.Error;
import nme.events.Event;
import nme.events.IOErrorEvent;
import nme.Vector;
import haxe.ds.StringMap;
import quake3.net.TextureLoader;

/**
 * 每次最大下载次数有限制,最多同时下载5个文件
 * @author andy
 */

class TextureManager 
{
	private static var _instance:TextureManager;
	
	public static function getInstance():TextureManager
	{
		if (_instance == null)
		    _instance = new TextureManager();
		return _instance;
	}
	
	private var _textureMap:StringMap<TextureBase>;
    private var _context3d:Context3D;
	
	//工作中的Loader
	private var _workLoaders:Vector<TextureLoader>;
	//空闲中的Loader
	private var _freeLoaders:Vector<TextureLoader>;
	
	private var _loadInfoList:Vector<TextureLoaderInfo>;
	
	//默认Texture
	private var _defaultTexture:Texture;
	
	public function new() 
	{
		_textureMap = new StringMap();
		
		//最多只准许5个同时下载
		_freeLoaders = new Vector<TextureLoader>();
		for (i in 0...5)
		{
			var loader:TextureLoader = new TextureLoader();
			loader.addEventListener(Event.COMPLETE, _loadCompleteHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, _loadIOErrorHandler, false, 0, true);
			_freeLoaders[i] = loader;
		}
		
		_workLoaders = new Vector<TextureLoader>();
		
		_loadInfoList = new Vector<TextureLoaderInfo>();
	}
	
	public static function initialize(context3d:Context3D):Void
	{
		getInstance().setContext3D(context3d);
	}
	
	public function setContext3D(context3d:Context3D):Void
	{
		_context3d = context3d;
	}
	
	public function setDefaultTexture(bitmapData:BitmapData):Void
	{
		_defaultTexture = _context3d.createTexture(bitmapData.width, bitmapData.height, Context3DTextureFormat.BGRA, false);
		_defaultTexture.uploadFromBitmapData(bitmapData);
	}
	
	public function getDefaultTexture():TextureBase
	{
		return _defaultTexture;
	}
	
	public function addTexture(bitmapData:BitmapData,name:String):Void
	{
		var t:Texture = null;
		if (bitmapData != null)
		{
			try 
			{
				t = _context3d.createTexture(bitmapData.width, bitmapData.height, Context3DTextureFormat.BGRA, false);
				t.uploadFromBitmapData(bitmapData);
			}
			catch (e:Error)
			{
				throw new Error(name+ " 图片长或者宽不是2的幂");
			}
			
			Lib.trace("addTexture:"+name);
		}

		//TODO 检查name是否已经存在，若存在了，则警告
		_textureMap.set(name, t);
	}
	
	/**
	 * 
	 * @param name Texture name
	 * @param ?useDefaultTexture 是否使用默认Texture
	 * @return TextureBase
	 */
	public function getTexture(name:String,?useDefaultTexture:Bool=true):TextureBase
	{
		var t:TextureBase = _textureMap.get(name);
		if (t == null && useDefaultTexture)
		{
			return getDefaultTexture();
		}
		return t;
	}
	
	public function removeTexture(name:String):Void
	{
		var t:TextureBase = _textureMap.get(name);
		_textureMap.remove(name);
		if (t != null)
		{
			t.dispose();
		}
	}
	
	public function loadTexture(url:String,name:String):Void
	{
		_loadInfoList.push(new TextureLoaderInfo(url, name));
		
		_loadNext();
	}
	
	/**
	 * 加载队列中的下一个文件
	 */
	private function _loadNext():Void
	{
		//没有未下载的，或者没有空余loader
		if (_loadInfoList.length == 0 || _freeLoaders.length == 0)
		{
			return;
		}
		
		var infoNum:Int = _loadInfoList.length;
		var freeNum:Int = _freeLoaders.length;
		var i:Int = 0;
		while (i < infoNum && i < freeNum)
		{
			var info:TextureLoaderInfo = _loadInfoList.shift();
			var loader:TextureLoader = _freeLoaders.shift();
			
			loader.loadTexture(info.name, info.url);
			_workLoaders.push(loader);
			i++;
		}
	}
	/**
	 * 加入空闲列表
	 * @param	loader
	 */
	private function freeLoader(loader:TextureLoader):Void
	{
		var index:Int = _workLoaders.indexOf(loader);
		
		if (index > -1)
		{
			_workLoaders.splice(index, 1);
			loader.unload();
			_freeLoaders.push(loader);
			_loadNext();
		}
	}
	
	private function _loadCompleteHandler(e:Event):Void
	{
		var loader:TextureLoader = Lib.as(e.currentTarget, TextureLoader);
		
		addTexture(loader.getBitmapData(), loader.getName());
		
		freeLoader(loader);
	}
	
	private function _loadIOErrorHandler(e:Event):Void
	{
		var loader:TextureLoader = Lib.as(e.currentTarget, TextureLoader);
		
		Logger.log( "can not find " + loader.getName() );
		
		addTexture(null, loader.getName());
		
		freeLoader(loader);
	}
}

class TextureLoaderInfo
{
	public var url:String;
	public var name:String;
	public function new(url:String, name:String)
	{
		this.url = url;
		this.name = name;
	}
}