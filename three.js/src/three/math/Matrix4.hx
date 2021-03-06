package three.math;

/**
 * ...
 * @author andy
 */
import js.html.Float32Array;
import three.utils.TempVars;

class Matrix4 
{
	public var elements:Float32Array;
	
	public function new() 
	{
		this.elements = new Float32Array(16);
	}
	
	public function setTo(n11:Float, n12:Float, n13:Float, n14:Float, 
							n21:Float, n22:Float, n23:Float, n24:Float, 
							n31:Float, n32:Float, n33:Float, n34:Float,
							n41:Float, n42:Float, n43:Float, n44:Float):Matrix4
	{
		var te:Float32Array = this.elements;

		te[0] = n11;
		te[4] = n12;
		te[8] = n13;
		te[12] = n14;
		te[1] = n21;
		te[5] = n22;
		te[9] = n23;
		te[13] = n24;
		te[2] = n31;
		te[6] = n32;
		te[10] = n33;
		te[14] = n34;
		te[3] = n41;
		te[7] = n42;
		te[11] = n43;
		te[15] = n44;

		return this;
	}
	
	public function identity():Matrix4
	{
		this.setTo(1, 0, 0, 0,
					0, 1, 0, 0,
					0, 0, 1, 0,
					0, 0, 0, 1);
					
		return this;
	}
	
	public function copy(m:Matrix4):Matrix4
	{
		var me:Float32Array = m.elements;
		
		this.setTo(me[0], me[4], me[8], me[12], 
					me[1], me[5], me[9], me[13], 
					me[2], me[6], me[10], me[14], 
					me[3], me[7], me[11], me[15]);
		
		return this;
	}
	
	public function lookAt(eye:Vector3, target:Vector3, up:Vector3):Matrix4
	{
		var te = this.elements;
		
		var tVar = TempVars.getTempVars();
		
		var vx:Vector3 = tVar.vect1;
		var vy:Vector3 = tVar.vect2;
		var vz:Vector3 = tVar.vect2;
		
		vz.sub(eye, target).normalize();
		
		if (vz.length == 0)
		{
			vz.z = 1;
		}
		
		vx.cross(up, vz).normalize();
		
		if (vx.length == 0)
		{
			vz.x += 0.0001;
			vx.cross(up, vz).normalize();
		}
		
		vy.cross(vz, vx);
		
		te[0] = vx.x;
		te[4] = vy.x;
		te[8] = vz.x;
		te[1] = vx.y;
		te[5] = vy.y;
		te[9] = vz.y;
		te[2] = vx.z;
		te[6] = vy.z;
		te[10] = vz.z;
		
		tVar.release();

		return this;
	}
	
	public function multiply(a:Matrix4, b:Matrix4):Matrix4
	{
		var ae = a.elements;
		var be = b.elements;
		var te = this.elements;

		var a11 = ae[0], a12 = ae[4], a13 = ae[8], a14 = ae[12];
		var a21 = ae[1], a22 = ae[5], a23 = ae[9], a24 = ae[13];
		var a31 = ae[2], a32 = ae[6], a33 = ae[10], a34 = ae[14];
		var a41 = ae[3], a42 = ae[7], a43 = ae[11], a44 = ae[15];

		var b11 = be[0], b12 = be[4], b13 = be[8], b14 = be[12];
		var b21 = be[1], b22 = be[5], b23 = be[9], b24 = be[13];
		var b31 = be[2], b32 = be[6], b33 = be[10], b34 = be[14];
		var b41 = be[3], b42 = be[7], b43 = be[11], b44 = be[15];

		te[0] = a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41;
		te[4] = a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42;
		te[8] = a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43;
		te[12] = a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44;

		te[1] = a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41;
		te[5] = a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42;
		te[9] = a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43;
		te[13] = a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44;

		te[2] = a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41;
		te[6] = a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42;
		te[10] = a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43;
		te[14] = a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44;

		te[3] = a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41;
		te[7] = a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42;
		te[11] = a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43;
		te[15] = a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44;

		return this;
	}
	
	public function multiplySelf(m:Matrix4):Matrix4
	{
		return this.multiply(this, m);
	}
	
