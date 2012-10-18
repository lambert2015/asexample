package org.angle3d.light
{

	import org.angle3d.math.Color;
	import org.angle3d.scene.Spatial;

	/**
	 * <code>LightList</code> is used internally by <code>Spatial</code> to manage
	 * lights that are attached to them.
	 *
	 * @author Kirill Vainer
	 */
	public class LightList
	{
		private var _list : Vector.<Light>;
		private var _owner : Spatial;

		/**
		 * Creates a <code>LightList</code> for the given {@link Spatial}.
		 *
		 * @param owner The spatial owner
		 */
		public function LightList(owner : Spatial = null)
		{
			_list = new Vector.<Light>();

			setOwner(owner);
		}

		/**
		 * Set the owner of the LightList. Only used for cloning.
		 * @param owner
		 */
		public function setOwner(owner : Spatial) : void
		{
			this._owner = owner;
		}

		/**
		 * Adds a light to the list.
		 *
		 * @param l The light to add.
		 */
		public function addLight(l : Light) : void
		{
			if (_list.indexOf(l) == -1)
			{
				_list.push(l);
			}
		}

		/**
		 * Remove the light at the given index.
		 *
		 * @param index
		 */
		public function removeLightAt(index : int) : void
		{
			_list.splice(index, 1);
		}

		/**
		 * Removes the given light from the LightList.
		 *
		 * @param l the light to remove
		 */
		public function removeLight(l : Light) : void
		{
			var index : int = _list.indexOf(l);
			if (index > -1)
			{
				removeLightAt(index);
			}
		}

		/**
		 * @return The size of the list.
		 */
		public function getSize() : int
		{
			return _list.length;
		}

		public function getList() : Vector.<Light>
		{
			return _list;
		}

		/**
		 * @return the light at the given index.
		 * @throws IndexOutOfBoundsException If the given index is outside bounds.
		 */
		public function getLightAt(index : int) : Light
		{
			return _list[index];
		}

		/**
		 * Resets list size to 0.
		 */
		public function clear() : void
		{
			_list.length = 0;
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
		public function sort(transformChanged : Boolean) : void
		{
			var listSize : int = _list.length;
			if (listSize > 1)
			{
				if (transformChanged)
				{
					// check distance of each light
					for (var i : int = 0; i < listSize; i++)
					{
						_list[i].computeLastDistance(_owner);
					}
				}
			}

			//sort list
			_list.sort(_compare);
		}

		private function _compare(a : Light, b : Light) : int
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
		public function update(local : LightList, parent : LightList) : void
		{
			// clear the list
			clear();

			//copy local LightList
			_list = local.getList().slice();

			// if the spatial has a parent node, add the lights
			// from the parent list as well
			if (parent != null)
			{
				_list = _list.concat(parent.getList());
			}
		}

		public function clone() : LightList
		{
			var lightList : LightList = new LightList();
			lightList._owner = null;
			lightList._list = _list.slice();
			return lightList;
		}
	}
}

