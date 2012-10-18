package org.angle3d.renderer;
import flash.display.Stage3D;
import flash.display3D.Context3D;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DTriangleFace;
import org.angle3d.material.RenderState;
import org.angle3d.math.Color;
import org.angle3d.scene.mesh.Mesh;
import org.angle3d.shader.Shader;
import org.angle3d.texture.FrameBuffer;

/**
 * The <code>Renderer</code> is responsible for taking rendering commands and
 * executing them on the underlying video hardware.
 * 
 * @author Kirill Vainer
 */
interface IRenderer 
{
	function getStage3D():Stage3D;
	
	function getContext3D():Context3D;

	/**
     * Invalidates the current rendering state.
     */
	function invalidateState():Void;
	
	/**
     * Clears certain channels of the currently bound framebuffer.
     *
     * @param color True if to clear colors (RGBA)
     * @param depth True if to clear depth/z
     * @param stencil True if to clear stencil buffer (if available, otherwise
     * ignored)
     */
    function clearBuffers(color:Bool,depth:Bool,stencil:Bool):Void;
	
	/**
     * Sets the background (aka clear) color.
     * 
     * @param color The background color to set
     */
	function setBackgroundColor(color:UInt):Void;
	
	/**
     * Applies the given {@link RenderState}, making the necessary
     * calls so that the state is applied.
     */
    function applyRenderState(state:RenderState):Void;
	
	
	function setDepthTest(depthMask:Bool, passCompareMode:Context3DCompareMode):Void;
	
	function setCulling(triangleFaceToCull:Context3DTriangleFace):Void;
	
	/**
     * Called when a new frame has been rendered.
     */
	function onFrame():Void;

	/**
     * Set the viewport location and resolution on the screen.
     * 
     * @param x The x coordinate of the viewport
     * @param y The y coordinate of the viewport
     * @param width Width of the viewport
     * @param height Height of the viewport
     */
    function setViewPort(x:Int, y:Int, width:Int, height:Int):Void;
	
	/**
     * Specifies a clipping rectangle.
     * For all future rendering commands, no pixels will be allowed
     * to be rendered outside of the clip rectangle.
     * 
     * @param x The x coordinate of the clip rect
     * @param y The y coordinate of the clip rect
     * @param width Width of the clip rect
     * @param height Height of the clip rect
     */
    function setClipRect(x:Int, y:Int, width:Int, height:Int):Void;
	
	/**
     * Clears the clipping rectangle set with 
     * {@link #setClipRect(int, int, int, int) }.
     */
    function clearClipRect():Void;
	
	/**
     * Sets the framebuffer that will be drawn to.
     */
	function setFrameBuffer(fb:FrameBuffer):Void;

	/**
     * Sets the shader to use for rendering.
     * If the shader has not been uploaded yet, it is compiled
     * and linked. If it has been uploaded, then the 
     * uniform data is updated and the shader is set.
     * 
     * @param shader The shader to use for rendering.
     */
	function setShader(shader:Shader):Void;
	
	/**
     * Renders <code>count</code> meshes, with the geometry data supplied.
     * The shader which is currently set with <code>setShader</code> is
     * responsible for transforming the input verticies into clip space
     * and shading it based on the given vertex attributes.
     *
     * @param mesh The mesh to render
     * @param lod The LOD level to use, see {@link Mesh#setLodLevels(org.angle3d.scene.VertexBuffer[]) }.
     * @param count Number of mesh instances to render
     */
	function renderMesh(mesh:Mesh, lod:Int, count:Int):Void;
	
	/**
	 * Synchronize graphics subsytem rendering
	 */
	function present():Void;
	
	/**
	 * Cleanup 
	 */
    function cleanup():Void;
}