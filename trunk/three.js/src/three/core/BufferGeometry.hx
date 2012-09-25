package three.core;
import three.math.Matrix4;
import three.math.Vector3;
import three.math.Vector4;
/**
 * ...
 * @author andy
 */

class BufferGeometry 
{
	public static var GeometryCount:Int = 0;

	public var id:Int;
	
	public var boundingBox:BoundingBox;
	public var boundingSphere:BoundingSphere;
	
	public var hasTangents:Bool;
	
	public var morphTargets:Array<Dynamic>;
	
	public var isDynamic:Bool;
	public var attributes:Dynamic;
	
	public var verticesNeedUpdate:Bool;
	public var normalsNeedUpdate:Bool;
	
	public var animations:Dynamic;
	
	public var firstAnimation:String;
	
	public function new() 
	{
		this.id = GeometryCount++;
		this.attributes = { };
		
		this.isDynamic = false;

		// boundings
		this.boundingBox = null;
		this.boundingSphere = null;

		this.hasTangents = false;

		// for compatibility
		this.morphTargets = [];
		
		verticesNeedUpdate = false;
		normalsNeedUpdate = false;
	}
	
	public function applyMatrix(matrix:Matrix4):Void
	{
		var positionArray:Array<Float> = null;
		var normalArray:Array<Float> = null;

		if (this.attributes.position != null)
			positionArray = this.attributes.position.array;
		if (this.attributes.normal != null)
			normalArray = this.attributes.normal.array;

		if (positionArray != null) 
		{
			matrix.multiplyVector3Array(positionArray);
			this.verticesNeedUpdate = true;
		}
		
		if (normalArray != null) 
		{
			var matrixRotation:Matrix4 = new Matrix4();
			matrixRotation.extractRotation(matrix);

			matrixRotation.multiplyVector3Array(normalArray);
			this.normalsNeedUpdate = true;
		}
	}

	public function computeBoundingBox():Void 
	{
		if (this.boundingBox == null)
		{
			this.boundingBox = new BoundingBox();
		}

		var positions:Array<Float> = this.attributes.position.array;

		if (positions != null && positions.length >= 3) 
		{
			this.boundingBox.computeFromPoints(positions);
		}
		else
		{
			this.boundingBox.resetTo(0, 0, 0);
		}
	}

	public function computeBoundingSphere():Void
	{
		if (this.boundingSphere == null)
			this.boundingSphere = new BoundingSphere();

		var positions = this.attributes.position.array;
		if (positions != null) 
		{
			this.boundingSphere.computeFromPoints(positions);
		}
		else
		{
			this.boundingSphere.radius = 0;
		}
	}

