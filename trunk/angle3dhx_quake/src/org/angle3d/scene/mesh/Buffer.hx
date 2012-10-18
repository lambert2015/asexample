package org.angle3d.scene.mesh;
import flash.display3D.Context3D;
import flash.display3D.Context3DVertexBufferFormat;
import flash.errors.Error;
import flash.Vector;

/**
 * A <code>Buffer</code> contains a particular type of geometry
 * data used by {@link Mesh}es. Every Buffer set on a <code>Mesh</code>
 * is sent as an attribute to the vertex shader to be processed.
 * <p>
 * Several terms are used throughout the javadoc for this class, explanation:
 * <ul>
 * <li>Element - A single element is the largest individual object
 * inside a VertexBuffer. E.g. if the Buffer is used to store 3D position
 * data, then an element will be a single 3D vector.</li>
 * <li>Component - A component represents the parts inside an element. 
 * For a 3D vector, a single component is one of the dimensions, X, Y or Z.</li>
 * </ul>
 */
class Buffer
{
	private var _offset:Int;
	
	private var _count:Int;

	private var _dirty:Bool;
	
	private var _type:String;
	
	public function new(type:String) 
	{
		_type = type;

		_offset = 0;
		_count = 0;
		_dirty = true;
	}
	
	/**
     * @return The offset (in bytes) from the start of the buffer
     * after which the data is sent to the GPU.
     */
	public inline function getOffset():Int
	{
		return _offset;
	}
	
	/**
     * @param offset Specify the offset (in bytes) from the start of the buffer
     * after which the data is sent to the GPU.
     */
	public inline function setOffset(offset:Int):Void
	{
		_offset = offset;
	}

	/**
     * @return The number of components of the given {@link Format format} per
     * element.
     */
    public inline function getCount():Int
	{
        return _count;
    }
	
	public function getType():String
	{
		return _type;
	}

	public function clean():Void
	{
		
	}
	
	/**
	 * 销毁
	 */
	public function destroy():Void
	{
		
	}
	
	public inline function isDirty():Bool
	{
		return _dirty;
	}
	
	/**
     * Internal use only. Indicates that the object has changed
     * and its state needs to be updated.
     */
    public inline function setDirty():Void
	{
        _dirty = true;
    }
	
	/**
     * Internal use only. Indicates that the state changes were applied.
     */
    public inline function clearDirty():Void
	{
        _dirty = false;
    }
	
}