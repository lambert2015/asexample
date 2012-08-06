/// <summary>
/// This scene demonstrates the basic lighting shader.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
function BasicLightingScene ()
{
	/// <summary>
	/// Setup inherited members.
	/// </summary>
	BaseScene.call(this);
	
	
	/// <summary>
	/// Basic shader program.
	/// </summary>
	this.mBasicShader = null;
	
	
	/// <summary>
	/// Light sources.
	/// </summary>
	this.mLight = null;
}


/// <summary>
/// Prototypal Inheritance.
/// </summary>
BasicLightingScene.prototype = new BaseScene();
BasicLightingScene.prototype.constructor = BasicLightingScene;


/// <summary>
/// Implementation.
/// </summary>
BasicLightingScene.prototype.Start = function ()
{
	// Prepare resources to download
	this.mResource.Add(new ResourceItem("basic.vs", null, "./shaders/basic.vs"));
	this.mResource.Add(new ResourceItem("basic.fs", null, "./shaders/basic.fs"));
	
	// Create scene content
	var sphereMesh = new Sphere(32, 32, 1.0, 0.0);
	var sphereVbo = new GLVertexBufferObject();
	sphereVbo.Create(sphereMesh);
	
	var cubeMesh = new Cube(4.0, 4.0, 6.0);
	// Invert cube normals because we're inside the cube
	for (var i = 0; i < cubeMesh.Normal.length; ++i)
		cubeMesh.Normal[i] = -cubeMesh.Normal[i];
	var cubeVbo = new GLVertexBufferObject();
	cubeVbo.Create(cubeMesh);
	
	// Create a sphere entity
	var sphereEntity = new Entity();
	sphereEntity.ObjectEntity = sphereVbo;
	sphereEntity.ObjectMaterial.Specular.SetPoint(0.8, 0.8, 0.8);
	sphereEntity.ObjectMaterial.Shininess = 64;
	this.mEntity.push(sphereEntity);
	
	// Create a cube entity
	var cubeEntity = new Entity();
	cubeEntity.ObjectEntity = cubeVbo;
	this.mEntity.push(cubeEntity);
	
	// Setup light source
	this.mLight = new Light();
	this.mLight.Position.SetPoint(2.0, 2.0, 3.0);
	this.mLight.Attenuation.z = 0.01;
	
	// Setup spotlight. Uncomment the next two lines to enable spotlight
	//this.mLight.Direction = sphereEntity.ObjectMatrix.GetTranslation().Subtract(this.mLight.Position);
	//this.mLight.Direction.Normalize();
	this.mLight.SetCutoff(3.0);
	this.mLight.Exponent = 1.0;
	
	// Start downloading resources
	BaseScene.prototype.Start.call(this);
	
	// Set camera position
	this.mViewMatrix.PointAt(new Point(0.0, 1.0, 5.0), new Point());
	
	// Setup user interface
	var ambientRedSlider = $("#OARedSlider");
	ambientRedSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		max: 1.0,
		value: sphereEntity.ObjectMaterial.Ambient.x
	});
	ambientRedSlider.on("slide", {owner : this}, this.AmbientRedValueChanged);
	ambientRedSlider.on("slidechange", {owner : this}, this.AmbientRedValueChanged);
	
	var ambientGreenSlider = $("#OAGreenSlider");
	ambientGreenSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		max: 1.0,
		value: sphereEntity.ObjectMaterial.Ambient.y
	});
	ambientGreenSlider.on("slide", {owner : this}, this.AmbientGreenValueChanged);
	ambientGreenSlider.on("slidechange", {owner : this}, this.AmbientGreenValueChanged);
	
	var ambientBlueSlider = $("#OABlueSlider");
	ambientBlueSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		max: 1.0,
		value: sphereEntity.ObjectMaterial.Ambient.z
	});
	ambientBlueSlider.on("slide", {owner : this}, this.AmbientBlueValueChanged);
	ambientBlueSlider.on("slidechange", {owner : this}, this.AmbientBlueValueChanged);
	
	var diffuseRedSlider = $("#ODRedSlider");
	diffuseRedSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		max: 1.0,
		value: sphereEntity.ObjectMaterial.Diffuse.x
	});
	diffuseRedSlider.on("slide", {owner : this}, this.DiffuseRedValueChanged);
	diffuseRedSlider.on("slidechange", {owner : this}, this.DiffuseRedValueChanged);
	
	var diffuseGreenSlider = $("#ODGreenSlider");
	diffuseGreenSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		max: 1.0,
		value: sphereEntity.ObjectMaterial.Diffuse.y
	});
	diffuseGreenSlider.on("slide", {owner : this}, this.DiffuseGreenValueChanged);
	diffuseGreenSlider.on("slidechange", {owner : this}, this.DiffuseGreenValueChanged);
	
	var diffuseBlueSlider = $("#ODBlueSlider");
	diffuseBlueSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		max: 1.0,
		value: sphereEntity.ObjectMaterial.Diffuse.z
	});
	diffuseBlueSlider.on("slide", {owner : this}, this.DiffuseBlueValueChanged);
	diffuseBlueSlider.on("slidechange", {owner : this}, this.DiffuseBlueValueChanged);
	
	var specularRedSlider = $("#OSRedSlider");
	specularRedSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		max: 1.0,
		value: sphereEntity.ObjectMaterial.Specular.x
	});
	specularRedSlider.on("slide", {owner : this}, this.SpecularRedValueChanged);
	specularRedSlider.on("slidechange", {owner : this}, this.SpecularRedValueChanged);
	
	var specularGreenSlider = $("#OSGreenSlider");
	specularGreenSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		max: 1.0,
		value: sphereEntity.ObjectMaterial.Specular.y
	});
	specularGreenSlider.on("slide", {owner : this}, this.SpecularGreenValueChanged);
	specularGreenSlider.on("slidechange", {owner : this}, this.SpecularGreenValueChanged);
	
	var specularBlueSlider = $("#OSBlueSlider");
	specularBlueSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		max: 1.0,
		value: sphereEntity.ObjectMaterial.Specular.z
	});
	specularBlueSlider.on("slide", {owner : this}, this.SpecularBlueValueChanged);
	specularBlueSlider.on("slidechange", {owner : this}, this.SpecularBlueValueChanged);
	
	var shininessSlider = $("#OSValueSlider");
	shininessSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.1,
		min: 1.0,
		max: 100.0,
		value: sphereEntity.ObjectMaterial.Shininess
	});
	shininessSlider.on("slide", {owner : this}, this.ShininessValueChanged);
	shininessSlider.on("slidechange", {owner : this}, this.ShininessValueChanged);
	
	var lightRedSlider = $("#LCRedSlider");
	lightRedSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		max: 1.0,
		value: this.mLight.Colour.x
	});
	lightRedSlider.on("slide", {owner : this}, this.LightRedValueChanged);
	lightRedSlider.on("slidechange", {owner : this}, this.LightRedValueChanged);
	
	var lightGreenSlider = $("#LCGreenSlider");
	lightGreenSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		max: 1.0,
		value: this.mLight.Colour.y
	});
	lightGreenSlider.on("slide", {owner : this}, this.LightGreenValueChanged);
	lightGreenSlider.on("slidechange", {owner : this}, this.LightGreenValueChanged);
	
	var lightBlueSlider = $("#LCBlueSlider");
	lightBlueSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		max: 1.0,
		value: this.mLight.Colour.z
	});
	lightBlueSlider.on("slide", {owner : this}, this.LightBlueValueChanged);
	lightBlueSlider.on("slidechange", {owner : this}, this.LightBlueValueChanged);
	
	var lightAttenuationConstantSlider = $("#LAConstantSlider");
	lightAttenuationConstantSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		min: 0.5,
		max: 2.0,
		value: this.mLight.Attenuation.x
	});
	lightAttenuationConstantSlider.on("slide", {owner : this}, this.LightAttenuationContantValueChanged);
	lightAttenuationConstantSlider.on("slidechange", {owner : this}, this.LightAttenuationContantValueChanged);
	
	var lightAttenuationLinearSlider = $("#LALinearSlider");
	lightAttenuationLinearSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		max: 0.1,
		value: this.mLight.Attenuation.y
	});
	lightAttenuationLinearSlider.on("slide", {owner : this}, this.LightAttenuationLinearValueChanged);
	lightAttenuationLinearSlider.on("slidechange", {owner : this}, this.LightAttenuationLinearValueChanged);
	
	var lightAttenuationQuadraticSlider = $("#LAQuadraticSlider");
	lightAttenuationQuadraticSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		max: 0.1,
		value: this.mLight.Attenuation.z
	});
	lightAttenuationQuadraticSlider.on("slide", {owner : this}, this.LightAttenuationQuadraticValueChanged);
	lightAttenuationQuadraticSlider.on("slidechange", {owner : this}, this.LightAttenuationQuadraticValueChanged);
	
	$("#OARedSliderTxt").text(sphereEntity.ObjectMaterial.Ambient.x);
	$("#OAGreenSliderTxt").text(sphereEntity.ObjectMaterial.Ambient.y);
	$("#OABlueSliderTxt").text(sphereEntity.ObjectMaterial.Ambient.z);
	$("#ODRedSliderTxt").text(sphereEntity.ObjectMaterial.Diffuse.x);
	$("#ODGreenSliderTxt").text(sphereEntity.ObjectMaterial.Diffuse.y);
	$("#ODBlueSliderTxt").text(sphereEntity.ObjectMaterial.Diffuse.z);
	$("#OSRedSliderTxt").text(sphereEntity.ObjectMaterial.Specular.x);
	$("#OSGreenSliderTxt").text(sphereEntity.ObjectMaterial.Specular.y);
	$("#OSBlueSliderTxt").text(sphereEntity.ObjectMaterial.Specular.z);
	$("#OSValueSliderTxt").text(sphereEntity.ObjectMaterial.Shininess);
	$("#LCRedSliderTxt").text(this.mLight.Colour.x);
	$("#LCGreenSliderTxt").text(this.mLight.Colour.y);
	$("#LCBlueSliderTxt").text(this.mLight.Colour.z);
	$("#LAConstantSliderTxt").text(this.mLight.Attenuation.x);
	$("#LALinearSliderTxt").text(this.mLight.Attenuation.y);
	$("#LAQuadraticSliderTxt").text(this.mLight.Attenuation.z);
	
	var btnGouraudShading = document.getElementById("BtnGouraudShading");
	btnGouraudShading.onclick = this.OnBtnGouraudShadingClicked.bind(this);
	
	var btnPhongShading = document.getElementById("BtnPhongShading");
	btnPhongShading.onclick = this.OnBtnPhongShadingClicked.bind(this);
}


