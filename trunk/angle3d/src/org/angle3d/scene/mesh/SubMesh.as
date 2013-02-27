package org.angle3d.scene.mesh
{
	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.Dictionary;

	import org.angle3d.bounding.BoundingBox;
	import org.angle3d.bounding.BoundingVolume;
	import org.angle3d.collision.Collidable;
	import org.angle3d.collision.CollisionResults;
	import org.angle3d.collision.bih.BIHTree;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Triangle;
	import org.angle3d.collision.CollisionData;
	import org.angle3d.utils.Assert;

	/**
	 * SubMesh is used to store rendering data.
	 * <p>
	 * All visible elements in a scene are represented by meshes.
	 */
	//TODO 目前有个问题，Shader中Attribute的顺序可能和这里的不同，这时候该根据那个作为标准呢
	//TODO 合并后对某些Shader可能会有问题，因为数据可能不搭配。
	//合并有许多问题，暂时不使用
	public class SubMesh
	{
		protected var collisionTree:CollisionData;

		public var mesh:Mesh;

		/**
		 * The bounding volume that contains the mesh entirely.
		 * By default a BoundingBox (AABB).
		 */
		protected var mBound:BoundingVolume;

		protected var mBufferMap:Dictionary; //<String,VertexBuffer>

		protected var mIndices:Vector.<uint>;
		protected var _indexBuffer3D:IndexBuffer3D;

		protected var _merge:Boolean;

		//合并时使用
		protected var _vertexData:Vector.<Number>;
		protected var _vertexBuffer3D:VertexBuffer3D;

		//不合并时使用
		protected var _vertexBuffer3DMap:Dictionary;

		public function SubMesh()
		{
			mBound = new BoundingBox();

			mBufferMap = new Dictionary();

			merge = false;
		}

		public function validate():void
		{
			updateBound();
		}

		/**
		 * Generates a collision tree for the mesh.
		 */
		private function createCollisionData():void
		{
			var tree:BIHTree = new BIHTree(this);
			tree.construct();
			collisionTree = tree;
		}

		public function collideWith(other:Collidable, worldMatrix:Matrix4f, worldBound:BoundingVolume, results:CollisionResults):int
		{
			if (collisionTree == null)
			{
				createCollisionData();
			}

			return collisionTree.collideWith(other, worldMatrix, worldBound, results);
		}

		/**
		 * 数据是否合并为一个VertexBuffer3D提交给GPU
		 */
		public function get merge():Boolean
		{
			return _merge;
		}

		public function set merge(value:Boolean):void
		{
			_merge = value;
			if (!_merge)
			{
				_vertexBuffer3DMap = new Dictionary();

				if (_vertexBuffer3D != null)
				{
					_vertexBuffer3D.dispose();
					_vertexBuffer3D = null;
				}
			}
		}

		public function getIndexBuffer3D(context:Context3D):IndexBuffer3D
		{
			if (_indexBuffer3D == null)
			{
				_indexBuffer3D = context.createIndexBuffer(mIndices.length);
				_indexBuffer3D.uploadFromVector(mIndices, 0, mIndices.length);
			}
			return _indexBuffer3D;
		}

		/**
		 * 不同Shader可能会生成不同的VertexBuffer3D
		 *
		 */
		public function getVertexBuffer3D(context:Context3D, type:String):VertexBuffer3D
		{
			//合并到一个VertexBuffer3D中
			//FIXME 需要判断有数据变化时进行重新合并
			if (_merge)
			{
				if (_vertexBuffer3D == null)
				{
					var vertCount:int = getVertexCount();
					_vertexData = getCombineData();
					_vertexBuffer3D = context.createVertexBuffer(vertCount, _getData32PerVertex());
					_vertexBuffer3D.uploadFromVector(_vertexData, 0, vertCount);
				}
				return _vertexBuffer3D;
			}

			if (_vertexBuffer3DMap == null)
				_vertexBuffer3DMap = new Dictionary();

			var buffer3D:VertexBuffer3D;
			var buffer:VertexBuffer;

			buffer = getVertexBuffer(type);
			//buffer更改过数据，需要重新上传数据
			if (buffer.dirty)
			{
				vertCount = getVertexCount();

				buffer3D = _vertexBuffer3DMap[type];
				if (buffer3D == null)
				{
					buffer3D = context.createVertexBuffer(vertCount, buffer.components);
					_vertexBuffer3DMap[type] = buffer3D;
				}

				buffer3D.uploadFromVector(buffer.getData(), 0, vertCount);

				buffer.dirty = false;
			}
			else
			{
				buffer3D = _vertexBuffer3DMap[type];
				if (buffer3D == null)
				{
					vertCount = getVertexCount();
					buffer3D = context.createVertexBuffer(vertCount, buffer.components);
					_vertexBuffer3DMap[type] = buffer3D;

					buffer3D.uploadFromVector(buffer.getData(), 0, vertCount);
				}
			}

			return buffer3D;
		}

		public function getVertexCount():int
		{
			var pb:VertexBuffer = getVertexBuffer(BufferType.POSITION);
			if (pb != null)
				return pb.count;
			return 0;
		}

		protected function getCombineData():Vector.<Number>
		{
			var vertCount:int = getVertexCount();

			var TYPES:Array = BufferType.VERTEX_TYPES;
			var TYPES_SIZE:int = TYPES.length;

			var result:Vector.<Number> = new Vector.<Number>();

			var buffer:VertexBuffer;
			var comps:int;
			var data:Vector.<Number>;
			for (var i:int = 0; i < vertCount; i++)
			{
				for (var j:int = 0; j < TYPES_SIZE; j++)
				{
					buffer = mBufferMap[TYPES[j]];
					if (buffer != null)
					{
						data = buffer.getData();
						comps = buffer.components;
						for (var k:int = 0; k < comps; k++)
						{
							result.push(data[i * comps + k]);
						}
					}
				}
			}

			result.fixed = true;
			return result;
		}

		private function _getData32PerVertex():int
		{
			var count:int = 0;

			var TYPES:Array = BufferType.VERTEX_TYPES;
			var TYPES_SIZE:int = TYPES.length;

			for (var j:int = 0; j < TYPES_SIZE; j++)
			{
				var buffer:VertexBuffer = mBufferMap[TYPES[j]];
				if (buffer != null)
				{
					count += buffer.components;
				}
			}
			return count;
		}

		/**
		 * Updates the bounding volume of this mesh.
		 * The method does nothing if the mesh has no Position buffer.
		 * It is expected that the position buffer is a float buffer with 3 components.
		 */
		public function updateBound():void
		{
			var vb:VertexBuffer = getVertexBuffer(BufferType.POSITION);
			if (mBound != null && vb != null)
			{
				mBound.computeFromPoints(vb.getData());
			}
		}

		/**
		 * Returns the {@link BoundingVolume} of this Mesh.
		 * By default the bounding volume is a {@link BoundingBox}.
		 *
		 * @return the bounding volume of this mesh
		 */
		public function getBound():BoundingVolume
		{
			return mBound;
		}

		public function getVertexBuffer(type:String):VertexBuffer
		{
			return mBufferMap[type];
		}

		public function setVertexBuffer(type:String, components:int, data:Vector.<Number>):void
		{
			CF::DEBUG
			{
				Assert.assert(data != null, "data can not be null");
			}

			var vb:VertexBuffer = mBufferMap[type];
			if (vb == null)
			{
				vb = new VertexBuffer(type);
				mBufferMap[type] = vb;
			}

			vb.setData(data, components);

			if (merge)
			{
				if (_vertexBuffer3D != null)
				{
					_vertexBuffer3D.dispose();
					_vertexBuffer3D = null;
				}
			}
		}

		public function setIndices(indices:Vector.<uint>):void
		{
			mIndices = indices;

			if (_indexBuffer3D != null)
			{
				_indexBuffer3D.dispose();
				_indexBuffer3D = null;
			}
		}

		public function getIndices():Vector.<uint>
		{
			return mIndices;
		}

		public function getTriangle(index:int, tri:Triangle):void
		{
			var pb:VertexBuffer = getVertexBuffer(BufferType.POSITION);
			if (pb != null && mIndices != null)
			{
				var vertices:Vector.<Number> = pb.getData();
				var vertIndex:int = index * 3;
				for (var i:int = 0; i < 3; i++)
				{
					BufferUtils.populateFromBuffer(tri.getPoint(i), vertices, mIndices[vertIndex + i]);
				}
			}
		}
	}
}

