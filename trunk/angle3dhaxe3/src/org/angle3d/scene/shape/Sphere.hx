package org.angle3d.scene.shape;

import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.Mesh;
import org.angle3d.scene.mesh.SubMesh;

/**
 * A UV Sphere primitive mesh.
 */
class Sphere extends Mesh
{
	private var _radius:Float;
	private var _segmentsW:uint;
	private var _segmentsH:uint;
	private var _yUp:Bool;

	/**
	 * Creates a new Sphere object.
	 * @param radius The radius of the sphere.
	 * @param segmentsW Defines the number of horizontal segments that make up the sphere. Defaults to 16.
	 * @param segmentsH Defines the number of vertical segments that make up the sphere. Defaults to 12.
	 * @param yUp Defines whether the sphere poles should lay on the Y-axis (true) or on the Z-axis (false).
	 */
	public function new(radius:Float = 50, segmentsW:uint = 16, segmentsH:uint = 12, yUp:Bool = true)
	{
		super();

		_radius = radius;
		_segmentsW = segmentsW;
		_segmentsH = segmentsH;
		_yUp = yUp;


		buildGeometry();
	}

	/**
	 * @inheritDoc
	 */
	private function buildGeometry():Void
	{
		var vertices:Vector<Float>;
		var vertexNormals:Vector<Float>;
		var vertexTangents:Vector<Float>;
		var indices:Vector<UInt>;

		var i:uint, j:uint, triIndex:uint;
		var numVerts:uint = (_segmentsH + 1) * (_segmentsW + 1);

		vertices = new Vector<Float>(numVerts * 3, true);
		vertexNormals = new Vector<Float>(numVerts * 3, true);
		vertexTangents = new Vector<Float>(numVerts * 3, true);
		indices = new Vector<UInt>((_segmentsH - 1) * _segmentsW * 6, true);

		numVerts = 0;
		for (j = 0; j <= _segmentsH; ++j)
		{
			var horangle:Float = Math.PI * j / _segmentsH;
			var z:Float = -_radius * Math.cos(horangle);
			var ringradius:Float = _radius * Math.sin(horangle);

			for (i = 0; i <= _segmentsW; ++i)
			{
				var verangle:Float = 2 * Math.PI * i / _segmentsW;
				var x:Float = ringradius * Math.cos(verangle);
				var y:Float = ringradius * Math.sin(verangle);
				var normLen:Float = 1 / Math.sqrt(x * x + y * y + z * z);
				var tanLen:Float = Math.sqrt(y * y + x * x);

				if (_yUp)
				{
					vertexNormals[numVerts] = x * normLen;
					vertexTangents[numVerts] = tanLen > .007 ? -y / tanLen : 1;
					vertices[numVerts++] = x;
					vertexNormals[numVerts] = -z * normLen;
					vertexTangents[numVerts] = 0;
					vertices[numVerts++] = -z;
					vertexNormals[numVerts] = y * normLen;
					vertexTangents[numVerts] = tanLen > .007 ? x / tanLen : 0;
					vertices[numVerts++] = y;
				}
				else
				{
					vertexNormals[numVerts] = x * normLen;
					vertexTangents[numVerts] = tanLen > .007 ? -y / tanLen : 1;
					vertices[numVerts++] = x;
					vertexNormals[numVerts] = y * normLen;
					vertexTangents[numVerts] = tanLen > .007 ? x / tanLen : 0;
					vertices[numVerts++] = y;
					vertexNormals[numVerts] = z * normLen;
					vertexTangents[numVerts] = 0;
					vertices[numVerts++] = z;
				}

				if (i > 0 && j > 0)
				{
					var a:Int = (_segmentsW + 1) * j + i;
					var b:Int = (_segmentsW + 1) * j + i - 1;
					var c:Int = (_segmentsW + 1) * (j - 1) + i - 1;
					var d:Int = (_segmentsW + 1) * (j - 1) + i;

					if (j == _segmentsH)
					{
						indices[triIndex++] = a;
						indices[triIndex++] = c;
						indices[triIndex++] = d;
					}
					else if (j == 1)
					{
						indices[triIndex++] = a;
						indices[triIndex++] = b;
						indices[triIndex++] = c;
					}
					else
					{
						indices[triIndex++] = a;
						indices[triIndex++] = b;
						indices[triIndex++] = c;
						indices[triIndex++] = a;
						indices[triIndex++] = c;
						indices[triIndex++] = d;
					}
				}
			}
		}

		var numUvs:uint = (_segmentsH + 1) * (_segmentsW + 1) * 2;
		var uvData:Vector<Float> = new Vector<Float>(numUvs, true);
		numUvs = 0;
		for (j = 0; j <= _segmentsH; ++j)
		{
			for (i = 0; i <= _segmentsW; ++i)
			{
				uvData[numUvs++] = i / _segmentsW;
				uvData[numUvs++] = j / _segmentsH;
			}
		}


		var subMesh:SubMesh = new SubMesh();
		subMesh.setVertexBuffer(BufferType.POSITION, 3, vertices);
		subMesh.setVertexBuffer(BufferType.TEXCOORD, 2, uvData);
		subMesh.setVertexBuffer(BufferType.NORMAL, 3, vertexNormals);
		subMesh.setVertexBuffer(BufferType.TANGENT, 3, vertexTangents);
		subMesh.setIndices(indices);
		subMesh.validate();
		this.addSubMesh(subMesh);
		validate();
	}

	/**
	 * The radius of the sphere.
	 */
	public function get radius():Float
	{
		return _radius;
	}

	public function set radius(value:Float):Void
	{
		_radius = value;
		buildGeometry();
	}

	/**
	 * Defines the number of horizontal segments that make up the sphere. Defaults to 16.
	 */
	public function get segmentsW():uint
	{
		return _segmentsW;
	}

	public function set segmentsW(value:uint):Void
	{
		_segmentsW = value;
		buildGeometry();
	}

	/**
	 * Defines the number of vertical segments that make up the sphere. Defaults to 12.
	 */
	public function get segmentsH():uint
	{
		return _segmentsH;
	}

	public function set segmentsH(value:uint):Void
	{
		_segmentsH = value;
		buildGeometry();
	}

	/**
	 * Defines whether the sphere poles should lay on the Y-axis (true) or on the Z-axis (false).
	 */
	public function get yUp():Bool
	{
		return _yUp;
	}

	public function set yUp(value:Bool):Void
	{
		_yUp = value;
		buildGeometry();
	}
}
