package org.angle3d.scene.shape;
import flash.Vector;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.IndexBuffer;
import org.angle3d.scene.mesh.Mesh;

/**
 * 3角形顺序理的不太清楚
 * @author andy
 */

class WireframeShape extends Mesh
{
	private var _posVector:Vector<Float>;
	private var _pos1Vector:Vector<Float>;
	private var _thicknessVector:Vector<Float>;

	private var _indices:Vector<UInt>;
	
	private var _segments:Vector<LineSet>;

	public function new() 
	{
		super();

		_segments = new Vector<LineSet>();
	}
	
	public function addSegment(segment:LineSet):Void
	{
		_segments.push(segment);
	}
	
	public function build():Void
	{
		_posVector = new Vector<Float>();
		_pos1Vector = new Vector<Float>();
		_thicknessVector = new Vector<Float>();

		_indices = new Vector<UInt>();
		
		for (i in 0..._segments.length)
		{
			var segment:LineSet = _segments[i];
			
			var index:UInt = i << 2;
			_indices.push(index);
			_indices.push(index + 1);
			_indices.push(index + 2);
			_indices.push(index + 3);
			_indices.push(index + 2);
			_indices.push(index + 1);
		
			var count:Int = i * 12;
			
			var sx:Float = segment.sx, sy:Float = segment.sy, sz:Float = segment.sz;
			var ex:Float = segment.ex, ey:Float = segment.ey, ez:Float = segment.ez;
			
			//pos
			_posVector[count + 0] = sx;
			_posVector[count + 1] = sy;
			_posVector[count + 2] = sz;
		
			_posVector[count + 3] = ex;
			_posVector[count + 4] = ey;
			_posVector[count + 5] = ez;
		
			_posVector[count + 6] = sx;
			_posVector[count + 7] = sy;
			_posVector[count + 8] = sz;
		
			_posVector[count + 9] = ex;
			_posVector[count + 10] = ey;
			_posVector[count + 11] = ez;
			
			//pos1
			_pos1Vector[count + 0] = ex;
			_pos1Vector[count + 1] = ey;
			_pos1Vector[count + 2] = ez;
		
			_pos1Vector[count + 3] = sx;
			_pos1Vector[count + 4] = sy;
			_pos1Vector[count + 5] = sz;
		
			_pos1Vector[count + 6] = ex;
			_pos1Vector[count + 7] = ey;
			_pos1Vector[count + 8] = ez;
		
			_pos1Vector[count + 9] = sx;
			_pos1Vector[count + 10] = sy;
			_pos1Vector[count + 11] = sz;
			
			//thickness
			count = i * 4;
			_thicknessVector[count + 0] = 1;
			_thicknessVector[count + 1] = -1;
			_thicknessVector[count + 2] = -1;
			_thicknessVector[count + 3] = 1;
		}

		var buffer:IndexBuffer = new IndexBuffer();
		buffer.setData(_indices);
		setIndexBuffer(buffer);
		
		setVertexBuffer(BufferType.Position,3, _posVector);
		setVertexBuffer(BufferType.Position1,3, _pos1Vector);
		setVertexBuffer(BufferType.Thickness, 1, _thicknessVector);
		
		updateBound();
	}
	
	public function removeSegment(segment:LineSet):Bool
	{
		return true;
	}
	
}