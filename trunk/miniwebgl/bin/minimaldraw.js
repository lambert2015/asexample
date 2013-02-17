(function () { "use strict";
var MinimalDraw = function() {
	this.gl = null;
	js.Browser.window.onload = $bind(this,this.onLoad);
};
MinimalDraw.__name__ = true;
MinimalDraw.main = function() {
	new MinimalDraw();
}
MinimalDraw.prototype = {
	onLoad: function(e) {
		var canvas = js.Browser.document.getElementById("webgl_canvas");
		this.gl = js.Boot.__cast(canvas.getContext("experimental-webgl") , WebGLRenderingContext);
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
		var program = WebGLUtil.createProgram(this.gl,vs,fs);
		this.gl.useProgram(program);
		var index = this.gl.getAttribLocation(program,"pos");
		this.gl.enableVertexAttribArray(index);
		this.gl.vertexAttribPointer(index,2,5126,false,0,0);
		this.gl.drawArrays(4,0,3);
	}
	,__class__: MinimalDraw
}
var Std = function() { }
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
var WebGLUtil = function() { }
WebGLUtil.__name__ = true;
WebGLUtil.createShader = function(gl,shaderSource,type) {
	var shader = gl.createShader(type);
	gl.shaderSource(shader,shaderSource);
	gl.compileShader(shader);
	return shader;
}
WebGLUtil.createProgram = function(gl,vertexSource,fragSource) {
	var program = gl.createProgram();
	var vshader = WebGLUtil.createShader(gl,vertexSource,35633);
	var fshader = WebGLUtil.createShader(gl,fragSource,35632);
	gl.attachShader(program,vshader);
	gl.attachShader(program,fshader);
	gl.linkProgram(program);
	return program;
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
var $_;
function $bind(o,m) { var f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; return f; };
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
MinimalDraw.main();
})();

//@ sourceMappingURL=minimaldraw.js.map