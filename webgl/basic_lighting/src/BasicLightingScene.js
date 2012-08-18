// This scene demonstrates the basic lighting shader.
function BasicLightingScene() {
	// Setup inherited members.
	BaseScene.call(this);

	// Basic shader program.
	this.mBasicShader = null;

	// Light sources.
	this.mLight = null;
}

// Prototypal Inheritance.
BasicLightingScene.prototype = new BaseScene();
BasicLightingScene.prototype.constructor = BasicLightingScene;

// Implementation.
BasicLightingScene.prototype.start = function() {
	// Prepare resources to download
	this.mResource.add(new ResourceItem("basic.vs", null, "./shaders/basic.vs"));
	this.mResource.add(new ResourceItem("basic.fs", null, "./shaders/basic.fs"));

	// Create scene content
	var sphereMesh = new Sphere(32, 32, 1.0, 0.0);
	var sphereVbo = new GLVertexBufferObject();
	sphereVbo.create(sphereMesh);

	var cubeMesh = new Cube(4.0, 4.0, 6.0);
	// Invert cube normals because we're inside the cube
	for (var i = 0; i < cubeMesh.normals.length; ++i)
		cubeMesh.normals[i] = -cubeMesh.normals[i];
	var cubeVbo = new GLVertexBufferObject();
	cubeVbo.create(cubeMesh);

	// Create a sphere entity
	var sphereEntity = new Entity();
	sphereEntity.objectEntity = sphereVbo;
	sphereEntity.objectMaterial.specular.setPoint(0.8, 0.8, 0.8);
	sphereEntity.objectMaterial.shininess = 64;
	this.mEntity.push(sphereEntity);

	// Create a cube entity
	var cubeEntity = new Entity();
	cubeEntity.objectEntity = cubeVbo;
	this.mEntity.push(cubeEntity);

	// Setup light source
	this.mLight = new Light();
	this.mLight.position.setPoint(2.0, 2.0, 3.0);
	this.mLight.attenuation.z = 0.01;

	// Setup spotlight. Uncomment the next two lines to enable spotlight
	//this.mLight.Direction =
	// sphereEntity.objectMatrix.GetTranslation().Subtract(this.mLight.Position);
	//this.mLight.Direction.normalize();
	this.mLight.setCutoff(3.0);
	this.mLight.exponent = 1.0;

	// Start downloading resources
	BaseScene.prototype.start.call(this);

	// Set camera position
	this.mViewMatrix.pointAt(new Point(0.0, 1.0, 5.0), new Point());

	// Setup user interface
	var ambientRedSlider = $("#OARedSlider");
	ambientRedSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.01,
		max : 1.0,
		value : sphereEntity.objectMaterial.ambient.x
	});
	ambientRedSlider.on("slide", {
		owner : this
	}, this.ambientRedValueChanged);
	ambientRedSlider.on("slidechange", {
		owner : this
	}, this.ambientRedValueChanged);

	var ambientGreenSlider = $("#OAGreenSlider");
	ambientGreenSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.01,
		max : 1.0,
		value : sphereEntity.objectMaterial.ambient.y
	});
	ambientGreenSlider.on("slide", {
		owner : this
	}, this.ambientGreenValueChanged);
	ambientGreenSlider.on("slidechange", {
		owner : this
	}, this.ambientGreenValueChanged);

	var ambientBlueSlider = $("#OABlueSlider");
	ambientBlueSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.01,
		max : 1.0,
		value : sphereEntity.objectMaterial.ambient.z
	});
	ambientBlueSlider.on("slide", {
		owner : this
	}, this.ambientBlueValueChanged);
	ambientBlueSlider.on("slidechange", {
		owner : this
	}, this.ambientBlueValueChanged);

	var diffuseRedSlider = $("#ODRedSlider");
	diffuseRedSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.01,
		max : 1.0,
		value : sphereEntity.objectMaterial.diffuse.x
	});
	diffuseRedSlider.on("slide", {
		owner : this
	}, this.diffuseRedValueChanged);
	diffuseRedSlider.on("slidechange", {
		owner : this
	}, this.diffuseRedValueChanged);

	var diffuseGreenSlider = $("#ODGreenSlider");
	diffuseGreenSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.01,
		max : 1.0,
		value : sphereEntity.objectMaterial.diffuse.y
	});
	diffuseGreenSlider.on("slide", {
		owner : this
	}, this.diffuseGreenValueChanged);
	diffuseGreenSlider.on("slidechange", {
		owner : this
	}, this.diffuseGreenValueChanged);

	var diffuseBlueSlider = $("#ODBlueSlider");
	diffuseBlueSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.01,
		max : 1.0,
		value : sphereEntity.objectMaterial.diffuse.z
	});
	diffuseBlueSlider.on("slide", {
		owner : this
	}, this.diffuseBlueValueChanged);
	diffuseBlueSlider.on("slidechange", {
		owner : this
	}, this.diffuseBlueValueChanged);

	var specularRedSlider = $("#OSRedSlider");
	specularRedSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.01,
		max : 1.0,
		value : sphereEntity.objectMaterial.specular.x
	});
	specularRedSlider.on("slide", {
		owner : this
	}, this.specularRedValueChanged);
	specularRedSlider.on("slidechange", {
		owner : this
	}, this.specularRedValueChanged);

	var specularGreenSlider = $("#OSGreenSlider");
	specularGreenSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.01,
		max : 1.0,
		value : sphereEntity.objectMaterial.specular.y
	});
	specularGreenSlider.on("slide", {
		owner : this
	}, this.specularGreenValueChanged);
	specularGreenSlider.on("slidechange", {
		owner : this
	}, this.specularGreenValueChanged);

	var specularBlueSlider = $("#OSBlueSlider");
	specularBlueSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.01,
		max : 1.0,
		value : sphereEntity.objectMaterial.specular.z
	});
	specularBlueSlider.on("slide", {
		owner : this
	}, this.specularBlueValueChanged);
	specularBlueSlider.on("slidechange", {
		owner : this
	}, this.specularBlueValueChanged);

	var shininessSlider = $("#OSValueSlider");
	shininessSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.1,
		min : 1.0,
		max : 100.0,
		value : sphereEntity.objectMaterial.shininess
	});
	shininessSlider.on("slide", {
		owner : this
	}, this.shininessValueChanged);
	shininessSlider.on("slidechange", {
		owner : this
	}, this.shininessValueChanged);

	var lightRedSlider = $("#LCRedSlider");
	lightRedSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.01,
		max : 1.0,
		value : this.mLight.colour.x
	});
	lightRedSlider.on("slide", {
		owner : this
	}, this.lightRedValueChanged);
	lightRedSlider.on("slidechange", {
		owner : this
	}, this.lightRedValueChanged);

	var lightGreenSlider = $("#LCGreenSlider");
	lightGreenSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.01,
		max : 1.0,
		value : this.mLight.colour.y
	});
	lightGreenSlider.on("slide", {
		owner : this
	}, this.lightGreenValueChanged);
	lightGreenSlider.on("slidechange", {
		owner : this
	}, this.lightGreenValueChanged);

	var lightBlueSlider = $("#LCBlueSlider");
	lightBlueSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.01,
		max : 1.0,
		value : this.mLight.colour.z
	});
	lightBlueSlider.on("slide", {
		owner : this
	}, this.lightBlueValueChanged);
	lightBlueSlider.on("slidechange", {
		owner : this
	}, this.lightBlueValueChanged);

	var lightAttenuationConstantSlider = $("#LAConstantSlider");
	lightAttenuationConstantSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.01,
		min : 0.5,
		max : 2.0,
		value : this.mLight.attenuation.x
	});
	lightAttenuationConstantSlider.on("slide", {
		owner : this
	}, this.lightAttenuationContantValueChanged);
	lightAttenuationConstantSlider.on("slidechange", {
		owner : this
	}, this.lightAttenuationContantValueChanged);

	var lightAttenuationLinearSlider = $("#LALinearSlider");
	lightAttenuationLinearSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.01,
		max : 0.1,
		value : this.mLight.attenuation.y
	});
	lightAttenuationLinearSlider.on("slide", {
		owner : this
	}, this.lightAttenuationLinearValueChanged);
	lightAttenuationLinearSlider.on("slidechange", {
		owner : this
	}, this.lightAttenuationLinearValueChanged);

	var lightAttenuationQuadraticSlider = $("#LAQuadraticSlider");
	lightAttenuationQuadraticSlider.slider({
		animate : true,
		orientation : "horizontal",
		range : "min",
		step : 0.01,
		max : 0.1,
		value : this.mLight.attenuation.z
	});
	lightAttenuationQuadraticSlider.on("slide", {
		owner : this
	}, this.lightAttenuationQuadraticValueChanged);
	lightAttenuationQuadraticSlider.on("slidechange", {
		owner : this
	}, this.lightAttenuationQuadraticValueChanged);

	$("#OARedSliderTxt").text(sphereEntity.objectMaterial.ambient.x);
	$("#OAGreenSliderTxt").text(sphereEntity.objectMaterial.ambient.y);
	$("#OABlueSliderTxt").text(sphereEntity.objectMaterial.ambient.z);
	$("#ODRedSliderTxt").text(sphereEntity.objectMaterial.diffuse.x);
	$("#ODGreenSliderTxt").text(sphereEntity.objectMaterial.diffuse.y);
	$("#ODBlueSliderTxt").text(sphereEntity.objectMaterial.diffuse.z);
	$("#OSRedSliderTxt").text(sphereEntity.objectMaterial.specular.x);
	$("#OSGreenSliderTxt").text(sphereEntity.objectMaterial.specular.y);
	$("#OSBlueSliderTxt").text(sphereEntity.objectMaterial.specular.z);
	$("#OSValueSliderTxt").text(sphereEntity.objectMaterial.shininess);
	$("#LCRedSliderTxt").text(this.mLight.colour.x);
	$("#LCGreenSliderTxt").text(this.mLight.colour.y);
	$("#LCBlueSliderTxt").text(this.mLight.colour.z);
	$("#LAConstantSliderTxt").text(this.mLight.attenuation.x);
	$("#LALinearSliderTxt").text(this.mLight.attenuation.y);
	$("#LAQuadraticSliderTxt").text(this.mLight.attenuation.z);

	var btnGouraudShading = document.getElementById("BtnGouraudShading");
	btnGouraudShading.onclick = this.onBtnGouraudShadingClicked.bind(this);

	var btnPhongShading = document.getElementById("BtnPhongShading");
	btnPhongShading.onclick = this.onBtnPhongShadingClicked.bind(this);
}