	public function multiplyToArray(a:Matrix4, b:Matrix4, r:Array<Float>):Matrix4
	{
		var te = this.elements;

		this.multiply(a, b);

		r[0] = te[0];
		r[1] = te[1];
		r[2] = te[2];
		r[3] = te[3];
		r[4] = te[4];
		r[5] = te[5];
		r[6] = te[6];
		r[7] = te[7];
		r[8] = te[8];
		r[9] = te[9];
		r[10] = te[10];
		r[11] = te[11];
		r[12] = te[12];
		r[13] = te[13];
		r[14] = te[14];
		r[15] = te[15];

		return this;
	}
	
	public function multiplyScalar(s:Float):Matrix4
	{
		var te = this.elements;

		te[0] *= s;
		te[4] *= s;
		te[8] *= s;
		te[12] *= s;
		te[1] *= s;
		te[5] *= s;
		te[9] *= s;
		te[13] *= s;
		te[2] *= s;
		te[6] *= s;
		te[10] *= s;
		te[14] *= s;
		te[3] *= s;
		te[7] *= s;
		te[11] *= s;
		te[15] *= s;

		return this;
	}
	
	public function multiplyVector3(v:Vector3):Vector3
	{
		var te = this.elements;

		var vx = v.x, vy = v.y, vz = v.z;
		var d = 1 / (te[3] * vx + te[7] * vy + te[11] * vz + te[15] );

		v.x = (te[0] * vx + te[4] * vy + te[8] * vz + te[12] ) * d;
		v.y = (te[1] * vx + te[5] * vy + te[9] * vz + te[13] ) * d;
		v.z = (te[2] * vx + te[6] * vy + te[10] * vz + te[14] ) * d;

		return v;
	}
	
	public function multiplyVector4(v:Vector4):Vector4
	{
		var te = this.elements;
		var vx = v.x, vy = v.y, vz = v.z, vw = v.w;

		v.x = te[0] * vx + te[4] * vy + te[8] * vz + te[12] * vw;
		v.y = te[1] * vx + te[5] * vy + te[9] * vz + te[13] * vw;
		v.z = te[2] * vx + te[6] * vy + te[10] * vz + te[14] * vw;
		v.w = te[3] * vx + te[7] * vy + te[11] * vz + te[15] * vw;

		return v;
	}
	
	public function multiplyVector3Array(a:Array<Float>):Array<Float>
	{
		var tVar:TempVars = TempVars.getTempVars();
		var tmp:Vector3 = tVar.vect1;

		var il = a.length;
		var i = 0;
		while (i < il)
		{
			tmp.x = a[i];
			tmp.y = a[i + 1];
			tmp.z = a[i + 2];

			this.multiplyVector3(tmp);

			a[i] = tmp.x;
			a[i + 1] = tmp.y;
			a[i + 2] = tmp.z;

			i += 3;
		}
		
		tVar.release();

		return a;
	}
	
	public function rotateAxis(v:Vector3):Vector3
	{
		var te = this.elements;
		var vx = v.x, vy = v.y, vz = v.z;

		v.x = vx * te[0] + vy * te[4] + vz * te[8];
		v.y = vx * te[1] + vy * te[5] + vz * te[9];
		v.z = vx * te[2] + vy * te[6] + vz * te[10];

		v.normalize();

		return v;
	}
	
	public function crossVector(a:Vector4):Vector4
	{
		var te = this.elements;
		var v = new Vector4();

		v.x = te[0] * a.x + te[4] * a.y + te[8] * a.z + te[12] * a.w;
		v.y = te[1] * a.x + te[5] * a.y + te[9] * a.z + te[13] * a.w;
		v.z = te[2] * a.x + te[6] * a.y + te[10] * a.z + te[14] * a.w;

		v.w = (a.w != 0) ? te[3] * a.x + te[7] * a.y + te[11] * a.z + te[15] * a.w : 1;

		return v;
	}
	
