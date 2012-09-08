package three.objects.shape;
import three.core.BoundingSphere;
import three.core.Geometry;
import three.math.Vector3;
import three.core.UV;
import three.core.Face3;
import three.core.Face4;
/**
 * ...
 * @author andy
 */

class SphereGeometry extends Geometry
{

	public function new(radius:Float = 50, 
						segmentsWidth:Int = 8, segmentsHeight:Int = 6,
						phiStart:Float = 0, phiLength:Float = 6.2832, 
						thetaStart:Float = 0, thetaLength:Float = 3.1416) 
	{
		super();
		
		var segmentsX:Int = segmentsWidth > 3 ? segmentsWidth : 3;
		var segmentsY:Int = segmentsHeight > 2 ? segmentsHeight : 2;

		var indices:Array<Array<Int>> = new Array<Array<Int>>();
		var uvs:Array<Array<UV>> = new Array<Array<UV>>();

		for( y in 0...(segmentsY + 1)) 
		{
			var verticesRow:Array<Int> = [];
			var uvsRow:Array<UV> = [];

			for( x in 0...(segmentsX + 1)) 
			{
				var u:Float = x / segmentsX;
				var v:Float = y / segmentsY;

				var vertex:Vector3 = new Vector3();
				vertex.x = - radius * Math.cos( phiStart + u * phiLength ) * Math.sin( thetaStart + v * thetaLength );
				vertex.y = radius * Math.cos( thetaStart + v * thetaLength );
				vertex.z = radius * Math.sin( phiStart + u * phiLength ) * Math.sin( thetaStart + v * thetaLength );

				this.vertices.push( vertex );

				verticesRow.push( this.vertices.length - 1 );
				uvsRow.push( new UV( u, 1 - v ) );

			}

			indices.push( verticesRow );
			uvs.push( uvsRow );
		}

		for ( y in 0...segmentsY) 
		{
			for (x in 0...segmentsX) 
			{
				var v1:Int = indices[ y ][ x + 1 ];
				var v2:Int = indices[ y ][ x ];
				var v3:Int = indices[ y + 1 ][ x ];
				var v4:Int = indices[ y + 1 ][ x + 1 ];

				var n1:Vector3 = this.vertices[ v1 ].clone().normalize();
				var n2:Vector3 = this.vertices[ v2 ].clone().normalize();
				var n3:Vector3 = this.vertices[ v3 ].clone().normalize();
				var n4:Vector3 = this.vertices[ v4 ].clone().normalize();

				var uv1:UV = uvs[ y ][ x + 1 ].clone();
				var uv2:UV = uvs[ y ][ x ].clone();
				var uv3:UV = uvs[ y + 1 ][ x ].clone();
				var uv4:UV = uvs[ y + 1 ][ x + 1 ].clone();

				if( Math.abs(this.vertices[ v1 ].y ) == radius ) 
				{
					this.faces.push(new Face3(v1, v3, v4, [ n1, n3, n4 ]));
					this.faceVertexUvs[0].push([uv1, uv3, uv4]);

				} 
				else if( Math.abs(this.vertices[ v3 ].y ) ==  radius ) 
				{
					this.faces.push(new Face3(v1, v2, v3, [ n1, n2, n3 ]));
					this.faceVertexUvs[0].push([uv1, uv2, uv3]);
				} 
				else 
				{
					this.faces.push(new Face4(v1, v2, v3, v4, [ n1, n2, n3, n4 ]));
					this.faceVertexUvs[0].push([uv1, uv2, uv3, uv4]);
				}

			}

		}

		this.computeCentroids();
		this.computeFaceNormals();

		this.boundingSphere = new BoundingSphere(radius);
	}
}