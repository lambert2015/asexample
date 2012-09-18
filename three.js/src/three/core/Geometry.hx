package three.core;
import three.math.Vector3;
import three.math.Color;
import three.materials.Material;
import UserAgentContext;
/**
 * ...
 * @author andy
 */

class Geometry 
{
	public static var GeometryCount:Int = 0;

	public var id:Int;
	public var name:String;
	
	public var vertices:Array<Vector3>;
	
	// one-to-one vertex colors, used in ParticleSystem, Line and Ribbon
	public var colors:Array<Color>;
	
	public var materials:Array<Material>;
	
	public var faces:Array<Face>;
	
	public var faceUvs:Array<UV>;
	public var faceVertexUvs:Array<Array<Array<UV>>>;
	
	public var boundingSphere:BoundingSphere;
	
	public var __webglVertexBuffer:WebGLBuffer;
	public var __webglColorBuffer:WebGLBuffer;
	
	public var geometryGroups:Array<Dynamic>;
	public function new() 
	{
		
	}
	
	public function computeCentroids():Void
	{
		
	}
	
	public function computeFaceNormals():Void
	{
		
	}
	
	public function mergeVertices():Void
	{
		
	}
	
}