BasicLightingScene.prototype.ambientRedValueChanged = function(event, ui) {
	event.data.owner.mEntity[0].objectMaterial.ambient.x = ui.value;
	$("#OARedSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.ambientGreenValueChanged = function(event, ui) {
	event.data.owner.mEntity[0].objectMaterial.ambient.y = ui.value;
	$("#OAGreenSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.ambientBlueValueChanged = function(event, ui) {
	event.data.owner.mEntity[0].objectMaterial.ambient.z = ui.value;
	$("#OABlueSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.diffuseRedValueChanged = function(event, ui) {
	event.data.owner.mEntity[0].objectMaterial.diffuse.x = ui.value;
	$("#ODRedSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.diffuseGreenValueChanged = function(event, ui) {
	event.data.owner.mEntity[0].objectMaterial.diffuse.y = ui.value;
	$("#ODGreenSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.diffuseBlueValueChanged = function(event, ui) {
	event.data.owner.mEntity[0].objectMaterial.diffuse.z = ui.value;
	$("#ODBlueSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.specularRedValueChanged = function(event, ui) {
	event.data.owner.mEntity[0].objectMaterial.specular.x = ui.value;
	$("#OSRedSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.specularGreenValueChanged = function(event, ui) {
	event.data.owner.mEntity[0].objectMaterial.specular.y = ui.value;
	$("#OSGreenSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.specularBlueValueChanged = function(event, ui) {
	event.data.owner.mEntity[0].objectMaterial.specular.z = ui.value;
	$("#OSBlueSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.shininessValueChanged = function(event, ui) {
	event.data.owner.mEntity[0].objectMaterial.shininess = ui.value;
	$("#OSValueSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.lightRedValueChanged = function(event, ui) {
	event.data.owner.mLight.colour.x = ui.value;
	$("#LCRedSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.lightGreenValueChanged = function(event, ui) {
	event.data.owner.mLight.colour.y = ui.value;
	$("#LCGreenSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.lightBlueValueChanged = function(event, ui) {
	event.data.owner.mLight.colour.z = ui.value;
	$("#LCBlueSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.lightAttenuationContantValueChanged = function(event, ui) {
	event.data.owner.mLight.attenuation.x = ui.value;
	$("#LAConstantSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.lightAttenuationLinearValueChanged = function(event, ui) {
	event.data.owner.mLight.attenuation.y = ui.value;
	$("#LALinearSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.lightAttenuationQuadraticValueChanged = function(event, ui) {
	event.data.owner.mLight.attenuation.z = ui.value;
	$("#LAQuadraticSliderTxt").text(ui.value);
}

BasicLightingScene.prototype.onBtnGouraudShadingClicked = function(event) {
	if (this.mBasicShader)
		this.mBasicShader.shadingType = 0;
}

BasicLightingScene.prototype.onBtnPhongShadingClicked = function(event) {
	if (this.mBasicShader)
		this.mBasicShader.shadingType = 1;
}
// Implementation.
BasicLightingScene.prototype.update = function() {
	BaseScene.prototype.update.call(this);

	// Draw only when all resources have been downloaded
	if (this.mBasicShader) {
		this.mBasicShader.enable();

		for (var i = 0; i < this.mEntity.length; ++i)
			this.mBasicShader.draw(this.mEntity[i]);

		this.mBasicShader.disable();
	}
}
// Implementation.
BasicLightingScene.prototype.end = function() {
	BaseScene.prototype.end.call(this);

	// Cleanup
	if (this.mBasicShader) {
		this.mBasicShader.release();
		this.mBasicShader = null;
	}
}
// Implementation.
BasicLightingScene.prototype.onLoadComplete = function() {
	// Process shaders
	var basicVs = this.mResource.find("basic.vs");
	var basicFs = this.mResource.find("basic.fs");

	if ((basicVs == null) || (basicVs.item == null) || (basicFs == null) || (basicFs.item == null)) {
		// Resources missing?
	} else {
		// Load vertex shader
		var shaderVs = new GLShader();
		if (!shaderVs.create(GLShader.ShaderType.Vertex, basicVs.item)) {
			// Report error
			var log = shaderVs.getLog();
			alert("Error compiling " + basicVs.name + ".\n\n" + log);
		} else
			this.mShader.push(shaderVs);

		// Load fragment shader
		var shaderFs = new GLShader();
		if (!shaderFs.create(GLShader.ShaderType.Fragment, basicFs.item)) {
			// Report error
			var log = shaderFs.getLog();
			alert("Error compiling " + basicFs.name + ".\n\n" + log);
		} else
			this.mShader.push(shaderFs);

		// Create shader program
		this.mBasicShader = new BasicShader();
		this.mBasicShader.projection = this.mProjectionMatrix;
		this.mBasicShader.view = this.mViewMatrix.inverse();
		this.mBasicShader.lightObject.push(this.mLight);
		this.mBasicShader.create();
		this.mBasicShader.addShader(shaderVs);
		this.mBasicShader.addShader(shaderFs);
		this.mBasicShader.link();
		this.mBasicShader.init();
	}
}