BasicLightingScene.prototype.AmbientRedValueChanged = function (event, ui)
{
	event.data.owner.mEntity[0].ObjectMaterial.Ambient.x = ui.value;
	$("#OARedSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.AmbientGreenValueChanged = function (event, ui)
{
	event.data.owner.mEntity[0].ObjectMaterial.Ambient.y = ui.value;
	$("#OAGreenSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.AmbientBlueValueChanged = function (event, ui)
{
	event.data.owner.mEntity[0].ObjectMaterial.Ambient.z = ui.value;
	$("#OABlueSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.DiffuseRedValueChanged = function (event, ui)
{
	event.data.owner.mEntity[0].ObjectMaterial.Diffuse.x = ui.value;
	$("#ODRedSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.DiffuseGreenValueChanged = function (event, ui)
{
	event.data.owner.mEntity[0].ObjectMaterial.Diffuse.y = ui.value;
	$("#ODGreenSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.DiffuseBlueValueChanged = function (event, ui)
{
	event.data.owner.mEntity[0].ObjectMaterial.Diffuse.z = ui.value;
	$("#ODBlueSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.SpecularRedValueChanged = function (event, ui)
{
	event.data.owner.mEntity[0].ObjectMaterial.Specular.x = ui.value;
	$("#OSRedSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.SpecularGreenValueChanged = function (event, ui)
{
	event.data.owner.mEntity[0].ObjectMaterial.Specular.y = ui.value;
	$("#OSGreenSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.SpecularBlueValueChanged = function (event, ui)
{
	event.data.owner.mEntity[0].ObjectMaterial.Specular.z = ui.value;
	$("#OSBlueSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.ShininessValueChanged = function (event, ui)
{
	event.data.owner.mEntity[0].ObjectMaterial.Shininess = ui.value;
	$("#OSValueSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.LightRedValueChanged = function (event, ui)
{
	event.data.owner.mLight.Colour.x = ui.value;
	$("#LCRedSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.LightGreenValueChanged = function (event, ui)
{
	event.data.owner.mLight.Colour.y = ui.value;
	$("#LCGreenSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.LightBlueValueChanged = function (event, ui)
{
	event.data.owner.mLight.Colour.z = ui.value;
	$("#LCBlueSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.LightAttenuationContantValueChanged = function (event, ui)
{
	event.data.owner.mLight.Attenuation.x = ui.value;
	$("#LAConstantSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.LightAttenuationLinearValueChanged = function (event, ui)
{
	event.data.owner.mLight.Attenuation.y = ui.value;
	$("#LALinearSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.LightAttenuationQuadraticValueChanged = function (event, ui)
{
	event.data.owner.mLight.Attenuation.z = ui.value;
	$("#LAQuadraticSliderTxt").text(ui.value);
}


BasicLightingScene.prototype.OnBtnGouraudShadingClicked = function (event)
{
	if ( this.mBasicShader )
		this.mBasicShader.ShadingType = 0;
}


BasicLightingScene.prototype.OnBtnPhongShadingClicked = function (event)
{
	if ( this.mBasicShader )
		this.mBasicShader.ShadingType = 1;
}


/// <summary>
/// Implementation.
/// </summary>
BasicLightingScene.prototype.Update = function ()
{
	BaseScene.prototype.Update.call(this);
	
	// Draw only when all resources have been downloaded
	if ( this.mBasicShader )
	{
		this.mBasicShader.Enable();
		
		for (var i = 0; i < this.mEntity.length; ++i)
			this.mBasicShader.Draw(this.mEntity[i]);
		
		this.mBasicShader.Disable();
	}
}


/// <summary>
/// Implementation.
/// </summary>
BasicLightingScene.prototype.End = function ()
{
	BaseScene.prototype.End.call(this);

	// Cleanup
	if ( this.mBasicShader )
	{
		this.mBasicShader.Release();
		this.mBasicShader = null;
	}
}



/// <summary>
/// Implementation.
/// </summary>
BasicLightingScene.prototype.OnLoadComplete = function ()
{
	// Process shaders
	var basicVs = this.mResource.Find("basic.vs");
	var basicFs = this.mResource.Find("basic.fs");
	
	if ( (basicVs == null) || (basicVs.Item == null) ||
		 (basicFs == null) || (basicFs.Item == null) )
	{
		// Resources missing?
	}
	else
	{
		// Load vertex shader
		var shaderVs = new GLShader();
		if ( !shaderVs.Create(shaderVs.ShaderType.Vertex, basicVs.Item) )
		{
			// Report error
			var log = shaderVs.GetLog();
			alert("Error compiling " + basicVs.Name + ".\n\n" + log);
		}
		else
			this.mShader.push(shaderVs);
		
		// Load fragment shader
		var shaderFs = new GLShader();
		if ( !shaderFs.Create(shaderFs.ShaderType.Fragment, basicFs.Item) )
		{
			// Report error
			var log = shaderFs.GetLog();
			alert("Error compiling " + basicFs.Name + ".\n\n" + log);
		}
		else
			this.mShader.push(shaderFs);
		
		// Create shader program
		this.mBasicShader = new BasicShader();
		this.mBasicShader.Projection = this.mProjectionMatrix;
		this.mBasicShader.View = this.mViewMatrix.Inverse();
		this.mBasicShader.LightObject.push(this.mLight);
		this.mBasicShader.Create();
		this.mBasicShader.AddShader(shaderVs);
		this.mBasicShader.AddShader(shaderFs);
		this.mBasicShader.Link();
		this.mBasicShader.Init();
	}
}