package org.angle3d.scene.shape
{
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.SubMesh;

	/**
	 * A UV Sphere primitive mesh.
	 */
	public class Sphere extends Mesh
	{
		private var _radius:Number;
		private var _segmentsW:uint;
		private var _segmentsH:uint;
		private var _yUp:Boolean;

		/**
		 * Creates a new Sphere object.
		 * @param radius The radius of the sphere.
		 * @param segmentsW Defines the number of horizontal segments that make up the sphere. Defaults to 16.
		 * @param segmentsH Defines the number of vertical segments that make up the sphere. Defaults to 12.
		 * @param yUp Defines whether the sphere poles should lay on the Y-axis (true) or on the Z-axis (false).
		 */
		public function Sphere(radius:Number=50, segmentsW:uint=16, segmentsH:uint=12, yUp:Boolean=true)
		{
			super();

			_radius=radius;
			_segmentsW=segmentsW;
			_segmentsH=segmentsH;
			_yUp=yUp;


			buildGeometry();
		}

		/**
		 * @inheritDoc
		 */
		private function buildGeometry():void
		{
			var vertices:Vector.<Number>;
			var vertexNormals:Vector.<Number>;
			var vertexTangents:Vector.<Number>;
			var indices:Vector.<uint>;

			var i:uint, j:uint, triIndex:uint;
			var numVerts:uint=(_segmentsH + 1) * (_segmentsW + 1);

			vertices=new Vector.<Number>(numVerts * 3, true);
			vertexNormals=new Vector.<Number>(numVerts * 3, true);
			vertexTangents=new Vector.<Number>(numVerts * 3, true);
			indices=new Vector.<uint>((_segmentsH - 1) * _segmentsW * 6, true);

			numVerts=0;
			for (j=0; j <= _segmentsH; ++j)
			{
				var horangle:Number=Math.PI * j / _segmentsH;
				var z:Number=-_radius * Math.cos(horangle);
				var ringradius:Number=_radius * Math.sin(horangle);

				for (i=0; i <= _segmentsW; ++i)
				{
					var verangle:Number=2 * Math.PI * i / _segmentsW;
					var x:Number=ringradius * Math.cos(verangle);
					var y:Number=ringradius * Math.sin(verangle);
					var normLen:Number=1 / Math.sqrt(x * x + y * y + z * z);
					var tanLen:Number=Math.sqrt(y * y + x * x);

					if (_yUp)
					{
						vertexNormals[numVerts]=x * normLen;
						vertexTangents[numVerts]=tanLen > .007 ? -y / tanLen : 1;
						vertices[numVerts++]=x;
						vertexNormals[numVerts]=-z * normLen;
						vertexTangents[numVerts]=0;
						vertices[numVerts++]=-z;
						vertexNormals[numVerts]=y * normLen;
						vertexTangents[numVerts]=tanLen > .007 ? x / tanLen : 0;
						vertices[numVerts++]=y;
					}
					else
					{
						vertexNormals[numVerts]=x * normLen;
						vertexTangents[numVerts]=tanLen > .007 ? -y / tanLen : 1;
						vertices[numVerts++]=x;
						vertexNormals[numVerts]=y * normLen;
						vertexTangents[numVerts]=tanLen > .007 ? x / tanLen : 0;
						vertices[numVerts++]=y;
						vertexNormals[numVerts]=z * normLen;
						vertexTangents[numVerts]=0;
						vertices[numVerts++]=z;
					}

					if (i > 0 && j > 0)
					{
						var a:int=(_segmentsW + 1) * j + i;
						var b:int=(_segmentsW + 1) * j + i - 1;
						var c:int=(_segmentsW + 1) * (j - 1) + i - 1;
						var d:int=(_segmentsW + 1) * (j - 1) + i;

						if (j == _segmentsH)
						{
							indices[triIndex++]=a;
							indices[triIndex++]=c;
							indices[triIndex++]=d;
						}
						else if (j == 1)
						{
							indices[triIndex++]=a;
							indices[triIndex++]=b;
							indices[triIndex++]=c;
						}
						else
						{
							indices[triIndex++]=a;
							indices[triIndex++]=b;
							indices[triIndex++]=c;
							indices[triIndex++]=a;
							indices[triIndex++]=c;
							indices[triIndex++]=d;
						}
					}
				}
			}

			var numUvs:uint=(_segmentsH + 1) * (_segmentsW + 1) * 2;
			var uvData:Vector.<Number>=new Vector.<Number>(numUvs, true);
			numUvs=0;
			for (j=0; j <= _segmentsH; ++j)
			{
				for (i=0; i <= _segmentsW; ++i)
				{
					uvData[numUvs++]=i / _segmentsW;
					uvData[numUvs++]=j / _segmentsH;
				}
			}


			var subMesh:SubMesh=new SubMesh();
			subMesh.setVertexBuffer(BufferType.POSITION, 3, vertices);
			subMesh.setVertexBuffer(BufferType.TEXCOORD, 2, uvData);
			subMesh.setVertexBuffer(BufferType.NORMAL, 3, vertexNormals);
			subMesh.setVertexBuffer(BufferType.TANGENT, 3, vertexTangents);
			subMesh.setIndices(indices);
			subMesh.validate();
			this.addSubMesh(subMesh);
		}

		/**
		 * The radius of the sphere.
		 */
		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			_radius=value;
			buildGeometry();
		}

		/**
		 * Defines the number of horizontal segments that make up the sphere. Defaults to 16.
		 */
		public function get segmentsW():uint
		{
			return _segmentsW;
		}

		public function set segmentsW(value:uint):void
		{
			_segmentsW=value;
			buildGeometry();
		}

		/**
		 * Defines the number of vertical segments that make up the sphere. Defaults to 12.
		 */
		public function get segmentsH():uint
		{
			return _segmentsH;
		}

		public function set segmentsH(value:uint):void
		{
			_segmentsH=value;
			buildGeometry();
		}

		/**
		 * Defines whether the sphere poles should lay on the Y-axis (true) or on the Z-axis (false).
		 */
		public function get yUp():Boolean
		{
			return _yUp;
		}

		public function set yUp(value:Boolean):void
		{
			_yUp=value;
			buildGeometry();
		}
	}
}
