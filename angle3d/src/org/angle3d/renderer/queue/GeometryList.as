package org.angle3d.renderer.queue
{
	import org.angle3d.renderer.Camera3D;
	import org.angle3d.scene.Geometry;


	/**
	 * This public class is a special function list of Spatial objects for render
	 * queuing.
	 *
	 * @author Jack Lindamood
	 * @author Three Rings - better sorting alg.
	 */
	public class GeometryList
	{
		private var _geometries:Vector.<Geometry>;
		private var _comparator:GeometryComparator;
		private var _size:uint;

		public function GeometryList(comparator:GeometryComparator)
		{
			_geometries = new Vector.<Geometry>();
			_size = 0;

			_comparator = comparator;
		}

		/**
		 * Returns the GeometryComparator that this Geometry list uses
		 * for sorting.
		 */
		public function getComparator():GeometryComparator
		{
			return _comparator;
		}

		public function setCamera(cam:Camera3D):void
		{
			_comparator.setCamera(cam);
		}

		public function get size():int
		{
			return _size;
		}

		public function get isEmpty():Boolean
		{
			return _size == 0;
		}

		public function getGeometry(i:int):Geometry
		{
			return _geometries[i];
		}

		/**
		 * Adds a geometry to the list. List size is doubled if there is no room.
		 *
		 * @param g
		 *            The geometry to add.
		 */
		public function add(g:Geometry):void
		{
			_geometries[_size++] = g;
		}

		/**
		 * Resets list size to 0.
		 */
		public function clear():void
		{
			_geometries.length = 0;

			_size = 0;
		}

		/**
		 * Sorts the elements in the list according to their Comparator.
		 */
		//TODO 需要优化，目前排序时间有点长
		public function sort():void
		{
			if (_size > 1)
			{
				// sort the spatial list using the comparator
				_geometries.sort(_comparator.compare);
			}
		}
	}
}