	public function determinant():Float
	{
		var te = this.elements;

		var n11 = te[0], n12 = te[4], n13 = te[8], n14 = te[12];
		var n21 = te[1], n22 = te[5], n23 = te[9], n24 = te[13];
		var n31 = te[2], n32 = te[6], n33 = te[10], n34 = te[14];
		var n41 = te[3], n42 = te[7], n43 = te[11], n44 = te[15];

		//TODO: make this more efficient
		//( based on
		// http://www.euclideanspace.com/maths/algebra/matrix/functions/inverse/fourD/index.htm
		// )

		return n14 * n23 * n32 * n41 - n13 * n24 * n32 * n41 - n14 * n22 * n33 * n41 + n12 * n24 * n33 * n41 + n13 * n22 * n34 * n41 - n12 * n23 * n34 * n41 - n14 * n23 * n31 * n42 + n13 * n24 * n31 * n42 + n14 * n21 * n33 * n42 - n11 * n24 * n33 * n42 - n13 * n21 * n34 * n42 + n11 * n23 * n34 * n42 + n14 * n22 * n31 * n43 - n12 * n24 * n31 * n43 - n14 * n21 * n32 * n43 + n11 * n24 * n32 * n43 + n12 * n21 * n34 * n43 - n11 * n22 * n34 * n43 - n13 * n22 * n31 * n44 + n12 * n23 * n31 * n44 + n13 * n21 * n32 * n44 - n11 * n23 * n32 * n44 - n12 * n21 * n33 * n44 + n11 * n22 * n33 * n44;
	}
	
	public function transpose():Matrix4
	{
		var te = this.elements;
		var tmp:Float;

		tmp = te[1];
		te[1] = te[4];
		te[4] = tmp;
		tmp = te[2];
		te[2] = te[8];
		te[8] = tmp;
		tmp = te[6];
		te[6] = te[9];
		te[9] = tmp;

		tmp = te[3];
		te[3] = te[12];
		te[12] = tmp;
		tmp = te[7];
		te[7] = te[13];
		te[13] = tmp;
		tmp = te[11];
		te[11] = te[14];
		te[14] = tmp;

		return this;
	}
	
	public function flattenToArray(flat:Dynamic):Dynamic
	{
		var te:Float32Array = this.elements;
		flat[0] = te[0];
		flat[1] = te[1];
		flat[2] = te[2];
		flat[3] = te[3];
		flat[4] = te[4];
		flat[5] = te[5];
		flat[6] = te[6];
		flat[7] = te[7];
		flat[8] = te[8];
		flat[9] = te[9];
		flat[10] = te[10];
		flat[11] = te[11];
		flat[12] = te[12];
		flat[13] = te[13];
		flat[14] = te[14];
		flat[15] = te[15];

		return flat;
	}
	
	public function flattenToArrayOffset(flat:Dynamic,offset:Int):Dynamic
	{
		var te = this.elements;
		flat[offset] = te[0];
		flat[offset + 1] = te[1];
		flat[offset + 2] = te[2];
		flat[offset + 3] = te[3];

		flat[offset + 4] = te[4];
		flat[offset + 5] = te[5];
		flat[offset + 6] = te[6];
		flat[offset + 7] = te[7];

		flat[offset + 8] = te[8];
		flat[offset + 9] = te[9];
		flat[offset + 10] = te[10];
		flat[offset + 11] = te[11];

		flat[offset + 12] = te[12];
		flat[offset + 13] = te[13];
		flat[offset + 14] = te[14];
		flat[offset + 15] = te[15];

		return flat;
	}
	
	public function getPosition():Vector3
	{
		var te = this.elements;
		return new Vector3(te[12], te[13], te[14]);
	}
	
	public function setPosition(v:Vector3):Matrix4
	{
		var te = this.elements;

		te[12] = v.x;
		te[13] = v.y;
		te[14] = v.z;

		return this;
	}
	
	public function getColumnX():Vector3
	{
		var te = this.elements;
		return new Vector3(te[0], te[1], te[2]);
	}
	
	public function getColumnY():Vector3
	{
		var te = this.elements;
		return new Vector3(te[4], te[5], te[6]);
	}
	
	public function getColumnZ():Vector3
	{
		var te = this.elements;
		return new Vector3(te[8], te[9], te[10]);
	}
	
