package org.angle3d.light;
import flash.Vector;
import org.angle3d.math.Color;
import org.angle3d.scene.Spatial;

/**
 * <code>LightList</code> is used internally by {@link Spatial}s to manage
 * lights that are attached to them.
 * 
 * @author Kirill Vainer
 */
class LightList 
{
	private var list:Vector<Light>;
	private var owner:Spatial;

	/**
     * Creates a <code>LightList</code> for the given {@link Spatial}.
     * 
     * @param owner The spatial owner
     */
	public function new(owner:Spatial = null) 
	{
		list = new Vector<Light>();
		
		setOwner(owner);
	}
	
	/**
     * Set the owner of the LightList. Only used for cloning.
     * @param owner 
     */
	public function setOwner(owner:Spatial):Void
	{
		this.owner = owner;
	}
	
	/**
     * Adds a light to the list.
     *
     * @param l The light to add.
     */
	public function addLight(l:Light):Void
	{
		if (list.indexOf(l) == -1)
		{
			list.push(l);
		}
	}
	
	/**
     * Remove the light at the given index.
     * 
     * @param index
     */
	public function removeLightAt(index:Int):Void
	{
		list.splice(index, 1);
	}
	
	/**
     * Removes the given light from the LightList.
     * 
     * @param l the light to remove
     */
	public function removeLight(l:Light):Void
	{
		var index:Int = list.indexOf(l);
		if (index > -1)
		{
			removeLightAt(index);
		}
	}
	
	/**
     * @return The size of the list.
     */
	public inline function getSize():Int
	{
		return list.length;
	}
	
	public function getList():Vector<Light>
	{
		return list;
	}
	
	/**
     * @return the light at the given index.
     * @throws IndexOutOfBoundsException If the given index is outside bounds.
     */
	public inline function getLightAt(index:Int):Light
	{
		return list[index];
	}
	
	/**
     * Resets list size to 0.
     */
	public function clear():Void
	{
		list.length = 0;
	}
	
	/**
     * Sorts the elements in the list acording to their Comparator.
     * There are two reasons why lights should be resorted. 
     * First, if the lights have moved, that means their distance to 
     * the spatial changed. 
     * Second, if the spatial itself moved, it means the distance from it to 
     * the individual lights might have changed.
     * 
     *
     * @param transformChanged Whether the spatial's transform has changed
     */
	public function sort(transformChanged:Bool):Void
	{
		var listSize:Int = list.length;
		if (listSize > 1)
		{
			if (transformChanged)
			{
				// check distance of each light
				for (i in 0...listSize)
				{
					list[i].computeLastDistance(owner);
				}
			}
		}
		
		//sort list
		list.sort(_compare);
	}
	
	private function _compare(a:Light, b:Light):Int
	{
		if (a.lastDistance < b.lastDistance)
		{
			return -1;
		}
		else if (a.lastDistance > b.lastDistance)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	
	/**
     * Updates a "world-space" light list, using the spatial's local-space
     * light list and its parent's world-space light list.
     *
     * @param local
     * @param parent
     */
	public function update(local:LightList, parent:LightList):Void
	{
		// clear the list
        clear();

		//copy local LightList
        list = local.getList().slice(0);
		
		// if the spatial has a parent node, add the lights
        // from the parent list as well
		if (parent != null)
		{
			list = list.concat(parent.getList());
		}
	}
	
	public function clone():LightList
	{
		var lightList = new LightList();
		lightList.owner = null;
		lightList.list = list.slice(0);
		return lightList;
	}
}