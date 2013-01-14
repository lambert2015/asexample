package yanyan.render
{
	/**
	 * 可渲染对象接口 
	 * 
	 * @author harry
	 * @date 11.07 2012
	 * 
	 */
	public interface IRenderable
	{
		function get isTransparentMesh():Boolean;
		function get zIndex():Number;
		
		function renderMesh(session:Object):void;
	}
}