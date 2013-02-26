package org.angle3d.renderer.queue;
import org.angle3d.renderer.Camera3D;
import org.angle3d.scene.Geometry;
import flash.Vector;

/**
 * This class is a special function list of Spatial objects for render
 * queuing.
 *
 * @author Jack Lindamood
 * @author Three Rings - better sorting alg.
 */
class GeometryList 
{
	private var geometries:Vector<Geometry>;
	private var comparator:GeometryComparator;
	private var size:Int;

	public function new(comparator:GeometryComparator) 
	{
		geometries = new Vector<Geometry>();
		size = 0;
		
		this.comparator = comparator;
	}
	
	public function setCamera(cam:Camera3D):Void
	{
		comparator.setCamera(cam);
	}
	
	public inline function getSize():Int
	{
		return size;
	}
	
	public inline function getGeometry(i:Int):Geometry
	{
		return geometries[i];
	}
	
	/**
     * Adds a geometry to the list. List size is doubled if there is no room.
     *
     * @param g
     *            The geometry to add.
     */
	public inline function add(g:Geometry):Void
	{
		geometries[size++] = g;
	}
	
	/**
     * Resets list size to 0.
     */
	public function clear():Void
	{
		geometries.length = 0;
		
		size = 0;
	}
	
	/**
     * Sorts the elements in the list according to their Comparator.
     */
	public function sort():Void
	{
		if (size > 1)
		{
			// sort the spatial list using the comparator
			geometries.sort(comparator.compare);
		}
	}
}