	public function getInverse(m:Matrix4):Matrix4
	{
		// based on
		// http://www.euclideanspace.com/maths/algebra/matrix/functions/inverse/fourD/index.htm
		var te = this.elements;
		var me = m.elements;

		var n11 = me[0], n12 = me[4], n13 = me[8], n14 = me[12];
		var n21 = me[1], n22 = me[5], n23 = me[9], n24 = me[13];
		var n31 = me[2], n32 = me[6], n33 = me[10], n34 = me[14];
		var n41 = me[3], n42 = me[7], n43 = me[11], n44 = me[15];

		te[0] = n23 * n34 * n42 - n24 * n33 * n42 + n24 * n32 * n43 - n22 * n34 * n43 - n23 * n32 * n44 + n22 * n33 * n44;
		te[4] = n14 * n33 * n42 - n13 * n34 * n42 - n14 * n32 * n43 + n12 * n34 * n43 + n13 * n32 * n44 - n12 * n33 * n44;
		te[8] = n13 * n24 * n42 - n14 * n23 * n42 + n14 * n22 * n43 - n12 * n24 * n43 - n13 * n22 * n44 + n12 * n23 * n44;
		te[12] = n14 * n23 * n32 - n13 * n24 * n32 - n14 * n22 * n33 + n12 * n24 * n33 + n13 * n22 * n34 - n12 * n23 * n34;
		te[1] = n24 * n33 * n41 - n23 * n34 * n41 - n24 * n31 * n43 + n21 * n34 * n43 + n23 * n31 * n44 - n21 * n33 * n44;
		te[5] = n13 * n34 * n41 - n14 * n33 * n41 + n14 * n31 * n43 - n11 * n34 * n43 - n13 * n31 * n44 + n11 * n33 * n44;
		te[9] = n14 * n23 * n41 - n13 * n24 * n41 - n14 * n21 * n43 + n11 * n24 * n43 + n13 * n21 * n44 - n11 * n23 * n44;
		te[13] = n13 * n24 * n31 - n14 * n23 * n31 + n14 * n21 * n33 - n11 * n24 * n33 - n13 * n21 * n34 + n11 * n23 * n34;
		te[2] = n22 * n34 * n41 - n24 * n32 * n41 + n24 * n31 * n42 - n21 * n34 * n42 - n22 * n31 * n44 + n21 * n32 * n44;
		te[6] = n14 * n32 * n41 - n12 * n34 * n41 - n14 * n31 * n42 + n11 * n34 * n42 + n12 * n31 * n44 - n11 * n32 * n44;
		te[10] = n12 * n24 * n41 - n14 * n22 * n41 + n14 * n21 * n42 - n11 * n24 * n42 - n12 * n21 * n44 + n11 * n22 * n44;
		te[14] = n14 * n22 * n31 - n12 * n24 * n31 - n14 * n21 * n32 + n11 * n24 * n32 + n12 * n21 * n34 - n11 * n22 * n34;
		te[3] = n23 * n32 * n41 - n22 * n33 * n41 - n23 * n31 * n42 + n21 * n33 * n42 + n22 * n31 * n43 - n21 * n32 * n43;
		te[7] = n12 * n33 * n41 - n13 * n32 * n41 + n13 * n31 * n42 - n11 * n33 * n42 - n12 * n31 * n43 + n11 * n32 * n43;
		te[11] = n13 * n22 * n41 - n12 * n23 * n41 - n13 * n21 * n42 + n11 * n23 * n42 + n12 * n21 * n43 - n11 * n22 * n43;
		te[15] = n12 * n23 * n31 - n13 * n22 * n31 + n13 * n21 * n32 - n11 * n23 * n32 - n12 * n21 * n33 + n11 * n22 * n33;
		this.multiplyScalar(1 / m.determinant());

		return this;
	}
	
