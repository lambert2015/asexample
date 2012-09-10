package three.objects.shape;

import three.core.Geometry;
import three.materials.Material;
import three.math.Vector3;
import three.core.UV;
import three.core.Face3;
import three.core.Face4;
/**
 * ...
 * @author 
 */

class CubeGeometry extends Geometry
{
	public var width:Float;
	public var height:Float;
	public var depth:Float;
	public var segmentsWidth:Int;
	public var segmentsHeight:Int;
	public var segmentsDepth:Int;
	public var sides:Dynamic;

	public function new(width:Float,height:Float, depth:Float,
						segmentsWidth:Int, segmentsHeight:Int,segmentsDepth:Int,
						materials:Dynamic,sides:Dynamic) 
	{
		super();
		
		this.width = width;
		this.height = height;
		this.depth = depth;
		this.segmentsWidth = segmentsWidth   < 1 ? 1 : segmentsWidth;
		this.segmentsHeight = segmentsHeight < 1 ? 1 : segmentsHeight;
		this.segmentsDepth = segmentsDepth 	 < 1 ? 1 : segmentsDepth;
		
		
		var scope = this,
		width_half = width / 2,
		height_half = height / 2,
		depth_half = depth / 2;

		var mpx:Int=0, mpy:Int=0, mpz:Int=0, mnx:Int=0, mny:Int=0, mnz:Int=0;

		if ( materials != null ) 
		{
			if ( Std.is(materials, Array) ) 
			{
				this.materials = materials;
			} 
			else 
			{
				this.materials = [];
				for ( i in 0...6) 
				{
					this.materials.push( materials );
				}
			}

			mpx = 0; mnx = 1; mpy = 2; mny = 3; mpz = 4; mnz = 5;
		} 
		else 
		{
			this.materials = [];
		}

		this.sides = { px: true, nx: true, py: true, ny: true, pz: true, nz: true };

		if ( sides != null ) 
		{
			var fields:Array<String> = Type.getClassFields(sides);
			for (key in fields)
			{
				if ( untyped this.sides[key] != null ) 
				{
					untyped this.sides[key] = sides[key];
				}
			}
		}

		if (this.sides.px)
			buildPlane( 'z', 'y', - 1, - 1, depth, height, width_half, mpx ); // px
		if (this.sides.nx) 
			buildPlane( 'z', 'y',   1, - 1, depth, height, - width_half, mnx ); // nx
		if (this.sides.py) 
			buildPlane( 'x', 'z',   1,   1, width, depth, height_half, mpy ); // py
		if (this.sides.ny) 
			buildPlane( 'x', 'z',   1, - 1, width, depth, - height_half, mny ); // ny
		if (this.sides.pz) 
			buildPlane( 'x', 'y',   1, - 1, width, height, depth_half, mpz ); // pz
		if (this.sides.nz) 
			buildPlane( 'x', 'y', - 1, - 1, width, height, - depth_half, mnz ); // nz

		this.computeCentroids();
		this.mergeVertices();
	}
	
	public function buildPlane( u:String, v:String, 
								udir:Float, vdir:Float, 
								width:Float, height:Float, depth:Float, 
								material:Int ):Void
	{
		var w:String = "";
		var gridX:Int = segmentsWidth;
		var gridY:Int = segmentsHeight;
		var width_half:Float = width / 2;
		var height_half:Float = height / 2;
		var offset:Int = this.vertices.length;

		if ( ( u == 'x' && v == 'y' ) || ( u == 'y' && v == 'x' ) ) 
		{
			w = 'z';
		} 
		else if ( ( u == 'x' && v == 'z' ) || ( u == 'z' && v == 'x' ) ) 
		{
			w = 'y';
			gridY = segmentsDepth;
		} 
		else if ( ( u == 'z' && v == 'y' ) || ( u == 'y' && v == 'z' ) ) 
		{
			w = 'x';
			gridX = segmentsDepth;
		}

		var gridX1:Int = gridX + 1;
		var gridY1:Int = gridY + 1;
		var segment_width:Float = width / gridX;
		var segment_height:Float = height / gridY;
		var normal:Vector3 = new Vector3();

		untyped normal[w] = depth > 0 ? 1 : - 1;

		for ( iy in 0...gridY1 ) 
		{
			for ( ix in 0...gridX1 ) 
			{
				var vector = new Vector3();
				untyped vector[ u ] = ( ix * segment_width - width_half ) * udir;
				untyped vector[ v ] = ( iy * segment_height - height_half ) * vdir;
				untyped vector[ w ] = depth;
				this.vertices.push( vector );
			}
		}

		for (iy in 0...gridY) 
		{
			for (ix in 0...gridX) 
			{
				var a:Int = ix + gridX1 * iy;
				var b:Int = ix + gridX1 * ( iy + 1 );
				var c:Int = ( ix + 1 ) + gridX1 * ( iy + 1 );
				var d:Int = ( ix + 1 ) + gridX1 * iy;

				var face:Face4 = new Face4( a + offset, b + offset, c + offset, d + offset );
				face.normal.copy( normal );
				face.vertexNormals.push( normal.clone());
				face.vertexNormals.push( normal.clone());
				face.vertexNormals.push( normal.clone());
				face.vertexNormals.push( normal.clone());
				face.materialIndex = material;

				this.faces.push( face );
				this.faceVertexUvs[ 0 ].push( [
							new UV( ix / gridX, 1 - iy / gridY ),
							new UV( ix / gridX, 1 - ( iy + 1 ) / gridY ),
							new UV( ( ix + 1 ) / gridX, 1- ( iy + 1 ) / gridY ),
							new UV( ( ix + 1 ) / gridX, 1 - iy / gridY )
						] );

			}
		}

	}
	
}