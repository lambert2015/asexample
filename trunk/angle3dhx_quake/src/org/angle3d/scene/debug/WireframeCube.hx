package org.angle3d.scene.debug;
import org.angle3d.math.Color;
import org.angle3d.math.Vector3f;

/**
 * ...
 * @author andy
 */

class WireframeCube extends WireframeShape
{
	private var _width : Float;
	private var _height : Float;
	private var _depth : Float;
	private var _color : UInt;
	private var _thickness : Float;

	public function new(width : Float, height : Float, depth : Float, color:UInt = 0xFFFFFF, thickness:Float = 1) 
	{
		super();
		
		this._width = width;
		this._height = height;
		this._depth = depth;
		this._thickness = thickness;
		
		this._color = color;

		setupGeometry();
		build();
		updateBound();
	}
	
	private function setupGeometry():Void
	{
		var hw : Float = _width * 0.5;
		var hh : Float = _height * 0.5;
		var hd : Float = _depth * 0.5;
			
		addSegment(new LineSegment(new Vector3f( -hw, hh, -hd), new Vector3f( -hw, -hh, -hd), _color, _color, _thickness));
		addSegment(new LineSegment(new Vector3f( -hw, hh, hd), new Vector3f( -hw, -hh, hd), _color, _color, _thickness));
		addSegment(new LineSegment(new Vector3f( hw, hh, hd), new Vector3f( hw, -hh, hd), _color, _color, _thickness));
		addSegment(new LineSegment(new Vector3f( hw, hh, -hd), new Vector3f( hw, -hh, -hd), _color, _color, _thickness));
		
		addSegment(new LineSegment(new Vector3f( -hw, -hh, -hd), new Vector3f( hw, -hh, -hd), _color, _color, _thickness));
		addSegment(new LineSegment(new Vector3f( -hw, hh, -hd), new Vector3f( hw, hh, -hd), _color, _color, _thickness));
		addSegment(new LineSegment(new Vector3f( -hw, hh, hd), new Vector3f( hw, hh, hd), _color, _color, _thickness));
		addSegment(new LineSegment(new Vector3f( -hw, -hh, hd), new Vector3f( hw, -hh, hd), _color, _color, _thickness));
		
		addSegment(new LineSegment(new Vector3f( -hw, -hh, -hd), new Vector3f( -hw, -hh, hd), _color, _color, _thickness));
		addSegment(new LineSegment(new Vector3f( -hw, hh, -hd), new Vector3f( -hw, hh, hd), _color, _color, _thickness));
		addSegment(new LineSegment(new Vector3f( hw, hh, -hd), new Vector3f( hw, hh, hd), _color, _color, _thickness));
		addSegment(new LineSegment(new Vector3f( hw, -hh, -hd), new Vector3f( hw, -hh, hd), _color, _color, _thickness));
	}
}