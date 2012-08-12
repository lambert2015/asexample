// The shadow map shader is a basic shader that also takes into account a depth map
// rendered from the light's point of view to determine if a pixel is in shadow.
function ShadowMapShader ()
{
	// Setup inherited members.
	BasicShader.call(this);
	
	// Shader variables.
	this.mLightSourceProjectionMatrixId;
	this.mLightSourceViewMatrixId;
	this.mDepthMapId;
	this.mDepthCubeMapId;
	this.mFilterTypeId;
	

	// View matrix at the light source. This is used only if the light source
	// is directional. Point light sources will calculate the 6 projection matrices
	// in realtime and check the cubemap.
	this.lightSourceProjectionMatrix;
	this.lightSourceViewMatrix;
	
	// Depth map texture to use. It may be 2D or cubemap. The shader will check the
	// light source type and assume the correct depth map was passed in. That is,
	// directional lights will use Texture2D and point lights will use TextureCube.
	this.depthMap;
	this.depthCubeMap;
	
	// Specifies the type of shadow map filtering to perform.
	// 0 = None
	// 1 = PCM
	// 2 = VSM
	// 3 = ESM
	this.filterType = 0;
}

// Prototypal Inheritance.
ShadowMapShader.prototype = new BasicShader();
ShadowMapShader.prototype.constructor = ShadowMapShader;

// Implementation.
ShadowMapShader.prototype.init = function ()
{
	BasicShader.prototype.init.call(this);
	
	// Get texture samples
	this.mDepthMapId = this.getVariable("u_depthMap");
	this.mDepthCubeMapId = this.getVariable("u_depthCubeMap");
	
	// Get matrices
	this.mLightSourceProjectionMatrixId = this.getVariable("u_lightSourceProjectionMatrix");
	this.mLightSourceViewMatrixId = this.getVariable("u_lightSourceViewMatrix");
	this.lightSourceViewMatrix = new Matrix(4, 4);
	
	// Get variables
	this.mFilterTypeId = this.getVariable("u_filterType");
}

// Implementation.
ShadowMapShader.prototype.enable = function ()
{
	BasicShader.prototype.enable.call(this);
	
	// Set light projection
	this.setMatrix(this.mLightSourceProjectionMatrixId, this.lightSourceProjectionMatrix.elements, 4);
	
	// Set variables
	this.setVariableInt(this.mFilterTypeId, this.filterType);
	
	// Set depth map sample
	gl.activeTexture(gl.TEXTURE0);
	if ( this.depthMap )
		this.depthMap.bind();
	else if ( this.depthCubeMap )
		this.depthCubeMap.bind();
}

// Implementation.
ShadowMapShader.prototype.draw = function (entity, numPoints, numIndices)
{
	// Matrices
	this.setMatrix(this.mLightSourceViewMatrixId, this.lightSourceViewMatrix.elements, 4);

	// Draw
	BasicShader.prototype.draw.call(this, entity, numPoints, numIndices);
}