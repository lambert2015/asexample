package org.angle3d.scene.debug;
import flash.Vector;
import org.angle3d.math.Color;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.IndexBuffer;
import org.angle3d.scene.mesh.Mesh;
import org.angle3d.scene.mesh.VertexBuffer;
import quake3.core.Vertex;

/**
 * ...
 * @author andy
 */

class WireframeShape extends Mesh
{
	private var _posVector:Vector<Float>;
	private var _pos1Vector:Vector<Float>;
	private var _thicknessVector:Vector<Float>;
	private var _colorVector:Vector<Float>;
	
	private var _indices:Vector<UInt>;
	
	private var _segments:Vector<LineSegment>;

	public function new() 
	{
		super();

		_segments = new Vector<LineSegment>();
	}
	
	public function addSegment(segment:LineSegment):Void
	{
		_segments.push(segment);
	}
	
	public function build():Void
	{
		_posVector = new Vector<Float>();
		_pos1Vector = new Vector<Float>();
		_thicknessVector = new Vector<Float>();
		_colorVector = new Vector<Float>();
		
		_indices = new Vector<UInt>();
		
		var startColor:Color = new Color();
		var endColor:Color = new Color();
		
		for (i in 0..._segments.length)
		{
			var segment:LineSegment = _segments[i];
			
			var index:UInt = i << 2;
			_indices.push(index);
			_indices.push(index + 1);
			_indices.push(index + 2);
			_indices.push(index + 3);
			_indices.push(index + 2);
			_indices.push(index + 1);
		
			var start:Vector3f = segment.start;
			var end:Vector3f = segment.end;
			var thickness:Float = segment.thickness;
			
			startColor.setColor(segment.startColor);
			endColor.setColor(segment.endColor);
		
			var count:Int = i * 12;
			
			//pos
			_posVector[count + 0] = start.x;
			_posVector[count + 1] = start.y;
			_posVector[count + 2] = start.z;
		
			_posVector[count + 3] = end.x;
			_posVector[count + 4] = end.y;
			_posVector[count + 5] = end.z;
		
			_posVector[count + 6] = start.x;
			_posVector[count + 7] = start.y;
			_posVector[count + 8] = start.z;
		
			_posVector[count + 9] = end.x;
			_posVector[count + 10] = end.y;
			_posVector[count + 11] = end.z;
			
			//pos1
			_pos1Vector[count + 0] = end.x;
			_pos1Vector[count + 1] = end.y;
			_pos1Vector[count + 2] = end.z;
		
			_pos1Vector[count + 3] = start.x;
			_pos1Vector[count + 4] = start.y;
			_pos1Vector[count + 5] = start.z;
		
			_pos1Vector[count + 6] = end.x;
			_pos1Vector[count + 7] = end.y;
			_pos1Vector[count + 8] = end.z;
		
			_pos1Vector[count + 9] = start.x;
			_pos1Vector[count + 10] = start.y;
			_pos1Vector[count + 11] = start.z;
			
			//color
			_colorVector[count + 0] = startColor.r;
			_colorVector[count + 1] = startColor.g;
			_colorVector[count + 2] = startColor.b;
		
			_colorVector[count + 3] = endColor.r;
			_colorVector[count + 4] = endColor.g;
			_colorVector[count + 5] = endColor.b;
		
			_colorVector[count + 6] = startColor.r;
			_colorVector[count + 7] = startColor.g;
			_colorVector[count + 8] = startColor.b;
		
			_colorVector[count + 9] = endColor.r;
			_colorVector[count + 10] = endColor.g;
			_colorVector[count + 11] = endColor.b;
			
			//thickness
			count = i * 4;
			_thicknessVector[count + 0] = thickness;
			_thicknessVector[count + 1] = -thickness;
			_thicknessVector[count + 2] = -thickness;
			_thicknessVector[count + 3] = thickness;
		}

		var buffer:IndexBuffer = new IndexBuffer();
		buffer.setData(_indices);
		setIndexBuffer(buffer);
		
		setVertexBuffer(BufferType.Position,3, _posVector);
		setVertexBuffer(BufferType.Position1,3, _pos1Vector);
		setVertexBuffer(BufferType.Thickness,1, _thicknessVector);
		setVertexBuffer(BufferType.Color, 3, _colorVector);
	}
	
	public function removeSegment(segment:LineSegment):Bool
	{
		return true;
	}
	
}