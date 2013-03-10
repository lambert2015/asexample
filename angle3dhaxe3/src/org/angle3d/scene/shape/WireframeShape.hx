package org.angle3d.scene.shape;

import haxe.ds.Vector;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.Mesh;
import org.angle3d.scene.mesh.SubMesh;
using org.angle3d.utils.ArrayUtil;
/**
 * 3角形顺序理的不太清楚
 * @author andy
 */

class WireframeShape extends Mesh
{
	private var _indices:Vector<UInt>;
	
	private var _posVector:Vector<Float>;
	private var _pos1Vector:Vector<Float>;

	private var _segments:Array<WireframeLineSet>;

	private var _subMesh:SubMesh;

	public function new()
	{
		super();

		_subMesh = new SubMesh();
		this.addSubMesh(_subMesh);

		_segments = new Array<WireframeLineSet>();
	}

	public function clearSegment():Void
	{
		_segments = _segments.clear();
	}

	public function addSegment(segment:WireframeLineSet):Void
	{
		_segments.push(segment);
	}

	/**
	 * 生成线框模式需要的数据
	 */
	public function build(updateIndices:Bool = true):Void
	{
		var sLength:Int = _segments.length;
		
		_posVector = new Vector<Float>(sLength * 12);
		_pos1Vector = new Vector<Float>(sLength * 16);
		if (updateIndices)
		{
			_indices = new Vector<UInt>(sLength * 6);
		}

		var indicesSize:Int = 0;
		for (i in 0...sLength)
		{
			var segment:WireframeLineSet = _segments[i];

			var index:Int = i << 2;
			if (updateIndices)
			{
				_indices[indicesSize] = index;
				_indices[indicesSize + 1] = index + 1;
				_indices[indicesSize + 2] = index + 2;
				_indices[indicesSize + 3] = index + 3;
				_indices[indicesSize + 4] = index + 2;
				_indices[indicesSize + 5] = index + 1;
				indicesSize += 6;
			}

			var i12:Int = i * 12;
			var i16:Int = i * 16;

			var sx:Float = segment.sx, sy:Float = segment.sy, sz:Float = segment.sz;
			var ex:Float = segment.ex, ey:Float = segment.ey, ez:Float = segment.ez;

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

		validate();
	}

	private function updateBuffer(updateIndices:Bool = true):Void
	{
		if (updateIndices)
		{
			_subMesh.setIndices(_indices);
		}

		_subMesh.setVertexBuffer(BufferType.POSITION, 3, _posVector);
		_subMesh.setVertexBuffer(BufferType.POSITION1, 4, _pos1Vector);
		_subMesh.validate();

		this.validate();
	}

	public function removeSegment(segment:WireframeLineSet):Bool
	{
		return true;
	}
}