	public function setRotationFromEuler(v:Vector3, order:EulerOrder):Matrix4
	{
		var te = this.elements;

		var x:Float = v.x, y:Float = v.y, z:Float = v.z;
		var a:Float = Math.cos(x), b:Float = Math.sin(x);
		var c:Float = Math.cos(y), d:Float = Math.sin(y);
		var e:Float = Math.cos(z), f:Float = Math.sin(z);

		if (order == EulerOrder.XYZ) 
		{
			var ae = a * e, af = a * f, be = b * e, bf = b * f;

			te[0] = c * e;
			te[4] = -c * f;
			te[8] = d;

			te[1] = af + be * d;
			te[5] = ae - bf * d;
			te[9] = -b * c;

			te[2] = bf - ae * d;
			te[6] = be + af * d;
			te[10] = a * c;
		} 
		else if (order == EulerOrder.YXZ) 
		{
			var ce = c * e, cf = c * f, de = d * e, df = d * f;

			te[0] = ce + df * b;
			te[4] = de * b - cf;
			te[8] = a * d;

			te[1] = a * f;
			te[5] = a * e;
			te[9] = -b;

			te[2] = cf * b - de;
			te[6] = df + ce * b;
			te[10] = a * c;
		} 
		else if (order == EulerOrder.ZXY) 
		{
			var ce = c * e, cf = c * f, de = d * e, df = d * f;

			te[0] = ce - df * b;
			te[4] = -a * f;
			te[8] = de + cf * b;

			te[1] = cf + de * b;
			te[5] = a * e;
			te[9] = df - ce * b;

			te[2] = -a * d;
			te[6] = b;
			te[10] = a * c;
		} 
		else if (order == EulerOrder.ZYX) 
		{
			var ae = a * e, af = a * f, be = b * e, bf = b * f;

			te[0] = c * e;
			te[4] = be * d - af;
			te[8] = ae * d + bf;

			te[1] = c * f;
			te[5] = bf * d + ae;
			te[9] = af * d - be;

			te[2] = -d;
			te[6] = b * c;
			te[10] = a * c;
		} 
		else if (order == EulerOrder.YZX) 
		{
			var ac = a * c, ad = a * d, bc = b * c, bd = b * d;

			te[0] = c * e;
			te[4] = bd - ac * f;
			te[8] = bc * f + ad;

			te[1] = f;
			te[5] = a * e;
			te[9] = -b * e;

			te[2] = -d * e;
			te[6] = ad * f + bc;
			te[10] = ac - bd * f;
		} 
		else if (order == EulerOrder.XZY) 
		{
			var ac = a * c, ad = a * d, bc = b * c, bd = b * d;

			te[0] = c * e;
			te[4] = -f;
			te[8] = d * e;

			te[1] = ac * f + bd;
			te[5] = a * e;
			te[9] = ad * f - bc;

			te[2] = bc * f - ad;
			te[6] = b * e;
			te[10] = bd * f + ac;
		}
		return this;
	}
	
	public function setRotationFromQuaternion(q:Quaternion):Matrix4
	{
		var te = this.elements;

		var x = q.x, y = q.y, z = q.z, w = q.w;
		var x2 = x + x, y2 = y + y, z2 = z + z;
		var xx = x * x2, xy = x * y2, xz = x * z2;
		var yy = y * y2, yz = y * z2, zz = z * z2;
		var wx = w * x2, wy = w * y2, wz = w * z2;

		te[0] = 1 - (yy + zz );
		te[4] = xy - wz;
		te[8] = xz + wy;

		te[1] = xy + wz;
		te[5] = 1 - (xx + zz );
		te[9] = yz - wx;

		te[2] = xz - wy;
		te[6] = yz + wx;
		te[10] = 1 - (xx + yy );

		return this;
	}
	
	public function compose(translation:Vector3, rotation:Quaternion, scale:Vector3):Matrix4
	{
		var te = this.elements;
		
		var tVar:TempVars = TempVars.getTempVars();
		
		var mRotation:Matrix4 = tVar.tempMat4;
		var mScale:Matrix4 = tVar.tempMat42;

		mRotation.identity();
		mRotation.setRotationFromQuaternion(rotation);

		mScale.makeScale(scale.x, scale.y, scale.z);

		this.multiply(mRotation, mScale);

		te[12] = translation.x;
		te[13] = translation.y;
		te[14] = translation.z;

		tVar.release();
		
		return this;
	}
	
