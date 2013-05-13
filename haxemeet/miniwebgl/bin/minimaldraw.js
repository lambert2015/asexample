(function () { "use strict";
var MinimalDraw = function() {
	this.gl = null;
	js.Browser.window.onload = $bind(this,this.onLoad);
};
MinimalDraw.main = function() {
	new MinimalDraw();
}
MinimalDraw.prototype = {
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
		var program = WebGLUtil.createProgram(this.gl,vs,fs);
		this.gl.useProgram(program);
		var index = this.gl.getAttribLocation(program,"pos");
		this.gl.enableVertexAttribArray(index);
		this.gl.vertexAttribPointer(index,2,5126,false,0,0);
		this.gl.drawArrays(4,0,3);
	}
}
var WebGLUtil = function() { }
WebGLUtil.createShader = function(gl,shaderSource,type) {
	var shader = gl.createShader(type);
	gl.shaderSource(shader,shaderSource);
	gl.compileShader(shader);
	if(!gl.getShaderParameter(shader,35713)) throw gl.getShaderInfoLog(shader);
	return shader;
}
WebGLUtil.createProgram = function(gl,vertexSource,fragSource) {
	var program = gl.createProgram();
	var vshader = WebGLUtil.createShader(gl,vertexSource,35633);
	var fshader = WebGLUtil.createShader(gl,fragSource,35632);
	gl.attachShader(program,vshader);
	gl.attachShader(program,fshader);
	gl.linkProgram(program);
	if(!gl.getProgramParameter(program,35714)) throw gl.getProgramInfoLog(program);
	return program;
}
var js = {}
js.Browser = function() { }
js.html = {}
js.html._CanvasElement = {}
js.html._CanvasElement.CanvasUtil = function() { }
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
var $_, $fid = 0;
function $bind(o,m) { if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; };
js.Browser.window = typeof window != "undefined" ? window : null;
js.Browser.document = typeof window != "undefined" ? window.document : null;
MinimalDraw.main();
})();

//@ sourceMappingURL=minimaldraw.js.map