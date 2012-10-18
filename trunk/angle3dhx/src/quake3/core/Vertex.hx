package quake3.core;
import flash.geom.Vector3D;
import quake3.math.Color;
import org.angle3d.utils.Logger;

class Vertex
{
	//position
	public var x : Float;
	public var y : Float;
	public var z : Float;
	//normal
	public var nx : Float;
	public var ny : Float;
	public var nz : Float;
	//color
	public var a : Float;
	public var r : Float;
	public var g : Float;
	public var b : Float;
	//uv
	public var u : Float;
	public var v : Float;
    //lightmap
	public var u2 : Float;
	public var v2 : Float;
	
	public function new()
	{
	}
	
	public function setColor(color:UInt):Void
	{
		a = (color >> 24 & 0xFF) / 0xFF;
		r = (color >> 16 & 0xFF) / 0xFF;
		g = (color >> 8 & 0xFF) / 0xFF;
		b = (color & 0xFF) / 0xFF;
	}

	public inline function copy(other : Vertex) : Void
	{
		x = other.x;
		y = other.y;
		z = other.z;
		nx = other.nx;
		ny = other.ny;
		nz = other.nz;
		a = other.a;
		r = other.r;
		g = other.g;
		b = other.b;
		u = other.u;
		v = other.v;
		u2 = other.u2;
		v2 = other.v2;
	}
	
	public inline function clone() : Vertex
	{
		var vertex : Vertex = new Vertex();
		vertex.copy(this);
		return vertex;
	}
}
