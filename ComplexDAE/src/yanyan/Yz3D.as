package yanyan
{
	import flash.display3D.Context3D;
	import flash.events.EventDispatcher;

	/**
	 * 最小简化3D Graphics Engine：YZ3D 
	 * 
	 * I call this engine named YZ3D. you can also call 'yanyan3d'
	 * or 'yan3d'.It is just for a happy study time. Hope you
	 * like it.
	 * 
	 * @author harry
	 * @date 11.07 2012
	 * 
	 */
	public class Yz3D extends EventDispatcher
	{	
		// common vars
		public static const VERSION:String = '0.1.0.0';
		public static const AUTHOR:String = 'harry';
		public static const BLOG:String = 'http://www.the3frames.com';
		
		public static var context3DHolder:Context3D = null;// Just a pointer holder
	}
}