	//public function computeVertexNormals():Void
	//{
		//if (this.attributes["position"] && this.attributes["index"]) {
//
			//var i, il;
			//var j, jl;
//
			//var nVertexElements = this.attributes["position"].array.length;
//
			//if (this.attributes["normal"] == null) 
			//{
				//this.attributes["normal"] = {
					//itemSize : 3,
					//array : new Float32Array(nVertexElements),
					//numItems : nVertexElements
				//};
			//} 
			//else 
			//{
				 //reset existing normals to zero
				//for ( i = 0, il = this.attributes["normal"].array.length; i < il; i++) 
				//{
					//this.attributes[ "normal" ].array[i] = 0;
				//}
			//}
//
			//var offsets = this.offsets;
//
			//var indices = this.attributes["index"].array;
			//var positions = this.attributes["position"].array;
			//var normals = this.attributes["normal"].array;
//
			//var vA, vB, vC, x, y, z, pA = new Vector3(), 
			//pB = new Vector3(), pC = new Vector3(), 
			//cb = new Vector3(), ab = new Vector3();
//
			//for ( j = 0, jl = offsets.length; j < jl; ++j) 
			//{
				//var start = offsets[j].start;
				//var count = offsets[j].count;
				//var index = offsets[j].index;
//
				//for ( i = start, il = start + count; i < il; i += 3)
				//{
					//vA = index + indices[i];
					//vB = index + indices[i + 1];
					//vC = index + indices[i + 2];
//
					//x = positions[vA * 3];
					//y = positions[vA * 3 + 1];
					//z = positions[vA * 3 + 2];
					//pA.set(x, y, z);
//
					//x = positions[vB * 3];
					//y = positions[vB * 3 + 1];
					//z = positions[vB * 3 + 2];
					//pB.set(x, y, z);
//
					//x = positions[vC * 3];
					//y = positions[vC * 3 + 1];
					//z = positions[vC * 3 + 2];
					//pC.set(x, y, z);
//
					//cb.sub(pC, pB);
					//ab.sub(pA, pB);
					//cb.crossSelf(ab);
//
					//normals[vA * 3] += cb.x;
					//normals[vA * 3 + 1] += cb.y;
					//normals[vA * 3 + 2] += cb.z;
//
					//normals[vB * 3] += cb.x;
					//normals[vB * 3 + 1] += cb.y;
					//normals[vB * 3 + 2] += cb.z;
//
					//normals[vC * 3] += cb.x;
					//normals[vC * 3 + 1] += cb.y;
					//normals[vC * 3 + 2] += cb.z;
				//}
			//}
//
			 //normalize normals
//
			//for ( i = 0, il = normals.length; i < il; i += 3) 
			//{
				//x = normals[i];
				//y = normals[i + 1];
				//z = normals[i + 2];
//
				//var n = 1.0 / Math.sqrt(x * x + y * y + z * z);
//
				//normals[i] *= n;
				//normals[i + 1] *= n;
				//normals[i + 2] *= n;
			//}
			//this.normalsNeedUpdate = true;
		//}
	//}
//
	//public function computeTangents():Void
	//{
		// based on http://www.terathon.com/code/tangent.html
		// (per vertex tangents)
		//if (this.attributes["index"] === undefined || this.attributes["position"] === undefined || this.attributes["normal"] === undefined || this.attributes["uv"] === undefined) {
//
			//console.warn("Missing required attributes (index, position, normal or uv) in BufferGeometry.computeTangents()");
			//return;
		//}
//
		//var indices = this.attributes["index"].array;
		//var positions = this.attributes["position"].array;
		//var normals = this.attributes["normal"].array;
		//var uvs = this.attributes["uv"].array;
//
		//var nVertices = positions.length / 3;
//
		//if (this.attributes["tangent"] === undefined) 
		//{
			//var nTangentElements = 4 * nVertices;
			//this.attributes["tangent"] = {
				//itemSize : 4,
				//array : new Float32Array(nTangentElements),
				//numItems : nTangentElements
//
			//};
		//}
//
		//var tangents = this.attributes["tangent"].array;
		//var tan1 = [], tan2 = [];
		//for (var k = 0; k < nVertices; k++) 
		//{
			//tan1[k] = new Vector3();
			//tan2[k] = new Vector3();
		//}
//
		//var xA, yA, zA, xB, yB, zB, xC, yC, zC, uA, vA, uB, vB, uC, vC, x1, x2, y1, y2, z1, z2, s1, s2, t1, t2, r;
//
		//var sdir = new Vector3(), tdir = new Vector3();
//
		//function handleTriangle(a, b, c) 
		//{
			//xA = positions[a * 3];
			//yA = positions[a * 3 + 1];
			//zA = positions[a * 3 + 2];
//
			//xB = positions[b * 3];
			//yB = positions[b * 3 + 1];
			//zB = positions[b * 3 + 2];
//
			//xC = positions[c * 3];
			//yC = positions[c * 3 + 1];
			//zC = positions[c * 3 + 2];
//
			//uA = uvs[a * 2];
			//vA = uvs[a * 2 + 1];
//
			//uB = uvs[b * 2];
			//vB = uvs[b * 2 + 1];
//
			//uC = uvs[c * 2];
			//vC = uvs[c * 2 + 1];
//
			//x1 = xB - xA;
			//x2 = xC - xA;
//
			//y1 = yB - yA;
			//y2 = yC - yA;
//
			//z1 = zB - zA;
			//z2 = zC - zA;
//
			//s1 = uB - uA;
			//s2 = uC - uA;
//
			//t1 = vB - vA;
			//t2 = vC - vA;
//
			//r = 1.0 / (s1 * t2 - s2 * t1 );
//
			//sdir.set((t2 * x1 - t1 * x2 ) * r, (t2 * y1 - t1 * y2 ) * r, (t2 * z1 - t1 * z2 ) * r);
//
			//tdir.set((s1 * x2 - s2 * x1 ) * r, (s1 * y2 - s2 * y1 ) * r, (s1 * z2 - s2 * z1 ) * r);
//
			//tan1[a].addSelf(sdir);
			//tan1[b].addSelf(sdir);
			//tan1[c].addSelf(sdir);
//
			//tan2[a].addSelf(tdir);
			//tan2[b].addSelf(tdir);
			//tan2[c].addSelf(tdir);
//
		//}
//
		//var i, il;
		//var j, jl;
		//var iA, iB, iC;
//
		//var offsets = this.offsets;
//
		//for ( j = 0, jl = offsets.length; j < jl; ++j) 
		//{
			//var start = offsets[j].start;
			//var count = offsets[j].count;
			//var index = offsets[j].index;
//
			//for ( i = start, il = start + count; i < il; i += 3) 
			//{
				//iA = index + indices[i];
				//iB = index + indices[i + 1];
				//iC = index + indices[i + 2];
//
				//handleTriangle(iA, iB, iC);
			//}
		//}
//
		//var tmp = new Vector3(), tmp2 = new Vector3();
		//var n = new Vector3(), n2 = new Vector3();
		//var w, t, test;
		//var nx, ny, nz;
//
		//function handleVertex(v) 
		//{
			//n.x = normals[v * 3];
			//n.y = normals[v * 3 + 1];
			//n.z = normals[v * 3 + 2];
//
			//n2.copy(n);
//
			//t = tan1[v];
//
			// Gram-Schmidt orthogonalize
//
			//tmp.copy(t);
			//tmp.subSelf(n.multiplyScalar(n.dot(t))).normalize();
//
			// Calculate handedness
//
			//tmp2.cross(n2, t);
			//test = tmp2.dot(tan2[v]);
			//w = (test < 0.0 ) ? -1.0 : 1.0;
//
			//tangents[v * 4] = tmp.x;
			//tangents[v * 4 + 1] = tmp.y;
			//tangents[v * 4 + 2] = tmp.z;
			//tangents[v * 4 + 3] = w;
//
		//}
//
		//for ( j = 0, jl = offsets.length; j < jl; ++j) 
		//{
			//var start = offsets[j].start;
			//var count = offsets[j].count;
			//var index = offsets[j].index;
//
			//for ( i = start, il = start + count; i < il; i += 3) 
			//{
				//iA = index + indices[i];
				//iB = index + indices[i + 1];
				//iC = index + indices[i + 2];
//
				//handleVertex(iA);
				//handleVertex(iB);
				//handleVertex(iC);
			//}
		//}
//
		//this.hasTangents = true;
		//this.tangentsNeedUpdate = true;
	//}
}