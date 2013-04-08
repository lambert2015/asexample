package org.angle3d.light;

import org.angle3d.scene.Spatial;
import haxe.ds.Vector;


using org.angle3d.utils.ArrayUtil;

/**
 * <code>LightList</code> is used internally by <code>Spatial</code> to manage
 * lights that are attached to them.
 *
 * @author Kirill Vainer
 */
class LightList
{
	private var mList:Array<Light>;
	private var mOwner:Spatial;

	/**
	 * Creates a <code>LightList</code> for the given {@link Spatial}.
	 *
	 * @param owner The spatial owner
	 */
	public function new(owner:Spatial = null)
	{
		mList = new Array<Light>();

		setOwner(owner);
	}

	/**
	 * set_the owner of the LightList. Only used for cloning.
	 * @param owner
	 */
	public function setOwner(owner:Spatial):Void
	{
		this.mOwner = owner;
	}

	/**
	 * Adds a light to the list.
	 *
	 * @param l The light to add.
	 */
	public function addLight(light:Light):Void
	{
		if (!mList.contain(light))
		{
			mList.push(light);
		}
	}

	/**
	 * Remove the light at the given index.
	 *
	 * @param index
	 */
	public function removeLightAt(index:Int):Void
	{
		mList.splice(index, 1);
	}

	/**
	 * Removes the given light from the LightList.
	 *
	 * @param l the light to remove
	 */
	public function removeLight(light:Light):Void
	{
		var index:Int = mList.indexOf(light);
		if (index > -1)
		{
			removeLightAt(index);
		}
	}

	/**
	 * @return The size of the list.
	 */
	public function getSize():Int
	{
		return mList.length;
	}

	public function getList():Array<Light>
	{
		return mList;
	}

	/**
	 * @return the light at the given index.
	 * @throws IndexOutOfBoundsException If the given index is outside bounds.
	 */
	public function getLightAt(index:Int):Light
	{
		return mList[index];
	}

	/**
	 * Resets list size to 0.
	 */
	public function clear():Void
	{
		#if flash
			untyped mList.length = 0;
		#else
			mList = [];
		#end
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
		var listSize:Int = mList.length;
		if (listSize > 1)
		{
			if (transformChanged)
			{
				// check distance of each light
				for (i in 0...listSize)
				{
					mList[i].computeLastDistance(mOwner);
				}
			}
		}

		//sort list
		mList.sort(_compare);
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
	//TODO 优化，创建对象太多，这里垃圾回收有一次用了4ms
	public function update(local:LightList, parent:LightList):Void
	{
		// clear the list
		clear();

		//copy local LightList
		mList = local.getList().slice(0);

		// if the spatial has a parent node, add the lights
		// from the parent list as well
		if (parent != null)
		{
			mList = mList.concat(parent.getList());
		}
	}

	public function clone():LightList
	{
		var lightList:LightList = new LightList();
		lightList.mOwner = null;
		lightList.mList = mList.slice(0);
		return lightList;
	}
}
