(function () { "use strict";
var $estr = function() { return js.Boot.__string_rec(this,''); };
var HxOverrides = function() { }
HxOverrides.__name__ = true;
HxOverrides.dateStr = function(date) {
	var m = date.getMonth() + 1;
	var d = date.getDate();
	var h = date.getHours();
	var mi = date.getMinutes();
	var s = date.getSeconds();
	return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d < 10?"0" + d:"" + d) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
}
HxOverrides.strDate = function(s) {
	switch(s.length) {
	case 8:
		var k = s.split(":");
		var d = new Date();
		d.setTime(0);
		d.setUTCHours(k[0]);
		d.setUTCMinutes(k[1]);
		d.setUTCSeconds(k[2]);
		return d;
	case 10:
		var k = s.split("-");
		return new Date(k[0],k[1] - 1,k[2],0,0,0);
	case 19:
		var k = s.split(" ");
		var y = k[0].split("-");
		var t = k[1].split(":");
		return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
	default:
		throw "Invalid date format : " + s;
	}
}
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
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
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
}
var IntIter = function(min,max) {
	this.min = min;
	this.max = max;
};
IntIter.__name__ = true;
IntIter.prototype = {
	next: function() {
		return this.min++;
	}
	,hasNext: function() {
		return this.min < this.max;
	}
	,__class__: IntIter
}
var Std = function() { }
Std.__name__ = true;
Std["is"] = function(v,t) {
	return js.Boot.__instanceof(v,t);
}
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std["int"] = function(x) {
	return x | 0;
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
Std.random = function(x) {
	return x <= 0?0:Math.floor(Math.random() * x);
}
var js = {}
js.Boot = function() { }
js.Boot.__name__ = true;
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__string_rec(v,"");
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof(console) != "undefined" && console.log != null) console.log(msg);
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
}
js.Boot.isClass = function(o) {
	return o.__name__;
}
js.Boot.isEnum = function(e) {
	return e.__ename__;
}
js.Boot.getClass = function(o) {
	return o.__class__;
}
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
js.Lib = function() { }
js.Lib.__name__ = true;
js.Lib.debug = function() {
	debugger;
}
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
}
js.Lib["eval"] = function(code) {
	return eval(code);
}
js.Lib.setErrorHandler = function(f) {
	js.Lib.onerror = f;
}
var three = {}
three.math = {}
three.math.Color = function(value) {
	if(value == null) value = -16777216;
	this.setRGBA(value);
};
three.math.Color.__name__ = true;
three.math.Color.prototype = {
	setRGBA: function(value) {
		var invert = 1.0 / 255;
		this.a = (value >> 24 & 255) * invert;
		this.r = (value >> 16 & 255) * invert;
		this.g = (value >> 8 & 255) * invert;
		this.b = (value & 255) * invert;
		return value;
	}
	,getRGBA: function() {
		return Math.floor(this.a * 255) << 24 | Math.floor(this.r * 255) << 16 | Math.floor(this.g * 255) << 8 | Math.floor(this.b * 255);
	}
	,setRGB: function(value) {
		var invert = 1.0 / 255;
		this.r = (value >> 16 & 255) * invert;
		this.g = (value >> 8 & 255) * invert;
		this.b = (value & 255) * invert;
		return value;
	}
	,getRGB: function() {
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
three.math.Matrix3 = function() {
};
three.math.Matrix3.__name__ = true;
three.math.Matrix3.prototype = {
	__class__: three.math.Matrix3
}
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
		var scaleX = 1 / vector.setTo(me[0],me[1],me[2]).getLength();
		var scaleY = 1 / vector.setTo(me[4],me[5],me[6]).getLength();
		var scaleZ = 1 / vector.setTo(me[8],me[9],me[10]).getLength();
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
		scale.x = x.getLength();
		scale.y = y.getLength();
		scale.z = z.getLength();
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
		if(vz.getLength() == 0) vz.z = 1;
		vx.cross(up,vz).normalize();
		if(vx.getLength() == 0) {
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
	,getLength: function() {
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
		return this.getLengthSq() < 0.0001;
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
	,getLength: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y);
	}
	,getLengthSq: function() {
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
		return this.getLengthSq() < 0.0001;
	}
	,equals: function(value) {
		return value.x == this.x && value.y == this.y && this.z == value.z;
	}
	,getScaleFromMatrix: function(m) {
		var sx = this.setTo(m.elements[0],m.elements[1],m.elements[2]).getLength();
		var sy = this.setTo(m.elements[4],m.elements[5],m.elements[6]).getLength();
		var sz = this.setTo(m.elements[8],m.elements[9],m.elements[10]).getLength();
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
	,getLength: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
	}
	,getLengthSq: function() {
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
	,getLength: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
	}
	,getLengthSq: function() {
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
three.scenes = {}
three.scenes.Fog = function(hex,near,far) {
	if(far == null) far = 1000;
	if(near == null) near = 1;
	this.color = new three.math.Color(hex);
	this.near = near;
	this.far = far;
};
three.scenes.Fog.__name__ = true;
three.scenes.Fog.prototype = {
	__class__: three.scenes.Fog
}
three.utils = {}
three.utils.Assert = function() {
};
three.utils.Assert.__name__ = true;
three.utils.Assert.assert = function(condition,info) {
	if(!condition) console.log(info);
}
three.utils.Assert.prototype = {
	__class__: three.utils.Assert
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
	if(!gl.getShaderParameter(shader,gl.COMPILE_STATUS)) throw gl.getShaderInfoLog(shader);
	return shader;
}
three.utils.WebGLUtil.createProgram = function(gl,vertexSource,fragSource) {
	var program = gl.createProgram();
	var vshader = three.utils.WebGLUtil.createShader(gl,vertexSource,gl.VERTEX_SHADER);
	var fshader = three.utils.WebGLUtil.createShader(gl,fragSource,gl.FRAGMENT_SHADER);
	gl.attachShader(program,vshader);
	gl.attachShader(program,fshader);
	gl.linkProgram(program);
	if(!gl.getProgramParameter(program,gl.LINK_STATUS)) throw gl.getProgramInfoLog(program);
	return program;
}
var webgl101 = {}
webgl101.MinimalDraw = function() {
	this.gl = null;
	js.Lib.window.onload = $bind(this,this.onLoad);
};
webgl101.MinimalDraw.__name__ = true;
webgl101.MinimalDraw.main = function() {
	new webgl101.MinimalDraw();
}
webgl101.MinimalDraw.prototype = {
	onLoad: function(e) {
		var canvas = js.Lib.document.getElementById("webgl_canvas");
		this.gl = js.Boot.__cast(canvas.getContext("experimental-webgl") , WebGLRenderingContext);
		this.gl.viewport(0,0,canvas.width,canvas.height);
		this.gl.clearColor(0,0,0.8,1);
		this.gl.clear(this.gl.COLOR_BUFFER_BIT | this.gl.DEPTH_BUFFER_BIT);
		var vertexPosBuffer = this.gl.createBuffer();
		this.gl.bindBuffer(this.gl.ARRAY_BUFFER,vertexPosBuffer);
		var vertices = [-0.5,-0.5,0.5,-0.5,0,0.5];
		var floatArray = new Float32Array(vertices);
		this.gl.bufferData(this.gl.ARRAY_BUFFER,floatArray,this.gl.STATIC_DRAW);
		var vs = "attribute vec2 pos;\n" + "void main(){ gl_Position = vec4(pos,0,1); }";
		var fs = "precision mediump float;\n" + "void main() { gl_FragColor = vec4(0,0.8,0,1); }";
		var program = three.utils.WebGLUtil.createProgram(this.gl,vs,fs);
		this.gl.useProgram(program);
		var index = this.gl.getAttribLocation(program,"pos");
		this.gl.enableVertexAttribArray(index);
		this.gl.vertexAttribPointer(index,2,this.gl.FLOAT,false,0,0);
		this.gl.drawArrays(this.gl.TRIANGLES,0,3);
	}
	,__class__: webgl101.MinimalDraw
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
Date.prototype.__class__ = Date;
Date.__name__ = ["Date"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
var Void = { __ename__ : ["Void"]};
if(typeof document != "undefined") js.Lib.document = document;
if(typeof window != "undefined") {
	js.Lib.window = window;
	js.Lib.window.onerror = function(msg,url,line) {
		var f = js.Lib.onerror;
		if(f == null) return false;
		return f(msg,[url + ":" + line]);
	};
}
three.utils.TempVars.STACK_SIZE = 5;
three.utils.TempVars.currentIndex = 0;
three.utils.TempVars.varStack = new Array();
webgl101.MinimalDraw.main();
})();

//@ sourceMappingURL=minimaldraw.js.map