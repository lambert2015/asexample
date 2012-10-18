package org.angle3d.scene.mesh
{
	CF::DEBUG
	{
		import org.angle3d.utils.Assert;
	}

	public class VertexBuffer
	{
		private var _count : int;

		private var _dirty : Boolean;

		private var _type : String;

		private var _data : Vector.<Number>;

		private var _components : int;

		public function VertexBuffer(type : String)
		{
			_type = type;

			_count = 0;
			_dirty = true;
		}

		public function get components() : int
		{
			return _components;
		}

		/**
		 *
		 * @param	data
		 * @param	components
		 */
		public function setData(data : Vector.<Number>, components : int) : void
		{
			_data = data;

			_components = components;

			CF::DEBUG
			{
				Assert.assert(_components >= 1 && _components <= 4, "_components长度应该在1～4之间");
			}

			_count = int(_data.length / _components);

			dirty = true;
		}

		public function updateData(data : Vector.<Number>) : void
		{
			_data = data;

			CF::DEBUG
			{
				Assert.assert(int(_data.length / _components) == _count, "更新的数组长度应该和之前相同");
			}

			dirty = true;
		}

		public function getData() : Vector.<Number>
		{
			return _data;
		}

		public function clean() : void
		{
			dirty = true;
			_data = null;
		}

		/**
		 * 销毁
		 */
		public function destroy() : void
		{
			_data = null;
		}

		public function get count() : int
		{
			return _count;
		}

		public function get type() : String
		{
			return _type;
		}

		public function get dirty() : Boolean
		{
			return _dirty;
		}

		/**
		 * Internal use only. Indicates that the object has changed
		 * and its state needs to be updated.
		 */
		public function set dirty(value : Boolean) : void
		{
			_dirty = value;
		}
	}
}

