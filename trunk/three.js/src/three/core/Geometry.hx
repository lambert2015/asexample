package three.core;
import three.math.Matrix4;
import three.math.Vector3;
import three.math.Vector4;
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
	
	public var morphTargets:Array<Dynamic>;
	public var morphColors:Array<Dynamic>;
	public var morphNormals:Array<Dynamic>;
	
	public var skinWeights:Array<Float>;
	public var skinIndices:Array<Int>;
	
	
	public var boundingBox:BoundingBox;
	public var boundingSphere:BoundingSphere;
	
	public var hasTangents:Bool;
	
	public var isDynamic:Bool;
	
	public var __webglVertexBuffer:WebGLBuffer;
	public var __webglColorBuffer:WebGLBuffer;
	
	public var animations:Dynamic;
	public var firstAnimation:String;
	
	public var geometryGroups:Dynamic;
	
	public var geometryGroupsList:Array<Dynamic>;
	
	public var attributes:Dynamic;
	
	public var __webglCustomAttributesList:Array<Dynamic>;
	
	public function new() 
	{
		this.id = GeometryCount++;

		this.name = '';

		this.vertices = [];
		this.colors = [];
		// one-to-one vertex colors, used in ParticleSystem, Line and Ribbon

		this.materials = [];

		this.faces = [];

		this.faceUvs = [];
		this.faceVertexUvs = [[]];

		this.morphTargets = [];
		this.morphColors = [];
		this.morphNormals = [];

		this.skinWeights = [];
		this.skinIndices = [];

		this.boundingBox = null;
		this.boundingSphere = null;

		this.hasTangents = false;

		this.isDynamic = true;// the intermediate typearrays will be deleted when set to false
	}
	
	public function applyMatrix(matrix:Matrix4):Void 
	{
		var matrixRotation:Matrix4 = new Matrix4();
		matrixRotation.extractRotation(matrix);

		for (i in 0...this.vertices.length) 
		{
			var vertex:Vector3 = this.vertices[i];
			matrix.multiplyVector3(vertex);
		}

		for (i in 0...this.faces.length) 
		{
			var face:Face = this.faces[i];

			matrixRotation.multiplyVector3(face.normal);

			for (j in 0...face.vertexNormals.length) 
			{
				matrixRotation.multiplyVector3(face.vertexNormals[j]);
			}

			matrix.multiplyVector3(face.centroid);
		}
	}

	public function computeCentroids():Void 
	{
		var face:Face;

		for ( f in 0...this.faces.length) 
		{
			face = this.faces[f];
			face.centroid.setTo(0, 0, 0);

			if ( Std.is(face,Face3)) 
			{
				face.centroid.addSelf(this.vertices[face.a]);
				face.centroid.addSelf(this.vertices[face.b]);
				face.centroid.addSelf(this.vertices[face.c]);
				face.centroid.divideScalar(3);
			} 
			else if ( Std.is(face,Face4)) 
			{
				var face4:Face4 = cast face;
				face4.centroid.addSelf(this.vertices[face4.a]);
				face4.centroid.addSelf(this.vertices[face4.b]);
				face4.centroid.addSelf(this.vertices[face4.c]);
				face4.centroid.addSelf(this.vertices[face4.d]);
				face4.centroid.divideScalar(4);
			}
		}
	}

	public function computeFaceNormals():Void 
	{
		var face:Face;
		var cb:Vector3 = new Vector3(); 
		var ab:Vector3 = new Vector3();

		for ( f in 0...this.faces.length) 
		{
			face = this.faces[f];

			var vA:Vector3 = this.vertices[face.a];
			var vB:Vector3 = this.vertices[face.b];
			var vC:Vector3 = this.vertices[face.c];

			cb.sub(vC, vB);
			ab.sub(vA, vB);
			cb.crossSelf(ab);

			if (!cb.isZero()) 
			{
				cb.normalize();
			}
			face.normal.copy(cb);
		}
	}

	private var __tmpVertices:Array<Vector3>;
	public function computeVertexNormals():Void 
	{
		var vertices:Array<Vector3>;
		// create internal buffers for reuse when calling this method repeatedly
		// (otherwise memory allocation / deallocation every frame is big resource hog)

		var face:Face;
		if (__tmpVertices == null) 
		{
			__tmpVertices = new Array();
			vertices = __tmpVertices;

			for ( v in 0...this.vertices.length) 
			{
				vertices[v] = new Vector3();
			}

			for ( f in 0...this.faces.length) 
			{
				var face:Face = this.faces[f];

				if ( Std.is(face, Face3)) 
				{
					face.vertexNormals = [new Vector3(), new Vector3(), new Vector3()];
				} 
				else if ( Std.is(face, Face4)) 
				{
					face.vertexNormals = [new Vector3(), new Vector3(), new Vector3(), new Vector3()];
				}

			}

		} 
		else 
		{
			vertices = __tmpVertices;

			for ( v in 0...this.vertices.length)
			{
				vertices[v].setTo(0, 0, 0);
			}
		}

		for ( f in 0...this.faces.length) 
		{
			face = this.faces[f];

			if ( Std.is(face, Face3)) 
			{
				vertices[face.a].addSelf(face.normal);
				vertices[face.b].addSelf(face.normal);
				vertices[face.c].addSelf(face.normal);
			} 
			else if ( Std.is(face, Face4)) 
			{
				var face4:Face4 = cast face;
				vertices[face4.a].addSelf(face4.normal);
				vertices[face4.b].addSelf(face4.normal);
				vertices[face4.c].addSelf(face4.normal);
				vertices[face4.d].addSelf(face4.normal);
			}
		}

		for ( v in 0...this.vertices.length) 
		{
			vertices[v].normalize();
		}

		for ( f in 0...this.faces.length) 
		{
			face = this.faces[f];

			if ( Std.is(face, Face3)) 
			{

				face.vertexNormals[0].copy(vertices[face.a]);
				face.vertexNormals[1].copy(vertices[face.b]);
				face.vertexNormals[2].copy(vertices[face.c]);

			} 
			else if ( Std.is(face, Face4)) 
			{
				var face4:Face4 = cast face;
				face4.vertexNormals[0].copy(vertices[face4.a]);
				face4.vertexNormals[1].copy(vertices[face4.b]);
				face4.vertexNormals[2].copy(vertices[face4.c]);
				face4.vertexNormals[3].copy(vertices[face4.d]);
			}
		}
	}

	public function computeMorphNormals():Void 
	{

		var face:Face;

		// save original normals
		// - create temp variables on first access
		//   otherwise just copy (for faster repeated calls)

		for ( f in 0...this.faces.length) 
		{
			face = this.faces[f];

			if (face.__originalFaceNormal == null) 
			{
				face.__originalFaceNormal = face.normal.clone();
			} 
			else 
			{
				face.__originalFaceNormal.copy(face.normal);
			}

			if (face.__originalVertexNormals == null)
				face.__originalVertexNormals = [];

			for ( i in 0...face.vertexNormals.length) 
			{
				if (face.__originalVertexNormals[i] == null) 
				{
					face.__originalVertexNormals[i] = face.vertexNormals[i].clone();
				} 
				else
				{
					face.__originalVertexNormals[i].copy(face.vertexNormals[i]);
				}
			}
		}

		// use temp geometry to compute face and vertex normals for each morph

		var tmpGeo:Geometry = new Geometry();
		tmpGeo.faces = this.faces;

		for ( i in 0...this.morphTargets.length) 
		{
			// create on first access
			if (this.morphNormals[i] == null) 
			{
				this.morphNormals[i] = {};
				this.morphNormals[i].faceNormals = [];
				this.morphNormals[i].vertexNormals = [];

				var dstNormalsFace = this.morphNormals[i].faceNormals;
				var dstNormalsVertex = this.morphNormals[i].vertexNormals;

				var faceNormal:Vector3; 
				var vertexNormals:Dynamic;

				for ( f in 0...this.faces.length) 
				{
					face = this.faces[f];

					faceNormal = new Vector3();

					if ( Std.is(face, Face3)) 
					{
						vertexNormals = {
							a : new Vector3(),
							b : new Vector3(),
							c : new Vector3()
						};
					} 
					else 
					{
						vertexNormals = {
							a : new Vector3(),
							b : new Vector3(),
							c : new Vector3(),
							d : new Vector3()
						};
					}

					dstNormalsFace.push(faceNormal);
					dstNormalsVertex.push(vertexNormals);
				}
			}

			var morphNormals = this.morphNormals[i];

			// set vertices to morph target
			tmpGeo.vertices = this.morphTargets[i].vertices;

			// compute morph normals

			tmpGeo.computeFaceNormals();
			tmpGeo.computeVertexNormals();

			// store morph normals

			var faceNormal:Vector3; 
			var vertexNormals:Dynamic;

			for ( f in 0...this.faces.length) 
			{
				face = this.faces[f];

				faceNormal = morphNormals.faceNormals[f];
				vertexNormals = morphNormals.vertexNormals[f];

				faceNormal.copy(face.normal);

				if (Std.is(face, Face3)) 
				{
					vertexNormals.a.copy(face.vertexNormals[0]);
					vertexNormals.b.copy(face.vertexNormals[1]);
					vertexNormals.c.copy(face.vertexNormals[2]);
				} 
				else 
				{
					vertexNormals.a.copy(face.vertexNormals[0]);
					vertexNormals.b.copy(face.vertexNormals[1]);
					vertexNormals.c.copy(face.vertexNormals[2]);
					vertexNormals.d.copy(face.vertexNormals[3]);
				}
			}
		}

		// restore original normals

		for ( f in 0...this.faces.length) 
		{
			face = this.faces[f];

			face.normal = face.__originalFaceNormal;
			face.vertexNormals = face.__originalVertexNormals;
		}
	}
	
	private function handleTriangle(context:Geometry, 
								a:Int, b:Int, c:Int, 
								ua:Int, ub:Int, uc:Int,
								uv:Array<UV>,
								tan1:Array<Vector3>,tan2:Array<Vector3>) 
	{
		var vA:Vector3 = context.vertices[a];
		var vB:Vector3 = context.vertices[b];
		var vC:Vector3 = context.vertices[c];

		var uvA:UV = uv[ua];
		var uvB:UV = uv[ub];
		var uvC:UV = uv[uc];

		var x1:Float = vB.x - vA.x;
		var x2:Float = vC.x - vA.x;
		var y1:Float = vB.y - vA.y;
		var y2:Float = vC.y - vA.y;
		var z1:Float = vB.z - vA.z;
		var z2:Float = vC.z - vA.z;

		var s1:Float = uvB.u - uvA.u;
		var s2:Float = uvC.u - uvA.u;
		var t1:Float = uvB.v - uvA.v;
		var t2:Float = uvC.v - uvA.v;

		var r:Float = 1.0 / (s1 * t2 - s2 * t1 );
		var sdir:Vector3 = new Vector3();
		var tdir:Vector3 = new Vector3();
		sdir.setTo((t2 * x1 - t1 * x2 ) * r, (t2 * y1 - t1 * y2 ) * r, (t2 * z1 - t1 * z2 ) * r);
		tdir.setTo((s1 * x2 - s2 * x1 ) * r, (s1 * y2 - s2 * y1 ) * r, (s1 * z2 - s2 * z1 ) * r);

		tan1[a].addSelf(sdir);
		tan1[b].addSelf(sdir);
		tan1[c].addSelf(sdir);

		tan2[a].addSelf(tdir);
		tan2[b].addSelf(tdir);
		tan2[c].addSelf(tdir);
	}

	public function computeTangents():Void 
	{

		// based on http://www.terathon.com/code/tangent.html
		// tangents go to vertices

		var face:Face;
		var uv:Array<UV>;
		var tan1:Array<Vector3> = [];
		var tan2:Array<Vector3> = [];
		for ( v in 0...this.vertices.length) 
		{
			tan1[v] = new Vector3();
			tan2[v] = new Vector3();
		}

		for ( f in 0...this.faces.length) 
		{
			face = this.faces[f];
			uv = this.faceVertexUvs[ 0 ][f];
			// use UV layer 0 for tangents

			if (Std.is(face, Face3))
			{
				handleTriangle(this, face.a, face.b, face.c, 0, 1, 2, uv, tan1, tan2);
			} 
			else if (Std.is(face, Face4)) 
			{
				var face4:Face4 = cast face;
				handleTriangle(this, face4.a, face4.b, face4.d, 0, 1, 3, uv, tan1, tan2);
				handleTriangle(this, face4.b, face4.c, face4.d, 1, 2, 3, uv, tan1, tan2);
			}

		}

		var faceIndex:Array<String> = ['a', 'b', 'c', 'd'];

		var n:Vector3 = new Vector3();
		var vertexIndex:Int;
		var t:Vector3;
		var tmp:Vector3 = new Vector3();
		var tmp2:Vector3 = new Vector3();
		for ( f in 0...this.faces.length) 
		{
			face = this.faces[f];

			for ( i in 0...face.vertexNormals.length) 
			{
				n.copy(face.vertexNormals[i]);

				vertexIndex = untyped face[faceIndex[i]];

				t = tan1[vertexIndex];

				// Gram-Schmidt orthogonalize

				tmp.copy(t);
				tmp.subSelf(n.multiplyScalar(n.dot(t))).normalize();

				// Calculate handedness

				tmp2.cross(face.vertexNormals[i], t);
				var test:Float = tmp2.dot(tan2[vertexIndex]);
				var w:Float = (test < 0.0) ? -1.0 : 1.0;

				face.vertexTangents[i] = new Vector4(tmp.x, tmp.y, tmp.z, w);
			}
		}

		this.hasTangents = true;
	}

	public function computeBoundingBox():Void 
	{
		if (this.boundingBox == null) 
		{
			this.boundingBox = new BoundingBox();
		}

		this.boundingBox.computeFromVertexs(this.vertices);
	}

	public function computeBoundingSphere():Void 
	{
		if (this.boundingSphere == null)
			this.boundingSphere = new BoundingSphere();

		boundingSphere.computeFromVertexs(this.vertices);
	}

	/*
	 * Checks for duplicate vertices with hashmap.
	 * Duplicated vertices are removed
	 * and faces' vertices are updated.
	 */

	public function mergeVertices():Int 
	{
		var verticesMap:Dynamic = {};
		// Hashmap for looking up vertice by position coordinates (and making sure they
		// are unique)
		var unique = [], changes = [];

		var v:Vector3; 
		var key:String;
		var precisionPoints:Int = 4;
		// number of decimal points, eg. 4 for epsilon of 0.0001
		var precision:Float = Math.pow(10, precisionPoints);
		var face:Face;
		var abcd:String = 'abcd';
		var o:Array<Int>;
		var k:Int;
		
		for ( i in 0...this.vertices.length) 
		{
			v = this.vertices[i];
			key = [Math.round(v.x * precision), Math.round(v.y * precision), Math.round(v.z * precision)].join('_');

			if (untyped verticesMap[key] == null) 
			{
				untyped verticesMap[key] = i;
				unique.push(this.vertices[i]);
				changes[i] = unique.length - 1;
			} 
			else 
			{
				//console.log('Duplicate vertex found. ', i, ' could be using ',
				// verticesMap[key]);
				changes[i] = changes[untyped verticesMap[key]];
			}
		}

		// Start to patch face indices
		var u:Array<UV>;
		for ( i in 0...this.faces.length) 
		{
			face = this.faces[i];

			if ( Std.is(face, Face3)) 
			{
				face.a = changes[face.a];
				face.b = changes[face.b];
				face.c = changes[face.c];
			} 
			else if (Std.is(face, Face4)) 
			{
				var face4:Face4 = cast face;
				face4.a = changes[face4.a];
				face4.b = changes[face4.b];
				face4.c = changes[face4.c];
				face4.d = changes[face4.d];

				// check dups in (a, b, c, d) and convert to -> face3

				o = [face4.a, face4.b, face4.c, face4.d];

				k = 3;
				while(k > 0)
				{
					var faceIndex:Int = untyped face[abcd[k]];
					if (untyped o.indexOf(faceIndex) != k) 
					{
						// console.log('faces', face.a, face.b, face.c, face.d, 'dup at', k);
						o.splice(k, 1);

						this.faces[i] = new Face3(o[0], o[1], o[2], face.normal, face.color, face.materialIndex);

						for ( j in 0...this.faceVertexUvs.length) 
						{
							u = this.faceVertexUvs[ j ][i];
							if (u != null)
								u.splice(k, 1);
						}

						this.faces[i].vertexColors = face.vertexColors;
						break;
					}
					
					k--;
				}
			}
		}

		// Use unique set of vertices
		var diff:Int = this.vertices.length - unique.length;
		this.vertices = unique;
		return diff;
	}

	public function clone():Geometry
	{
		// TODO
		return null;
	}
}