	public function decompose(translation:Vector3, rotation:Quaternion, scale:Vector3):Array<Dynamic>
	{
		var te = this.elements;

		var tVar:TempVars = TempVars.getTempVars();
		// grab the axis vectors
		var x = tVar.vect1;
		var y = tVar.vect2;
		var z = tVar.vect3;

		x.setTo(te[0], te[1], te[2]);
		y.setTo(te[4], te[5], te[6]);
		z.setTo(te[8], te[9], te[10]);

		translation = ( translation != null ) ? translation : new Vector3();
		rotation = ( rotation != null ) ? rotation : new Quaternion();
		scale = ( scale != null ) ? scale : new Vector3();

		scale.x = x.length;
		scale.y = y.length;
		scale.z = z.length;

		translation.x = te[12];
		translation.y = te[13];
		translation.z = te[14];

		// scale the rotation part

		var matrix:Matrix4 = tVar.tempMat4;

		matrix.copy(this);

		matrix.elements[0] /= scale.x;
		matrix.elements[1] /= scale.x;
		matrix.elements[2] /= scale.x;

		matrix.elements[4] /= scale.y;
		matrix.elements[5] /= scale.y;
		matrix.elements[6] /= scale.y;

		matrix.elements[8] /= scale.z;
		matrix.elements[9] /= scale.z;
		matrix.elements[10] /= scale.z;

		rotation.setFromRotationMatrix(matrix);
		
		tVar.release();

		return [translation, rotation, scale];
	}
	
	public function extractPosition(m:Matrix4):Matrix4
	{
		var te = this.elements;
		var me = m.elements;

		te[12] = me[12];
		te[13] = me[13];
		te[14] = me[14];

		return this;
	}
	
	public function extractRotation(m:Matrix4):Matrix4
	{
		var te = this.elements;
		var me = m.elements;

		var tVar:TempVars = TempVars.getTempVars();
		var vector:Vector3 = tVar.vect1;

		var scaleX = 1 / vector.setTo(me[0], me[1], me[2]).length;
		var scaleY = 1 / vector.setTo(me[4], me[5], me[6]).length;
		var scaleZ = 1 / vector.setTo(me[8], me[9], me[10]).length;

		te[0] = me[0] * scaleX;
		te[1] = me[1] * scaleX;
		te[2] = me[2] * scaleX;

		te[4] = me[4] * scaleY;
		te[5] = me[5] * scaleY;
		te[6] = me[6] * scaleY;

		te[8] = me[8] * scaleZ;
		te[9] = me[9] * scaleZ;
		te[10] = me[10] * scaleZ;
		
		tVar.release();

		return this;
	}
	
	public function translate(v:Vector3):Matrix4
	{
		var te = this.elements;
		var x = v.x, y = v.y, z = v.z;

		te[12] = te[0] * x + te[4] * y + te[8] * z + te[12];
		te[13] = te[1] * x + te[5] * y + te[9] * z + te[13];
		te[14] = te[2] * x + te[6] * y + te[10] * z + te[14];
		te[15] = te[3] * x + te[7] * y + te[11] * z + te[15];

		return this;
	}
	
	public function rotateX(angle:Float):Matrix4 
	{

		var te = this.elements;
		var m12 = te[4];
		var m22 = te[5];
		var m32 = te[6];
		var m42 = te[7];
		var m13 = te[8];
		var m23 = te[9];
		var m33 = te[10];
		var m43 = te[11];
		var c = Math.cos(angle);
		var s = Math.sin(angle);

		te[4] = c * m12 + s * m13;
		te[5] = c * m22 + s * m23;
		te[6] = c * m32 + s * m33;
		te[7] = c * m42 + s * m43;

		te[8] = c * m13 - s * m12;
		te[9] = c * m23 - s * m22;
		te[10] = c * m33 - s * m32;
		te[11] = c * m43 - s * m42;

		return this;

	}

	public function rotateY(angle:Float):Matrix4 
	{

		var te = this.elements;
		var m11 = te[0];
		var m21 = te[1];
		var m31 = te[2];
		var m41 = te[3];
		var m13 = te[8];
		var m23 = te[9];
		var m33 = te[10];
		var m43 = te[11];
		var c = Math.cos(angle);
		var s = Math.sin(angle);

		te[0] = c * m11 - s * m13;
		te[1] = c * m21 - s * m23;
		te[2] = c * m31 - s * m33;
		te[3] = c * m41 - s * m43;

		te[8] = c * m13 + s * m11;
		te[9] = c * m23 + s * m21;
		te[10] = c * m33 + s * m31;
		te[11] = c * m43 + s * m41;

		return this;

	}

