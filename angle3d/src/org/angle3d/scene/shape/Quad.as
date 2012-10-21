package org.angle3d.scene.shape
{

	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.SubMesh;

	/**
	 * <code>Quad</code> represents a rectangular plane in space
	 * defined by 4 vertices. The quad's lower-left side is contained
	 * at the local space origin (0, 0, 0), while the upper-right
	 * side is located at the width/height coordinates (width, height, 0).
	 *
	 */
	public class Quad extends Mesh
	{
		private var width:Number;
		private var height:Number;

		public function Quad(width:Number, height:Number, flipCoords:Boolean=false)
		{
			super();
			updateGeometry(width, height, flipCoords);
		}

		public function getHeight():Number
		{
			return height;
		}

		public function getWidth():Number
		{
			return width;
		}

		public function updateGeometry(width:Number, height:Number, flipCoords:Boolean=false):void
		{
			this.width=width;
			this.height=height;

			var subMesh:SubMesh=new SubMesh();

			var data:Vector.<Number>=Vector.<Number>([0.0, 0.0, 0.0, width, 0.0, 0.0, width, height, 0.0, 0.0, height, 0.0]);
			subMesh.setVertexBuffer(BufferType.POSITION, 3, data);

			if (flipCoords)
			{
				data=Vector.<Number>([0.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0]);
			}
			else
			{
				data=Vector.<Number>([0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 0.0, 1.0]);
			}
			subMesh.setVertexBuffer(BufferType.TEXCOORD, 2, data);

			data=Vector.<Number>([0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0]);
			subMesh.setVertexBuffer(BufferType.NORMAL, 3, data);

			data=Vector.<Number>([1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0]);
			subMesh.setVertexBuffer(BufferType.COLOR, 3, data);

			var indices:Vector.<uint>;
			if (height < 0)
			{
				indices=Vector.<uint>([0, 2, 1, 0, 3, 2]);
			}
			else
			{
				indices=Vector.<uint>([0, 1, 2, 0, 2, 3]);
			}

			subMesh.setIndices(indices);

			subMesh.validate();
			this.addSubMesh(subMesh);
		}
	}
}

