(function () { "use strict";
var $estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var HxOverrides = function() { }
HxOverrides.__name__ = true;
HxOverrides.remove = function(a,obj) {
	var i = 0;
	var l = a.length;
	while(i < l) {
		if(a[i] == obj) {
			a.splice(i,1);
			return true;
		}
		i++;
	}
	return false;
}
var Reflect = function() { }
Reflect.__name__ = true;
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
}
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
}
var Std = function() { }
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
var Test = function() {
	js.Browser.window.onload = $bind(this,this.onLoad);
};
Test.__name__ = true;
Test.main = function() {
	new Test();
}
Test.prototype = {
	onLoad: function(e) {
		var canvas = js.Browser.document.getElementById("webgl_canvas");
		this.gl = js.html._CanvasElement.CanvasUtil.getContextWebGL(canvas,null);
		this.gl.viewport(0,0,canvas.width,canvas.height);
		this.gl.clearColor(0,0,0.8,1);
		this.gl.clear(16640);
		var vertexPosBuffer = this.gl.createBuffer();
		this.gl.bindBuffer(34962,vertexPosBuffer);
		var vertices = [-0.5,-0.5,0.5,-0.5,0,0.5];
		var floatArray = new Float32Array(vertices);
		this.gl.bufferData(34962,floatArray,35044);
		var vs = "attribute vec2 pos;\n" + "void main(){ gl_Position = vec4(pos,0,1); }";
		var fs = "precision mediump float;\n" + "void main() { gl_FragColor = vec4(0,0.8,0,1); }";
		var program = three.utils.WebGLUtil.createProgram(this.gl,vs,fs);
		this.gl.useProgram(program);
		var index = this.gl.getAttribLocation(program,"pos");
		this.gl.enableVertexAttribArray(index);
		this.gl.vertexAttribPointer(index,2,5126,false,0,0);
		this.gl.drawArrays(4,0,3);
	}
	,__class__: Test
}
var Type = function() { }
Type.__name__ = true;
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	HxOverrides.remove(a,"__name__");
	HxOverrides.remove(a,"__interfaces__");
	HxOverrides.remove(a,"__properties__");
	HxOverrides.remove(a,"__super__");
	HxOverrides.remove(a,"prototype");
	return a;
}
var haxe = {}
haxe.ds = {}
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__name__ = true;
haxe.ds.StringMap.prototype = {
	exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,__class__: haxe.ds.StringMap
}
var js = {}
js.Boot = function() { }
js.Boot.__name__ = true;
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	try {
		if(o instanceof cl) {
			if(cl == Array) return o.__enum__ == null;
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	} catch( e ) {
		if(cl == null) return false;
	}
	switch(cl) {
	case Int:
		return Math.ceil(o%2147483648.0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return o === true || o === false;
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o == null) return false;
		if(cl == Class && o.__name__ != null) return true; else null;
		if(cl == Enum && o.__ename__ != null) return true; else null;
		return o.__enum__ == cl;
	}
}
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
}
js.Browser = function() { }
js.Browser.__name__ = true;
js.html = {}
js.html._CanvasElement = {}
js.html._CanvasElement.CanvasUtil = function() { }
js.html._CanvasElement.CanvasUtil.__name__ = true;
js.html._CanvasElement.CanvasUtil.getContextWebGL = function(canvas,attribs) {
	var _g = 0, _g1 = ["webgl","experimental-webgl"];
	while(_g < _g1.length) {
		var name = _g1[_g];
		++_g;
		var ctx = canvas.getContext(name,attribs);
		if(ctx != null) return ctx;
	}
	return null;
}
var three = {}
three.ThreeGlobal = function() { }
three.ThreeGlobal.__name__ = true;
three.ThreeGlobal.gl = null;
three.ThreeGlobal.paramThreeToGL = function(p) {
	if(p == 1000) return 10497;
	if(p == 1001) return 33071;
	if(p == 1002) return 33648;
	if(p == 1003) return 9728;
	if(p == 1004) return 9984;
	if(p == 1005) return 9986;
	if(p == 1006) return 9729;
	if(p == 1007) return 9985;
	if(p == 1008) return 9987;
	if(p == 1009) return 5121;
	if(p == 1016) return 32819;
	if(p == 1017) return 32820;
	if(p == 1018) return 33635;
	if(p == 1010) return 5120;
	if(p == 1011) return 5122;
	if(p == 1012) return 5123;
	if(p == 1013) return 5124;
	if(p == 1014) return 5125;
	if(p == 1015) return 5126;
	if(p == 1019) return 6406;
	if(p == 1020) return 6407;
	if(p == 1021) return 6408;
	if(p == 1022) return 6409;
	if(p == 1023) return 6410;
	if(p == 100) return 32774;
	if(p == 101) return 32778;
	if(p == 102) return 32779;
	if(p == 200) return 0;
	if(p == 201) return 1;
	if(p == 202) return 768;
	if(p == 203) return 769;
	if(p == 204) return 770;
	if(p == 205) return 771;
	if(p == 206) return 772;
	if(p == 207) return 773;
	if(p == 208) return 774;
	if(p == 209) return 775;
	if(p == 210) return 776;
	return 0;
}
three.ThreeGlobal.filterFallback = function(f) {
	if(f == 1003 || f == 1004 || f == 1005) return 9728;
	return 9729;
}
three.math = {}
three.math.Matrix4 = function() {
	this.elements = new Float32Array(16);
};
three.math.Matrix4.__name__ = true;
three.math.Matrix4.prototype = {
	clone: function() {
		var result = new three.math.Matrix4();
		var te = this.elements;
		result.setTo(te[0],te[4],te[8],te[12],te[1],te[5],te[9],te[13],te[2],te[6],te[10],te[14],te[3],te[7],te[11],te[15]);
		return result;
	}
	,makeOrthographic: function(left,right,top,bottom,near,far) {
		var te = this.elements;
		var w = right - left;
		var h = top - bottom;
		var p = far - near;
		var x = (right + left) / w;
		var y = (top + bottom) / h;
		var z = (far + near) / p;
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
	,makePerspective: function(fov,aspect,near,far) {
		var ymax = near * Math.tan(fov * Math.PI / 360);
		var ymin = -ymax;
		var xmin = ymin * aspect;
		var xmax = ymax * aspect;
		return this.makeFrustum(xmin,xmax,ymin,ymax,near,far);
	}
	,makeFrustum: function(left,right,bottom,top,near,far) {
		var te = this.elements;
		var x = 2 * near / (right - left);
		var y = 2 * near / (top - bottom);
		var a = (right + left) / (right - left);
		var b = (top + bottom) / (top - bottom);
		var c = -(far + near) / (far - near);
		var d = -2 * far * near / (far - near);
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
	,makeScale: function(x,y,z) {
		this.setTo(x,0,0,0,0,y,0,0,0,0,z,0,0,0,0,1);
		return this;
	}
	,makeRotationAxis: function(axis,angle) {
		var c = Math.cos(angle);
		var s = Math.sin(angle);
		var t = 1 - c;
		var x = axis.x, y = axis.y, z = axis.z;
		var tx = t * x, ty = t * y;
		this.setTo(tx * x + c,tx * y - s * z,tx * z + s * y,0,tx * y + s * z,ty * y + c,ty * z - s * x,0,tx * z - s * y,ty * z + s * x,t * z * z + c,0,0,0,0,1);
		return this;
	}
	,makeRotationZ: function(theta) {
		var c = Math.cos(theta), s = Math.sin(theta);
		this.setTo(c,-s,0,0,s,c,0,0,0,0,1,0,0,0,0,1);
		return this;
	}
	,makeRotationY: function(theta) {
		var c = Math.cos(theta), s = Math.sin(theta);
		this.setTo(c,0,s,0,0,1,0,0,-s,0,c,0,0,0,0,1);
		return this;
	}
	,makeRotationX: function(theta) {
		var c = Math.cos(theta), s = Math.sin(theta);
		this.setTo(1,0,0,0,0,c,-s,0,0,s,c,0,0,0,0,1);
		return this;
	}
	,makeTranslation: function(x,y,z) {
		this.setTo(1,0,0,x,0,1,0,y,0,0,1,z,0,0,0,1);
		return this;
	}
	,getMaxScaleOnAxis: function() {
		var te = this.elements;
		var scaleXSq = te[0] * te[0] + te[1] * te[1] + te[2] * te[2];
		var scaleYSq = te[4] * te[4] + te[5] * te[5] + te[6] * te[6];
		var scaleZSq = te[8] * te[8] + te[9] * te[9] + te[10] * te[10];
		return Math.sqrt(Math.max(scaleXSq,Math.max(scaleYSq,scaleZSq)));
	}
	,scale: function(v) {
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
	,rotateByAxis: function(axis,angle) {
		var te = this.elements;
		if(axis.x == 1 && axis.y == 0 && axis.z == 0) return this.rotateX(angle); else if(axis.x == 0 && axis.y == 1 && axis.z == 0) return this.rotateY(angle); else if(axis.x == 0 && axis.y == 0 && axis.z == 1) return this.rotateZ(angle);
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
	,rotateZ: function(angle) {
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
	,rotateY: function(angle) {
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
	,rotateX: function(angle) {
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
	,translate: function(v) {
		var te = this.elements;
		var x = v.x, y = v.y, z = v.z;
		te[12] = te[0] * x + te[4] * y + te[8] * z + te[12];
		te[13] = te[1] * x + te[5] * y + te[9] * z + te[13];
		te[14] = te[2] * x + te[6] * y + te[10] * z + te[14];
		te[15] = te[3] * x + te[7] * y + te[11] * z + te[15];
		return this;
	}
	,extractRotation: function(m) {
		var te = this.elements;
		var me = m.elements;
		var tVar = three.utils.TempVars.getTempVars();
		var vector = tVar.vect1;
		var scaleX = 1 / vector.setTo(me[0],me[1],me[2]).get_length();
		var scaleY = 1 / vector.setTo(me[4],me[5],me[6]).get_length();
		var scaleZ = 1 / vector.setTo(me[8],me[9],me[10]).get_length();
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
	,extractPosition: function(m) {
		var te = this.elements;
		var me = m.elements;
		te[12] = me[12];
		te[13] = me[13];
		te[14] = me[14];
		return this;
	}
	,decompose: function(translation,rotation,scale) {
		var te = this.elements;
		var tVar = three.utils.TempVars.getTempVars();
		var x = tVar.vect1;
		var y = tVar.vect2;
		var z = tVar.vect3;
		x.setTo(te[0],te[1],te[2]);
		y.setTo(te[4],te[5],te[6]);
		z.setTo(te[8],te[9],te[10]);
		translation = translation != null?translation:new three.math.Vector3();
		rotation = rotation != null?rotation:new three.math.Quaternion();
		scale = scale != null?scale:new three.math.Vector3();
		scale.x = x.get_length();
		scale.y = y.get_length();
		scale.z = z.get_length();
		translation.x = te[12];
		translation.y = te[13];
		translation.z = te[14];
		var matrix = tVar.tempMat4;
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
		return [translation,rotation,scale];
	}
	,compose: function(translation,rotation,scale) {
		var te = this.elements;
		var tVar = three.utils.TempVars.getTempVars();
		var mRotation = tVar.tempMat4;
		var mScale = tVar.tempMat42;
		mRotation.identity();
		mRotation.setRotationFromQuaternion(rotation);
		mScale.makeScale(scale.x,scale.y,scale.z);
		this.multiply(mRotation,mScale);
		te[12] = translation.x;
		te[13] = translation.y;
		te[14] = translation.z;
		tVar.release();
		return this;
	}
	,setRotationFromQuaternion: function(q) {
		var te = this.elements;
		var x = q.x, y = q.y, z = q.z, w = q.w;
		var x2 = x + x, y2 = y + y, z2 = z + z;
		var xx = x * x2, xy = x * y2, xz = x * z2;
		var yy = y * y2, yz = y * z2, zz = z * z2;
		var wx = w * x2, wy = w * y2, wz = w * z2;
		te[0] = 1 - (yy + zz);
		te[4] = xy - wz;
		te[8] = xz + wy;
		te[1] = xy + wz;
		te[5] = 1 - (xx + zz);
		te[9] = yz - wx;
		te[2] = xz - wy;
		te[6] = yz + wx;
		te[10] = 1 - (xx + yy);
		return this;
	}
	,setRotationFromEuler: function(v,order) {
		var te = this.elements;
		var x = v.x, y = v.y, z = v.z;
		var a = Math.cos(x), b = Math.sin(x);
		var c = Math.cos(y), d = Math.sin(y);
		var e = Math.cos(z), f = Math.sin(z);
		if(order == three.math.EulerOrder.XYZ) {
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
		} else if(order == three.math.EulerOrder.YXZ) {
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
		} else if(order == three.math.EulerOrder.ZXY) {
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
		} else if(order == three.math.EulerOrder.ZYX) {
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
		} else if(order == three.math.EulerOrder.YZX) {
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
		} else if(order == three.math.EulerOrder.XZY) {
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
	,getInverse: function(m) {
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
	,getColumnZ: function() {
		var te = this.elements;
		return new three.math.Vector3(te[8],te[9],te[10]);
	}
	,getColumnY: function() {
		var te = this.elements;
		return new three.math.Vector3(te[4],te[5],te[6]);
	}
	,getColumnX: function() {
		var te = this.elements;
		return new three.math.Vector3(te[0],te[1],te[2]);
	}
	,setPosition: function(v) {
		var te = this.elements;
		te[12] = v.x;
		te[13] = v.y;
		te[14] = v.z;
		return this;
	}
	,getPosition: function() {
		var te = this.elements;
		return new three.math.Vector3(te[12],te[13],te[14]);
	}
	,flattenToArrayOffset: function(flat,offset) {
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
	,flattenToArray: function(flat) {
		var te = this.elements;
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
	,transpose: function() {
		var te = this.elements;
		var tmp;
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
	,determinant: function() {
		var te = this.elements;
		var n11 = te[0], n12 = te[4], n13 = te[8], n14 = te[12];
		var n21 = te[1], n22 = te[5], n23 = te[9], n24 = te[13];
		var n31 = te[2], n32 = te[6], n33 = te[10], n34 = te[14];
		var n41 = te[3], n42 = te[7], n43 = te[11], n44 = te[15];
		return n14 * n23 * n32 * n41 - n13 * n24 * n32 * n41 - n14 * n22 * n33 * n41 + n12 * n24 * n33 * n41 + n13 * n22 * n34 * n41 - n12 * n23 * n34 * n41 - n14 * n23 * n31 * n42 + n13 * n24 * n31 * n42 + n14 * n21 * n33 * n42 - n11 * n24 * n33 * n42 - n13 * n21 * n34 * n42 + n11 * n23 * n34 * n42 + n14 * n22 * n31 * n43 - n12 * n24 * n31 * n43 - n14 * n21 * n32 * n43 + n11 * n24 * n32 * n43 + n12 * n21 * n34 * n43 - n11 * n22 * n34 * n43 - n13 * n22 * n31 * n44 + n12 * n23 * n31 * n44 + n13 * n21 * n32 * n44 - n11 * n23 * n32 * n44 - n12 * n21 * n33 * n44 + n11 * n22 * n33 * n44;
	}
	,crossVector: function(a) {
		var te = this.elements;
		var v = new three.math.Vector4();
		v.x = te[0] * a.x + te[4] * a.y + te[8] * a.z + te[12] * a.w;
		v.y = te[1] * a.x + te[5] * a.y + te[9] * a.z + te[13] * a.w;
		v.z = te[2] * a.x + te[6] * a.y + te[10] * a.z + te[14] * a.w;
		v.w = a.w != 0?te[3] * a.x + te[7] * a.y + te[11] * a.z + te[15] * a.w:1;
		return v;
	}
	,rotateAxis: function(v) {
		var te = this.elements;
		var vx = v.x, vy = v.y, vz = v.z;
		v.x = vx * te[0] + vy * te[4] + vz * te[8];
		v.y = vx * te[1] + vy * te[5] + vz * te[9];
		v.z = vx * te[2] + vy * te[6] + vz * te[10];
		v.normalize();
		return v;
	}
	,multiplyVector3Array: function(a) {
		var tVar = three.utils.TempVars.getTempVars();
		var tmp = tVar.vect1;
		var il = a.length;
		var i = 0;
		while(i < il) {
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
	,multiplyVector4: function(v) {
		var te = this.elements;
		var vx = v.x, vy = v.y, vz = v.z, vw = v.w;
		v.x = te[0] * vx + te[4] * vy + te[8] * vz + te[12] * vw;
		v.y = te[1] * vx + te[5] * vy + te[9] * vz + te[13] * vw;
		v.z = te[2] * vx + te[6] * vy + te[10] * vz + te[14] * vw;
		v.w = te[3] * vx + te[7] * vy + te[11] * vz + te[15] * vw;
		return v;
	}
	,multiplyVector3: function(v) {
		var te = this.elements;
		var vx = v.x, vy = v.y, vz = v.z;
		var d = 1 / (te[3] * vx + te[7] * vy + te[11] * vz + te[15]);
		v.x = (te[0] * vx + te[4] * vy + te[8] * vz + te[12]) * d;
		v.y = (te[1] * vx + te[5] * vy + te[9] * vz + te[13]) * d;
		v.z = (te[2] * vx + te[6] * vy + te[10] * vz + te[14]) * d;
		return v;
	}
	,multiplyScalar: function(s) {
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
	,multiplyToArray: function(a,b,r) {
		var te = this.elements;
		this.multiply(a,b);
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
	,multiplySelf: function(m) {
		return this.multiply(this,m);
	}
	,multiply: function(a,b) {
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
	,lookAt: function(eye,target,up) {
		var te = this.elements;
		var tVar = three.utils.TempVars.getTempVars();
		var vx = tVar.vect1;
		var vy = tVar.vect2;
		var vz = tVar.vect2;
		vz.sub(eye,target).normalize();
		if(vz.get_length() == 0) vz.z = 1;
		vx.cross(up,vz).normalize();
		if(vx.get_length() == 0) {
			vz.x += 0.0001;
			vx.cross(up,vz).normalize();
		}
		vy.cross(vz,vx);
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
	,copy: function(m) {
		var me = m.elements;
		this.setTo(me[0],me[4],me[8],me[12],me[1],me[5],me[9],me[13],me[2],me[6],me[10],me[14],me[3],me[7],me[11],me[15]);
		return this;
	}
	,identity: function() {
		this.setTo(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1);
		return this;
	}
	,setTo: function(n11,n12,n13,n14,n21,n22,n23,n24,n31,n32,n33,n34,n41,n42,n43,n44) {
		var te = this.elements;
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
	,__class__: three.math.Matrix4
}
three.core = {}
three.core.Object3D = function() {
	this.id = three.core.Object3D.Object3DCount++;
	this.name = "";
	this.properties = { };
	this.parent = null;
	this.children = new Array();
	this.up = new three.math.Vector3(0,1,0);
	this.position = new three.math.Vector3();
	this.rotation = new three.math.Vector3();
	this.eulerOrder = three.math.EulerOrder.XYZ;
	this.scale = new three.math.Vector3(1,1,1);
	this.renderDepth = null;
	this.rotationAutoUpdate = true;
	this.matrix = new three.math.Matrix4();
	this.matrixWorld = new three.math.Matrix4();
	this.matrixRotationWorld = new three.math.Matrix4();
	this.matrixAutoUpdate = true;
	this.matrixWorldNeedsUpdate = true;
	this.quaternion = new three.math.Quaternion();
	this.useQuaternion = false;
	this.boundRadius = 0.0;
	this.boundRadiusScale = 1.0;
	this.visible = true;
	this.castShadow = false;
	this.receiveShadow = false;
	this.frustumCulled = true;
	this._vector = new three.math.Vector3();
};
three.core.Object3D.__name__ = true;
three.core.Object3D.prototype = {
	clone: function() {
		return null;
	}
	,localToWorld: function(vector) {
		return this.matrixWorld.multiplyVector3(vector);
	}
	,worldToLocal: function(vector) {
		return three.core.Object3D._m1.getInverse(this.matrixWorld).multiplyVector3(vector);
	}
	,updateMatrixWorld: function(force) {
		if(force == null) force = false;
		if(this.matrixAutoUpdate) this.updateMatrix();
		if(this.matrixWorldNeedsUpdate || force) {
			if(this.parent != null) this.matrixWorld.multiply(this.parent.matrixWorld,this.matrix); else this.matrixWorld.copy(this.matrix);
			this.matrixWorldNeedsUpdate = false;
			force = true;
		}
		var _g1 = 0, _g = this.children.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.children[i].updateMatrixWorld(force);
		}
	}
	,updateMatrix: function() {
		this.matrix.setPosition(this.position);
		if(this.useQuaternion) this.matrix.setRotationFromQuaternion(this.quaternion); else this.matrix.setRotationFromEuler(this.rotation,this.eulerOrder);
		if(this.scale.x != 1 || this.scale.y != 1 || this.scale.z != 1) {
			this.matrix.scale(this.scale);
			this.boundRadiusScale = Math.max(this.scale.x,Math.max(this.scale.y,this.scale.z));
		}
		this.matrixWorldNeedsUpdate = true;
	}
	,getChildByName: function(name,recursive) {
		var child;
		var _g1 = 0, _g = this.children.length;
		while(_g1 < _g) {
			var c = _g1++;
			child = this.children[c];
			if(child.name == name) return child;
			if(recursive) {
				child = child.getChildByName(name,recursive);
				if(child != null) return child;
			}
		}
		return null;
	}
	,remove: function(object) {
		var index = this.children.indexOf(object);
		if(index != -1) {
			object.parent = null;
			this.children.splice(index,1);
			var scene = js.Boot.__cast(this , three.scenes.Scene);
			while(scene.parent != null) scene = js.Boot.__cast(scene.parent , three.scenes.Scene);
			if(scene != null && js.Boot.__instanceof(scene,three.scenes.Scene)) scene.__removeObject(object);
		}
	}
	,add: function(object) {
		if(object == this) {
			three.utils.Logger.warn("Object3D.add: An object can't be added as a child of itself.");
			return;
		}
		if(js.Boot.__instanceof(object,three.core.Object3D)) {
			if(object.parent != null) object.parent.remove(object);
			object.parent = this;
			this.children.push(object);
			var scene = js.Boot.__cast(this , three.scenes.Scene);
			while(scene.parent != null) scene = js.Boot.__cast(scene.parent , three.scenes.Scene);
			if(scene != null && js.Boot.__instanceof(scene,three.scenes.Scene)) scene.__addObject(object);
		}
	}
	,lookAt: function(vector) {
		this.matrix.lookAt(vector,this.position,this.up);
		if(this.rotationAutoUpdate) this.rotation.setEulerFromRotationMatrix(this.matrix,this.eulerOrder);
	}
	,translateZ: function(distance) {
		this.translate(distance,three.math.Vector3.Z_AXIS);
	}
	,translateY: function(distance) {
		this.translate(distance,three.math.Vector3.Y_AXIS);
	}
	,translateX: function(distance) {
		this.translate(distance,three.math.Vector3.X_AXIS);
	}
	,translate: function(distance,axis) {
		this.matrix.rotateAxis(axis);
		this.position.addSelf(axis.multiplyScalar(distance));
	}
	,applyMatrix: function(matrix) {
		this.matrix.multiply(matrix,this.matrix);
		this.scale.getScaleFromMatrix(this.matrix);
		var mat = new three.math.Matrix4().extractRotation(this.matrix);
		this.rotation.setEulerFromRotationMatrix(mat,this.eulerOrder);
		this.position.getPositionFromMatrix(this.matrix);
	}
	,__class__: three.core.Object3D
}
three.cameras = {}
three.cameras.Camera = function() {
	three.core.Object3D.call(this);
	this.matrixWorldInverse = new three.math.Matrix4();
	this.projectionMatrix = new three.math.Matrix4();
	this.projectionMatrixInverse = new three.math.Matrix4();
};
three.cameras.Camera.__name__ = true;
three.cameras.Camera.__super__ = three.core.Object3D;
three.cameras.Camera.prototype = $extend(three.core.Object3D.prototype,{
	lookAt: function(target) {
		this.matrix.lookAt(this.position,target,this.up);
		if(this.rotationAutoUpdate) this.rotation.setEulerFromRotationMatrix(this.matrix,this.eulerOrder);
	}
	,__class__: three.cameras.Camera
});
three.core.BoundingBox = function() {
	this.min = new three.math.Vector3(Math.POSITIVE_INFINITY,Math.POSITIVE_INFINITY,Math.POSITIVE_INFINITY);
	this.max = new three.math.Vector3(Math.NEGATIVE_INFINITY,Math.NEGATIVE_INFINITY,Math.NEGATIVE_INFINITY);
};
three.core.BoundingBox.__name__ = true;
three.core.BoundingBox.prototype = {
	computeFromVertexs: function(vertexs) {
		if(vertexs.length == 0) {
			this.resetTo(0,0,0);
			return;
		}
		var p;
		p = vertexs[0];
		this.resetTo(p.x,p.y,p.z);
		var _g1 = 0, _g = vertexs.length;
		while(_g1 < _g) {
			var i = _g1++;
			p = vertexs[i];
			if(p.x < this.min.x) this.min.x = p.x; else if(p.x > this.max.x) this.max.x = p.x;
			if(p.y < this.min.y) this.min.y = p.y; else if(p.y > this.max.y) this.max.y = p.y;
			if(p.z < this.min.z) this.min.z = p.z; else if(p.z > this.max.z) this.max.z = p.z;
		}
	}
	,computeFromPoints: function(points) {
		var x, y, z;
		var i = 0;
		var pSize = points.length;
		while(i < pSize) {
			x = points[i];
			y = points[i + 1];
			z = points[i + 2];
			if(x < this.min.x) this.min.x = x; else if(x > this.max.x) this.max.x = x;
			if(y < this.min.y) this.min.y = y; else if(y > this.max.y) this.max.y = y;
			if(z < this.min.z) this.min.z = z; else if(z > this.max.z) this.max.z = z;
			i += 3;
		}
	}
	,resetTo: function(x,y,z) {
		this.min.setTo(x,y,z);
		this.max.setTo(x,y,z);
	}
	,__class__: three.core.BoundingBox
}
three.core.BoundingSphere = function(radius) {
	if(radius == null) radius = 0;
	this.radius = radius;
};
three.core.BoundingSphere.__name__ = true;
three.core.BoundingSphere.prototype = {
	computeFromVertexs: function(vertexs) {
		if(vertexs.length == 0) {
			this.radius = 0;
			return;
		}
		var p;
		var radiusSq, maxRadiusSq = 0;
		var _g1 = 0, _g = vertexs.length;
		while(_g1 < _g) {
			var i = _g1++;
			p = vertexs[i];
			radiusSq = p.get_lengthSq();
			if(radiusSq > maxRadiusSq) maxRadiusSq = radiusSq;
		}
		this.radius = Math.sqrt(maxRadiusSq);
	}
	,computeFromPoints: function(points) {
		var x, y, z;
		var radiusSq, maxRadiusSq = 0;
		var i = 0;
		var pSize = points.length;
		while(i < pSize) {
			x = points[i];
			y = points[i + 1];
			z = points[i + 2];
			radiusSq = x * x + y * y + z * z;
			if(radiusSq > maxRadiusSq) maxRadiusSq = radiusSq;
			i += 3;
		}
		this.radius = Math.sqrt(maxRadiusSq);
	}
	,__class__: three.core.BoundingSphere
}
three.core.EventDispatcher = function() {
	this.listeners = new haxe.ds.StringMap();
};
three.core.EventDispatcher.__name__ = true;
three.core.EventDispatcher.prototype = {
	dispatchEvent: function(event) {
		var listenerArray = this.listeners.get(event.type);
		if(listenerArray != null) {
			event.target = this;
			var _g1 = 0, _g = listenerArray.length;
			while(_g1 < _g) {
				var i = _g1++;
				listenerArray[i].call(this,event);
			}
		}
	}
	,removeEventListener: function(type,listener) {
		var list = this.listeners.get(type);
		var x = listener;
		HxOverrides.remove(list,x);
	}
	,addEventListener: function(type,listener) {
		var list;
		if(!this.listeners.exists(type)) {
			list = [];
			this.listeners.set(type,list);
		} else list = this.listeners.get(type);
		if(three.utils.ArrayUtil.indexOf(list,listener) == -1) list.push(listener);
	}
	,__class__: three.core.EventDispatcher
}
three.core.Face = function() {
};
three.core.Face.__name__ = true;
three.core.Face.prototype = {
	__class__: three.core.Face
}
three.core.Face3 = function(a,b,c,normal,color,materialIndex) {
	if(materialIndex == null) materialIndex = 0;
	three.core.Face.call(this);
	this.a = a;
	this.b = b;
	this.c = c;
	this.normal = js.Boot.__instanceof(normal,three.math.Vector3)?normal:new three.math.Vector3();
	this.vertexNormals = js.Boot.__instanceof(normal,Array)?normal:[];
	this.color = js.Boot.__instanceof(color,three.math.Color)?color:new three.math.Color();
	this.vertexColors = js.Boot.__instanceof(color,Array)?color:[];
	this.vertexTangents = [];
	this.materialIndex = materialIndex;
	this.centroid = new three.math.Vector3();
};
three.core.Face3.__name__ = true;
three.core.Face3.__super__ = three.core.Face;
three.core.Face3.prototype = $extend(three.core.Face.prototype,{
	clone: function() {
		var face = new three.core.Face3(this.a,this.b,this.c);
		face.normal.copy(this.normal);
		face.color.copy(this.color);
		face.centroid.copy(this.centroid);
		face.materialIndex = this.materialIndex;
		var _g1 = 0, _g = this.vertexNormals.length;
		while(_g1 < _g) {
			var i = _g1++;
			face.vertexNormals[i] = this.vertexNormals[i].clone();
		}
		var _g1 = 0, _g = this.vertexColors.length;
		while(_g1 < _g) {
			var i = _g1++;
			face.vertexColors[i] = this.vertexColors[i].clone();
		}
		var _g1 = 0, _g = this.vertexTangents.length;
		while(_g1 < _g) {
			var i = _g1++;
			face.vertexTangents[i] = this.vertexTangents[i].clone();
		}
		return face;
	}
	,__class__: three.core.Face3
});
three.core.Face4 = function(a,b,c,d,normal,color,materialIndex) {
	if(materialIndex == null) materialIndex = 0;
	three.core.Face.call(this);
	this.a = a;
	this.b = b;
	this.c = c;
	this.d = d;
	this.normal = js.Boot.__instanceof(normal,three.math.Vector3)?normal:new three.math.Vector3();
	this.vertexNormals = js.Boot.__instanceof(normal,Array)?normal:[];
	this.color = js.Boot.__instanceof(color,three.math.Color)?color:new three.math.Color();
	this.vertexColors = js.Boot.__instanceof(color,Array)?color:[];
	this.vertexTangents = [];
	this.materialIndex = materialIndex;
	this.centroid = new three.math.Vector3();
};
three.core.Face4.__name__ = true;
three.core.Face4.__super__ = three.core.Face;
three.core.Face4.prototype = $extend(three.core.Face.prototype,{
	clone: function() {
		var face = new three.core.Face4(this.a,this.b,this.c,this.d);
		face.normal.copy(this.normal);
		face.color.copy(this.color);
		face.centroid.copy(this.centroid);
		face.materialIndex = this.materialIndex;
		var _g1 = 0, _g = this.vertexNormals.length;
		while(_g1 < _g) {
			var i = _g1++;
			face.vertexNormals[i] = this.vertexNormals[i].clone();
		}
		var _g1 = 0, _g = this.vertexColors.length;
		while(_g1 < _g) {
			var i = _g1++;
			face.vertexColors[i] = this.vertexColors[i].clone();
		}
		var _g1 = 0, _g = this.vertexTangents.length;
		while(_g1 < _g) {
			var i = _g1++;
			face.vertexTangents[i] = this.vertexTangents[i].clone();
		}
		return face;
	}
	,__class__: three.core.Face4
});
three.core.Geometry = function() {
	this.id = three.core.Geometry.GeometryCount++;
	this.name = "";
	this.vertices = [];
	this.colors = [];
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
	this.isDynamic = true;
};
three.core.Geometry.__name__ = true;
three.core.Geometry.prototype = {
	clone: function() {
		return null;
	}
	,mergeVertices: function() {
		var verticesMap = { };
		var unique = [], changes = [];
		var v;
		var key;
		var precisionPoints = 4;
		var precision = Math.pow(10,precisionPoints);
		var face;
		var abcd = "abcd";
		var o;
		var k;
		var _g1 = 0, _g = this.vertices.length;
		while(_g1 < _g) {
			var i = _g1++;
			v = this.vertices[i];
			key = [Math.round(v.x * precision),Math.round(v.y * precision),Math.round(v.z * precision)].join("_");
			if(verticesMap[key] == null) {
				verticesMap[key] = i;
				unique.push(this.vertices[i]);
				changes[i] = unique.length - 1;
			} else changes[i] = changes[verticesMap[key]];
		}
		var u;
		var _g1 = 0, _g = this.faces.length;
		while(_g1 < _g) {
			var i = _g1++;
			face = this.faces[i];
			if(js.Boot.__instanceof(face,three.core.Face3)) {
				face.a = changes[face.a];
				face.b = changes[face.b];
				face.c = changes[face.c];
			} else if(js.Boot.__instanceof(face,three.core.Face4)) {
				var face4 = face;
				face4.a = changes[face4.a];
				face4.b = changes[face4.b];
				face4.c = changes[face4.c];
				face4.d = changes[face4.d];
				o = [face4.a,face4.b,face4.c,face4.d];
				k = 3;
				while(k > 0) {
					var faceIndex = face[abcd[k]];
					if(o.indexOf(faceIndex) != k) {
						o.splice(k,1);
						this.faces[i] = new three.core.Face3(o[0],o[1],o[2],face.normal,face.color,face.materialIndex);
						var _g3 = 0, _g2 = this.faceVertexUvs.length;
						while(_g3 < _g2) {
							var j = _g3++;
							u = this.faceVertexUvs[j][i];
							if(u != null) u.splice(k,1);
						}
						this.faces[i].vertexColors = face.vertexColors;
						break;
					}
					k--;
				}
			}
		}
		var diff = this.vertices.length - unique.length;
		this.vertices = unique;
		return diff;
	}
	,computeBoundingSphere: function() {
		if(this.boundingSphere == null) this.boundingSphere = new three.core.BoundingSphere();
		this.boundingSphere.computeFromVertexs(this.vertices);
	}
	,computeBoundingBox: function() {
		if(this.boundingBox == null) this.boundingBox = new three.core.BoundingBox();
		this.boundingBox.computeFromVertexs(this.vertices);
	}
	,computeTangents: function() {
		var face;
		var uv;
		var tan1 = [];
		var tan2 = [];
		var _g1 = 0, _g = this.vertices.length;
		while(_g1 < _g) {
			var v = _g1++;
			tan1[v] = new three.math.Vector3();
			tan2[v] = new three.math.Vector3();
		}
		var _g1 = 0, _g = this.faces.length;
		while(_g1 < _g) {
			var f = _g1++;
			face = this.faces[f];
			uv = this.faceVertexUvs[0][f];
			if(js.Boot.__instanceof(face,three.core.Face3)) this.handleTriangle(this,face.a,face.b,face.c,0,1,2,uv,tan1,tan2); else if(js.Boot.__instanceof(face,three.core.Face4)) {
				var face4 = face;
				this.handleTriangle(this,face4.a,face4.b,face4.d,0,1,3,uv,tan1,tan2);
				this.handleTriangle(this,face4.b,face4.c,face4.d,1,2,3,uv,tan1,tan2);
			}
		}
		var faceIndex = ["a","b","c","d"];
		var n = new three.math.Vector3();
		var vertexIndex;
		var t;
		var tmp = new three.math.Vector3();
		var tmp2 = new three.math.Vector3();
		var _g1 = 0, _g = this.faces.length;
		while(_g1 < _g) {
			var f = _g1++;
			face = this.faces[f];
			var _g3 = 0, _g2 = face.vertexNormals.length;
			while(_g3 < _g2) {
				var i = _g3++;
				n.copy(face.vertexNormals[i]);
				vertexIndex = face[faceIndex[i]];
				t = tan1[vertexIndex];
				tmp.copy(t);
				tmp.subSelf(n.multiplyScalar(n.dot(t))).normalize();
				tmp2.cross(face.vertexNormals[i],t);
				var test = tmp2.dot(tan2[vertexIndex]);
				var w = test < 0.0?-1.0:1.0;
				face.vertexTangents[i] = new three.math.Vector4(tmp.x,tmp.y,tmp.z,w);
			}
		}
		this.hasTangents = true;
	}
	,handleTriangle: function(context,a,b,c,ua,ub,uc,uv,tan1,tan2) {
		var vA = context.vertices[a];
		var vB = context.vertices[b];
		var vC = context.vertices[c];
		var uvA = uv[ua];
		var uvB = uv[ub];
		var uvC = uv[uc];
		var x1 = vB.x - vA.x;
		var x2 = vC.x - vA.x;
		var y1 = vB.y - vA.y;
		var y2 = vC.y - vA.y;
		var z1 = vB.z - vA.z;
		var z2 = vC.z - vA.z;
		var s1 = uvB.u - uvA.u;
		var s2 = uvC.u - uvA.u;
		var t1 = uvB.v - uvA.v;
		var t2 = uvC.v - uvA.v;
		var r = 1.0 / (s1 * t2 - s2 * t1);
		var sdir = new three.math.Vector3();
		var tdir = new three.math.Vector3();
		sdir.setTo((t2 * x1 - t1 * x2) * r,(t2 * y1 - t1 * y2) * r,(t2 * z1 - t1 * z2) * r);
		tdir.setTo((s1 * x2 - s2 * x1) * r,(s1 * y2 - s2 * y1) * r,(s1 * z2 - s2 * z1) * r);
		tan1[a].addSelf(sdir);
		tan1[b].addSelf(sdir);
		tan1[c].addSelf(sdir);
		tan2[a].addSelf(tdir);
		tan2[b].addSelf(tdir);
		tan2[c].addSelf(tdir);
	}
	,computeMorphNormals: function() {
		var face;
		var _g1 = 0, _g = this.faces.length;
		while(_g1 < _g) {
			var f = _g1++;
			face = this.faces[f];
			if(face.__originalFaceNormal == null) face.__originalFaceNormal = face.normal.clone(); else face.__originalFaceNormal.copy(face.normal);
			if(face.__originalVertexNormals == null) face.__originalVertexNormals = [];
			var _g3 = 0, _g2 = face.vertexNormals.length;
			while(_g3 < _g2) {
				var i = _g3++;
				if(face.__originalVertexNormals[i] == null) face.__originalVertexNormals[i] = face.vertexNormals[i].clone(); else face.__originalVertexNormals[i].copy(face.vertexNormals[i]);
			}
		}
		var tmpGeo = new three.core.Geometry();
		tmpGeo.faces = this.faces;
		var _g1 = 0, _g = this.morphTargets.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.morphNormals[i] == null) {
				this.morphNormals[i] = { };
				this.morphNormals[i].faceNormals = [];
				this.morphNormals[i].vertexNormals = [];
				var dstNormalsFace = this.morphNormals[i].faceNormals;
				var dstNormalsVertex = this.morphNormals[i].vertexNormals;
				var faceNormal;
				var vertexNormals;
				var _g3 = 0, _g2 = this.faces.length;
				while(_g3 < _g2) {
					var f = _g3++;
					face = this.faces[f];
					faceNormal = new three.math.Vector3();
					if(js.Boot.__instanceof(face,three.core.Face3)) vertexNormals = { a : new three.math.Vector3(), b : new three.math.Vector3(), c : new three.math.Vector3()}; else vertexNormals = { a : new three.math.Vector3(), b : new three.math.Vector3(), c : new three.math.Vector3(), d : new three.math.Vector3()};
					dstNormalsFace.push(faceNormal);
					dstNormalsVertex.push(vertexNormals);
				}
			}
			var morphNormals = this.morphNormals[i];
			tmpGeo.vertices = this.morphTargets[i].vertices;
			tmpGeo.computeFaceNormals();
			tmpGeo.computeVertexNormals();
			var faceNormal;
			var vertexNormals;
			var _g3 = 0, _g2 = this.faces.length;
			while(_g3 < _g2) {
				var f = _g3++;
				face = this.faces[f];
				faceNormal = morphNormals.faceNormals[f];
				vertexNormals = morphNormals.vertexNormals[f];
				faceNormal.copy(face.normal);
				if(js.Boot.__instanceof(face,three.core.Face3)) {
					vertexNormals.a.copy(face.vertexNormals[0]);
					vertexNormals.b.copy(face.vertexNormals[1]);
					vertexNormals.c.copy(face.vertexNormals[2]);
				} else {
					vertexNormals.a.copy(face.vertexNormals[0]);
					vertexNormals.b.copy(face.vertexNormals[1]);
					vertexNormals.c.copy(face.vertexNormals[2]);
					vertexNormals.d.copy(face.vertexNormals[3]);
				}
			}
		}
		var _g1 = 0, _g = this.faces.length;
		while(_g1 < _g) {
			var f = _g1++;
			face = this.faces[f];
			face.normal = face.__originalFaceNormal;
			face.vertexNormals = face.__originalVertexNormals;
		}
	}
	,computeVertexNormals: function() {
		var vertices;
		var face;
		if(this.__tmpVertices == null) {
			this.__tmpVertices = new Array();
			vertices = this.__tmpVertices;
			var _g1 = 0, _g = this.vertices.length;
			while(_g1 < _g) {
				var v = _g1++;
				vertices[v] = new three.math.Vector3();
			}
			var _g1 = 0, _g = this.faces.length;
			while(_g1 < _g) {
				var f = _g1++;
				var face1 = this.faces[f];
				if(js.Boot.__instanceof(face1,three.core.Face3)) face1.vertexNormals = [new three.math.Vector3(),new three.math.Vector3(),new three.math.Vector3()]; else if(js.Boot.__instanceof(face1,three.core.Face4)) face1.vertexNormals = [new three.math.Vector3(),new three.math.Vector3(),new three.math.Vector3(),new three.math.Vector3()];
			}
		} else {
			vertices = this.__tmpVertices;
			var _g1 = 0, _g = this.vertices.length;
			while(_g1 < _g) {
				var v = _g1++;
				vertices[v].setTo(0,0,0);
			}
		}
		var _g1 = 0, _g = this.faces.length;
		while(_g1 < _g) {
			var f = _g1++;
			face = this.faces[f];
			if(js.Boot.__instanceof(face,three.core.Face3)) {
				vertices[face.a].addSelf(face.normal);
				vertices[face.b].addSelf(face.normal);
				vertices[face.c].addSelf(face.normal);
			} else if(js.Boot.__instanceof(face,three.core.Face4)) {
				var face4 = face;
				vertices[face4.a].addSelf(face4.normal);
				vertices[face4.b].addSelf(face4.normal);
				vertices[face4.c].addSelf(face4.normal);
				vertices[face4.d].addSelf(face4.normal);
			}
		}
		var _g1 = 0, _g = this.vertices.length;
		while(_g1 < _g) {
			var v = _g1++;
			vertices[v].normalize();
		}
		var _g1 = 0, _g = this.faces.length;
		while(_g1 < _g) {
			var f = _g1++;
			face = this.faces[f];
			if(js.Boot.__instanceof(face,three.core.Face3)) {
				face.vertexNormals[0].copy(vertices[face.a]);
				face.vertexNormals[1].copy(vertices[face.b]);
				face.vertexNormals[2].copy(vertices[face.c]);
			} else if(js.Boot.__instanceof(face,three.core.Face4)) {
				var face4 = face;
				face4.vertexNormals[0].copy(vertices[face4.a]);
				face4.vertexNormals[1].copy(vertices[face4.b]);
				face4.vertexNormals[2].copy(vertices[face4.c]);
				face4.vertexNormals[3].copy(vertices[face4.d]);
			}
		}
	}
	,computeFaceNormals: function() {
		var face;
		var cb = new three.math.Vector3();
		var ab = new three.math.Vector3();
		var _g1 = 0, _g = this.faces.length;
		while(_g1 < _g) {
			var f = _g1++;
			face = this.faces[f];
			var vA = this.vertices[face.a];
			var vB = this.vertices[face.b];
			var vC = this.vertices[face.c];
			cb.sub(vC,vB);
			ab.sub(vA,vB);
			cb.crossSelf(ab);
			if(!cb.isZero()) cb.normalize();
			face.normal.copy(cb);
		}
	}
	,computeCentroids: function() {
		var face;
		var _g1 = 0, _g = this.faces.length;
		while(_g1 < _g) {
			var f = _g1++;
			face = this.faces[f];
			face.centroid.setTo(0,0,0);
			if(js.Boot.__instanceof(face,three.core.Face3)) {
				face.centroid.addSelf(this.vertices[face.a]);
				face.centroid.addSelf(this.vertices[face.b]);
				face.centroid.addSelf(this.vertices[face.c]);
				face.centroid.divideScalar(3);
			} else if(js.Boot.__instanceof(face,three.core.Face4)) {
				var face4 = face;
				face4.centroid.addSelf(this.vertices[face4.a]);
				face4.centroid.addSelf(this.vertices[face4.b]);
				face4.centroid.addSelf(this.vertices[face4.c]);
				face4.centroid.addSelf(this.vertices[face4.d]);
				face4.centroid.divideScalar(4);
			}
		}
	}
	,applyMatrix: function(matrix) {
		var matrixRotation = new three.math.Matrix4();
		matrixRotation.extractRotation(matrix);
		var _g1 = 0, _g = this.vertices.length;
		while(_g1 < _g) {
			var i = _g1++;
			var vertex = this.vertices[i];
			matrix.multiplyVector3(vertex);
		}
		var _g1 = 0, _g = this.faces.length;
		while(_g1 < _g) {
			var i = _g1++;
			var face = this.faces[i];
			matrixRotation.multiplyVector3(face.normal);
			var _g3 = 0, _g2 = face.vertexNormals.length;
			while(_g3 < _g2) {
				var j = _g3++;
				matrixRotation.multiplyVector3(face.vertexNormals[j]);
			}
			matrix.multiplyVector3(face.centroid);
		}
	}
	,__class__: three.core.Geometry
}
three.core.UV = function(u,v) {
	if(v == null) v = 0;
	if(u == null) u = 0;
	this.u = u;
	this.v = v;
};
three.core.UV.__name__ = true;
three.core.UV.prototype = {
	lerpSelf: function(uv,interp) {
		this.u += (uv.u - this.u) * interp;
		this.v += (uv.v - this.v) * interp;
		return this;
	}
	,setTo: function(u,v) {
		this.u = u;
		this.v = v;
		return this;
	}
	,clone: function() {
		return new three.core.UV(this.u,this.v);
	}
	,copy: function(value) {
		this.u = value.u;
		this.v = value.v;
		return this;
	}
	,__class__: three.core.UV
}
three.lights = {}
three.lights.Light = function(hex) {
	three.core.Object3D.call(this);
	this.color = new three.math.Color(hex);
};
three.lights.Light.__name__ = true;
three.lights.Light.__super__ = three.core.Object3D;
three.lights.Light.prototype = $extend(three.core.Object3D.prototype,{
	__class__: three.lights.Light
});
three.materials = {}
three.materials.Material = function() {
	this.alphaTest = 0;
	this.id = three.materials.Material.MaterialCount++;
	this.name = "";
	this.side = 0;
	this.opacity = 1;
	this.transparent = false;
	this.blending = 1;
	this.blendSrc = 204;
	this.blendDst = 205;
	this.blendEquation = 100;
	this.depthTest = true;
	this.depthWrite = true;
	this.polygonOffset = 0;
	this.polygonOffsetFactor = 0;
	this.polygonOffsetUnits = 0;
	this.alphaTest = 0;
	this.overdraw = false;
	this.visible = true;
	this.needsUpdate = true;
};
three.materials.Material.__name__ = true;
three.materials.Material.prototype = {
	clone: function(material) {
		if(material == null) material = new three.materials.Material();
		material.name = this.name;
		material.side = this.side;
		material.opacity = this.opacity;
		material.transparent = this.transparent;
		material.blending = this.blending;
		material.blendSrc = this.blendSrc;
		material.blendDst = this.blendDst;
		material.blendEquation = this.blendEquation;
		material.depthTest = this.depthTest;
		material.depthWrite = this.depthWrite;
		material.polygonOffset = this.polygonOffset;
		material.polygonOffsetFactor = this.polygonOffsetFactor;
		material.polygonOffsetUnits = this.polygonOffsetUnits;
		material.alphaTest = this.alphaTest;
		material.overdraw = this.overdraw;
		material.visible = this.visible;
		return material;
	}
	,setValues: function(values) {
		if(values == null) return;
		var fields = Type.getClassFields(values);
		var _g = 0;
		while(_g < fields.length) {
			var key = fields[_g];
			++_g;
			var newValue = Reflect.field(values,key);
			if(newValue == null) {
				three.utils.Logger.warn("Material: '" + key + "' parameter is undefined.");
				continue;
			}
			if(Reflect.hasField(this,key)) {
				var currentValue = Reflect.field(values,key);
				if(js.Boot.__instanceof(currentValue,three.math.Color) && js.Boot.__instanceof(newValue,three.math.Color)) currentValue.copy(newValue); else if(js.Boot.__instanceof(currentValue,three.math.Color) && js.Boot.__instanceof(newValue,Float)) currentValue.setHex(newValue); else if(js.Boot.__instanceof(currentValue,three.math.Vector3) && js.Boot.__instanceof(newValue,three.math.Vector3)) currentValue.copy(newValue); else this[key] = newValue;
			}
		}
	}
	,__class__: three.materials.Material
}
three.materials.UVMapping = function() {
};
three.materials.UVMapping.__name__ = true;
three.materials.UVMapping.prototype = {
	__class__: three.materials.UVMapping
}
three.math.Color = function(value) {
	if(value == null) value = -16777216;
	this.set_rgba(value);
};
three.math.Color.__name__ = true;
three.math.Color.prototype = {
	set_rgba: function(value) {
		var invert = 1.0 / 255;
		this.a = (value >> 24 & 255) * invert;
		this.r = (value >> 16 & 255) * invert;
		this.g = (value >> 8 & 255) * invert;
		this.b = (value & 255) * invert;
		return value;
	}
	,get_rgba: function() {
		return Math.floor(this.a * 255) << 24 | Math.floor(this.r * 255) << 16 | Math.floor(this.g * 255) << 8 | Math.floor(this.b * 255);
	}
	,set_rgb: function(value) {
		var invert = 1.0 / 255;
		this.r = (value >> 16 & 255) * invert;
		this.g = (value >> 8 & 255) * invert;
		this.b = (value & 255) * invert;
		return value;
	}
	,get_rgb: function() {
		return Math.floor(this.r * 255) << 16 | Math.floor(this.g * 255) << 8 | Math.floor(this.b * 255);
	}
	,clone: function() {
		var result = new three.math.Color();
		result.copy(this);
		return result;
	}
	,copy: function(value) {
		this.r = value.r;
		this.g = value.g;
		this.b = value.b;
		this.a = value.a;
		return this;
	}
	,lerpSelf: function(color,interp) {
		this.r += (color.r - this.r) * interp;
		this.g += (color.g - this.g) * interp;
		this.b += (color.b - this.b) * interp;
		this.a += (color.a - this.a) * interp;
		return this;
	}
	,setTo: function(r,g,b,a) {
		if(a == null) a = 1.0;
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
		return this;
	}
	,setHSV: function(h,s,v) {
		var f, p, q, t;
		if(v == 0) this.r = this.g = this.b = 0; else {
			var i = Math.floor(h * 6);
			f = h * 6 - i;
			p = v * (1 - s);
			q = v * (1 - s * f);
			t = v * (1 - s * (1 - f));
			if(i == 0) {
				this.r = v;
				this.g = t;
				this.b = p;
			} else if(i == 1) {
				this.r = q;
				this.g = v;
				this.b = p;
			} else if(i == 2) {
				this.r = p;
				this.g = v;
				this.b = t;
			} else if(i == 3) {
				this.r = p;
				this.g = q;
				this.b = v;
			} else if(i == 4) {
				this.r = t;
				this.g = p;
				this.b = v;
			} else if(i == 5) {
				this.r = v;
				this.g = p;
				this.b = q;
			}
		}
		return this;
	}
	,__class__: three.math.Color
}
three.math.EulerOrder = { __ename__ : true, __constructs__ : ["XYZ","YXZ","ZXY","ZYX","YZX","XZY"] }
three.math.EulerOrder.XYZ = ["XYZ",0];
three.math.EulerOrder.XYZ.toString = $estr;
three.math.EulerOrder.XYZ.__enum__ = three.math.EulerOrder;
three.math.EulerOrder.YXZ = ["YXZ",1];
three.math.EulerOrder.YXZ.toString = $estr;
three.math.EulerOrder.YXZ.__enum__ = three.math.EulerOrder;
three.math.EulerOrder.ZXY = ["ZXY",2];
three.math.EulerOrder.ZXY.toString = $estr;
three.math.EulerOrder.ZXY.__enum__ = three.math.EulerOrder;
three.math.EulerOrder.ZYX = ["ZYX",3];
three.math.EulerOrder.ZYX.toString = $estr;
three.math.EulerOrder.ZYX.__enum__ = three.math.EulerOrder;
three.math.EulerOrder.YZX = ["YZX",4];
three.math.EulerOrder.YZX.toString = $estr;
three.math.EulerOrder.YZX.__enum__ = three.math.EulerOrder;
three.math.EulerOrder.XZY = ["XZY",5];
three.math.EulerOrder.XZY.toString = $estr;
three.math.EulerOrder.XZY.__enum__ = three.math.EulerOrder;
three.math.MathUtil = function() { }
three.math.MathUtil.__name__ = true;
three.math.MathUtil.clamp = function(value,min,max) {
	return value < min?min:value > max?max:value;
}
three.math.MathUtil.mapLinear = function(x,a1,a2,b1,b2) {
	return b1 + (x - a1) * (b2 - b1) / (a2 - a1);
}
three.math.MathUtil.randInt = function(low,high) {
	return low + Math.floor(Math.random() * (high - low + 1));
}
three.math.MathUtil.randFloat = function(low,high) {
	return low + Math.random() * (high - low);
}
three.math.MathUtil.sign = function(x) {
	return x < 0?-1:x > 0?1:0;
}
three.math.MathUtil.isPow2 = function(n) {
	var l = Math.log(n) / three.math.MathUtil.LN2;
	return Math.floor(l) == l;
}
three.math.MathUtil.nearestPow2 = function(n) {
	var l = Math.log(n) / three.math.MathUtil.LN2;
	return Math.pow(2,Math.round(l)) | 0;
}
three.math.MathUtil.isPowerOfTwo = function(value) {
	return (value & value - 1) == 0;
}
three.math.MathUtil.rgb2hex = function(rgb) {
	return ((rgb[0] * 255 | 0) << 16) + ((rgb[1] * 255 | 0) << 8) + (rgb[2] | 0) * 255;
}
three.math.Matrix3 = function() {
	this.elements = new Float32Array(9);
};
three.math.Matrix3.__name__ = true;
three.math.Matrix3.prototype = {
	transposeIntoArray: function(r) {
		var m = this.elements;
		r[0] = m[0];
		r[1] = m[3];
		r[2] = m[6];
		r[3] = m[1];
		r[4] = m[4];
		r[5] = m[7];
		r[6] = m[2];
		r[7] = m[5];
		r[8] = m[8];
		return this;
	}
	,transpose: function() {
		var tmp;
		var m = this.elements;
		tmp = m[1];
		m[1] = m[3];
		m[3] = tmp;
		tmp = m[2];
		m[2] = m[6];
		m[6] = tmp;
		tmp = m[5];
		m[5] = m[7];
		m[7] = tmp;
		return this;
	}
	,getInverse: function(matrix) {
		var me = matrix.elements;
		var a11 = me[10] * me[5] - me[6] * me[9];
		var a21 = -me[10] * me[1] + me[2] * me[9];
		var a31 = me[6] * me[1] - me[2] * me[5];
		var a12 = -me[10] * me[4] + me[6] * me[8];
		var a22 = me[10] * me[0] - me[2] * me[8];
		var a32 = -me[6] * me[0] + me[2] * me[4];
		var a13 = me[9] * me[4] - me[5] * me[8];
		var a23 = -me[9] * me[0] + me[1] * me[8];
		var a33 = me[5] * me[0] - me[1] * me[4];
		var det = me[0] * a11 + me[1] * a12 + me[2] * a13;
		if(det == 0) three.utils.Logger.warn("Matrix3.getInverse(): determinant == 0");
		var idet = 1.0 / det;
		var m = this.elements;
		m[0] = idet * a11;
		m[1] = idet * a21;
		m[2] = idet * a31;
		m[3] = idet * a12;
		m[4] = idet * a22;
		m[5] = idet * a32;
		m[6] = idet * a13;
		m[7] = idet * a23;
		m[8] = idet * a33;
		return this;
	}
	,__class__: three.math.Matrix3
}
three.math.Quaternion = function(x,y,z,w) {
	if(w == null) w = 1;
	if(z == null) z = 0;
	if(y == null) y = 0;
	if(x == null) x = 0;
	this.x = x;
	this.y = y;
	this.z = z;
	this.w = w;
};
three.math.Quaternion.__name__ = true;
three.math.Quaternion.prototype = {
	clone: function() {
		return new three.math.Quaternion(this.x,this.y,this.z,this.w);
	}
	,slerpSelf: function(qb,t) {
		var x = this.x, y = this.y, z = this.z, w = this.w;
		var cosHalfTheta = w * qb.w + x * qb.x + y * qb.y + z * qb.z;
		if(cosHalfTheta < 0) {
			this.w = -qb.w;
			this.x = -qb.x;
			this.y = -qb.y;
			this.z = -qb.z;
			cosHalfTheta = -cosHalfTheta;
		} else this.copy(qb);
		if(cosHalfTheta >= 1.0) {
			this.w = w;
			this.x = x;
			this.y = y;
			this.z = z;
			return this;
		}
		var halfTheta = Math.acos(cosHalfTheta);
		var sinHalfTheta = Math.sqrt(1.0 - cosHalfTheta * cosHalfTheta);
		if(Math.abs(sinHalfTheta) < 0.001) {
			this.w = 0.5 * (w + this.w);
			this.x = 0.5 * (x + this.x);
			this.y = 0.5 * (y + this.y);
			this.z = 0.5 * (z + this.z);
			return this;
		}
		var ratioA = Math.sin((1 - t) * halfTheta) / sinHalfTheta, ratioB = Math.sin(t * halfTheta) / sinHalfTheta;
		this.w = w * ratioA + this.w * ratioB;
		this.x = x * ratioA + this.x * ratioB;
		this.y = y * ratioA + this.y * ratioB;
		this.z = z * ratioA + this.z * ratioB;
		return this;
	}
	,multiplyVector3: function(vector,dest) {
		if(dest == null) dest = vector;
		var x = vector.x, y = vector.y, z = vector.z, qx = this.x, qy = this.y, qz = this.z, qw = this.w;
		var ix = qw * x + qy * z - qz * y, iy = qw * y + qz * x - qx * z, iz = qw * z + qx * y - qy * x, iw = -qx * x - qy * y - qz * z;
		dest.x = ix * qw + iw * -qx + iy * -qz - iz * -qy;
		dest.y = iy * qw + iw * -qy + iz * -qx - ix * -qz;
		dest.z = iz * qw + iw * -qz + ix * -qy - iy * -qx;
		return dest;
	}
	,multiplySelf: function(b) {
		var qax = this.x, qay = this.y, qaz = this.z, qaw = this.w, qbx = b.x, qby = b.y, qbz = b.z, qbw = b.w;
		this.x = qax * qbw + qaw * qbx + qay * qbz - qaz * qby;
		this.y = qay * qbw + qaw * qby + qaz * qbx - qax * qbz;
		this.z = qaz * qbw + qaw * qbz + qax * qby - qay * qbx;
		this.w = qaw * qbw - qax * qbx - qay * qby - qaz * qbz;
		return this;
	}
	,multiply: function(a,b) {
		var qax = a.x, qay = a.y, qaz = a.z, qaw = a.w, qbx = b.x, qby = b.y, qbz = b.z, qbw = b.w;
		this.x = qax * qbw + qay * qbz - qaz * qby + qaw * qbx;
		this.y = -qax * qbz + qay * qbw + qaz * qbx + qaw * qby;
		this.z = qax * qby - qay * qbx + qaz * qbw + qaw * qbz;
		this.w = -qax * qbx - qay * qby - qaz * qbz + qaw * qbw;
		return this;
	}
	,normalize: function() {
		var l = Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
		if(l == 0) {
			this.x = 0;
			this.y = 0;
			this.z = 0;
			this.w = 0;
		} else {
			l = 1 / l;
			this.x = this.x * l;
			this.y = this.y * l;
			this.z = this.z * l;
			this.w = this.w * l;
		}
		return this;
	}
	,get_length: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
	}
	,inverse: function() {
		this.x *= -1;
		this.y *= -1;
		this.z *= -1;
		return this;
	}
	,calculateW: function() {
		this.w = -Math.sqrt(Math.abs(1.0 - this.x * this.x - this.y * this.y - this.z * this.z));
		return this;
	}
	,setFromRotationMatrix: function(m) {
		var te = m.elements;
		var m11 = te[0], m12 = te[4], m13 = te[8];
		var m21 = te[1], m22 = te[5], m23 = te[9];
		var m31 = te[2], m32 = te[6], m33 = te[10];
		var tTrace = m11 + m22 + m33, s;
		if(tTrace > 0) {
			s = 0.5 / Math.sqrt(tTrace + 1.0);
			this.w = 0.25 / s;
			this.x = (m32 - m23) * s;
			this.y = (m13 - m31) * s;
			this.z = (m21 - m12) * s;
		} else if(m11 > m22 && m11 > m33) {
			s = 2.0 * Math.sqrt(1.0 + m11 - m22 - m33);
			this.w = (m32 - m23) / s;
			this.x = 0.25 * s;
			this.y = (m12 + m21) / s;
			this.z = (m13 + m31) / s;
		} else if(m22 > m33) {
			s = 2.0 * Math.sqrt(1.0 + m22 - m11 - m33);
			this.w = (m13 - m31) / s;
			this.x = (m12 + m21) / s;
			this.y = 0.25 * s;
			this.z = (m23 + m32) / s;
		} else {
			s = 2.0 * Math.sqrt(1.0 + m33 - m11 - m22);
			this.w = (m21 - m12) / s;
			this.x = (m13 + m31) / s;
			this.y = (m23 + m32) / s;
			this.z = 0.25 * s;
		}
		return this;
	}
	,setFromAxisAngle: function(axis,angle) {
		var halfAngle = angle / 2, s = Math.sin(halfAngle);
		this.x = axis.x * s;
		this.y = axis.y * s;
		this.z = axis.z * s;
		this.w = Math.cos(halfAngle);
		return this;
	}
	,setFromEuler: function(v,order) {
		var c1 = Math.cos(v.x / 2);
		var c2 = Math.cos(v.y / 2);
		var c3 = Math.cos(v.z / 2);
		var s1 = Math.sin(v.x / 2);
		var s2 = Math.sin(v.y / 2);
		var s3 = Math.sin(v.z / 2);
		if(order == null || order == three.math.EulerOrder.XYZ) {
			this.x = s1 * c2 * c3 + c1 * s2 * s3;
			this.y = c1 * s2 * c3 - s1 * c2 * s3;
			this.z = c1 * c2 * s3 + s1 * s2 * c3;
			this.w = c1 * c2 * c3 - s1 * s2 * s3;
		} else if(order == three.math.EulerOrder.YXZ) {
			this.x = s1 * c2 * c3 + c1 * s2 * s3;
			this.y = c1 * s2 * c3 - s1 * c2 * s3;
			this.z = c1 * c2 * s3 - s1 * s2 * c3;
			this.w = c1 * c2 * c3 + s1 * s2 * s3;
		} else if(order == three.math.EulerOrder.ZXY) {
			this.x = s1 * c2 * c3 - c1 * s2 * s3;
			this.y = c1 * s2 * c3 + s1 * c2 * s3;
			this.z = c1 * c2 * s3 + s1 * s2 * c3;
			this.w = c1 * c2 * c3 - s1 * s2 * s3;
		} else if(order == three.math.EulerOrder.ZYX) {
			this.x = s1 * c2 * c3 - c1 * s2 * s3;
			this.y = c1 * s2 * c3 + s1 * c2 * s3;
			this.z = c1 * c2 * s3 - s1 * s2 * c3;
			this.w = c1 * c2 * c3 + s1 * s2 * s3;
		} else if(order == three.math.EulerOrder.YZX) {
			this.x = s1 * c2 * c3 + c1 * s2 * s3;
			this.y = c1 * s2 * c3 + s1 * c2 * s3;
			this.z = c1 * c2 * s3 - s1 * s2 * c3;
			this.w = c1 * c2 * c3 - s1 * s2 * s3;
		} else if(order == three.math.EulerOrder.XZY) {
			this.x = s1 * c2 * c3 - c1 * s2 * s3;
			this.y = c1 * s2 * c3 - s1 * c2 * s3;
			this.z = c1 * c2 * s3 + s1 * s2 * c3;
			this.w = c1 * c2 * c3 + s1 * s2 * s3;
		}
		return this;
	}
	,copy: function(value) {
		this.x = value.x;
		this.y = value.y;
		this.z = value.z;
		this.w = value.w;
		return this;
	}
	,setTo: function(x,y,z,w) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
		return this;
	}
	,__class__: three.math.Quaternion
}
three.math.Vector2 = function(x,y) {
	if(y == null) y = 0;
	if(x == null) x = 0;
	this.x = x;
	this.y = y;
};
three.math.Vector2.__name__ = true;
three.math.Vector2.prototype = {
	clone: function() {
		return new three.math.Vector2(this.x,this.y);
	}
	,isZero: function() {
		return this.get_lengthSq() < 0.0001;
	}
	,equals: function(value) {
		return value.x == this.x && value.y == this.y;
	}
	,lerpSelf: function(value,interp) {
		this.x += (value.x - this.x) * interp;
		this.y += (value.y - this.y) * interp;
		return this;
	}
	,setLength: function(value) {
		return this.normalize().multiplyScalar(value);
	}
	,distanceTo: function(value) {
		var dx = this.x - value.x, dy = this.y - value.y;
		return Math.sqrt(dx * dx + dy * dy);
	}
	,distanceToSquared: function(value) {
		var dx = this.x - value.x, dy = this.y - value.y;
		return dx * dx + dy * dy;
	}
	,normalize: function() {
		var lengthSquare = this.x * this.x + this.y * this.y;
		if(lengthSquare != 0) {
			var len = 1 / lengthSquare;
			this.x *= len;
			this.y *= len;
		} else {
			this.x = 0;
			this.y = 0;
		}
		return this;
	}
	,get_length: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y);
	}
	,get_lengthSq: function() {
		return this.x * this.x + this.y * this.y;
	}
	,dot: function(value) {
		return this.x * value.x + this.y * value.y;
	}
	,negate: function() {
		return this.multiplyScalar(-1);
	}
	,divideScalar: function(value) {
		if(value != 0) {
			this.x /= value;
			this.y /= value;
		} else this.setTo(0,0);
		return this;
	}
	,multiplyScalar: function(value) {
		this.x *= value;
		this.y *= value;
		return this;
	}
	,subSelf: function(value) {
		this.x -= value.x;
		this.y -= value.y;
		return this;
	}
	,sub: function(a,b) {
		this.x = a.x - b.x;
		this.y = a.y - b.y;
		return this;
	}
	,addSelf: function(value) {
		this.x += value.x;
		this.y += value.y;
		return this;
	}
	,add: function(a,b) {
		this.x = a.x + b.x;
		this.y = a.y + b.y;
		return this;
	}
	,copy: function(value) {
		this.x = value.x;
		this.y = value.y;
		return this;
	}
	,setTo: function(x,y) {
		this.x = x;
		this.y = y;
		return this;
	}
	,__class__: three.math.Vector2
}
three.math.Vector3 = function(x,y,z) {
	if(z == null) z = 0;
	if(y == null) y = 0;
	if(x == null) x = 0;
	this.x = x;
	this.y = y;
	this.z = z;
};
three.math.Vector3.__name__ = true;
three.math.Vector3.prototype = {
	clone: function() {
		return new three.math.Vector3(this.x,this.y,this.z);
	}
	,isZero: function() {
		return this.get_lengthSq() < 0.0001;
	}
	,equals: function(value) {
		return value.x == this.x && value.y == this.y && this.z == value.z;
	}
	,getScaleFromMatrix: function(m) {
		var sx = this.setTo(m.elements[0],m.elements[1],m.elements[2]).get_length();
		var sy = this.setTo(m.elements[4],m.elements[5],m.elements[6]).get_length();
		var sz = this.setTo(m.elements[8],m.elements[9],m.elements[10]).get_length();
		this.x = sx;
		this.y = sy;
		this.z = sz;
		return this;
	}
	,setEulerFromQuaternion: function(q,order) {
		var sqx = q.x * q.x;
		var sqy = q.y * q.y;
		var sqz = q.z * q.z;
		var sqw = q.w * q.w;
		if(order == null || order == three.math.EulerOrder.XYZ) {
			this.x = Math.atan2(2 * (q.x * q.w - q.y * q.z),sqw - sqx - sqy + sqz);
			this.y = Math.asin(three.math.MathUtil.clamp(2 * (q.x * q.z + q.y * q.w),-1,1));
			this.z = Math.atan2(2 * (q.z * q.w - q.x * q.y),sqw + sqx - sqy - sqz);
		} else if(order == three.math.EulerOrder.YXZ) {
			this.x = Math.asin(three.math.MathUtil.clamp(2 * (q.x * q.w - q.y * q.z),-1,1));
			this.y = Math.atan2(2 * (q.x * q.z + q.y * q.w),sqw - sqx - sqy + sqz);
			this.z = Math.atan2(2 * (q.x * q.y + q.z * q.w),sqw - sqx + sqy - sqz);
		} else if(order == three.math.EulerOrder.ZXY) {
			this.x = Math.asin(three.math.MathUtil.clamp(2 * (q.x * q.w + q.y * q.z),-1,1));
			this.y = Math.atan2(2 * (q.y * q.w - q.z * q.x),sqw - sqx - sqy + sqz);
			this.z = Math.atan2(2 * (q.z * q.w - q.x * q.y),sqw - sqx + sqy - sqz);
		} else if(order == three.math.EulerOrder.ZYX) {
			this.x = Math.atan2(2 * (q.x * q.w + q.z * q.y),sqw - sqx - sqy + sqz);
			this.y = Math.asin(three.math.MathUtil.clamp(2 * (q.y * q.w - q.x * q.z),-1,1));
			this.z = Math.atan2(2 * (q.x * q.y + q.z * q.w),sqw + sqx - sqy - sqz);
		} else if(order == three.math.EulerOrder.YZX) {
			this.x = Math.atan2(2 * (q.x * q.w - q.z * q.y),sqw - sqx + sqy - sqz);
			this.y = Math.atan2(2 * (q.y * q.w - q.x * q.z),sqw + sqx - sqy - sqz);
			this.z = Math.asin(three.math.MathUtil.clamp(2 * (q.x * q.y + q.z * q.w),-1,1));
		} else if(order == three.math.EulerOrder.XZY) {
			this.x = Math.atan2(2 * (q.x * q.w + q.y * q.z),sqw - sqx + sqy - sqz);
			this.y = Math.atan2(2 * (q.x * q.z + q.y * q.w),sqw + sqx - sqy - sqz);
			this.z = Math.asin(three.math.MathUtil.clamp(2 * (q.z * q.w - q.x * q.y),-1,1));
		}
		return this;
	}
	,setEulerFromRotationMatrix: function(m,order) {
		var te = m.elements;
		var m11 = te[0], m12 = te[4], m13 = te[8];
		var m21 = te[1], m22 = te[5], m23 = te[9];
		var m31 = te[2], m32 = te[6], m33 = te[10];
		if(order == null || order == three.math.EulerOrder.XYZ) {
			this.y = Math.asin(three.math.MathUtil.clamp(m13,-1,1));
			if(Math.abs(m13) < 0.99999) {
				this.x = Math.atan2(-m23,m33);
				this.z = Math.atan2(-m12,m11);
			} else {
				this.x = Math.atan2(m21,m22);
				this.z = 0;
			}
		} else if(order == three.math.EulerOrder.YXZ) {
			this.x = Math.asin(-three.math.MathUtil.clamp(m23,-1,1));
			if(Math.abs(m23) < 0.99999) {
				this.y = Math.atan2(m13,m33);
				this.z = Math.atan2(m21,m22);
			} else {
				this.y = Math.atan2(-m31,m11);
				this.z = 0;
			}
		} else if(order == three.math.EulerOrder.ZXY) {
			this.x = Math.asin(three.math.MathUtil.clamp(m32,-1,1));
			if(Math.abs(m32) < 0.99999) {
				this.y = Math.atan2(-m31,m33);
				this.z = Math.atan2(-m12,m22);
			} else {
				this.y = 0;
				this.z = Math.atan2(m13,m11);
			}
		} else if(order == three.math.EulerOrder.ZYX) {
			this.y = Math.asin(-three.math.MathUtil.clamp(m31,-1,1));
			if(Math.abs(m31) < 0.99999) {
				this.x = Math.atan2(m32,m33);
				this.z = Math.atan2(m21,m11);
			} else {
				this.x = 0;
				this.z = Math.atan2(-m12,m22);
			}
		} else if(order == three.math.EulerOrder.YZX) {
			this.z = Math.asin(three.math.MathUtil.clamp(m21,-1,1));
			if(Math.abs(m21) < 0.99999) {
				this.x = Math.atan2(-m23,m22);
				this.y = Math.atan2(-m31,m11);
			} else {
				this.x = 0;
				this.y = Math.atan2(m31,m33);
			}
		} else if(order == three.math.EulerOrder.XZY) {
			this.z = Math.asin(-three.math.MathUtil.clamp(m12,-1,1));
			if(Math.abs(m12) < 0.99999) {
				this.x = Math.atan2(m32,m22);
				this.y = Math.atan2(m13,m11);
			} else {
				this.x = Math.atan2(-m13,m33);
				this.y = 0;
			}
		}
		return this;
	}
	,getPositionFromMatrix: function(m) {
		this.x = m.elements[12];
		this.y = m.elements[13];
		this.z = m.elements[14];
		return this;
	}
	,lerpSelf: function(value,interp) {
		this.x += (value.x - this.x) * interp;
		this.y += (value.y - this.y) * interp;
		this.z += (value.z - this.z) * interp;
		return this;
	}
	,distanceTo: function(value) {
		var dx = this.x - value.x, dy = this.y - value.y, dz = this.z - value.z;
		return Math.sqrt(dx * dx + dy * dy + dz * dz);
	}
	,distanceToSquared: function(value) {
		var dx = this.x - value.x, dy = this.y - value.y, dz = this.z - value.z;
		return dx * dx + dy * dy + dz * dz;
	}
	,crossSelf: function(b) {
		var sx = this.x, sy = this.y, sz = this.z;
		this.x = sy * b.z - sz * b.y;
		this.y = sz * b.x - sx * b.z;
		this.z = sx * b.y - sy * b.x;
		return this;
	}
	,cross: function(a,b) {
		this.x = a.y * b.z - a.z * b.y;
		this.y = a.z * b.x - a.x * b.z;
		this.z = a.x * b.y - a.y * b.x;
		return this;
	}
	,normalize: function() {
		var lengthSquare = this.x * this.x + this.y * this.y + this.z * this.z;
		if(lengthSquare != 0) {
			var len = 1 / lengthSquare;
			this.x *= len;
			this.y *= len;
			this.z *= len;
		} else {
			this.x = 0;
			this.y = 0;
			this.z = 0;
		}
		return this;
	}
	,lengthManhattan: function() {
		return Math.abs(this.x) + Math.abs(this.y) + Math.abs(this.z);
	}
	,setLength: function(value) {
		return this.normalize().multiplyScalar(value);
	}
	,get_length: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
	}
	,get_lengthSq: function() {
		return this.x * this.x + this.y * this.y + this.z * this.z;
	}
	,dot: function(value) {
		return this.x * value.x + this.y * value.y + this.z * value.z;
	}
	,negate: function() {
		return this.multiplyScalar(-1);
	}
	,divideScalar: function(value) {
		if(value != 0) {
			this.x /= value;
			this.y /= value;
			this.z /= value;
		} else this.setTo(0,0,0);
		return this;
	}
	,multiplyScalar: function(value) {
		this.x *= value;
		this.y *= value;
		this.z *= value;
		return this;
	}
	,multiplySelf: function(value) {
		this.x *= value.x;
		this.y *= value.y;
		this.z *= value.z;
		return this;
	}
	,multiply: function(a,b) {
		this.x = a.x * b.x;
		this.y = a.y * b.y;
		this.z = a.z * b.z;
		return this;
	}
	,subSelf: function(value) {
		this.x -= value.x;
		this.y -= value.y;
		this.z -= value.z;
		return this;
	}
	,sub: function(a,b) {
		this.x = a.x - b.x;
		this.y = a.y - b.y;
		this.z = a.z - b.z;
		return this;
	}
	,addSelf: function(value) {
		this.x += value.x;
		this.y += value.y;
		this.z += value.z;
		return this;
	}
	,add: function(a,b) {
		this.x = a.x + b.x;
		this.y = a.y + b.y;
		this.z = a.z + b.z;
		return this;
	}
	,copy: function(value) {
		this.x = value.x;
		this.y = value.y;
		this.z = value.z;
		return this;
	}
	,setTo: function(x,y,z) {
		this.x = x;
		this.y = y;
		this.z = z;
		return this;
	}
	,__class__: three.math.Vector3
}
three.math.Vector4 = function(x,y,z,w) {
	if(w == null) w = 1;
	if(z == null) z = 0;
	if(y == null) y = 0;
	if(x == null) x = 0;
	this.x = x;
	this.y = y;
	this.z = z;
	this.w = w;
};
three.math.Vector4.__name__ = true;
three.math.Vector4.prototype = {
	setAxisAngleFromRotationMatrix: function(m) {
		var angle, x, y, z;
		var epsilon = 0.01;
		var epsilon2 = 0.1;
		var te = m.elements;
		var m11 = te[0], m12 = te[4], m13 = te[8];
		var m21 = te[1], m22 = te[5], m23 = te[9];
		var m31 = te[2], m32 = te[6], m33 = te[10];
		if(Math.abs(m12 - m21) < epsilon && Math.abs(m13 - m31) < epsilon && Math.abs(m23 - m32) < epsilon) {
			if(Math.abs(m12 + m21) < epsilon2 && Math.abs(m13 + m31) < epsilon2 && Math.abs(m23 + m32) < epsilon2 && Math.abs(m11 + m22 + m33 - 3) < epsilon2) {
				this.setTo(1,0,0,0);
				return this;
			}
			angle = Math.PI;
			var xx = (m11 + 1) / 2;
			var yy = (m22 + 1) / 2;
			var zz = (m33 + 1) / 2;
			var xy = (m12 + m21) / 4;
			var xz = (m13 + m31) / 4;
			var yz = (m23 + m32) / 4;
			if(xx > yy && xx > zz) {
				if(xx < epsilon) {
					x = 0;
					y = 0.707106781;
					z = 0.707106781;
				} else {
					x = Math.sqrt(xx);
					y = xy / x;
					z = xz / x;
				}
			} else if(yy > zz) {
				if(yy < epsilon) {
					x = 0.707106781;
					y = 0;
					z = 0.707106781;
				} else {
					y = Math.sqrt(yy);
					x = xy / y;
					z = yz / y;
				}
			} else if(zz < epsilon) {
				x = 0.707106781;
				y = 0.707106781;
				z = 0;
			} else {
				z = Math.sqrt(zz);
				x = xz / z;
				y = yz / z;
			}
			this.setTo(x,y,z,angle);
			return this;
		}
		var s = Math.sqrt((m32 - m23) * (m32 - m23) + (m13 - m31) * (m13 - m31) + (m21 - m12) * (m21 - m12));
		if(Math.abs(s) < 0.001) s = 1;
		this.x = (m32 - m23) / s;
		this.y = (m13 - m31) / s;
		this.z = (m21 - m12) / s;
		this.w = Math.acos((m11 + m22 + m33 - 1) / 2);
		return this;
	}
	,setAxisAngleFromQuaternion: function(q) {
		this.w = 2 * Math.acos(q.w);
		var s = Math.sqrt(1 - q.w * q.w);
		if(s < 0.0001) {
			this.x = 1;
			this.y = 0;
			this.z = 0;
		} else {
			this.x = q.x / s;
			this.y = q.y / s;
			this.z = q.z / s;
		}
		return this;
	}
	,clone: function() {
		return new three.math.Vector4(this.x,this.y,this.z,this.w);
	}
	,equals: function(value) {
		return value.x == this.x && value.y == this.y && this.z == value.z && this.w == value.w;
	}
	,lerpSelf: function(value,interp) {
		this.x += (value.x - this.x) * interp;
		this.y += (value.y - this.y) * interp;
		this.z += (value.z - this.z) * interp;
		this.w += (value.w - this.w) * interp;
		return this;
	}
	,normalize: function() {
		var lengthSquare = this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w;
		if(lengthSquare != 0) {
			var len = 1 / lengthSquare;
			this.x *= len;
			this.y *= len;
			this.z *= len;
			this.w *= len;
		} else {
			this.x = 0;
			this.y = 0;
			this.z = 0;
			this.w = 1;
		}
		return this;
	}
	,setLength: function(value) {
		return this.normalize().multiplyScalar(value);
	}
	,get_length: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
	}
	,get_lengthSq: function() {
		return this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w;
	}
	,dot: function(value) {
		return this.x * value.x + this.y * value.y + this.z * value.z + this.w * value.w;
	}
	,negate: function() {
		return this.multiplyScalar(-1);
	}
	,divideScalar: function(value) {
		if(value != 0) {
			this.x /= value;
			this.y /= value;
			this.z /= value;
			this.w /= value;
		} else this.setTo(0,0,0,1);
		return this;
	}
	,multiplyScalar: function(value) {
		this.x *= value;
		this.y *= value;
		this.z *= value;
		this.w *= value;
		return this;
	}
	,subSelf: function(value) {
		this.x -= value.x;
		this.y -= value.y;
		this.z -= value.z;
		this.w -= value.w;
		return this;
	}
	,sub: function(a,b) {
		this.x = a.x - b.x;
		this.y = a.y - b.y;
		this.z = a.z - b.z;
		this.w = a.w - b.w;
		return this;
	}
	,addSelf: function(value) {
		this.x += value.x;
		this.y += value.y;
		this.z += value.z;
		this.w += value.w;
		return this;
	}
	,add: function(a,b) {
		this.x = a.x + b.x;
		this.y = a.y + b.y;
		this.z = a.z + b.z;
		this.w = a.w + b.w;
		return this;
	}
	,copy: function(value) {
		this.x = value.x;
		this.y = value.y;
		this.z = value.z;
		this.w = value.w;
		return this;
	}
	,setTo: function(x,y,z,w) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
		return this;
	}
	,__class__: three.math.Vector4
}
three.objects = {}
three.objects.Bone = function() {
	three.core.Object3D.call(this);
};
three.objects.Bone.__name__ = true;
three.objects.Bone.__super__ = three.core.Object3D;
three.objects.Bone.prototype = $extend(three.core.Object3D.prototype,{
	__class__: three.objects.Bone
});
three.renderers = {}
three.renderers.Program3D = function() {
};
three.renderers.Program3D.__name__ = true;
three.renderers.Program3D.prototype = {
	__class__: three.renderers.Program3D
}
three.renderers.ShaderLib = function() { }
three.renderers.ShaderLib.__name__ = true;
three.renderers.ShaderLib._shaderChunk = null;
three.renderers.ShaderLib._uniformsLib = null;
three.renderers.ShaderLib._shaderMap = null;
three.renderers.ShaderLib.initShaderLib = function() {
	three.renderers.ShaderLib._shaderChunk = { fog_pars_fragment : ["#ifdef USE_FOG","uniform vec3 fogColor;","#ifdef FOG_EXP2","uniform float fogDensity;","#else","uniform float fogNear;","uniform float fogFar;","#endif","#endif"].join("\n"), fog_fragment : ["#ifdef USE_FOG","float depth = gl_FragCoord.z / gl_FragCoord.w;","#ifdef FOG_EXP2","const float LOG2 = 1.442695;","float fogFactor = exp2( - fogDensity * fogDensity * depth * depth * LOG2 );","fogFactor = 1.0 - clamp( fogFactor, 0.0, 1.0 );","#else","float fogFactor = smoothstep( fogNear, fogFar, depth );","#endif","gl_FragColor = mix( gl_FragColor, vec4( fogColor, gl_FragColor.w ), fogFactor );","#endif"].join("\n"), envmap_pars_fragment : ["#ifdef USE_ENVMAP","uniform float reflectivity;","uniform samplerCube envMap;","uniform float flipEnvMap;","uniform int combine;","#ifdef USE_BUMPMAP","uniform bool useRefract;","uniform float refractionRatio;","#else","varying vec3 vReflect;","#endif","#endif"].join("\n"), envmap_fragment : ["#ifdef USE_ENVMAP","vec3 reflectVec;","#ifdef USE_BUMPMAP","vec3 cameraToVertex = normalize( vWorldPosition - cameraPosition );","if ( useRefract ) {","reflectVec = refract( cameraToVertex, normal, refractionRatio );","} else { ","reflectVec = reflect( cameraToVertex, normal );","}","#else","reflectVec = vReflect;","#endif","#ifdef DOUBLE_SIDED","float flipNormal = ( -1.0 + 2.0 * float( gl_FrontFacing ) );","vec4 cubeColor = textureCube( envMap, flipNormal * vec3( flipEnvMap * reflectVec.x, reflectVec.yz ) );","#else","vec4 cubeColor = textureCube( envMap, vec3( flipEnvMap * reflectVec.x, reflectVec.yz ) );","#endif","#ifdef GAMMA_INPUT","cubeColor.xyz *= cubeColor.xyz;","#endif","if ( combine == 1 ) {","gl_FragColor.xyz = mix( gl_FragColor.xyz, cubeColor.xyz, specularStrength * reflectivity );","} else {","gl_FragColor.xyz = mix( gl_FragColor.xyz, gl_FragColor.xyz * cubeColor.xyz, specularStrength * reflectivity );","}","#endif"].join("\n"), envmap_pars_vertex : ["#if defined( USE_ENVMAP ) && ! defined( USE_BUMPMAP )","varying vec3 vReflect;","uniform float refractionRatio;","uniform bool useRefract;","#endif"].join("\n"), envmap_vertex : ["#ifdef USE_ENVMAP","vec4 mPosition = modelMatrix * vec4( position, 1.0 );","#endif","#if defined( USE_ENVMAP ) && ! defined( USE_BUMPMAP )","vec3 nWorld = mat3( modelMatrix[ 0 ].xyz, modelMatrix[ 1 ].xyz, modelMatrix[ 2 ].xyz ) * normal;","if ( useRefract ) {","vReflect = refract( normalize( mPosition.xyz - cameraPosition ), normalize( nWorld.xyz ), refractionRatio );","} else {","vReflect = reflect( normalize( mPosition.xyz - cameraPosition ), normalize( nWorld.xyz ) );","}","#endif"].join("\n"), map_particle_pars_fragment : ["#ifdef USE_MAP","uniform sampler2D map;","#endif"].join("\n"), map_particle_fragment : ["#ifdef USE_MAP","gl_FragColor = gl_FragColor * texture2D( map, vec2( gl_PointCoord.x, 1.0 - gl_PointCoord.y ) );","#endif"].join("\n"), map_pars_vertex : ["#if defined( USE_MAP ) || defined( USE_BUMPMAP ) || defined( USE_SPECULARMAP )","varying vec2 vUv;","uniform vec4 offsetRepeat;","#endif"].join("\n"), map_pars_fragment : ["#if defined( USE_MAP ) || defined( USE_BUMPMAP ) || defined( USE_SPECULARMAP )","varying vec2 vUv;","#endif","#ifdef USE_MAP","uniform sampler2D map;","#endif"].join("\n"), map_vertex : ["#if defined( USE_MAP ) || defined( USE_BUMPMAP ) || defined( USE_SPECULARMAP )","vUv = uv * offsetRepeat.zw + offsetRepeat.xy;","#endif"].join("\n"), map_fragment : ["#ifdef USE_MAP","#ifdef GAMMA_INPUT","vec4 texelColor = texture2D( map, vUv );","texelColor.xyz *= texelColor.xyz;","gl_FragColor = gl_FragColor * texelColor;","#else","gl_FragColor = gl_FragColor * texture2D( map, vUv );","#endif","#endif"].join("\n"), lightmap_pars_fragment : ["#ifdef USE_LIGHTMAP","varying vec2 vUv2;","uniform sampler2D lightMap;","#endif"].join("\n"), lightmap_pars_vertex : ["#ifdef USE_LIGHTMAP","varying vec2 vUv2;","#endif"].join("\n"), lightmap_fragment : ["#ifdef USE_LIGHTMAP","gl_FragColor = gl_FragColor * texture2D( lightMap, vUv2 );","#endif"].join("\n"), lightmap_vertex : ["#ifdef USE_LIGHTMAP","vUv2 = uv2;","#endif"].join("\n"), bumpmap_pars_fragment : ["#ifdef USE_BUMPMAP","uniform sampler2D bumpMap;","uniform float bumpScale;","vec2 dHdxy_fwd() {","vec2 dSTdx = dFdx( vUv );","vec2 dSTdy = dFdy( vUv );","float Hll = bumpScale * texture2D( bumpMap, vUv ).x;","float dBx = bumpScale * texture2D( bumpMap, vUv + dSTdx ).x - Hll;","float dBy = bumpScale * texture2D( bumpMap, vUv + dSTdy ).x - Hll;","return vec2( dBx, dBy );","}","vec3 perturbNormalArb( vec3 surf_pos, vec3 surf_norm, vec2 dHdxy ) {","vec3 vSigmaX = dFdx( surf_pos );","vec3 vSigmaY = dFdy( surf_pos );","vec3 vN = surf_norm;","vec3 R1 = cross( vSigmaY, vN );","vec3 R2 = cross( vN, vSigmaX );","float fDet = dot( vSigmaX, R1 );","vec3 vGrad = sign( fDet ) * ( dHdxy.x * R1 + dHdxy.y * R2 );","return normalize( abs( fDet ) * surf_norm - vGrad );","}","#endif"].join("\n"), specularmap_pars_fragment : ["#ifdef USE_SPECULARMAP","uniform sampler2D specularMap;","#endif"].join("\n"), specularmap_fragment : ["float specularStrength;","#ifdef USE_SPECULARMAP","vec4 texelSpecular = texture2D( specularMap, vUv );","specularStrength = texelSpecular.r;","#else","specularStrength = 1.0;","#endif"].join("\n"), lights_lambert_pars_vertex : ["uniform vec3 ambient;","uniform vec3 diffuse;","uniform vec3 emissive;","uniform vec3 ambientLightColor;","#if MAX_DIR_LIGHTS > 0","uniform vec3 directionalLightColor[ MAX_DIR_LIGHTS ];","uniform vec3 directionalLightDirection[ MAX_DIR_LIGHTS ];","#endif","#if MAX_POINT_LIGHTS > 0","uniform vec3 pointLightColor[ MAX_POINT_LIGHTS ];","uniform vec3 pointLightPosition[ MAX_POINT_LIGHTS ];","uniform float pointLightDistance[ MAX_POINT_LIGHTS ];","#endif","#if MAX_SPOT_LIGHTS > 0","uniform vec3 spotLightColor[ MAX_SPOT_LIGHTS ];","uniform vec3 spotLightPosition[ MAX_SPOT_LIGHTS ];","uniform vec3 spotLightDirection[ MAX_SPOT_LIGHTS ];","uniform float spotLightDistance[ MAX_SPOT_LIGHTS ];","uniform float spotLightAngle[ MAX_SPOT_LIGHTS ];","uniform float spotLightExponent[ MAX_SPOT_LIGHTS ];","#endif","#ifdef WRAP_AROUND","uniform vec3 wrapRGB;","#endif"].join("\n"), lights_lambert_vertex : ["vLightFront = vec3( 0.0 );","#ifdef DOUBLE_SIDED","vLightBack = vec3( 0.0 );","#endif","transformedNormal = normalize( transformedNormal );","#if MAX_DIR_LIGHTS > 0","for( int i = 0; i < MAX_DIR_LIGHTS; i ++ ) {","vec4 lDirection = viewMatrix * vec4( directionalLightDirection[ i ], 0.0 );","vec3 dirVector = normalize( lDirection.xyz );","float dotProduct = dot( transformedNormal, dirVector );","vec3 directionalLightWeighting = vec3( max( dotProduct, 0.0 ) );","#ifdef DOUBLE_SIDED","vec3 directionalLightWeightingBack = vec3( max( -dotProduct, 0.0 ) );","#ifdef WRAP_AROUND","vec3 directionalLightWeightingHalfBack = vec3( max( -0.5 * dotProduct + 0.5, 0.0 ) );","#endif","#endif","#ifdef WRAP_AROUND","vec3 directionalLightWeightingHalf = vec3( max( 0.5 * dotProduct + 0.5, 0.0 ) );","directionalLightWeighting = mix( directionalLightWeighting, directionalLightWeightingHalf, wrapRGB );","#ifdef DOUBLE_SIDED","directionalLightWeightingBack = mix( directionalLightWeightingBack, directionalLightWeightingHalfBack, wrapRGB );","#endif","#endif","vLightFront += directionalLightColor[ i ] * directionalLightWeighting;","#ifdef DOUBLE_SIDED","vLightBack += directionalLightColor[ i ] * directionalLightWeightingBack;","#endif","}","#endif","#if MAX_POINT_LIGHTS > 0","for( int i = 0; i < MAX_POINT_LIGHTS; i ++ ) {","vec4 lPosition = viewMatrix * vec4( pointLightPosition[ i ], 1.0 );","vec3 lVector = lPosition.xyz - mvPosition.xyz;","float lDistance = 1.0;","if ( pointLightDistance[ i ] > 0.0 )","lDistance = 1.0 - min( ( length( lVector ) / pointLightDistance[ i ] ), 1.0 );","lVector = normalize( lVector );","float dotProduct = dot( transformedNormal, lVector );","vec3 pointLightWeighting = vec3( max( dotProduct, 0.0 ) );","#ifdef DOUBLE_SIDED","vec3 pointLightWeightingBack = vec3( max( -dotProduct, 0.0 ) );","#ifdef WRAP_AROUND","vec3 pointLightWeightingHalfBack = vec3( max( -0.5 * dotProduct + 0.5, 0.0 ) );","#endif","#endif","#ifdef WRAP_AROUND","vec3 pointLightWeightingHalf = vec3( max( 0.5 * dotProduct + 0.5, 0.0 ) );","pointLightWeighting = mix( pointLightWeighting, pointLightWeightingHalf, wrapRGB );","#ifdef DOUBLE_SIDED","pointLightWeightingBack = mix( pointLightWeightingBack, pointLightWeightingHalfBack, wrapRGB );","#endif","#endif","vLightFront += pointLightColor[ i ] * pointLightWeighting * lDistance;","#ifdef DOUBLE_SIDED","vLightBack += pointLightColor[ i ] * pointLightWeightingBack * lDistance;","#endif","}","#endif","#if MAX_SPOT_LIGHTS > 0","for( int i = 0; i < MAX_SPOT_LIGHTS; i ++ ) {","vec4 lPosition = viewMatrix * vec4( spotLightPosition[ i ], 1.0 );","vec3 lVector = lPosition.xyz - mvPosition.xyz;","lVector = normalize( lVector );","float spotEffect = dot( spotLightDirection[ i ], normalize( spotLightPosition[ i ] - mPosition.xyz ) );","if ( spotEffect > spotLightAngle[ i ] ) {","spotEffect = pow( spotEffect, spotLightExponent[ i ] );","float lDistance = 1.0;","if ( spotLightDistance[ i ] > 0.0 )","lDistance = 1.0 - min( ( length( lVector ) / spotLightDistance[ i ] ), 1.0 );","float dotProduct = dot( transformedNormal, lVector );","vec3 spotLightWeighting = vec3( max( dotProduct, 0.0 ) );","#ifdef DOUBLE_SIDED","vec3 spotLightWeightingBack = vec3( max( -dotProduct, 0.0 ) );","#ifdef WRAP_AROUND","vec3 spotLightWeightingHalfBack = vec3( max( -0.5 * dotProduct + 0.5, 0.0 ) );","#endif","#endif","#ifdef WRAP_AROUND","vec3 spotLightWeightingHalf = vec3( max( 0.5 * dotProduct + 0.5, 0.0 ) );","spotLightWeighting = mix( spotLightWeighting, spotLightWeightingHalf, wrapRGB );","#ifdef DOUBLE_SIDED","spotLightWeightingBack = mix( spotLightWeightingBack, spotLightWeightingHalfBack, wrapRGB );","#endif","#endif","vLightFront += spotLightColor[ i ] * spotLightWeighting * lDistance * spotEffect;","#ifdef DOUBLE_SIDED","vLightBack += spotLightColor[ i ] * spotLightWeightingBack * lDistance * spotEffect;","#endif","}","}","#endif","vLightFront = vLightFront * diffuse + ambient * ambientLightColor + emissive;","#ifdef DOUBLE_SIDED","vLightBack = vLightBack * diffuse + ambient * ambientLightColor + emissive;","#endif"].join("\n"), lights_phong_pars_vertex : ["#ifndef PHONG_PER_PIXEL","#if MAX_POINT_LIGHTS > 0","uniform vec3 pointLightPosition[ MAX_POINT_LIGHTS ];","uniform float pointLightDistance[ MAX_POINT_LIGHTS ];","varying vec4 vPointLight[ MAX_POINT_LIGHTS ];","#endif","#if MAX_SPOT_LIGHTS > 0","uniform vec3 spotLightPosition[ MAX_SPOT_LIGHTS ];","uniform float spotLightDistance[ MAX_SPOT_LIGHTS ];","varying vec4 vSpotLight[ MAX_SPOT_LIGHTS ];","#endif","#endif","#if MAX_SPOT_LIGHTS > 0 || defined( USE_BUMPMAP )","varying vec3 vWorldPosition;","#endif"].join("\n"), lights_phong_vertex : ["#ifndef PHONG_PER_PIXEL","#if MAX_POINT_LIGHTS > 0","for( int i = 0; i < MAX_POINT_LIGHTS; i ++ ) {","vec4 lPosition = viewMatrix * vec4( pointLightPosition[ i ], 1.0 );","vec3 lVector = lPosition.xyz - mvPosition.xyz;","float lDistance = 1.0;","if ( pointLightDistance[ i ] > 0.0 )","lDistance = 1.0 - min( ( length( lVector ) / pointLightDistance[ i ] ), 1.0 );","vPointLight[ i ] = vec4( lVector, lDistance );","}","#endif","#if MAX_SPOT_LIGHTS > 0","for( int i = 0; i < MAX_SPOT_LIGHTS; i ++ ) {","vec4 lPosition = viewMatrix * vec4( spotLightPosition[ i ], 1.0 );","vec3 lVector = lPosition.xyz - mvPosition.xyz;","float lDistance = 1.0;","if ( spotLightDistance[ i ] > 0.0 )","lDistance = 1.0 - min( ( length( lVector ) / spotLightDistance[ i ] ), 1.0 );","vSpotLight[ i ] = vec4( lVector, lDistance );","}","#endif","#endif","#if MAX_SPOT_LIGHTS > 0 || defined( USE_BUMPMAP )","vWorldPosition = mPosition.xyz;","#endif"].join("\n"), lights_phong_pars_fragment : ["uniform vec3 ambientLightColor;","#if MAX_DIR_LIGHTS > 0","uniform vec3 directionalLightColor[ MAX_DIR_LIGHTS ];","uniform vec3 directionalLightDirection[ MAX_DIR_LIGHTS ];","#endif","#if MAX_POINT_LIGHTS > 0","uniform vec3 pointLightColor[ MAX_POINT_LIGHTS ];","#ifdef PHONG_PER_PIXEL","uniform vec3 pointLightPosition[ MAX_POINT_LIGHTS ];","uniform float pointLightDistance[ MAX_POINT_LIGHTS ];","#else","varying vec4 vPointLight[ MAX_POINT_LIGHTS ];","#endif","#endif","#if MAX_SPOT_LIGHTS > 0","uniform vec3 spotLightColor[ MAX_SPOT_LIGHTS ];","uniform vec3 spotLightPosition[ MAX_SPOT_LIGHTS ];","uniform vec3 spotLightDirection[ MAX_SPOT_LIGHTS ];","uniform float spotLightAngle[ MAX_SPOT_LIGHTS ];","uniform float spotLightExponent[ MAX_SPOT_LIGHTS ];","#ifdef PHONG_PER_PIXEL","uniform float spotLightDistance[ MAX_SPOT_LIGHTS ];","#else","varying vec4 vSpotLight[ MAX_SPOT_LIGHTS ];","#endif","#endif","#if MAX_SPOT_LIGHTS > 0 || defined( USE_BUMPMAP )","varying vec3 vWorldPosition;","#endif","#ifdef WRAP_AROUND","uniform vec3 wrapRGB;","#endif","varying vec3 vViewPosition;","varying vec3 vNormal;"].join("\n"), lights_phong_fragment : ["vec3 normal = normalize( vNormal );","vec3 viewPosition = normalize( vViewPosition );","#ifdef DOUBLE_SIDED","normal = normal * ( -1.0 + 2.0 * float( gl_FrontFacing ) );","#endif","#ifdef USE_BUMPMAP","normal = perturbNormalArb( -vViewPosition, normal, dHdxy_fwd() );","#endif","#if MAX_POINT_LIGHTS > 0","vec3 pointDiffuse  = vec3( 0.0 );","vec3 pointSpecular = vec3( 0.0 );","for ( int i = 0; i < MAX_POINT_LIGHTS; i ++ ) {","#ifdef PHONG_PER_PIXEL","vec4 lPosition = viewMatrix * vec4( pointLightPosition[ i ], 1.0 );","vec3 lVector = lPosition.xyz + vViewPosition.xyz;","float lDistance = 1.0;","if ( pointLightDistance[ i ] > 0.0 )","lDistance = 1.0 - min( ( length( lVector ) / pointLightDistance[ i ] ), 1.0 );","lVector = normalize( lVector );","#else","vec3 lVector = normalize( vPointLight[ i ].xyz );","float lDistance = vPointLight[ i ].w;","#endif","float dotProduct = dot( normal, lVector );","#ifdef WRAP_AROUND","float pointDiffuseWeightFull = max( dotProduct, 0.0 );","float pointDiffuseWeightHalf = max( 0.5 * dotProduct + 0.5, 0.0 );","vec3 pointDiffuseWeight = mix( vec3 ( pointDiffuseWeightFull ), vec3( pointDiffuseWeightHalf ), wrapRGB );","#else","float pointDiffuseWeight = max( dotProduct, 0.0 );","#endif","pointDiffuse  += diffuse * pointLightColor[ i ] * pointDiffuseWeight * lDistance;","vec3 pointHalfVector = normalize( lVector + viewPosition );","float pointDotNormalHalf = max( dot( normal, pointHalfVector ), 0.0 );","float pointSpecularWeight = specularStrength * max( pow( pointDotNormalHalf, shininess ), 0.0 );","#ifdef PHYSICALLY_BASED_SHADING","float specularNormalization = ( shininess + 2.0001 ) / 8.0;","vec3 schlick = specular + vec3( 1.0 - specular ) * pow( 1.0 - dot( lVector, pointHalfVector ), 5.0 );","pointSpecular += schlick * pointLightColor[ i ] * pointSpecularWeight * pointDiffuseWeight * lDistance * specularNormalization;","#else","pointSpecular += specular * pointLightColor[ i ] * pointSpecularWeight * pointDiffuseWeight * lDistance;","#endif","}","#endif","#if MAX_SPOT_LIGHTS > 0","vec3 spotDiffuse  = vec3( 0.0 );","vec3 spotSpecular = vec3( 0.0 );","for ( int i = 0; i < MAX_SPOT_LIGHTS; i ++ ) {","#ifdef PHONG_PER_PIXEL","vec4 lPosition = viewMatrix * vec4( spotLightPosition[ i ], 1.0 );","vec3 lVector = lPosition.xyz + vViewPosition.xyz;","float lDistance = 1.0;","if ( spotLightDistance[ i ] > 0.0 )","lDistance = 1.0 - min( ( length( lVector ) / spotLightDistance[ i ] ), 1.0 );","lVector = normalize( lVector );","#else","vec3 lVector = normalize( vSpotLight[ i ].xyz );","float lDistance = vSpotLight[ i ].w;","#endif","float spotEffect = dot( spotLightDirection[ i ], normalize( spotLightPosition[ i ] - vWorldPosition ) );","if ( spotEffect > spotLightAngle[ i ] ) {","spotEffect = pow( spotEffect, spotLightExponent[ i ] );","float dotProduct = dot( normal, lVector );","#ifdef WRAP_AROUND","float spotDiffuseWeightFull = max( dotProduct, 0.0 );","float spotDiffuseWeightHalf = max( 0.5 * dotProduct + 0.5, 0.0 );","vec3 spotDiffuseWeight = mix( vec3 ( spotDiffuseWeightFull ), vec3( spotDiffuseWeightHalf ), wrapRGB );","#else","float spotDiffuseWeight = max( dotProduct, 0.0 );","#endif","spotDiffuse += diffuse * spotLightColor[ i ] * spotDiffuseWeight * lDistance * spotEffect;","vec3 spotHalfVector = normalize( lVector + viewPosition );","float spotDotNormalHalf = max( dot( normal, spotHalfVector ), 0.0 );","float spotSpecularWeight = specularStrength * max( pow( spotDotNormalHalf, shininess ), 0.0 );","#ifdef PHYSICALLY_BASED_SHADING","float specularNormalization = ( shininess + 2.0001 ) / 8.0;","vec3 schlick = specular + vec3( 1.0 - specular ) * pow( 1.0 - dot( lVector, spotHalfVector ), 5.0 );","spotSpecular += schlick * spotLightColor[ i ] * spotSpecularWeight * spotDiffuseWeight * lDistance * specularNormalization * spotEffect;","#else","spotSpecular += specular * spotLightColor[ i ] * spotSpecularWeight * spotDiffuseWeight * lDistance * spotEffect;","#endif","}","}","#endif","#if MAX_DIR_LIGHTS > 0","vec3 dirDiffuse  = vec3( 0.0 );","vec3 dirSpecular = vec3( 0.0 );","for( int i = 0; i < MAX_DIR_LIGHTS; i ++ ) {","vec4 lDirection = viewMatrix * vec4( directionalLightDirection[ i ], 0.0 );","vec3 dirVector = normalize( lDirection.xyz );","float dotProduct = dot( normal, dirVector );","#ifdef WRAP_AROUND","float dirDiffuseWeightFull = max( dotProduct, 0.0 );","float dirDiffuseWeightHalf = max( 0.5 * dotProduct + 0.5, 0.0 );","vec3 dirDiffuseWeight = mix( vec3( dirDiffuseWeightFull ), vec3( dirDiffuseWeightHalf ), wrapRGB );","#else","float dirDiffuseWeight = max( dotProduct, 0.0 );","#endif","dirDiffuse  += diffuse * directionalLightColor[ i ] * dirDiffuseWeight;","vec3 dirHalfVector = normalize( dirVector + viewPosition );","float dirDotNormalHalf = max( dot( normal, dirHalfVector ), 0.0 );","float dirSpecularWeight = specularStrength * max( pow( dirDotNormalHalf, shininess ), 0.0 );","#ifdef PHYSICALLY_BASED_SHADING","float specularNormalization = ( shininess + 2.0001 ) / 8.0;","vec3 schlick = specular + vec3( 1.0 - specular ) * pow( 1.0 - dot( dirVector, dirHalfVector ), 5.0 );","dirSpecular += schlick * directionalLightColor[ i ] * dirSpecularWeight * dirDiffuseWeight * specularNormalization;","#else","dirSpecular += specular * directionalLightColor[ i ] * dirSpecularWeight * dirDiffuseWeight;","#endif","}","#endif","vec3 totalDiffuse = vec3( 0.0 );","vec3 totalSpecular = vec3( 0.0 );","#if MAX_DIR_LIGHTS > 0","totalDiffuse += dirDiffuse;","totalSpecular += dirSpecular;","#endif","#if MAX_POINT_LIGHTS > 0","totalDiffuse += pointDiffuse;","totalSpecular += pointSpecular;","#endif","#if MAX_SPOT_LIGHTS > 0","totalDiffuse += spotDiffuse;","totalSpecular += spotSpecular;","#endif","#ifdef METAL","gl_FragColor.xyz = gl_FragColor.xyz * ( emissive + totalDiffuse + ambientLightColor * ambient + totalSpecular );","#else","gl_FragColor.xyz = gl_FragColor.xyz * ( emissive + totalDiffuse + ambientLightColor * ambient ) + totalSpecular;","#endif"].join("\n"), color_pars_fragment : ["#ifdef USE_COLOR","varying vec3 vColor;","#endif"].join("\n"), color_fragment : ["#ifdef USE_COLOR","gl_FragColor = gl_FragColor * vec4( vColor, opacity );","#endif"].join("\n"), color_pars_vertex : ["#ifdef USE_COLOR","varying vec3 vColor;","#endif"].join("\n"), color_vertex : ["#ifdef USE_COLOR","#ifdef GAMMA_INPUT","vColor = color * color;","#else","vColor = color;","#endif","#endif"].join("\n"), skinning_pars_vertex : ["#ifdef USE_SKINNING","#ifdef BONE_TEXTURE","uniform sampler2D boneTexture;","mat4 getBoneMatrix( const in float i ) {","float j = i * 4.0;","float x = mod( j, N_BONE_PIXEL_X );","float y = floor( j / N_BONE_PIXEL_X );","const float dx = 1.0 / N_BONE_PIXEL_X;","const float dy = 1.0 / N_BONE_PIXEL_Y;","y = dy * ( y + 0.5 );","vec4 v1 = texture2D( boneTexture, vec2( dx * ( x + 0.5 ), y ) );","vec4 v2 = texture2D( boneTexture, vec2( dx * ( x + 1.5 ), y ) );","vec4 v3 = texture2D( boneTexture, vec2( dx * ( x + 2.5 ), y ) );","vec4 v4 = texture2D( boneTexture, vec2( dx * ( x + 3.5 ), y ) );","mat4 bone = mat4( v1, v2, v3, v4 );","return bone;","}","#else","uniform mat4 boneGlobalMatrices[ MAX_BONES ];","mat4 getBoneMatrix( const in float i ) {","mat4 bone = boneGlobalMatrices[ int(i) ];","return bone;","}","#endif","#endif"].join("\n"), skinbase_vertex : ["#ifdef USE_SKINNING","mat4 boneMatX = getBoneMatrix( skinIndex.x );","mat4 boneMatY = getBoneMatrix( skinIndex.y );","#endif"].join("\n"), skinning_vertex : ["#ifdef USE_SKINNING","vec4 skinned  = boneMatX * skinVertexA * skinWeight.x;","skinned \t  += boneMatY * skinVertexB * skinWeight.y;","gl_Position  = projectionMatrix * modelViewMatrix * skinned;","#endif"].join("\n"), morphtarget_pars_vertex : ["#ifdef USE_MORPHTARGETS","#ifndef USE_MORPHNORMALS","uniform float morphTargetInfluences[ 8 ];","#else","uniform float morphTargetInfluences[ 4 ];","#endif","#endif"].join("\n"), morphtarget_vertex : ["#ifdef USE_MORPHTARGETS","vec3 morphed = vec3( 0.0 );","morphed += ( morphTarget0 - position ) * morphTargetInfluences[ 0 ];","morphed += ( morphTarget1 - position ) * morphTargetInfluences[ 1 ];","morphed += ( morphTarget2 - position ) * morphTargetInfluences[ 2 ];","morphed += ( morphTarget3 - position ) * morphTargetInfluences[ 3 ];","#ifndef USE_MORPHNORMALS","morphed += ( morphTarget4 - position ) * morphTargetInfluences[ 4 ];","morphed += ( morphTarget5 - position ) * morphTargetInfluences[ 5 ];","morphed += ( morphTarget6 - position ) * morphTargetInfluences[ 6 ];","morphed += ( morphTarget7 - position ) * morphTargetInfluences[ 7 ];","#endif","morphed += position;","gl_Position = projectionMatrix * modelViewMatrix * vec4( morphed, 1.0 );","#endif"].join("\n"), default_vertex : ["#ifndef USE_MORPHTARGETS","#ifndef USE_SKINNING","gl_Position = projectionMatrix * mvPosition;","#endif","#endif"].join("\n"), morphnormal_vertex : ["#ifdef USE_MORPHNORMALS","vec3 morphedNormal = vec3( 0.0 );","morphedNormal +=  ( morphNormal0 - normal ) * morphTargetInfluences[ 0 ];","morphedNormal +=  ( morphNormal1 - normal ) * morphTargetInfluences[ 1 ];","morphedNormal +=  ( morphNormal2 - normal ) * morphTargetInfluences[ 2 ];","morphedNormal +=  ( morphNormal3 - normal ) * morphTargetInfluences[ 3 ];","morphedNormal += normal;","#endif"].join("\n"), skinnormal_vertex : ["#ifdef USE_SKINNING","mat4 skinMatrix = skinWeight.x * boneMatX;","skinMatrix \t+= skinWeight.y * boneMatY;","vec4 skinnedNormal = skinMatrix * vec4( normal, 0.0 );","#endif"].join("\n"), defaultnormal_vertex : ["vec3 transformedNormal;","#ifdef USE_SKINNING","transformedNormal = skinnedNormal.xyz;","#endif","#ifdef USE_MORPHNORMALS","transformedNormal = morphedNormal;","#endif","#ifndef USE_MORPHNORMALS","#ifndef USE_SKINNING","transformedNormal = normal;","#endif","#endif","transformedNormal = normalMatrix * transformedNormal;"].join("\n"), shadowmap_pars_fragment : ["#ifdef USE_SHADOWMAP","uniform sampler2D shadowMap[ MAX_SHADOWS ];","uniform vec2 shadowMapSize[ MAX_SHADOWS ];","uniform float shadowDarkness[ MAX_SHADOWS ];","uniform float shadowBias[ MAX_SHADOWS ];","varying vec4 vShadowCoord[ MAX_SHADOWS ];","float unpackDepth( const in vec4 rgba_depth ) {","const vec4 bit_shift = vec4( 1.0 / ( 256.0 * 256.0 * 256.0 ), 1.0 / ( 256.0 * 256.0 ), 1.0 / 256.0, 1.0 );","float depth = dot( rgba_depth, bit_shift );","return depth;","}","#endif"].join("\n"), shadowmap_fragment : ["#ifdef USE_SHADOWMAP","#ifdef SHADOWMAP_DEBUG","vec3 frustumColors[3];","frustumColors[0] = vec3( 1.0, 0.5, 0.0 );","frustumColors[1] = vec3( 0.0, 1.0, 0.8 );","frustumColors[2] = vec3( 0.0, 0.5, 1.0 );","#endif","#ifdef SHADOWMAP_CASCADE","int inFrustumCount = 0;","#endif","float fDepth;","vec3 shadowColor = vec3( 1.0 );","for( int i = 0; i < MAX_SHADOWS; i ++ ) {","vec3 shadowCoord = vShadowCoord[ i ].xyz / vShadowCoord[ i ].w;","bvec4 inFrustumVec = bvec4 ( shadowCoord.x >= 0.0, shadowCoord.x <= 1.0, shadowCoord.y >= 0.0, shadowCoord.y <= 1.0 );","bool inFrustum = all( inFrustumVec );","#ifdef SHADOWMAP_CASCADE","inFrustumCount += int( inFrustum );","bvec3 frustumTestVec = bvec3( inFrustum, inFrustumCount == 1, shadowCoord.z <= 1.0 );","#else","bvec2 frustumTestVec = bvec2( inFrustum, shadowCoord.z <= 1.0 );","#endif","bool frustumTest = all( frustumTestVec );","if ( frustumTest ) {","shadowCoord.z += shadowBias[ i ];","#ifdef SHADOWMAP_SOFT","float shadow = 0.0;","const float shadowDelta = 1.0 / 9.0;","float xPixelOffset = 1.0 / shadowMapSize[ i ].x;","float yPixelOffset = 1.0 / shadowMapSize[ i ].y;","float dx0 = -1.25 * xPixelOffset;","float dy0 = -1.25 * yPixelOffset;","float dx1 = 1.25 * xPixelOffset;","float dy1 = 1.25 * yPixelOffset;","fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx0, dy0 ) ) );","if ( fDepth < shadowCoord.z ) shadow += shadowDelta;","fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( 0.0, dy0 ) ) );","if ( fDepth < shadowCoord.z ) shadow += shadowDelta;","fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx1, dy0 ) ) );","if ( fDepth < shadowCoord.z ) shadow += shadowDelta;","fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx0, 0.0 ) ) );","if ( fDepth < shadowCoord.z ) shadow += shadowDelta;","fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy ) );","if ( fDepth < shadowCoord.z ) shadow += shadowDelta;","fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx1, 0.0 ) ) );","if ( fDepth < shadowCoord.z ) shadow += shadowDelta;","fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx0, dy1 ) ) );","if ( fDepth < shadowCoord.z ) shadow += shadowDelta;","fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( 0.0, dy1 ) ) );","if ( fDepth < shadowCoord.z ) shadow += shadowDelta;","fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx1, dy1 ) ) );","if ( fDepth < shadowCoord.z ) shadow += shadowDelta;","shadowColor = shadowColor * vec3( ( 1.0 - shadowDarkness[ i ] * shadow ) );","#else","vec4 rgbaDepth = texture2D( shadowMap[ i ], shadowCoord.xy );","float fDepth = unpackDepth( rgbaDepth );","if ( fDepth < shadowCoord.z )","shadowColor = shadowColor * vec3( 1.0 - shadowDarkness[ i ] );","#endif","}","#ifdef SHADOWMAP_DEBUG","#ifdef SHADOWMAP_CASCADE","if ( inFrustum && inFrustumCount == 1 ) gl_FragColor.xyz *= frustumColors[ i ];","#else","if ( inFrustum ) gl_FragColor.xyz *= frustumColors[ i ];","#endif","#endif","}","#ifdef GAMMA_OUTPUT","shadowColor *= shadowColor;","#endif","gl_FragColor.xyz = gl_FragColor.xyz * shadowColor;","#endif"].join("\n"), shadowmap_pars_vertex : ["#ifdef USE_SHADOWMAP","varying vec4 vShadowCoord[ MAX_SHADOWS ];","uniform mat4 shadowMatrix[ MAX_SHADOWS ];","#endif"].join("\n"), shadowmap_vertex : ["#ifdef USE_SHADOWMAP","vec4 transformedPosition;","#ifdef USE_MORPHTARGETS","transformedPosition = modelMatrix * vec4( morphed, 1.0 );","#else","#ifdef USE_SKINNING","transformedPosition = modelMatrix * skinned;","#else","transformedPosition = modelMatrix * vec4( position, 1.0 );","#endif","#endif","for( int i = 0; i < MAX_SHADOWS; i ++ ) {","vShadowCoord[ i ] = shadowMatrix[ i ] * transformedPosition;","}","#endif"].join("\n"), alphatest_fragment : ["#ifdef ALPHATEST","if ( gl_FragColor.a < ALPHATEST ) discard;","#endif"].join("\n"), linear_to_gamma_fragment : ["#ifdef GAMMA_OUTPUT","gl_FragColor.xyz = sqrt( gl_FragColor.xyz );","#endif"].join("\n")};
	three.renderers.ShaderLib._uniformsLib = { common : { diffuse : { type : "c", value : new three.math.Color(15658734)}, opacity : { type : "f", value : 1.0}, map : { type : "t", value : 0, texture : null}, offsetRepeat : { type : "v4", value : new three.math.Vector4(0,0,1,1)}, lightMap : { type : "t", value : 2, texture : null}, specularMap : { type : "t", value : 3, texture : null}, envMap : { type : "t", value : 1, texture : null}, flipEnvMap : { type : "f", value : -1}, useRefract : { type : "i", value : 0}, reflectivity : { type : "f", value : 1.0}, refractionRatio : { type : "f", value : 0.98}, combine : { type : "i", value : 0}, morphTargetInfluences : { type : "f", value : 0}}, bump : { bumpMap : { type : "t", value : 4, texture : null}, bumpScale : { type : "f", value : 1}}, fog : { fogDensity : { type : "f", value : 0.00025}, fogNear : { type : "f", value : 1}, fogFar : { type : "f", value : 2000}, fogColor : { type : "c", value : new three.math.Color(16777215)}}, lights : { ambientLightColor : { type : "fv", value : []}, directionalLightDirection : { type : "fv", value : []}, directionalLightColor : { type : "fv", value : []}, pointLightColor : { type : "fv", value : []}, pointLightPosition : { type : "fv", value : []}, pointLightDistance : { type : "fv1", value : []}, spotLightColor : { type : "fv", value : []}, spotLightPosition : { type : "fv", value : []}, spotLightDirection : { type : "fv", value : []}, spotLightDistance : { type : "fv1", value : []}, spotLightAngle : { type : "fv1", value : []}, spotLightExponent : { type : "fv1", value : []}}, particle : { psColor : { type : "c", value : new three.math.Color(15658734)}, opacity : { type : "f", value : 1.0}, size : { type : "f", value : 1.0}, scale : { type : "f", value : 1.0}, map : { type : "t", value : 0, texture : null}, fogDensity : { type : "f", value : 0.00025}, fogNear : { type : "f", value : 1}, fogFar : { type : "f", value : 2000}, fogColor : { type : "c", value : new three.math.Color(16777215)}}, shadowmap : { shadowMap : { type : "tv", value : 6, texture : []}, shadowMapSize : { type : "v2v", value : []}, shadowBias : { type : "fv1", value : []}, shadowDarkness : { type : "fv1", value : []}, shadowMatrix : { type : "m4v", value : []}}};
	three.renderers.ShaderLib._shaderMap = { };
	var depthShader = { uniforms : { mNear : { type : "f", value : 1.0}, mFar : { type : "f", value : 2000.0}, opacity : { type : "f", value : 1.0}}, vertexShader : ["void main() {","gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );","}"].join("\n"), fragmentShader : ["uniform float mNear;","uniform float mFar;","uniform float opacity;","void main() {","float depth = gl_FragCoord.z / gl_FragCoord.w;","float color = 1.0 - smoothstep( mNear, mFar, depth );","gl_FragColor = vec4( vec3( color ), opacity );","}"].join("\n")};
	var normalShader = { uniforms : { opacity : { type : "f", value : 1.0}}, vertexShader : ["varying vec3 vNormal;","void main() {","vec4 mvPosition = modelViewMatrix * vec4( position, 1.0 );","vNormal = normalMatrix * normal;","gl_Position = projectionMatrix * mvPosition;","}"].join("\n"), fragmentShader : ["uniform float opacity;","varying vec3 vNormal;","void main() {","gl_FragColor = vec4( 0.5 * normalize( vNormal ) + 0.5, opacity );","}"].join("\n")};
	var basicShader = { uniforms : three.renderers.UniformsUtils.merge([three.renderers.ShaderLib._uniformsLib.common,three.renderers.ShaderLib._uniformsLib.fog,three.renderers.ShaderLib._uniformsLib.shadowmap]), vertexShader : [three.renderers.ShaderLib._shaderChunk.map_pars_vertex,three.renderers.ShaderLib._shaderChunk.lightmap_pars_vertex,three.renderers.ShaderLib._shaderChunk.envmap_pars_vertex,three.renderers.ShaderLib._shaderChunk.color_pars_vertex,three.renderers.ShaderLib._shaderChunk.skinning_pars_vertex,three.renderers.ShaderLib._shaderChunk.morphtarget_pars_vertex,three.renderers.ShaderLib._shaderChunk.shadowmap_pars_vertex,"void main() {","vec4 mvPosition = modelViewMatrix * vec4( position, 1.0 );",three.renderers.ShaderLib._shaderChunk.map_vertex,three.renderers.ShaderLib._shaderChunk.lightmap_vertex,three.renderers.ShaderLib._shaderChunk.envmap_vertex,three.renderers.ShaderLib._shaderChunk.color_vertex,three.renderers.ShaderLib._shaderChunk.skinbase_vertex,three.renderers.ShaderLib._shaderChunk.skinning_vertex,three.renderers.ShaderLib._shaderChunk.morphtarget_vertex,three.renderers.ShaderLib._shaderChunk.default_vertex,three.renderers.ShaderLib._shaderChunk.shadowmap_vertex,"}"].join("\n"), fragmentShader : ["uniform vec3 diffuse;","uniform float opacity;",three.renderers.ShaderLib._shaderChunk.color_pars_fragment,three.renderers.ShaderLib._shaderChunk.map_pars_fragment,three.renderers.ShaderLib._shaderChunk.lightmap_pars_fragment,three.renderers.ShaderLib._shaderChunk.envmap_pars_fragment,three.renderers.ShaderLib._shaderChunk.fog_pars_fragment,three.renderers.ShaderLib._shaderChunk.shadowmap_pars_fragment,three.renderers.ShaderLib._shaderChunk.specularmap_pars_fragment,"void main() {","gl_FragColor = vec4( diffuse, opacity );",three.renderers.ShaderLib._shaderChunk.map_fragment,three.renderers.ShaderLib._shaderChunk.alphatest_fragment,three.renderers.ShaderLib._shaderChunk.specularmap_fragment,three.renderers.ShaderLib._shaderChunk.lightmap_fragment,three.renderers.ShaderLib._shaderChunk.color_fragment,three.renderers.ShaderLib._shaderChunk.envmap_fragment,three.renderers.ShaderLib._shaderChunk.shadowmap_fragment,three.renderers.ShaderLib._shaderChunk.linear_to_gamma_fragment,three.renderers.ShaderLib._shaderChunk.fog_fragment,"}"].join("\n")};
	var lambertShader = { uniforms : three.renderers.UniformsUtils.merge([three.renderers.ShaderLib._uniformsLib.common,three.renderers.ShaderLib._uniformsLib.fog,three.renderers.ShaderLib._uniformsLib.lights,three.renderers.ShaderLib._uniformsLib.shadowmap,{ ambient : { type : "c", value : new three.math.Color(16777215)}, emissive : { type : "c", value : new three.math.Color(0)}, wrapRGB : { type : "v3", value : new three.math.Vector3(1,1,1)}}]), vertexShader : ["varying vec3 vLightFront;","#ifdef DOUBLE_SIDED","varying vec3 vLightBack;","#endif",three.renderers.ShaderLib._shaderChunk.map_pars_vertex,three.renderers.ShaderLib._shaderChunk.lightmap_pars_vertex,three.renderers.ShaderLib._shaderChunk.envmap_pars_vertex,three.renderers.ShaderLib._shaderChunk.lights_lambert_pars_vertex,three.renderers.ShaderLib._shaderChunk.color_pars_vertex,three.renderers.ShaderLib._shaderChunk.skinning_pars_vertex,three.renderers.ShaderLib._shaderChunk.morphtarget_pars_vertex,three.renderers.ShaderLib._shaderChunk.shadowmap_pars_vertex,"void main() {","vec4 mvPosition = modelViewMatrix * vec4( position, 1.0 );",three.renderers.ShaderLib._shaderChunk.map_vertex,three.renderers.ShaderLib._shaderChunk.lightmap_vertex,three.renderers.ShaderLib._shaderChunk.envmap_vertex,three.renderers.ShaderLib._shaderChunk.color_vertex,three.renderers.ShaderLib._shaderChunk.morphnormal_vertex,three.renderers.ShaderLib._shaderChunk.skinbase_vertex,three.renderers.ShaderLib._shaderChunk.skinnormal_vertex,three.renderers.ShaderLib._shaderChunk.defaultnormal_vertex,"#ifndef USE_ENVMAP","vec4 mPosition = modelMatrix * vec4( position, 1.0 );","#endif",three.renderers.ShaderLib._shaderChunk.lights_lambert_vertex,three.renderers.ShaderLib._shaderChunk.skinning_vertex,three.renderers.ShaderLib._shaderChunk.morphtarget_vertex,three.renderers.ShaderLib._shaderChunk.default_vertex,three.renderers.ShaderLib._shaderChunk.shadowmap_vertex,"}"].join("\n"), fragmentShader : ["uniform float opacity;","varying vec3 vLightFront;","#ifdef DOUBLE_SIDED","varying vec3 vLightBack;","#endif",three.renderers.ShaderLib._shaderChunk.color_pars_fragment,three.renderers.ShaderLib._shaderChunk.map_pars_fragment,three.renderers.ShaderLib._shaderChunk.lightmap_pars_fragment,three.renderers.ShaderLib._shaderChunk.envmap_pars_fragment,three.renderers.ShaderLib._shaderChunk.fog_pars_fragment,three.renderers.ShaderLib._shaderChunk.shadowmap_pars_fragment,three.renderers.ShaderLib._shaderChunk.specularmap_pars_fragment,"void main() {","gl_FragColor = vec4( vec3 ( 1.0 ), opacity );",three.renderers.ShaderLib._shaderChunk.map_fragment,three.renderers.ShaderLib._shaderChunk.alphatest_fragment,three.renderers.ShaderLib._shaderChunk.specularmap_fragment,"#ifdef DOUBLE_SIDED","if ( gl_FrontFacing )","gl_FragColor.xyz *= vLightFront;","else","gl_FragColor.xyz *= vLightBack;","#else","gl_FragColor.xyz *= vLightFront;","#endif",three.renderers.ShaderLib._shaderChunk.lightmap_fragment,three.renderers.ShaderLib._shaderChunk.color_fragment,three.renderers.ShaderLib._shaderChunk.envmap_fragment,three.renderers.ShaderLib._shaderChunk.shadowmap_fragment,three.renderers.ShaderLib._shaderChunk.linear_to_gamma_fragment,three.renderers.ShaderLib._shaderChunk.fog_fragment,"}"].join("\n")};
	var phongShader = { uniforms : three.renderers.UniformsUtils.merge([three.renderers.ShaderLib._uniformsLib.common,three.renderers.ShaderLib._uniformsLib.bump,three.renderers.ShaderLib._uniformsLib.fog,three.renderers.ShaderLib._uniformsLib.lights,three.renderers.ShaderLib._uniformsLib.shadowmap,{ ambient : { type : "c", value : new three.math.Color(16777215)}, emissive : { type : "c", value : new three.math.Color(0)}, specular : { type : "c", value : new three.math.Color(1118481)}, shininess : { type : "f", value : 30}, wrapRGB : { type : "v3", value : new three.math.Vector3(1,1,1)}}]), vertexShader : ["varying vec3 vViewPosition;","varying vec3 vNormal;",three.renderers.ShaderLib._shaderChunk.map_pars_vertex,three.renderers.ShaderLib._shaderChunk.lightmap_pars_vertex,three.renderers.ShaderLib._shaderChunk.envmap_pars_vertex,three.renderers.ShaderLib._shaderChunk.lights_phong_pars_vertex,three.renderers.ShaderLib._shaderChunk.color_pars_vertex,three.renderers.ShaderLib._shaderChunk.skinning_pars_vertex,three.renderers.ShaderLib._shaderChunk.morphtarget_pars_vertex,three.renderers.ShaderLib._shaderChunk.shadowmap_pars_vertex,"void main() {","vec4 mvPosition = modelViewMatrix * vec4( position, 1.0 );",three.renderers.ShaderLib._shaderChunk.map_vertex,three.renderers.ShaderLib._shaderChunk.lightmap_vertex,three.renderers.ShaderLib._shaderChunk.envmap_vertex,three.renderers.ShaderLib._shaderChunk.color_vertex,"#ifndef USE_ENVMAP","vec4 mPosition = modelMatrix * vec4( position, 1.0 );","#endif","vViewPosition = -mvPosition.xyz;",three.renderers.ShaderLib._shaderChunk.morphnormal_vertex,three.renderers.ShaderLib._shaderChunk.skinbase_vertex,three.renderers.ShaderLib._shaderChunk.skinnormal_vertex,three.renderers.ShaderLib._shaderChunk.defaultnormal_vertex,"vNormal = transformedNormal;",three.renderers.ShaderLib._shaderChunk.lights_phong_vertex,three.renderers.ShaderLib._shaderChunk.skinning_vertex,three.renderers.ShaderLib._shaderChunk.morphtarget_vertex,three.renderers.ShaderLib._shaderChunk.default_vertex,three.renderers.ShaderLib._shaderChunk.shadowmap_vertex,"}"].join("\n"), fragmentShader : ["uniform vec3 diffuse;","uniform float opacity;","uniform vec3 ambient;","uniform vec3 emissive;","uniform vec3 specular;","uniform float shininess;",three.renderers.ShaderLib._shaderChunk.color_pars_fragment,three.renderers.ShaderLib._shaderChunk.map_pars_fragment,three.renderers.ShaderLib._shaderChunk.lightmap_pars_fragment,three.renderers.ShaderLib._shaderChunk.envmap_pars_fragment,three.renderers.ShaderLib._shaderChunk.fog_pars_fragment,three.renderers.ShaderLib._shaderChunk.lights_phong_pars_fragment,three.renderers.ShaderLib._shaderChunk.shadowmap_pars_fragment,three.renderers.ShaderLib._shaderChunk.bumpmap_pars_fragment,three.renderers.ShaderLib._shaderChunk.specularmap_pars_fragment,"void main() {","gl_FragColor = vec4( vec3 ( 1.0 ), opacity );",three.renderers.ShaderLib._shaderChunk.map_fragment,three.renderers.ShaderLib._shaderChunk.alphatest_fragment,three.renderers.ShaderLib._shaderChunk.specularmap_fragment,three.renderers.ShaderLib._shaderChunk.lights_phong_fragment,three.renderers.ShaderLib._shaderChunk.lightmap_fragment,three.renderers.ShaderLib._shaderChunk.color_fragment,three.renderers.ShaderLib._shaderChunk.envmap_fragment,three.renderers.ShaderLib._shaderChunk.shadowmap_fragment,three.renderers.ShaderLib._shaderChunk.linear_to_gamma_fragment,three.renderers.ShaderLib._shaderChunk.fog_fragment,"}"].join("\n")};
	var particleBasicShader = { uniforms : three.renderers.UniformsUtils.merge([three.renderers.ShaderLib._uniformsLib.particle,three.renderers.ShaderLib._uniformsLib.shadowmap]), vertexShader : ["uniform float size;","uniform float scale;",three.renderers.ShaderLib._shaderChunk.color_pars_vertex,three.renderers.ShaderLib._shaderChunk.shadowmap_pars_vertex,"void main() {",three.renderers.ShaderLib._shaderChunk.color_vertex,"vec4 mvPosition = modelViewMatrix * vec4( position, 1.0 );","#ifdef USE_SIZEATTENUATION","gl_PointSize = size * ( scale / length( mvPosition.xyz ) );","#else","gl_PointSize = size;","#endif","gl_Position = projectionMatrix * mvPosition;",three.renderers.ShaderLib._shaderChunk.shadowmap_vertex,"}"].join("\n"), fragmentShader : ["uniform vec3 psColor;","uniform float opacity;",three.renderers.ShaderLib._shaderChunk.color_pars_fragment,three.renderers.ShaderLib._shaderChunk.map_particle_pars_fragment,three.renderers.ShaderLib._shaderChunk.fog_pars_fragment,three.renderers.ShaderLib._shaderChunk.shadowmap_pars_fragment,"void main() {","gl_FragColor = vec4( psColor, opacity );",three.renderers.ShaderLib._shaderChunk.map_particle_fragment,three.renderers.ShaderLib._shaderChunk.alphatest_fragment,three.renderers.ShaderLib._shaderChunk.color_fragment,three.renderers.ShaderLib._shaderChunk.shadowmap_fragment,three.renderers.ShaderLib._shaderChunk.fog_fragment,"}"].join("\n")};
	var depthRGBAShader = { uniforms : { }, vertexShader : [three.renderers.ShaderLib._shaderChunk.skinning_pars_vertex,three.renderers.ShaderLib._shaderChunk.morphtarget_pars_vertex,"void main() {","vec4 mvPosition = modelViewMatrix * vec4( position, 1.0 );",three.renderers.ShaderLib._shaderChunk.skinbase_vertex,three.renderers.ShaderLib._shaderChunk.skinning_vertex,three.renderers.ShaderLib._shaderChunk.morphtarget_vertex,three.renderers.ShaderLib._shaderChunk.default_vertex,"}"].join("\n"), fragmentShader : ["vec4 pack_depth( const in float depth ) {","const vec4 bit_shift = vec4( 256.0 * 256.0 * 256.0, 256.0 * 256.0, 256.0, 1.0 );","const vec4 bit_mask  = vec4( 0.0, 1.0 / 256.0, 1.0 / 256.0, 1.0 / 256.0 );","vec4 res = fract( depth * bit_shift );","res -= res.xxyz * bit_mask;","return res;","}","void main() {","gl_FragData[ 0 ] = pack_depth( gl_FragCoord.z );","}"].join("\n")};
	three.renderers.ShaderLib._shaderMap.depth = depthShader;
	three.renderers.ShaderLib._shaderMap.normal = normalShader;
	three.renderers.ShaderLib._shaderMap.basic = basicShader;
	three.renderers.ShaderLib._shaderMap.lambert = lambertShader;
	three.renderers.ShaderLib._shaderMap.phong = phongShader;
	three.renderers.ShaderLib._shaderMap.particle_basic = particleBasicShader;
	three.renderers.ShaderLib._shaderMap.depthRGBA = depthRGBAShader;
}
three.renderers.ShaderLib.getShaderDef = function(value) {
	return three.renderers.ShaderLib._shaderMap[value];
}
three.renderers.UniformsUtils = function() { }
three.renderers.UniformsUtils.__name__ = true;
three.renderers.UniformsUtils.merge = function(uniforms) {
	var merged = { };
	var tmp;
	var _g1 = 0, _g = uniforms.length;
	while(_g1 < _g) {
		var u = _g1++;
		tmp = three.renderers.UniformsUtils.clone(uniforms[u]);
		var fields = Type.getClassFields(tmp);
		var _g2 = 0;
		while(_g2 < fields.length) {
			var key = fields[_g2];
			++_g2;
			merged[key] = tmp[key];
		}
	}
	return merged;
}
three.renderers.UniformsUtils.clone = function(uniforms_src) {
	var uniforms_dst = { };
	var parameter_src;
	var fields = Type.getClassFields(uniforms_src);
	var _g = 0;
	while(_g < fields.length) {
		var u = fields[_g];
		++_g;
		var srcItem = { };
		var itemFields = Type.getClassFields(srcItem);
		var _g1 = 0;
		while(_g1 < itemFields.length) {
			var p = itemFields[_g1];
			++_g1;
			parameter_src = itemFields[p];
			if(js.Boot.__instanceof(parameter_src,three.math.Color) || js.Boot.__instanceof(parameter_src,three.math.Vector2) || js.Boot.__instanceof(parameter_src,three.math.Vector3) || js.Boot.__instanceof(parameter_src,three.math.Vector4) || js.Boot.__instanceof(parameter_src,three.math.Matrix4) || js.Boot.__instanceof(parameter_src,three.textures.Texture)) srcItem[p] = parameter_src.clone(); else if(js.Boot.__instanceof(parameter_src,Array)) srcItem[p] = (js.Boot.__cast(parameter_src , Array)).slice(0); else srcItem[p] = parameter_src;
		}
		uniforms_dst[u] = srcItem;
	}
	return uniforms_dst;
}
three.scenes = {}
three.scenes.IFog = function() { }
three.scenes.IFog.__name__ = true;
three.scenes.IFog.prototype = {
	__class__: three.scenes.IFog
}
three.scenes.Scene = function() {
	three.core.Object3D.call(this);
	this.fog = null;
	this.overrideMaterial = null;
	this.matrixAutoUpdate = false;
	this.__objects = [];
	this.__lights = [];
	this.__objectsAdded = [];
	this.__objectsRemoved = [];
};
three.scenes.Scene.__name__ = true;
three.scenes.Scene.__super__ = three.core.Object3D;
three.scenes.Scene.prototype = $extend(three.core.Object3D.prototype,{
	__removeObject: function(object) {
		if(js.Boot.__instanceof(object,three.lights.Light)) {
			var i = this.__lights.indexOf(object);
			if(i != -1) this.__lights.splice(i,1);
		} else if(!js.Boot.__instanceof(object,three.cameras.Camera)) {
			var i = this.__objects.indexOf(object);
			if(i != -1) {
				this.__objects.splice(i,1);
				this.__objectsRemoved.push(object);
				var ai = this.__objectsAdded.indexOf(object);
				if(ai != -1) this.__objectsAdded.splice(ai,1);
			}
		}
		var _g1 = 0, _g = object.children.length;
		while(_g1 < _g) {
			var c = _g1++;
			this.__removeObject(object.children[c]);
		}
	}
	,__addObject: function(object) {
		if(js.Boot.__instanceof(object,three.lights.Light)) {
			var light = js.Boot.__cast(object , three.lights.Light);
			var i = this.__lights.indexOf(light);
			if(i == -1) this.__lights.push(light);
			if(light.target != null && light.target.parent == null) this.add(light.target);
		} else if(!(js.Boot.__instanceof(object,three.cameras.Camera) || js.Boot.__instanceof(object,three.objects.Bone))) {
			var i = this.__objects.indexOf(object);
			if(i == -1) {
				this.__objects.push(object);
				this.__objectsAdded.push(object);
				var i1 = this.__objectsRemoved.indexOf(object);
				if(i1 != -1) this.__objectsRemoved.splice(i1,1);
			}
		}
		var _g1 = 0, _g = object.children.length;
		while(_g1 < _g) {
			var c = _g1++;
			this.__addObject(object.children[c]);
		}
	}
	,__class__: three.scenes.Scene
});
three.textures = {}
three.textures.Texture = function(image,mapping) {
	this.id = three.textures.Texture.TextureCount++;
	this.image = image;
	this.mapping = mapping != null?mapping:new three.materials.UVMapping();
	this.wrapS = 1001;
	this.wrapT = 1001;
	this.magFilter = 1006;
	this.minFilter = 1008;
	this.anisotropy = 1;
	this.format = 1021;
	this.type = 1021;
	this.offset = new three.math.Vector2(0,0);
	this.repeat = new three.math.Vector2(1,1);
	this.generateMipmaps = true;
	this.premultiplyAlpha = false;
	this.flipY = true;
	this.needsUpdate = false;
};
three.textures.Texture.__name__ = true;
three.textures.Texture.prototype = {
	clone: function() {
		var clonedTexture = new three.textures.Texture(this.image,this.mapping);
		clonedTexture.wrapS = this.wrapS;
		clonedTexture.wrapT = this.wrapS;
		clonedTexture.magFilter = this.magFilter;
		clonedTexture.minFilter = this.magFilter;
		clonedTexture.anisotropy = this.anisotropy;
		clonedTexture.format = this.format;
		clonedTexture.type = this.type;
		clonedTexture.offset.copy(this.offset);
		clonedTexture.repeat.copy(this.repeat);
		clonedTexture.generateMipmaps = this.generateMipmaps;
		clonedTexture.premultiplyAlpha = this.premultiplyAlpha;
		clonedTexture.flipY = this.flipY;
		return clonedTexture;
	}
	,onUpdate: function() {
	}
	,__class__: three.textures.Texture
}
three.utils = {}
three.utils.ArrayUtil = function() { }
three.utils.ArrayUtil.__name__ = true;
three.utils.ArrayUtil.indexOf = function(list,item) {
	return list.indexOf(item);
}
three.utils.Assert = function() {
};
three.utils.Assert.__name__ = true;
three.utils.Assert.assert = function(condition,info) {
	if(!condition) console.log(info);
}
three.utils.Assert.prototype = {
	__class__: three.utils.Assert
}
three.utils.Logger = function() { }
three.utils.Logger.__name__ = true;
three.utils.Logger.log = function(value) {
	console.log(value);
}
three.utils.Logger.warn = function(value) {
}
three.utils.Logger.error = function(value) {
}
three.utils.TempVars = function() {
	this.isUsed = false;
	this.color = new three.math.Color();
	this.vect1 = new three.math.Vector3();
	this.vect2 = new three.math.Vector3();
	this.vect3 = new three.math.Vector3();
	this.vect4 = new three.math.Vector3();
	this.vect5 = new three.math.Vector3();
	this.vect6 = new three.math.Vector3();
	this.vect7 = new three.math.Vector3();
	this.vect4f = new three.math.Vector4();
	this.vect2d = new three.math.Vector2();
	this.vect2d2 = new three.math.Vector2();
	this.tempMat3 = new three.math.Matrix3();
	this.tempMat4 = new three.math.Matrix4();
	this.tempMat42 = new three.math.Matrix4();
};
three.utils.TempVars.__name__ = true;
three.utils.TempVars.getTempVars = function() {
	var instance = three.utils.TempVars.varStack[three.utils.TempVars.currentIndex];
	if(instance == null) {
		instance = new three.utils.TempVars();
		three.utils.TempVars.varStack[three.utils.TempVars.currentIndex] = instance;
	}
	three.utils.TempVars.currentIndex++;
	instance.isUsed = true;
	return instance;
}
three.utils.TempVars.prototype = {
	release: function() {
		three.utils.Assert.assert(this.isUsed,"This instance of TempVars was already released!");
		this.isUsed = false;
		three.utils.TempVars.currentIndex--;
		three.utils.Assert.assert(three.utils.TempVars.varStack[three.utils.TempVars.currentIndex] == this,"An instance of TempVars has not been released in a called method!");
	}
	,__class__: three.utils.TempVars
}
three.utils.WebGLUtil = function() { }
three.utils.WebGLUtil.__name__ = true;
three.utils.WebGLUtil.createShader = function(gl,shaderSource,type) {
	var shader = gl.createShader(type);
	gl.shaderSource(shader,shaderSource);
	gl.compileShader(shader);
	if(!gl.getShaderParameter(shader,35713)) throw gl.getShaderInfoLog(shader);
	return shader;
}
three.utils.WebGLUtil.createProgram = function(gl,vertexSource,fragSource) {
	var program = gl.createProgram();
	var vshader = three.utils.WebGLUtil.createShader(gl,vertexSource,35633);
	var fshader = three.utils.WebGLUtil.createShader(gl,fragSource,35632);
	gl.attachShader(program,vshader);
	gl.attachShader(program,fshader);
	gl.linkProgram(program);
	if(!gl.getProgramParameter(program,35714)) throw gl.getProgramInfoLog(program);
	return program;
}
var $_;
function $bind(o,m) { var f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; return f; };
if(Array.prototype.indexOf) HxOverrides.remove = function(a,o) {
	var i = a.indexOf(o);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
}; else null;
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.prototype.__class__ = Array;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
js.Browser.window = typeof window != "undefined" ? window : null;
js.Browser.document = typeof window != "undefined" ? window.document : null;
three.ThreeGlobal.FrontSide = 0;
three.ThreeGlobal.BackSide = 1;
three.ThreeGlobal.DoubleSide = 2;
three.ThreeGlobal.NoShading = 0;
three.ThreeGlobal.FlatShading = 1;
three.ThreeGlobal.SmoothShading = 2;
three.ThreeGlobal.NoColors = 0;
three.ThreeGlobal.FaceColors = 1;
three.ThreeGlobal.VertexColors = 2;
three.ThreeGlobal.NoBlending = 0;
three.ThreeGlobal.NormalBlending = 1;
three.ThreeGlobal.AdditiveBlending = 2;
three.ThreeGlobal.SubtractiveBlending = 3;
three.ThreeGlobal.MultiplyBlending = 4;
three.ThreeGlobal.CustomBlending = 5;
three.ThreeGlobal.AddEquation = 100;
three.ThreeGlobal.SubtractEquation = 101;
three.ThreeGlobal.ReverseSubtractEquation = 102;
three.ThreeGlobal.ZeroFactor = 200;
three.ThreeGlobal.OneFactor = 201;
three.ThreeGlobal.SrcColorFactor = 202;
three.ThreeGlobal.OneMinusSrcColorFactor = 203;
three.ThreeGlobal.SrcAlphaFactor = 204;
three.ThreeGlobal.OneMinusSrcAlphaFactor = 205;
three.ThreeGlobal.DstAlphaFactor = 206;
three.ThreeGlobal.OneMinusDstAlphaFactor = 207;
three.ThreeGlobal.DstColorFactor = 208;
three.ThreeGlobal.OneMinusDstColorFactor = 209;
three.ThreeGlobal.SrcAlphaSaturateFactor = 210;
three.ThreeGlobal.MultiplyOperation = 0;
three.ThreeGlobal.MixOperation = 1;
three.ThreeGlobal.RepeatWrapping = 1000;
three.ThreeGlobal.ClampToEdgeWrapping = 1001;
three.ThreeGlobal.MirroredRepeatWrapping = 1002;
three.ThreeGlobal.NearestFilter = 1003;
three.ThreeGlobal.NearestMipMapNearestFilter = 1004;
three.ThreeGlobal.NearestMipMapLinearFilter = 1005;
three.ThreeGlobal.LinearFilter = 1006;
three.ThreeGlobal.LinearMipMapNearestFilter = 1007;
three.ThreeGlobal.LinearMipMapLinearFilter = 1008;
three.ThreeGlobal.UnsignedByteType = 1009;
three.ThreeGlobal.ByteType = 1010;
three.ThreeGlobal.ShortType = 1011;
three.ThreeGlobal.UnsignedShortType = 1012;
three.ThreeGlobal.IntType = 1013;
three.ThreeGlobal.UnsignedIntType = 1014;
three.ThreeGlobal.FloatType = 1015;
three.ThreeGlobal.UnsignedShort4444Type = 1016;
three.ThreeGlobal.UnsignedShort5551Type = 1017;
three.ThreeGlobal.UnsignedShort565Type = 1018;
three.ThreeGlobal.AlphaFormat = 1019;
three.ThreeGlobal.RGBFormat = 1020;
three.ThreeGlobal.RGBAFormat = 1021;
three.ThreeGlobal.LuminanceFormat = 1022;
three.ThreeGlobal.LuminanceAlphaFormat = 1023;
three.core.Object3D.Object3DCount = 0;
three.core.Object3D._m1 = new three.math.Matrix4();
three.core.Geometry.GeometryCount = 0;
three.materials.Material.MaterialCount = 0;
three.math.MathUtil.LN2 = Math.LN2;
three.math.MathUtil.RAD2DEG = 180 / Math.PI;
three.math.MathUtil.DEG2RAD = Math.PI / 180;
three.math.Vector3.X_AXIS = new three.math.Vector3(1,0,0);
three.math.Vector3.Y_AXIS = new three.math.Vector3(0,1,0);
three.math.Vector3.Z_AXIS = new three.math.Vector3(0,0,1);
three.textures.Texture.TextureCount = 0;
three.utils.TempVars.STACK_SIZE = 5;
three.utils.TempVars.currentIndex = 0;
three.utils.TempVars.varStack = new Array();
Test.main();
})();

//@ sourceMappingURL=Threejs.js.map