	public function rotateZ(angle:Float):Matrix4 
	{

		var te = this.elements;
		var m11 = te[0];
		var m21 = te[1];
		var m31 = te[2];
		var m41 = te[3];
		var m12 = te[4];
		var m22 = te[5];
		var m32 = te[6];
		var m42 = te[7];
		var c = Math.cos(angle);
		var s = Math.sin(angle);

		te[0] = c * m11 + s * m12;
		te[1] = c * m21 + s * m22;
		te[2] = c * m31 + s * m32;
		te[3] = c * m41 + s * m42;

		te[4] = c * m12 - s * m11;
		te[5] = c * m22 - s * m21;
		te[6] = c * m32 - s * m31;
		te[7] = c * m42 - s * m41;

		return this;

	}

	public function rotateByAxis(axis:Vector3, angle:Float):Matrix4
	{

		var te = this.elements;

		// optimize by checking axis

		if (axis.x == 1 && axis.y == 0 && axis.z == 0) {

			return this.rotateX(angle);

		} else if (axis.x == 0 && axis.y == 1 && axis.z == 0) {

			return this.rotateY(angle);

		} else if (axis.x == 0 && axis.y == 0 && axis.z == 1) {

			return this.rotateZ(angle);

		}

		var x = axis.x, y = axis.y, z = axis.z;
		var n = Math.sqrt(x * x + y * y + z * z);

		x /= n;
		y /= n;
		z /= n;

		var xx = x * x, yy = y * y, zz = z * z;
		var c = Math.cos(angle);
		var s = Math.sin(angle);
		var oneMinusCosine = 1 - c;
		var xy = x * y * oneMinusCosine;
		var xz = x * z * oneMinusCosine;
		var yz = y * z * oneMinusCosine;
		var xs = x * s;
		var ys = y * s;
		var zs = z * s;

		var r11 = xx + (1 - xx) * c;
		var r21 = xy + zs;
		var r31 = xz - ys;
		var r12 = xy - zs;
		var r22 = yy + (1 - yy) * c;
		var r32 = yz + xs;
		var r13 = xz + ys;
		var r23 = yz - xs;
		var r33 = zz + (1 - zz) * c;

		var m11 = te[0], m21 = te[1], m31 = te[2], m41 = te[3];
		var m12 = te[4], m22 = te[5], m32 = te[6], m42 = te[7];
		var m13 = te[8], m23 = te[9], m33 = te[10], m43 = te[11];
		var m14 = te[12], m24 = te[13], m34 = te[14], m44 = te[15];

		te[0] = r11 * m11 + r21 * m12 + r31 * m13;
		te[1] = r11 * m21 + r21 * m22 + r31 * m23;
		te[2] = r11 * m31 + r21 * m32 + r31 * m33;
		te[3] = r11 * m41 + r21 * m42 + r31 * m43;

		te[4] = r12 * m11 + r22 * m12 + r32 * m13;
		te[5] = r12 * m21 + r22 * m22 + r32 * m23;
		te[6] = r12 * m31 + r22 * m32 + r32 * m33;
		te[7] = r12 * m41 + r22 * m42 + r32 * m43;

		te[8] = r13 * m11 + r23 * m12 + r33 * m13;
		te[9] = r13 * m21 + r23 * m22 + r33 * m23;
		te[10] = r13 * m31 + r23 * m32 + r33 * m33;
		te[11] = r13 * m41 + r23 * m42 + r33 * m43;

		return this;

	}

	public function scale(v:Vector3):Matrix4
	{

		var te = this.elements;
		var x = v.x, y = v.y, z = v.z;

		te[0] *= x;
		te[4] *= y;
		te[8] *= z;
		te[1] *= x;
		te[5] *= y;
		te[9] *= z;
		te[2] *= x;
		te[6] *= y;
		te[10] *= z;
		te[3] *= x;
		te[7] *= y;
		te[11] *= z;

		return this;

	}

	public function getMaxScaleOnAxis():Float {

		var te = this.elements;

		var scaleXSq = te[0] * te[0] + te[1] * te[1] + te[2] * te[2];
		var scaleYSq = te[4] * te[4] + te[5] * te[5] + te[6] * te[6];
		var scaleZSq = te[8] * te[8] + te[9] * te[9] + te[10] * te[10];

		return Math.sqrt(Math.max(scaleXSq, Math.max(scaleYSq, scaleZSq)));

	}

