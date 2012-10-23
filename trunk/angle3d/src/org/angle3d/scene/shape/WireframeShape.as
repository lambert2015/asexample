package org.angle3d.scene.shape
{

	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.SubMesh;

	/**
	 * 3角形顺序理的不太清楚
	 * @author andy
	 */

	public class WireframeShape extends Mesh
	{
		private var _posVector:Vector.<Number>;
		private var _pos1Vector:Vector.<Number>;

		protected var _segments:Vector.<WireframeLineSet>;

		protected var _subMesh:SubMesh;

		public function WireframeShape()
		{
			super();

			_subMesh = new SubMesh();
			this.addSubMesh(_subMesh);

			_posVector = new Vector.<Number>();
			_pos1Vector = new Vector.<Number>();

			_indices = new Vector.<uint>();

			_segments = new Vector.<WireframeLineSet>();
		}

		public function clearSegment():void
		{
			_segments.length = 0;
		}

		public function addSegment(segment:WireframeLineSet):void
		{
			_segments.push(segment);
		}

		/**
		 * 生成线框模式需要的数据
		 */
		private var _indices:Vector.<uint>;

		public function build(updateIndices:Boolean = true):void
		{
			_posVector.fixed = false;
			_posVector.length = 0;

			_pos1Vector.fixed = false;
			_pos1Vector.length = 0;

			if (updateIndices)
			{
				_indices.fixed = false;
				_indices.length = 0;
			}


			var sLength:int = _segments.length;
			for (var i:int = 0; i < sLength; i++)
			{
				var segment:WireframeLineSet = _segments[i];

				var index:uint = i << 2;
				if (updateIndices)
				{
					_indices.push(index);
					_indices.push(index + 1);
					_indices.push(index + 2);
					_indices.push(index + 3);
					_indices.push(index + 2);
					_indices.push(index + 1);
				}

				var i12:int = i * 12;
				var i16:int = i * 16;

				var sx:Number = segment.sx, sy:Number = segment.sy, sz:Number = segment.sz;
				var ex:Number = segment.ex, ey:Number = segment.ey, ez:Number = segment.ez;

				//pos
				_posVector[i12 + 0] = sx;
				_posVector[i12 + 1] = sy;
				_posVector[i12 + 2] = sz;

				_posVector[i12 + 3] = ex;
				_posVector[i12 + 4] = ey;
				_posVector[i12 + 5] = ez;

				_posVector[i12 + 6] = sx;
				_posVector[i12 + 7] = sy;
				_posVector[i12 + 8] = sz;

				_posVector[i12 + 9] = ex;
				_posVector[i12 + 10] = ey;
				_posVector[i12 + 11] = ez;

				//pos1
				_pos1Vector[i16 + 0] = ex;
				_pos1Vector[i16 + 1] = ey;
				_pos1Vector[i16 + 2] = ez;
				//thickness
				_pos1Vector[i16 + 3] = 1;

				_pos1Vector[i16 + 4] = sx;
				_pos1Vector[i16 + 5] = sy;
				_pos1Vector[i16 + 6] = sz;
				_pos1Vector[i16 + 7] = -1;

				_pos1Vector[i16 + 8] = ex;
				_pos1Vector[i16 + 9] = ey;
				_pos1Vector[i16 + 10] = ez;
				_pos1Vector[i16 + 11] = -1;

				_pos1Vector[i16 + 12] = sx;
				_pos1Vector[i16 + 13] = sy;
				_pos1Vector[i16 + 14] = sz;
				_pos1Vector[i16 + 15] = 1;
			}

			updateBuffer(updateIndices);
		}

		protected function updateBuffer(updateIndices:Boolean = true):void
		{
			_posVector.fixed = true;
			_pos1Vector.fixed = true;

			if (updateIndices)
			{
				_indices.fixed = true;
				_subMesh.setIndices(_indices);
			}

			_subMesh.setVertexBuffer(BufferType.POSITION, 3, _posVector);
			_subMesh.setVertexBuffer(BufferType.POSITION1, 4, _pos1Vector);
			_subMesh.validate();

			this.validate();
		}

		public function removeSegment(segment:WireframeLineSet):Boolean
		{
			return true;
		}
	}

}