	//

	public function makeTranslation(x:Float, y:Float, z:Float):Matrix4 {

		this.setTo(1, 0, 0, x, 0, 1, 0, y, 0, 0, 1, z, 0, 0, 0, 1);

		return this;

	}

	public function makeRotationX(theta:Float):Matrix4
	{

		var c = Math.cos(theta), s = Math.sin(theta);

		this.setTo(1, 0, 0, 0, 0, c, -s, 0, 0, s, c, 0, 0, 0, 0, 1);

		return this;

	}

	public function makeRotationY(theta:Float):Matrix4
	{

		var c = Math.cos(theta), s = Math.sin(theta);

		this.setTo(c, 0, s, 0, 0, 1, 0, 0, -s, 0, c, 0, 0, 0, 0, 1);

		return this;

	}

	public function makeRotationZ(theta:Float):Matrix4
	{

		var c = Math.cos(theta), s = Math.sin(theta);

		this.setTo(c, -s, 0, 0, s, c, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);

		return this;

	}

	public function makeRotationAxis(axis:Vector3, angle:Float):Matrix4
	{

		// Based on http://www.gamedev.net/reference/articles/article1199.asp

		var c = Math.cos(angle);
		var s = Math.sin(angle);
		var t = 1 - c;
		var x = axis.x, y = axis.y, z = axis.z;
		var tx = t * x, ty = t * y;

		this.setTo(tx * x + c, tx * y - s * z, tx * z + s * y, 0, tx * y + s * z, ty * y + c, ty * z - s * x, 0, tx * z - s * y, ty * z + s * x, t * z * z + c, 0, 0, 0, 0, 1);

		return this;

	}

	public function makeScale(x:Float, y:Float, z:Float):Matrix4 
	{

		this.setTo(x, 0, 0, 0, 0, y, 0, 0, 0, 0, z, 0, 0, 0, 0, 1);

		return this;

	}

	public function makeFrustum(left:Float, right:Float, bottom:Float, top:Float, near:Float, far:Float):Matrix4  
	{

		var te = this.elements;
		var x = 2 * near / (right - left );
		var y = 2 * near / (top - bottom );

		var a = (right + left ) / (right - left );
		var b = (top + bottom ) / (top - bottom );
		var c = -(far + near ) / (far - near );
		var d = -2 * far * near / (far - near );

		te[0] = x;
		te[4] = 0;
		te[8] = a;
		te[12] = 0;
		te[1] = 0;
		te[5] = y;
		te[9] = b;
		te[13] = 0;
		te[2] = 0;
		te[6] = 0;
		te[10] = c;
		te[14] = d;
		te[3] = 0;
		te[7] = 0;
		te[11] = -1;
		te[15] = 0;

		return this;

	}

	public function makePerspective(fov:Float, aspect:Float, near:Float, far:Float):Matrix4
	{

		var ymax = near * Math.tan(fov * Math.PI / 360);
		var ymin = -ymax;
		var xmin = ymin * aspect;
		var xmax = ymax * aspect;

		return this.makeFrustum(xmin, xmax, ymin, ymax, near, far);

	}

	public function makeOrthographic(left:Float, right:Float, top:Float, bottom:Float, near:Float, far:Float):Matrix4
	{
		var te = this.elements;
		var w = right - left;
		var h = top - bottom;
		var p = far - near;

		var x = (right + left ) / w;
		var y = (top + bottom ) / h;
		var z = (far + near ) / p;

		te[0] = 2 / w;
		te[4] = 0;
		te[8] = 0;
		te[12] = -x;
		te[1] = 0;
		te[5] = 2 / h;
		te[9] = 0;
		te[13] = -y;
		te[2] = 0;
		te[6] = 0;
		te[10] = -2 / p;
		te[14] = -z;
		te[3] = 0;
		te[7] = 0;
		te[11] = 0;
		te[15] = 1;

		return this;
	}

	public function clone():Matrix4
	{
		var result:Matrix4 = new Matrix4();
		var te = this.elements;
		result.setTo(te[0], te[4], te[8], te[12], 
					te[1], te[5], te[9], te[13], 
					te[2], te[6], te[10], te[14], 
					te[3], te[7], te[11], te[15]);
		return result;
	}
}