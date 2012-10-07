package three.renderers;

import js.Boot;
import js.Dom;
import js.Lib;
import three.core.BufferGeometry;
import three.core.Geometry;
import three.core.Face;
import three.core.Frustum;
import three.core.Face3;
import three.core.Face4;
import three.core.Object3D;
import three.core.BoundingBox;
import three.core.BoundingSphere;
import three.lights.Light;
import three.lights.DirectionalLight;
import three.lights.SpotLight;
import three.lights.PointLight;
import three.lights.AmbientLight;
import three.materials.Material;
import three.materials.MeshBasicMaterial;
import three.materials.MeshDepthMaterial;
import three.materials.MeshFaceMaterial;
import three.math.Color;
import three.math.Vector2;
import three.math.Vector3;
import three.math.Vector4;
import three.math.Matrix4;
import three.math.Matrix3;
import three.math.MathUtil;
import three.renderers.plugins.LensFlarePlugin;
import three.renderers.plugins.ShadowMapPlugin;
import three.renderers.plugins.SpritePlugin;
import three.scenes.Fog;
import three.scenes.FogExp2;
import three.scenes.IFog;
import three.scenes.Scene;
import three.objects.SkinnedMesh;
import three.objects.Mesh;
import three.objects.Line;
import three.objects.Ribbon;
import three.objects.ParticleSystem;
import three.objects.ImmediateRenderObject;
import three.objects.LensFlare;
import three.objects.Sprite;
import three.cameras.Camera;
import three.textures.Texture;
import three.materials.Material;
import three.materials.MeshBasicMaterial;
import three.materials.MeshLambertMaterial;
import three.materials.MeshNormalMaterial;
import three.materials.MeshPhongMaterial;
import three.materials.ShaderMaterial;
import three.materials.LineBasicMaterial;
import three.materials.CubeRefractionMapping;
import three.materials.*;
import three.textures.DataTexture;
import three.textures.Texture;
import three.ThreeGlobal;
import three.utils.Logger;
import three.utils.BoolUtil;
import UserAgentContext;
/**
 * ...
 * @author 
 */

class WebGLRenderer implements IRenderer
{
	public var domElement:Dynamic;
	public var gl:WebGLRenderingContext;

	// clearing

	public var autoClear:Bool;
	public var autoClearColor:Bool;
	public var autoClearDepth:Bool;
	public var autoClearStencil:Bool;

	// scene graph

	public var sortObjects:Bool;

	public var autoUpdateObjects:Bool;
	public var autoUpdateScene:Bool;

	// physically based shading

	public var gammaInput:Bool;
	public var gammaOutput:Bool;
	public var physicallyBasedShading:Bool;

	// shadow map

	public var shadowMapEnabled:Bool;
	public var shadowMapAutoUpdate:Bool;
	public var shadowMapSoft:Bool;
	public var shadowMapCullFrontFaces:Bool;
	public var shadowMapDebug:Bool;
	public var shadowMapCascade:Bool;

	// morphs

	public var maxMorphTargets:Int;
	public var maxMorphNormals:Int;

	// flags

	public var autoScaleCubemaps:Bool;

	// custom render plugins

	public var renderPluginsPre:Array<IPlugin>;
	public var renderPluginsPost:Array<IPlugin>;

	// info

	public var statistics:Statistics;
	
	private var _canvas:HTMLCanvasElement;
	
	private var _clearColor:Color;
	
	private var _precision:String;
	
	private var _alpha:Bool;
	
	private var _premultipliedAlpha:Bool;
	
	private var _antialias:Bool;
	
	private var _stencil:Bool;
	
	private var _preserveDrawingBuffer:Bool;
	
	private var _maxLights:Int;
	
	private var _frustum:Frustum;
	
	private var _projScreenMatrix:Matrix4;
	private var _projScreenMatrixPS:Matrix4;
	private var _vector3:Vector3;
	
	private var _direction:Vector3;
	
	private var _lightsNeedUpdate:Bool;
	private var _lights:LightsDef;
	
	private var shadowMapPlugin:ShadowMapPlugin;
	
	public function new(parameters:Dynamic = null) 
	{
		if (parameters == null)
			parameters = { };
			
		_canvas = parameters.canvas != null ? parameters.canvas : cast(Lib.document.createElement('canvas'),HTMLCanvasElement);

		_precision = parameters.precision != null ? parameters.precision : 'highp';

		_alpha = parameters.alpha != null ? parameters.alpha : true;
		_premultipliedAlpha = parameters.premultipliedAlpha != null ? parameters.premultipliedAlpha : true;
		_antialias = parameters.antialias != null ? parameters.antialias : false;
		_stencil = parameters.stencil != null ? parameters.stencil : true;
		_preserveDrawingBuffer = parameters.preserveDrawingBuffer != null ? parameters.preserveDrawingBuffer : false;

		_clearColor = parameters.clearColor != null ? new Color(parameters.clearColor) : new Color(0x00000000);

		_maxLights = parameters.maxLights != null ? parameters.maxLights : 4;
		
		// public properties

		this.domElement = _canvas;
		
		// clearing
		this.autoClear = true;
		this.autoClearColor = true;
		this.autoClearDepth = true;
		this.autoClearStencil = true;

		// scene graph
		this.sortObjects = true;

		this.autoUpdateObjects = true;
		this.autoUpdateScene = true;

		// physically based shading

		this.gammaInput = false;
		this.gammaOutput = false;
		this.physicallyBasedShading = false;

		// shadow map

		this.shadowMapEnabled = false;
		this.shadowMapAutoUpdate = true;
		this.shadowMapSoft = true;
		this.shadowMapCullFrontFaces = true;
		this.shadowMapDebug = false;
		this.shadowMapCascade = false;

		// morphs

		this.maxMorphTargets = 8;
		this.maxMorphNormals = 4;

		// flags

		this.autoScaleCubemaps = true;

		// custom render plugins

		this.renderPluginsPre = [];
		this.renderPluginsPost = [];

		// info

		this.statistics = new Statistics();

		// frustum
		_frustum = new Frustum();

		// camera matrices cache

		_projScreenMatrix = new Matrix4(); 
		_projScreenMatrixPS = new Matrix4(); 
		_vector3 = new Vector3();

		// light arrays cache

		_direction = new Vector3(); 
		_lightsNeedUpdate = true; 
		_lights = {

			ambient : [0, 0, 0],
			directional : {
				length : 0,
				colors : [],
				positions : []
			},
			point : {
				length : 0,
				colors : [],
				positions : [],
				distances : []
			},
			spot : {
				length : 0,
				colors : [],
				positions : [],
				distances : [],
				directions : [],
				angles : [],
				exponents : []
			}
		};

		// initialize
		initGL();

		setDefaultGLState();

		// GPU capabilities

		_maxVertexTextures = gl.getParameter(gl.MAX_VERTEX_TEXTURE_IMAGE_UNITS);
		_maxTextureSize = gl.getParameter(gl.MAX_TEXTURE_SIZE); 
		_maxCubemapSize = gl.getParameter(gl.MAX_CUBE_MAP_TEXTURE_SIZE);

		_maxAnisotropy = _glExtensionTextureFilterAnisotropic != null ? gl.getParameter(_glExtensionTextureFilterAnisotropic.MAX_TEXTURE_MAX_ANISOTROPY_EXT) : 0;

		_supportsVertexTextures = (_maxVertexTextures > 0 );
		_supportsBoneTextures = _supportsVertexTextures && _glExtensionTextureFloat;
		
		
		// default plugins (order is important)
		this.shadowMapPlugin = new ShadowMapPlugin();
		this.addPrePlugin(this.shadowMapPlugin);
		
		this.addPostPlugin(new SpritePlugin());
		this.addPostPlugin(new LensFlarePlugin());
	}
	
	private var _glExtensionTextureFloat:Bool;
	private var _glExtensionStandardDerivatives:Bool;
	private var _glExtensionTextureFilterAnisotropic:Dynamic;
	
	private var _maxVertexTextures:Int;
	private var _maxTextureSize:Int;
	private var _maxCubemapSize:Int;
	
	private var _maxAnisotropy:Int;
	private var _supportsVertexTextures:Bool;
	private var _supportsBoneTextures:Bool;
	
	private var _currentCamera:Camera;
	public function renderPlugins(plugins:Array<IPlugin>, scene:Scene, camera:Camera):Void
	{
		if (plugins.length == 0)
			return;

		for (i in 0...plugins.length) 
		{
			// reset state for plugin (to start from clean slate)
			_currentProgram = null;
			_currentCamera = null;

			_oldBlending = -1;
			_oldDepthTest = false;
			_oldDepthWrite = false;
			_oldDoubleSided = false;
			_oldFlipSided = false;
			_currentGeometryGroupHash = -1;
			_currentMaterialId = -1;

			_lightsNeedUpdate = true;

			plugins[i].render(scene, camera, _currentWidth, _currentHeight);

			// reset state after plugin (anything could have changed)

			_currentProgram = null;
			_currentCamera = null;

			_oldBlending = -1;
			_oldDepthTest = false;
			_oldDepthWrite = false;
			_oldDoubleSided = false;
			_oldFlipSided = false;
			_currentGeometryGroupHash = -1;
			_currentMaterialId = -1;

			_lightsNeedUpdate = true;

		}
	}
	
	public function render(scene:Scene, camera:Camera, renderTarget:WebGLRenderTarget, forceClear:Bool = false):Void
	{
		var webglObject; 
		var object:Object3D; 
		var renderList; 
		var lights:Array<Light> = scene.__lights; 
		var fog:IFog = scene.fog;

		// reset caching for this frame

		_currentMaterialId = -1;
		_lightsNeedUpdate = true;

		// update scene graph

		if (this.autoUpdateScene)
			scene.updateMatrixWorld();

		// update camera matrices and frustum

		if (camera.parent == null)
			camera.updateMatrixWorld();

		if (camera._viewMatrixArray == null)
			camera._viewMatrixArray = new Float32Array(16);
		if (camera._projectionMatrixArray == null)
			camera._projectionMatrixArray = new Float32Array(16);

		camera.matrixWorldInverse.getInverse(camera.matrixWorld);

		camera.matrixWorldInverse.flattenToArray(camera._viewMatrixArray);
		camera.projectionMatrix.flattenToArray(camera._projectionMatrixArray);

		_projScreenMatrix.multiply(camera.projectionMatrix, camera.matrixWorldInverse);
		_frustum.setFromMatrix(_projScreenMatrix);

		// update WebGL objects

		if (this.autoUpdateObjects)
			this.initWebGLObjects(scene);

		// custom render plugins (pre pass)

		renderPlugins(this.renderPluginsPre, scene, camera);

		//

		this.statistics.resetRender();

		this.setRenderTarget(renderTarget);

		if (this.autoClear || forceClear) 
		{
			this.clear(this.autoClearColor, this.autoClearDepth, this.autoClearStencil);
		}

		// set matrices for regular objects (frustum culled)

		renderList = scene.__webglObjects;

		for ( i in 0...renderList.length) 
		{
			webglObject = renderList[i];
			object = webglObject.object;

			webglObject.render = false;

			if (object.visible) 
			{
				if (!(Std.is(object, Mesh) || Std.is(object, ParticleSystem)) || 
					!(object.frustumCulled ) || 
					_frustum.contains(object)) 
				{

					//object.matrixWorld.flattenToArray( object._modelMatrixArray );
					setupMatrices(object, camera);

					unrollBufferMaterial(webglObject);

					webglObject.render = true;

					if (this.sortObjects) 
					{
						if (object.renderDepth != 0) 
						{
							webglObject.z = object.renderDepth;
						}
						else 
						{
							_vector3.copy(object.matrixWorld.getPosition());
							_projScreenMatrix.multiplyVector3(_vector3);

							webglObject.z = _vector3.z;
						}
					}
				}
			}
		}

		if (this.sortObjects) 
		{
			renderList.sort(painterSort);
		}

		// set matrices for immediate objects

		renderList = scene.__webglObjectsImmediate;

		for ( i in 0...renderList.length) 
		{
			webglObject = renderList[i];
			object = webglObject.object;

			if (object.visible) 
			{
				/*
				 if ( object.matrixAutoUpdate ) {

				 object.matrixWorld.flattenToArray( object._modelMatrixArray );

				 }
				 */

				setupMatrices(object, camera);

				unrollImmediateBufferMaterial(webglObject);
			}
		}

		if (scene.overrideMaterial) 
		{
			var material = scene.overrideMaterial;

			this.setBlending(material.blending, material.blendEquation, material.blendSrc, material.blendDst);
			this.setDepthTest(material.depthTest);
			this.setDepthWrite(material.depthWrite);
			setPolygonOffset(material.polygonOffset, material.polygonOffsetFactor, material.polygonOffsetUnits);

			renderObjects(scene.__webglObjects, false, "", camera, lights, fog, true, material);
			renderObjectsImmediate(scene.__webglObjectsImmediate, "", camera, lights, fog, false, material);

		} 
		else 
		{
			// opaque pass (front-to-back order)

			this.setBlending(ThreeGlobal.NormalBlending);

			renderObjects(scene.__webglObjects, true, "opaque", camera, lights, fog, false);
			renderObjectsImmediate(scene.__webglObjectsImmediate, "opaque", camera, lights, fog, false);

			// transparent pass (back-to-front order)

			renderObjects(scene.__webglObjects, false, "transparent", camera, lights, fog, true);
			renderObjectsImmediate(scene.__webglObjectsImmediate, "transparent", camera, lights, fog, true);
		}

		// custom render plugins (post pass)

		renderPlugins(this.renderPluginsPost, scene, camera);

		// Generate mipmap if we're using any kind of mipmap filtering

		if (renderTarget != null && 
			renderTarget.generateMipmaps && 
			renderTarget.minFilter != ThreeGlobal.NearestFilter && 
			renderTarget.minFilter != ThreeGlobal.LinearFilter) 
		{
			updateRenderTargetMipmap(renderTarget);
		}

		// Ensure depth buffer writing is enabled so it can be cleared on next render
		this.setDepthTest(true);
		this.setDepthWrite(true);

		//gl.finish();
	}
	
	private function renderObjects(renderList, reverse, materialType, 
								camera, lights, fog, 
								useBlending:Bool, overrideMaterial:Material):Void 
	{

		var webglObject, object, buffer, start, end, delta;
		var material:Material;

		if (reverse) 
		{
			start = renderList.length - 1;
			end = -1;
			delta = -1;
		} 
		else 
		{
			start = 0;
			end = renderList.length;
			delta = 1;
		}

		var i:Int = start;
		while (i != end)
		{
			webglObject = renderList[i];
			
			i += delta;

			if (webglObject.render) 
			{
				object = webglObject.object;
				buffer = webglObject.buffer;

				if (overrideMaterial != null) 
				{
					material = overrideMaterial;
				} 
				else 
				{
					material = untyped webglObject[materialType];

					if (material == null)
						continue;

					if (useBlending)
						this.setBlending(material.blending, material.blendEquation, material.blendSrc, material.blendDst);

					this.setDepthTest(material.depthTest);
					this.setDepthWrite(material.depthWrite);
					setPolygonOffset(material.polygonOffset, material.polygonOffsetFactor, material.polygonOffsetUnits);

				}

				this.setMaterialFaces(material);

				if ( Std.is(buffer, BufferGeometry)) 
				{
					this.renderBufferDirect(camera, lights, fog, material, buffer, object);
				} 
				else 
				{
					this.renderBuffer(camera, lights, fog, material, buffer, object);
				}
			}
		}
	}

	private function renderObjectsImmediate(renderList, materialType, camera, lights, fog, useBlending, overrideMaterial) 
	{
		var webglObject;
		var object:Object3D; 
		var material:Material; 
		var program;

		for (i in 0...renderList.length) 
		{
			webglObject = renderList[i];
			object = webglObject.object;

			if (object.visible) 
			{
				if (overrideMaterial != null) 
				{
					material = overrideMaterial;
				} 
				else
				{
					material = webglObject[materialType];

					if (!material)
						continue;

					if (useBlending)
						this.setBlending(material.blending, material.blendEquation, material.blendSrc, material.blendDst);

					this.setDepthTest(material.depthTest);
					this.setDepthWrite(material.depthWrite);
					setPolygonOffset(material.polygonOffset, material.polygonOffsetFactor, material.polygonOffsetUnits);
				}
				this.renderImmediateObject(camera, lights, fog, material, object);
			}
		}
	}

	private function renderImmediateObject(camera:Camera, lights:Array<Light>, fog:IFog, material:Material, object:Object3D):Void 
	{
		var program:Program3D = setProgram(camera, lights, fog, material, object);

		_currentGeometryGroupHash = -1;

		this.setMaterialFaces(material);

		if (object.immediateRenderCallback != null) 
		{
			object.immediateRenderCallback(program, gl, _frustum);
		} 
		else 
		{
			object.render(function(object) {
				this.renderBufferImmediate(object, program, material);
			});
		}
	}

	private function unrollImmediateBufferMaterial(globject):Void 
	{
		var object = globject.object;
		var material:Material = object.material;

		if (material.transparent) 
		{
			globject.transparent = material;
			globject.opaque = null;
		} 
		else 
		{
			globject.opaque = material;
			globject.transparent = null;
		}
	}

	private function unrollBufferMaterial(globject):Void
	{
		var object = globject.object, buffer = globject.buffer, material, materialIndex, meshMaterial;

		meshMaterial = object.material;

		if ( Std.is(meshMaterial,MeshFaceMaterial)) 
		{
			materialIndex = buffer.materialIndex;

			if (materialIndex >= 0) 
			{
				material = object.geometry.materials[materialIndex];
				if (material.transparent) 
				{
					globject.transparent = material;
					globject.opaque = null;
				} 
				else
				{
					globject.opaque = material;
					globject.transparent = null;
				}
			}
		} 
		else 
		{
			material = meshMaterial;

			if (material) 
			{
				if (material.transparent) 
				{
					globject.transparent = material;
					globject.opaque = null;
				} 
				else 
				{
					globject.opaque = material;
					globject.transparent = null;
				}
			}
		}
	}

	// Geometry splitting

	private function sortFacesByMaterial(geometry:Geometry):Void 
	{
		var face:Face;
		var materialIndex:Int = -1;
		var vertices:Int; 
		var materialHash:Int;
		var groupHash:String;
		var hash_map:Dynamic = { };

		var numMorphTargets = geometry.morphTargets.length;
		var numMorphNormals = geometry.morphNormals.length;

		geometry.geometryGroups = {};

		for ( f in 0...geometry.faces.length) 
		{
			face = geometry.faces[f];
			materialIndex = face.materialIndex;

			materialHash = materialIndex;

			if (untyped hash_map[materialHash] == null) 
			{
				untyped hash_map[materialHash] = {
					'hash' : materialHash,
					'counter' : 0
				};
			}

			groupHash = hash_map[materialHash].hash + '_' + hash_map[materialHash].counter;

			if (untyped geometry.geometryGroups[groupHash] == null) {

				untyped geometry.geometryGroups[groupHash] = {
					'faces3' : [],
					'faces4' : [],
					'materialIndex' : materialIndex,
					'vertices' : 0,
					'numMorphTargets' : numMorphTargets,
					'numMorphNormals' : numMorphNormals
				};

			}

			vertices = Std.is(face,Face3) ? 3 : 4;

			if (untyped geometry.geometryGroups[groupHash].vertices + vertices > 65535) 
			{
				hash_map[materialHash].counter += 1;
				groupHash = hash_map[materialHash].hash + '_' + hash_map[materialHash].counter;

				if (untyped geometry.geometryGroups[groupHash] == null) 
				{
					untyped geometry.geometryGroups[groupHash] = {
						'faces3' : [],
						'faces4' : [],
						'materialIndex' : materialIndex,
						'vertices' : 0,
						'numMorphTargets' : numMorphTargets,
						'numMorphNormals' : numMorphNormals
					};
				}
			}

			if ( Std.is(face,Face3)) 
			{
				untyped geometry.geometryGroups[groupHash].faces3.push(f);
			} 
			else 
			{
				untyped geometry.geometryGroups[groupHash].faces4.push(f);
			}

			untyped geometry.geometryGroups[groupHash].vertices += vertices;

		}

		geometry.geometryGroupsList = [];

		var fields:Array<String> = Type.getClassFields(geometry.geometryGroups);
		for (g in fields ) 
		{
			untyped geometry.geometryGroups[g].id = _geometryGroupCounter++;
			geometry.geometryGroupsList.push(untyped geometry.geometryGroups[g]);
		}
	}

	
	public function setMaterialShaders(material:Material, shaders:ShaderDef):Void
	{
		material.uniforms = UniformsUtils.clone(shaders.uniforms);
		material.vertexShader = shaders.vertexShader;
		material.fragmentShader = shaders.fragmentShader;
	}

	public function setProgram(camera:Camera, lights:Array<Light>, fog:Fog, material:Material, object:Dynamic):Program3D
	{
		if (material.needsUpdate) 
		{
			if (material.program != null)
				this.deallocateMaterial(material);

			this.initMaterial(material, lights, fog, object);
			material.needsUpdate = false;
		}

		if (material.morphTargets != null) 
		{
			if (object.__webglMorphTargetInfluences == null) 
			{
				object.__webglMorphTargetInfluences = new Float32Array(this.maxMorphTargets);
			}
		}

		var refreshMaterial:Bool = false;

		var program:Program3D = material.program, 
		p_uniforms:Dynamic = program.uniforms, 
		m_uniforms:Dynamic = material.uniforms;

		if (program != _currentProgram) 
		{
			gl.useProgram(program.program);
			_currentProgram = program;
			refreshMaterial = true;
		}

		if (material.id != _currentMaterialId) 
		{
			_currentMaterialId = material.id;
			refreshMaterial = true;
		}

		if (refreshMaterial || camera != _currentCamera) 
		{
			gl.uniformMatrix4fv(p_uniforms.projectionMatrix, false, camera._projectionMatrixArray);

			if (camera != _currentCamera)
				_currentCamera = camera;

		}

		if (refreshMaterial) 
		{
			// refresh uniforms common to several materials
			if (fog != null && material.fog != null) 
			{
				refreshUniformsFog(m_uniforms, fog);
			}

			if ( Std.is(material, MeshPhongMaterial) || 
				Std.is(material, MeshLambertMaterial) || 
				material.lights != null) 
			{
				if (_lightsNeedUpdate) 
				{
					setupLights(program, lights);
					_lightsNeedUpdate = false;
				}

				refreshUniformsLights(m_uniforms, _lights);
			}

			if ( Std.is(material,MeshBasicMaterial) || 
				Std.is(material,MeshLambertMaterial) || 
				Std.is(material,MeshPhongMaterial) )
			{
				refreshUniformsCommon(m_uniforms, material);
			}

			// refresh single material specific uniforms

			if ( Std.is(material, LineBasicMaterial)) 
			{
				refreshUniformsLine(m_uniforms, material);
			} 
			else if ( Std.is(material,ParticleBasicMaterial)) 
			{
				refreshUniformsParticle(m_uniforms, material);
			} 
			else if ( Std.is(material,MeshPhongMaterial)) 
			{
				refreshUniformsPhong(m_uniforms, material);
			} 
			else if ( Std.is(material,MeshLambertMaterial))
			{
				refreshUniformsLambert(m_uniforms, material);
			} 
			else if ( Std.is(material,MeshDepthMaterial)) 
			{
				m_uniforms.mNear.value = camera.near;
				m_uniforms.mFar.value = camera.far;
				m_uniforms.opacity.value = material.opacity;
			} 
			else if ( Std.is(material,MeshNormalMaterial)) 
			{
				m_uniforms.opacity.value = material.opacity;
			}

			if (object.receiveShadow && !material._shadowPass) 
			{
				refreshUniformsShadow(m_uniforms, lights);
			}

			// load common uniforms

			loadUniformsGeneric(program, material.uniformsList);

			// load material specific uniforms
			// (shader material also gets them for the sake of genericity)

			if ( Std.is(material, ShaderMaterial) || 
				Std.is(material,MeshPhongMaterial) || 
				material.envMap != null) 
			{
				if (p_uniforms.cameraPosition != null) 
				{
					var position:Vector3 = camera.matrixWorld.getPosition();
					gl.uniform3f(p_uniforms.cameraPosition, position.x, position.y, position.z);
				}
			}

			if ( Std.is(material, MeshPhongMaterial) || 
				Std.is(material,MeshLambertMaterial) || 
				Std.is(material,ShaderMaterial) || 
				material.skinning) 
			{
				if (p_uniforms.viewMatrix != null) 
				{
					gl.uniformMatrix4fv(p_uniforms.viewMatrix, false, camera._viewMatrixArray);
				}
			}

		}

		if (material.skinning) 
		{
			if (_supportsBoneTextures && object.useVertexTexture) 
			{
				if (p_uniforms.boneTexture != null) 
				{
					// shadowMap texture array starts from 6
					// texture unit 12 should leave space for 6 shadowmaps
					var textureUnit:Int = 12;
					gl.uniform1i(p_uniforms.boneTexture, textureUnit);
					this.setTexture(object.boneTexture, textureUnit);
				}
			} 
			else 
			{
				if (p_uniforms.boneGlobalMatrices != null) 
				{
					gl.uniformMatrix4fv(p_uniforms.boneGlobalMatrices, false, object.boneMatrices);
				}
			}

		}

		loadUniformsMatrices(p_uniforms, object);

		if (p_uniforms.modelMatrix != null) 
		{
			gl.uniformMatrix4fv(p_uniforms.modelMatrix, false, object.matrixWorld.elements);
		}

		return program;

	}
	
	public function allocateBones(object:Dynamic):Int
	{
		if (_supportsBoneTextures && object != null && object.useVertexTexture)
		{
			return 1024;
		}
		else
		{
			// default for when object is not specified
			// ( for example when prebuilding shader
			//   to be used with multiple objects )
			//
			// 	- leave some extra space for other uniforms
			//  - limit here is ANGLE's 254 max uniform vectors
			//    (up to 54 should be safe)

			var nVertexUniforms:Int = gl.getParameter(gl.MAX_VERTEX_UNIFORM_VECTORS);
			var nVertexMatrices:Int = Math.floor((nVertexUniforms - 20 ) / 4);

			var maxBones:Int = nVertexMatrices;

			if (object != null && Std.is(object,SkinnedMesh)) 
			{
				var skinnedMesh:SkinnedMesh = cast(object, SkinnedMesh);
				maxBones = Std.int(Math.min(skinnedMesh.bones.length, maxBones));
				if (maxBones < skinnedMesh.bones.length) 
				{
					Logger.warn("WebGLRenderer: too many bones - " + skinnedMesh.bones.length + ", this GPU supports just " + maxBones + " (try OpenGL instead of ANGLE)");
				}
			}
			return maxBones;
		}
	}
	public function allocateLights(lights:Array<Light>):Dynamic
	{
		var light:Light;
		var pointLights:Int;
		var spotLights:Int;
		var dirLights:Int;
		var maxDirLights:Int;
		var maxPointLights:Int;
		var maxSpotLights:Int;
		
		dirLights = pointLights = spotLights = maxDirLights = maxPointLights = maxSpotLights = 0;
		
		for ( i in 0...lights.length)
		{
			light = lights[i];
			
			if (light.onlyShadow)
				continue;
				
			if (Std.is(light, DirectionalLight))
			{
				dirLights++;
			}
			else if (Std.is(light, PointLight))
			{
				pointLights++;
			}
			else if (Std.is(light, SpotLight))
			{
				spotLights++;
			}
		}
		
		if (pointLights + spotLights + dirLights <= _maxLights)
		{
			maxDirLights = dirLights;
			maxPointLights = pointLights;
			maxSpotLights = spotLights;
		}
		else
		{
			// this is not really correct
			maxDirLights = Math.ceil(_maxLights * dirLights / (pointLights + dirLights));
			maxPointLights = _maxLights - maxDirLights;
			maxSpotLights = maxPointLights;
		}
		
		return {
			'directional' : maxDirLights,
			'point' : maxPointLights,
			'spot' : maxSpotLights
		};
	}
	
	public function allocateShadows(lights:Array<Light>):Int 
	{
		var light:Light; 
		var maxShadows:Int = 0;

		for ( l in 0...lights.length) 
		{
			light = lights[l];

			if (!light.castShadow)
				continue;

			if ( Std.is(light,SpotLight))
				maxShadows++;
				
			if ( Std.is(light,DirectionalLight) && !cast(light,DirectionalLight).shadowCascade)
				maxShadows++;
		}

		return maxShadows;
	}
	
	public function initGL():Void
	{
		try 
		{
			 gl = cast(_canvas.getContext('experimental-webgl', 
							{
								alpha : _alpha,
								premultipliedAlpha : _premultipliedAlpha,
								antialias : _antialias,
								stencil : _stencil,
								preserveDrawingBuffer : _preserveDrawingBuffer
							}), WebGLRenderingContext);
			
			ThreeGlobal.gl = gl;

			if (gl != null) 
			{
				throw 'Error creating WebGL context.';
			}

		} catch ( error:String ) 
		{
			//console.error(error);
		}

		_glExtensionTextureFloat = cast(gl.getExtension('OES_texture_float'),Bool);
		_glExtensionStandardDerivatives = cast(gl.getExtension('OES_standard_derivatives'),Bool);

		if (gl.getExtension('EXT_texture_filter_anisotropic') != null)
		{
			_glExtensionTextureFilterAnisotropic = gl.getExtension('EXT_texture_filter_anisotropic');
		}
		else if (gl.getExtension('MOZ_EXT_texture_filter_anisotropic') != null)
		{
			_glExtensionTextureFilterAnisotropic = gl.getExtension('MOZ_EXT_texture_filter_anisotropic');
		}
		else if (gl.getExtension('MOZ_EXT_texture_filter_anisotropic') != null)
		{
			_glExtensionTextureFilterAnisotropic = gl.getExtension('WEBKIT_EXT_texture_filter_anisotropic');
		}

		if (!_glExtensionTextureFloat) 
		{
			Logger.log('WebGLRenderer: Float textures not supported.');
		}

		if (!_glExtensionStandardDerivatives) 
		{
			Logger.log('WebGLRenderer: Standard derivatives not supported.');
		}

		if (!_glExtensionTextureFilterAnisotropic) 
		{
			Logger.log('WebGLRenderer: Anisotropic texture filtering not supported.');
		}
	}
	
	public function setDefaultGLState():Void
	{
		gl.clearColor(0, 0, 0, 1);
		gl.clearDepth(1);
		gl.clearStencil(0);

		gl.enable(gl.DEPTH_TEST);
		gl.depthFunc(gl.LEQUAL);

		gl.frontFace(gl.CCW);
		gl.cullFace(gl.BACK);
		gl.enable(gl.CULL_FACE);

		gl.enable(gl.BLEND);
		gl.blendEquation(gl.FUNC_ADD);
		gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);

		gl.clearColor(_clearColor.r, _clearColor.g, _clearColor.b, _clearColor.a);
	}
	
	public function supportsVertexTextures():Bool
	{
		return _supportsVertexTextures;
	}
	
	public function getMaxAnisotropy():Int
	{
		return _maxAnisotropy;
	}
	
	public function setSize(width:Int, height:Int):Void
	{
		_canvas.width = width;
		_canvas.height = height;
		
		setViewport(0, 0, _canvas.width, _canvas.height);
	}
	
	private var _viewportX:Int;
	private var _viewportY:Int;
	private var _viewportWidth:Int;
	private var _viewportHeight:Int;
	public function setViewport(x:Int, y:Int, width:Int, height:Int):Void
	{
		_viewportX = x;
		_viewportY = y;
		_viewportWidth = width;
		_viewportHeight = height;
		
		gl.viewport(_viewportX, _viewportY, _viewportWidth, _viewportHeight);
	}
	
	public function setScissor(x:Int, y:Int, width:Int, height:Int):Void
	{
		gl.scissor(x, y, width, height);
	}
	
	public function enableScissorTest(enable:Bool):Void
	{
		if (enable)
		{
			gl.enable(gl.SCISSOR_TEST);
		}
		else
		{
			gl.disable(gl.SCISSOR_TEST);
		}
	}
	
	public function setClearColor(color:Int):Void
	{
		_clearColor.setRGBA(color);
		
		gl.clearColor(_clearColor.r, _clearColor.g, _clearColor.b, _clearColor.a);
	}
	
	public function getClearColor():Color
	{
		return _clearColor;
	}
	
	public function clear(color:Bool, depth:Bool, stencil:Bool):Void
	{
		var bits:Int = 0;
		
		if (color)
			bits |= gl.COLOR_BUFFER_BIT;
		if (depth)
			bits |= gl.DEPTH_BUFFER_BIT;
		if (stencil)
			bits |= gl.STENCIL_BUFFER_BIT;
		
		gl.clear(bits);
	}
	
	public function clearTarget(renderTarget:WebGLRenderTarget, color:Bool, depth:Bool, stencil:Bool):Void
	{
		this.setRenderTarget(renderTarget);
		this.clear(color, depth, stencil);
	}
	
	private var _currentFramebuffer:WebGLFramebuffer;
	private var _currentWidth:Int;
	private var _currentHeight:Int;
	public function setRenderTarget(renderTarget:WebGLRenderTarget):Void
	{
		if (renderTarget == null)
			return;	
		var isCube:Bool = Std.is(renderTarget, WebGLRenderTargetCube);
		
		if (renderTarget != null && renderTarget.__webglFramebuffer == null)
		{
			renderTarget.depthBuffer = true;
			renderTarget.stencilBuffer = true;
			
			renderTarget.__webglTexture = gl.createTexture();
			
			// Setup texture, create render and frame buffers
			var isTargetPowerOfTwo = MathUtil.isPow2(renderTarget.width) &&
									MathUtil.isPow2(renderTarget.height);
			var glFormat:GLenum = ThreeGlobal.paramThreeToGL(renderTarget.format);
			var glType:GLenum = ThreeGlobal.paramThreeToGL(renderTarget.type);
			
			if (isCube)
			{
				renderTarget.__webglFramebuffer = [];
				renderTarget.__webglRenderbuffer = [];
				
				gl.bindTexture(gl.TEXTURE_CUBE_MAP, renderTarget.__webglTexture);
				setTextureParameters(gl.TEXTURE_CUBE_MAP, renderTarget, isTargetPowerOfTwo);
				
				for (i in 0...6)
				{
					renderTarget.__webglFramebuffer[i] = gl.createFramebuffer();
					renderTarget.__webglRenderbuffer[i] = gl.createRenderbuffer();
					
					gl.texImage2D(gl.TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, glFormat, renderTarget.width, renderTarget.height, 0, glFormat, glType, null);
					
					setupFrameBuffer(renderTarget.__webglFramebuffer[i], renderTarget, gl.TEXTURE_CUBE_MAP_POSITIVE_X + i);
					setupRenderBuffer(renderTarget.__webglRenderbuffer[i], renderTarget);
				}
				
				if (isTargetPowerOfTwo)
					gl.generateMipmap(gl.TEXTURE_CUBE_MAP);
			}
			else
			{
				renderTarget.__webglFramebuffer[0] = gl.createFramebuffer();
				renderTarget.__webglRenderbuffer[0] = gl.createRenderbuffer();
				
				gl.bindTexture(gl.TEXTURE_2D, renderTarget.__webglTexture);
				setTextureParameters(gl.TEXTURE_2D, renderTarget, isTargetPowerOfTwo);
				
				gl.texImage2D(gl.TEXTURE_2D, 0, glFormat, renderTarget.width, renderTarget.height, 0, glFormat, glType, null);

				setupFrameBuffer(renderTarget.__webglFramebuffer[0], renderTarget, gl.TEXTURE_2D);
				setupRenderBuffer(renderTarget.__webglRenderbuffer[0], renderTarget);

				if (isTargetPowerOfTwo)
					gl.generateMipmap(gl.TEXTURE_2D);
			}
			
			//Release everything
			if (isCube)
			{
				gl.bindTexture(gl.TEXTURE_CUBE_MAP, null);
			}
			else
			{
				gl.bindTexture(gl.TEXTURE_2D, null);
			}
			
			gl.bindRenderbuffer(gl.RENDERBUFFER, null);
			gl.bindFramebuffer(gl.FRAMEBUFFER, null);
		}
		
		var framebuffer:WebGLFramebuffer;
		var width:Int, height:Int, vx:Int, vy:Int;
		if (renderTarget != null)
		{
			if (isCube)
			{
				framebuffer = renderTarget.__webglFramebuffer[cast(renderTarget,WebGLRenderTargetCube).activeCubeFace];
			}
			else
			{
				framebuffer = renderTarget.__webglFramebuffer[0];
			}
			
			width = renderTarget.width;
			height = renderTarget.height;
			
			vx = 0;
			vy = 0;
		}
		else
		{
			framebuffer = null;
			
			width = _viewportWidth;
			height = _viewportHeight;
			
			vx = _viewportX;
			vy = _viewportY;
		}
		
		if (framebuffer != _currentFramebuffer)
		{
			gl.bindFramebuffer(gl.FRAMEBUFFER, framebuffer);
			gl.viewport(vx, vy, width, height);
			
			_currentFramebuffer = framebuffer;
		}
		
		_currentWidth = width;
		_currentHeight = height;
	}
	
	public function clampToMaxSize(image:Image, maxSize:Int):HTMLElement
	{
		if (image.width <= maxSize && image.height <= maxSize) 
		{
			return image;
		}

		// Warning: Scaling through the canvas will only work with images that use
		// premultiplied alpha.

		var maxDimension:Float = Math.max(image.width, image.height);
		var newWidth:Int = Math.floor(image.width * maxSize / maxDimension);
		var newHeight:Int = Math.floor(image.height * maxSize / maxDimension);

		var canvas:HTMLCanvasElement = cast(Lib.document.createElement('canvas'),HTMLCanvasElement);
		canvas.width = newWidth;
		canvas.height = newHeight;

		var ctx:CanvasRenderingContext2D = cast(canvas.getContext("2d"),CanvasRenderingContext2D);
		ctx.drawImage(image, 0, 0, image.width, image.height, 0, 0, newWidth, newHeight);

		return canvas;
	}
	
	public function setCubeTexture(texture:Texture, slot:Int):Void
	{
		if (texture.image.length == 6) 
		{
			if (texture.needsUpdate) 
			{
				if (!texture.image.__webglTextureCube) 
				{
					texture.image.__webglTextureCube = gl.createTexture();
				}

				gl.activeTexture(gl.TEXTURE0 + slot);
				gl.bindTexture(gl.TEXTURE_CUBE_MAP, texture.image.__webglTextureCube);

				gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, BoolUtil.toInt(texture.flipY));

				var cubeImage:Array<Dynamic> = [];

				for (i in 0...6) 
				{
					if (this.autoScaleCubemaps)
					{
						cubeImage[i] = clampToMaxSize(texture.image[i], _maxCubemapSize);
					} 
					else
					{
						cubeImage[i] = texture.image[i];
					}
				}

				var image = cubeImage[0], 
				isImagePowerOfTwo = MathUtil.isPowerOfTwo(image.width) && 
									MathUtil.isPowerOfTwo(image.height), 
				glFormat = ThreeGlobal.paramThreeToGL(texture.format), 
				glType = ThreeGlobal.paramThreeToGL(texture.type);

				setTextureParameters(gl.TEXTURE_CUBE_MAP, texture, isImagePowerOfTwo);

				for (i in 0...6) 
				{
					gl.texImage2D(gl.TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, glFormat, glFormat, glType, cubeImage[i]);
				}

				if (texture.generateMipmaps && isImagePowerOfTwo) 
				{
					gl.generateMipmap(gl.TEXTURE_CUBE_MAP);
				}

				texture.needsUpdate = false;

				if (texture.onUpdate != null)
					texture.onUpdate();

			} 
			else 
			{
				gl.activeTexture(gl.TEXTURE0 + slot);
				gl.bindTexture(gl.TEXTURE_CUBE_MAP, texture.image.__webglTextureCube);
			}
		}
	}

	public function setCubeTextureDynamic(texture:Texture, slot:Int):Void
	{
		gl.activeTexture(gl.TEXTURE0 + slot);
		gl.bindTexture(gl.TEXTURE_CUBE_MAP, texture.__webglTexture);
	}
	
	public function setupFrameBuffer(framebuffer:WebGLFramebuffer, renderTarget:WebGLRenderTarget, textureTarget:GLenum):Void
	{
		gl.bindFramebuffer(gl.FRAMEBUFFER, framebuffer);
		gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, textureTarget, renderTarget.__webglTexture, 0);
	}
	
	public function setupRenderBuffer(renderbuffer:WebGLRenderbuffer, renderTarget:WebGLRenderTarget):Void
	{
		gl.bindRenderbuffer(gl.RENDERBUFFER, renderbuffer);
		if (renderTarget.depthBuffer && !renderTarget.stencilBuffer)
		{
			gl.renderbufferStorage(gl.RENDERBUFFER, gl.DEPTH_COMPONENT16, renderTarget.width, renderTarget.height);
			gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.DEPTH_ATTACHMENT, gl.RENDERBUFFER, renderbuffer);
			
			/* For some reason this is not working. Defaulting to RGBA4.
			 } else if( ! renderTarget.depthBuffer && renderTarget.stencilBuffer ) {

			 _gl.renderbufferStorage( _gl.RENDERBUFFER,gl.STENCIL_INDEX8,
			renderTarget.width, renderTarget.height );
			gl.framebufferRenderbuffer(gl.FRAMEBUFFER,gl.STENCIL_ATTACHMENT,
			gl.RENDERBUFFER, renderbuffer );
			 */
		}
		else if(renderTarget.depthBuffer && renderTarget.stencilBuffer)
		{
			gl.renderbufferStorage(gl.RENDERBUFFER, gl.DEPTH_STENCIL, renderTarget.width, renderTarget.height);
			gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.DEPTH_STENCIL_ATTACHMENT, gl.RENDERBUFFER, renderbuffer);
		}
		else
		{
			gl.renderbufferStorage(gl.RENDERBUFFER, gl.RGBA4, renderTarget.width, renderTarget.height);
		}
	}
	
	/**
	 * 
	 * @param	textureType
	 * @param	texture  Texture|WebGLRenderTarget
	 * @param	isImagePowerOfTwo
	 */
	public function setTextureParameters(textureType:GLenum, texture:Dynamic, isImagePowerOfTwo:Bool):Void 
	{
		if (isImagePowerOfTwo) 
		{
			gl.texParameteri(textureType, gl.TEXTURE_WRAP_S, ThreeGlobal.paramThreeToGL(texture.wrapS));
			gl.texParameteri(textureType, gl.TEXTURE_WRAP_T, ThreeGlobal.paramThreeToGL(texture.wrapT));

			gl.texParameteri(textureType, gl.TEXTURE_MAG_FILTER, ThreeGlobal.paramThreeToGL(texture.magFilter));
			gl.texParameteri(textureType, gl.TEXTURE_MIN_FILTER, ThreeGlobal.paramThreeToGL(texture.minFilter));
		} 
		else 
		{
			gl.texParameteri(textureType, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri(textureType, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);

			gl.texParameteri(textureType, gl.TEXTURE_MAG_FILTER, ThreeGlobal.filterFallback(texture.magFilter));
			gl.texParameteri(textureType, gl.TEXTURE_MIN_FILTER, ThreeGlobal.filterFallback(texture.minFilter));
		}

		if (_glExtensionTextureFilterAnisotropic && texture.type != ThreeGlobal.FloatType) 
		{
			if (texture.anisotropy > 1 || texture.__oldAnisotropy <= 0) 
			{
				gl.texParameterf(textureType, _glExtensionTextureFilterAnisotropic.TEXTURE_MAX_ANISOTROPY_EXT, 
								Math.min(texture.anisotropy, _maxAnisotropy));
				texture.__oldAnisotropy = texture.anisotropy;
			}
		}
	}
	
	public function updateRenderTargetMipmap(renderTarget:WebGLRenderTarget):Void
	{
		if (Std.is(renderTarget, WebGLRenderTargetCube))
		{
			gl.bindTexture(gl.TEXTURE_CUBE_MAP, renderTarget.__webglTexture);
			gl.generateMipmap(gl.TEXTURE_CUBE_MAP);
			gl.bindTexture(gl.TEXTURE_CUBE_MAP, null);
		}
		else
		{
			gl.bindTexture(gl.TEXTURE_2D, renderTarget.__webglTexture);
			gl.generateMipmap(gl.TEXTURE_2D);
			gl.bindTexture(gl.TEXTURE_2D, null);
		}
	}
	
	public function addPostPlugin(plugin:IPostRenderPlugin):Void
	{
		plugin.init(this);
		this.renderPluginsPost.push(plugin);
	}
	
	public function addPrePlugin(plugin:IPreRenderPlugin):Void
	{
		plugin.init(this);
		this.renderPluginsPre.push(plugin);
	}
	
	private var _currentProgram:Program3D;
	private var _oldBlending:Int;
	private var _oldDepthTest:Bool;
	private var _oldDepthWrite:Bool;
	private var _currentGeometryGroupHash:Int;
	private var _currentMaterialId:Int;
	private var _oldDoubleSided:Bool;
	private var _oldFlipSided:Bool;
	public function updateShadowMap(scene:Scene, camera:Camera):Void
	{
		_currentProgram = null;
		_oldBlending = -1;
		_oldDepthTest = false;
		_oldDepthWrite = false;
		_currentGeometryGroupHash = -1;
		_currentMaterialId = -1;
		_lightsNeedUpdate = true;
		_oldDoubleSided = false;
		_oldFlipSided = false;

		this.shadowMapPlugin.update(scene, camera);
	}
	
	// Internal functions
	// Buffer allocation
	private function createParticleBuffers(geometry:Geometry):Void
	{
		geometry.__webglVertexBuffer = gl.createBuffer();
		geometry.__webglColorBuffer = gl.createBuffer();
		
		this.statistics.geometries++;
	}
	
	private function createLineBuffers(geometry:Geometry):Void
	{
		geometry.__webglVertexBuffer = gl.createBuffer();
		geometry.__webglColorBuffer = gl.createBuffer();

		this.statistics.geometries++;
	}
	
	private function createRibbonBuffers(geometry:Geometry):Void
	{
		geometry.__webglVertexBuffer = gl.createBuffer();
		geometry.__webglColorBuffer = gl.createBuffer();

		this.statistics.geometries++;
	}
	
	private function createMeshBuffers(geometryGroup:Dynamic):Void 
	{
		geometryGroup.__webglVertexBuffer = gl.createBuffer();
		geometryGroup.__webglNormalBuffer = gl.createBuffer();
		geometryGroup.__webglTangentBuffer = gl.createBuffer();
		geometryGroup.__webglColorBuffer = gl.createBuffer();
		geometryGroup.__webglUVBuffer = gl.createBuffer();
		geometryGroup.__webglUV2Buffer = gl.createBuffer();

		geometryGroup.__webglSkinVertexABuffer = gl.createBuffer();
		geometryGroup.__webglSkinVertexBBuffer = gl.createBuffer();
		geometryGroup.__webglSkinIndicesBuffer = gl.createBuffer();
		geometryGroup.__webglSkinWeightsBuffer = gl.createBuffer();

		geometryGroup.__webglFaceBuffer = gl.createBuffer();
		geometryGroup.__webglLineBuffer = gl.createBuffer();

		if (geometryGroup.numMorphTargets > 0) 
		{
			geometryGroup.__webglMorphTargetsBuffers = [];

			for ( m in 0...geometryGroup.numMorphTargets) 
			{
				geometryGroup.__webglMorphTargetsBuffers.push(gl.createBuffer());
			}
		}

		if (geometryGroup.numMorphNormals > 0) 
		{
			geometryGroup.__webglMorphNormalsBuffers = [];

			for ( m in 0...geometryGroup.numMorphNormals) 
			{
				geometryGroup.__webglMorphNormalsBuffers.push(gl.createBuffer());
			}
		}
		this.statistics.geometries++;
	}
	
	// Buffer deallocation

	private function deleteParticleBuffers(geometry:Geometry):Void
	{
		gl.deleteBuffer(geometry.__webglVertexBuffer);
		gl.deleteBuffer(geometry.__webglColorBuffer);

		this.statistics.geometries--;
	}

	private function deleteLineBuffers(geometry:Geometry):Void
	{
		gl.deleteBuffer(geometry.__webglVertexBuffer);
		gl.deleteBuffer(geometry.__webglColorBuffer);

		this.statistics.geometries--;
	}

	private function deleteRibbonBuffers(geometry:Geometry):Void
	{
		gl.deleteBuffer(geometry.__webglVertexBuffer);
		gl.deleteBuffer(geometry.__webglColorBuffer);

		this.statistics.geometries--;
	}

	private function deleteMeshBuffers(geometryGroup:Dynamic):Void 
	{
		gl.deleteBuffer(geometryGroup.__webglVertexBuffer);
		gl.deleteBuffer(geometryGroup.__webglNormalBuffer);
		gl.deleteBuffer(geometryGroup.__webglTangentBuffer);
		gl.deleteBuffer(geometryGroup.__webglColorBuffer);
		gl.deleteBuffer(geometryGroup.__webglUVBuffer);
		gl.deleteBuffer(geometryGroup.__webglUV2Buffer);

		gl.deleteBuffer(geometryGroup.__webglSkinVertexABuffer);
		gl.deleteBuffer(geometryGroup.__webglSkinVertexBBuffer);
		gl.deleteBuffer(geometryGroup.__webglSkinIndicesBuffer);
		gl.deleteBuffer(geometryGroup.__webglSkinWeightsBuffer);

		gl.deleteBuffer(geometryGroup.__webglFaceBuffer);
		gl.deleteBuffer(geometryGroup.__webglLineBuffer);

		if (geometryGroup.numMorphTargets) 
		{
			for ( m in 0...geometryGroup.numMorphTargets) 
			{
				gl.deleteBuffer(geometryGroup.__webglMorphTargetsBuffers[m]);
			}
		}

		if (geometryGroup.numMorphNormals) 
		{
			for ( m in 0...geometryGroup.numMorphNormals) 
			{
				gl.deleteBuffer(geometryGroup.__webglMorphNormalsBuffers[m]);
			}
		}

		if (geometryGroup.__webglCustomAttributesList != null) 
		{
			var attList:Dynamic = geometryGroup.__webglCustomAttributesList;
			var field:Array<String> = Type.getClassFields(attList);
			for (id in field ) 
			{
				gl.deleteBuffer(untyped attList[id].buffer);
			}
		}

		this.statistics.geometries--;
	}

	// Buffer initialization
	// Deallocation
	public function deallocateObject(object:Dynamic):Void 
	{
		if (!object.__webglInit)
			return;

		object.__webglInit = false;
		//untyped delete object._modelViewMatrix;
		//untyped delete object._normalMatrix;
		//untyped delete object._normalMatrixArray;
		//untyped delete object._modelViewMatrixArray;
		//untyped delete object._modelMatrixArray;

		if ( Std.is(object,Mesh)) 
		{
			var fields:Array<String> = Type.getClassFields(object.geometry.geometryGroups);
			for (g in fields) 
			{
				deleteMeshBuffers(untyped object.geometry.geometryGroups[g]);
			}
		} 
		else if ( Std.is(object,Ribbon)) 
		{
			deleteRibbonBuffers(object.geometry);

		} 
		else if ( Std.is(object,Line)) 
		{
			deleteLineBuffers(object.geometry);
		} 
		else if ( Std.is(object,ParticleSystem)) 
		{
			deleteParticleBuffers(object.geometry);
		}
	}

	public function deallocateTexture(texture:Texture):Void 
	{
		if (!texture.__webglInit)
			return;

		texture.__webglInit = false;
		gl.deleteTexture(texture.__webglTexture);

		this.statistics.textures--;
	}

	public function deallocateRenderTarget(renderTarget:WebGLRenderTarget):Void 
	{
		if (renderTarget == null || renderTarget.__webglTexture == null)
			return;

		gl.deleteTexture(renderTarget.__webglTexture);

		if ( Std.is(renderTarget,WebGLRenderTargetCube)) 
		{
			for (i in 0...6) 
			{
				gl.deleteFramebuffer(renderTarget.__webglFramebuffer[i]);
				gl.deleteRenderbuffer(renderTarget.__webglRenderbuffer[i]);
			}
		} 
		else 
		{
			gl.deleteFramebuffer(renderTarget.__webglFramebuffer[0]);
			gl.deleteRenderbuffer(renderTarget.__webglRenderbuffer[0]);
		}
	}

	private var _programs:Array<ProgramInfo>;
	public function deallocateMaterial(material:Material):Void 
	{
		var program:Program3D = material.program;

		if (program == null)
			return;

		material.program = null;

		 //only deallocate GL program if this was the last use of shared program
		 //assumed there is only single copy of any program in the _programs list
		 //(that's how it's constructed)

		var programInfo:ProgramInfo;
		var deleteProgram:Bool = false;
		for ( i in 0..._programs.length) 
		{
			programInfo = _programs[i];

			if (programInfo.program == program) 
			{
				programInfo.usedTimes--;
				if (programInfo.usedTimes == 0) 
				{
					deleteProgram = true;
				}
				break;
			}
		}

		if (deleteProgram) 
		{
			 //avoid using array.splice, this is costlier than creating new array from
			 //scratch

			var newPrograms:Array<ProgramInfo> = [];
			for ( i in 0..._programs.length) 
			{
				programInfo = _programs[i];
				if (programInfo.program != program) 
				{
					newPrograms.push(programInfo);
				}
			}

			_programs = newPrograms;

			gl.deleteProgram(program.program);

			this.statistics.programs--;
		}
	}
	
	public function setTexture(texture:Texture, slot:Int):Void
	{
		if (texture.needsUpdate) 
		{
			if (!texture.__webglInit) 
			{
				texture.__webglInit = true;
				texture.__webglTexture = gl.createTexture();

				this.statistics.textures++;
			}

			gl.activeTexture(gl.TEXTURE0 + slot);
			gl.bindTexture(gl.TEXTURE_2D, texture.__webglTexture);

			gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, BoolUtil.toInt(texture.flipY));
			gl.pixelStorei(gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, BoolUtil.toInt(texture.premultiplyAlpha));

			var image:Image = texture.image, 
			isImagePowerOfTwo = MathUtil.isPowerOfTwo(image.width) && 
								MathUtil.isPowerOfTwo(image.height), 
			glFormat:GLenum = ThreeGlobal.paramThreeToGL(texture.format), 
			glType:GLenum = ThreeGlobal.paramThreeToGL(texture.type);

			setTextureParameters(gl.TEXTURE_2D, texture, isImagePowerOfTwo);

			if ( Std.is(texture,DataTexture)) 
			{
				gl.texImage2D(gl.TEXTURE_2D, 0, glFormat, image.width, image.height, 0, glFormat, glType, image.data);
			} 
			else 
			{
				gl.texImage2D(gl.TEXTURE_2D, 0, glFormat, glFormat, glType, texture.image);
			}

			if (texture.generateMipmaps && isImagePowerOfTwo)
				gl.generateMipmap(gl.TEXTURE_2D);

			texture.needsUpdate = false;

			if (texture.onUpdate != null)
				texture.onUpdate();

		} 
		else 
		{
			gl.activeTexture(gl.TEXTURE0 + slot);
			gl.bindTexture(gl.TEXTURE_2D, texture.__webglTexture);
		}
	}
	
	// Materials

	public function initMaterial(material:Material, lights:Array<Light>, 
								fog:Dynamic, object:Dynamic):Void
	{
		var u, a, identifiers, i, parameters, maxLightCount, maxBones, maxShadows;

		var shaderID:String = "";
		if ( Std.is(material, MeshDepthMaterial))
		{
			shaderID = 'depth';
		} 
		else if ( Std.is(material, MeshNormalMaterial))
		{
			shaderID = 'normal';
		} 
		else if ( Std.is(material, MeshBasicMaterial)) 
		{
			shaderID = 'basic';
		} 
		else if ( Std.is(material, MeshLambertMaterial)) 
		{
			shaderID = 'lambert';
		} 
		else if ( Std.is(material, MeshPhongMaterial)) 
		{
			shaderID = 'phong';
		} 
		else if ( Std.is(material, LineBasicMaterial)) 
		{
			shaderID = 'basic';
		} 
		else if ( Std.is(material, ParticleBasicMaterial)) 
		{
			shaderID = 'particle_basic';
		}

		if (shaderID != "") 
		{
			setMaterialShaders(material, ShaderLib.getShaderDef(shaderID));
		}

		// heuristics to create shader parameters according to lights in the scene
		// (not to blow over maxLights budget)

		maxLightCount = allocateLights(lights);

		maxShadows = allocateShadows(lights);

		maxBones = allocateBones(object);

		parameters = {

			map : material.map,
			envMap : material.envMap,
			lightMap : material.lightMap,
			bumpMap : material.bumpMap,
			specularMap : material.specularMap,

			vertexColors : material.vertexColors,

			fog : fog,
			useFog : material.fog,

			sizeAttenuation : material.sizeAttenuation,

			skinning : material.skinning,
			maxBones : maxBones,
			useVertexTexture : _supportsBoneTextures && object && object.useVertexTexture,
			boneTextureWidth : object && object.boneTextureWidth,
			boneTextureHeight : object && object.boneTextureHeight,

			morphTargets : material.morphTargets,
			morphNormals : material.morphNormals,
			maxMorphTargets : this.maxMorphTargets,
			maxMorphNormals : this.maxMorphNormals,

			maxDirLights : maxLightCount.directional,
			maxPointLights : maxLightCount.point,
			maxSpotLights : maxLightCount.spot,

			maxShadows : maxShadows,
			shadowMapEnabled : this.shadowMapEnabled && object.receiveShadow,
			shadowMapSoft : this.shadowMapSoft,
			shadowMapDebug : this.shadowMapDebug,
			shadowMapCascade : this.shadowMapCascade,

			alphaTest : material.alphaTest,
			metal : material.metal,
			perPixel : material.perPixel,
			wrapAround : material.wrapAround,
			doubleSided : material.side == ThreeGlobal.DoubleSide
		};

		material.program = buildProgram(shaderID, material.fragmentShader, material.vertexShader, material.uniforms, material.attributes, parameters);

		var attributes:Dynamic = material.program.attributes;

		if (attributes.position >= 0)
			gl.enableVertexAttribArray(attributes.position);
		if (attributes.color >= 0)
			gl.enableVertexAttribArray(attributes.color);
		if (attributes.normal >= 0)
			gl.enableVertexAttribArray(attributes.normal);
		if (attributes.tangent >= 0)
			gl.enableVertexAttribArray(attributes.tangent);

		if (material.skinning && 
			attributes.skinVertexA >= 0 && 
			attributes.skinVertexB >= 0 && 
			attributes.skinIndex >= 0 && 
			attributes.skinWeight >= 0) 
		{
			gl.enableVertexAttribArray(attributes.skinVertexA);
			gl.enableVertexAttribArray(attributes.skinVertexB);
			gl.enableVertexAttribArray(attributes.skinIndex);
			gl.enableVertexAttribArray(attributes.skinWeight);
		}

		if (material.attributes != null) 
		{
			var fields:Array<String> = Type.getClassFields(material.attributes);
			for (a in fields)
			{
				if (untyped attributes[a] != null && attributes[a] >= 0)
					gl.enableVertexAttribArray(untyped attributes[a]);
			}
		}

		if (material.morphTargets) 
		{
			material.numSupportedMorphTargets = 0;

			var id:String;
			var base:String = "morphTarget";
			for ( i in 0...this.maxMorphTargets) 
			{
				id = base + i;
				if (untyped attributes[id] >= 0) 
				{
					gl.enableVertexAttribArray(untyped attributes[id]);
					material.numSupportedMorphTargets++;
				}
			}
		}

		if (material.morphNormals) 
		{
			material.numSupportedMorphNormals = 0;

			var id:String;
			var base:String = "morphNormal";
			for ( i in 0...this.maxMorphNormals) 
			{
				id = base + i;
				if (untyped attributes[id] >= 0) 
				{
					gl.enableVertexAttribArray(untyped attributes[id]);
					material.numSupportedMorphNormals++;
				}
			}
		}

		material.uniformsList = [];

		var fields:Array<String> = Type.getClassFields(material.uniforms);
		for (u in fields)
		{
			material.uniformsList.push([untyped material.uniforms[u], u]);
		}

	}
	
	public function setupMatrices(object:Object3D, camera:Camera):Void
	{
		object._modelViewMatrix.multiply(camera.matrixWorldInverse, object.matrixWorld);

		object._normalMatrix.getInverse(object._modelViewMatrix);
		object._normalMatrix.transpose();
	}
	
	// Uniforms (refresh uniforms objects)

	private function refreshUniformsCommon(uniforms:Dynamic, material:Material):Void
	{
		uniforms.opacity.value = material.opacity;

		if (this.gammaInput) 
		{
			uniforms.diffuse.value.copyGammaToLinear(material.color);
		} 
		else 
		{
			uniforms.diffuse.value = material.color;
		}

		uniforms.map.texture = material.map;
		uniforms.lightMap.texture = material.lightMap;
		uniforms.specularMap.texture = material.specularMap;

		if (material.bumpMap != null) 
		{
			uniforms.bumpMap.texture = material.bumpMap;
			uniforms.bumpScale.value = material.bumpScale;
		}

		// uv repeat and offset setting priorities
		//	1. color map
		//	2. specular map
		//	3. bump map

		var uvScaleMap:Texture = null;

		if (material.map != null) 
		{
			uvScaleMap = material.map;
		} 
		else if (material.specularMap != null) 
		{
			uvScaleMap = material.specularMap;
		} 
		else if (material.bumpMap != null) 
		{
			uvScaleMap = material.bumpMap;
		}

		if (uvScaleMap  != null) 
		{
			var offset:Vector2 = uvScaleMap.offset;
			var repeat:Vector2 = uvScaleMap.repeat;
			uniforms.offsetRepeat.value.set(offset.x, offset.y, repeat.x, repeat.y);
		}

		uniforms.envMap.texture = material.envMap;
		uniforms.flipEnvMap.value = (Std.is(material.envMap, WebGLRenderTargetCube) ) ? 1 : -1;

		if (this.gammaInput) 
		{
			//uniforms.reflectivity.value = material.reflectivity * material.reflectivity;
			uniforms.reflectivity.value = material.reflectivity;
		} 
		else 
		{
			uniforms.reflectivity.value = material.reflectivity;
		}

		uniforms.refractionRatio.value = material.refractionRatio;
		uniforms.combine.value = material.combine;
		uniforms.useRefract.value = material.envMap != null && Std.is(material.envMap.mapping,CubeRefractionMapping);
	}

	private function refreshUniformsLine(uniforms:Dynamic, material:Material):Void
	{
		uniforms.diffuse.value = material.color;
		uniforms.opacity.value = material.opacity;
	}

	private function refreshUniformsParticle(uniforms:Dynamic, material:Material):Void
	{
		uniforms.psColor.value = material.color;
		uniforms.opacity.value = material.opacity;
		uniforms.size.value = material.size;
		uniforms.scale.value = _canvas.height / 2.0;
		// TODO: Cache this.

		uniforms.map.texture = material.map;
	}

	private function refreshUniformsFog(uniforms:Dynamic, fog:IFog):Void
	{
		uniforms.fogColor.value = fog.color;

		if ( Std.is(fog, Fog)) 
		{
			var fog:Fog = cast(fog, Fog);
			uniforms.fogNear.value = fog.near;
			uniforms.fogFar.value = fog.far;
		} 
		else if ( Std.is(fog,FogExp2)) 
		{
			uniforms.fogDensity.value = cast(fog,FogExp2).density;
		}
	}

	private function refreshUniformsPhong(uniforms:Dynamic, material:Material):Void
	{
		uniforms.shininess.value = material.shininess;

		if (this.gammaInput) 
		{
			uniforms.ambient.value.copyGammaToLinear(material.ambient);
			uniforms.emissive.value.copyGammaToLinear(material.emissive);
			uniforms.specular.value.copyGammaToLinear(material.specular);
		} 
		else 
		{
			uniforms.ambient.value = material.ambient;
			uniforms.emissive.value = material.emissive;
			uniforms.specular.value = material.specular;
		}

		if (material.wrapAround) 
		{
			uniforms.wrapRGB.value.copy(material.wrapRGB);
		}
	}

	private function refreshUniformsLambert(uniforms:Dynamic, material:Material):Void
	{
		if (this.gammaInput) 
		{
			uniforms.ambient.value.copyGammaToLinear(material.ambient);
			uniforms.emissive.value.copyGammaToLinear(material.emissive);
		} 
		else 
		{
			uniforms.ambient.value = material.ambient;
			uniforms.emissive.value = material.emissive;
		}

		if (material.wrapAround) 
		{
			uniforms.wrapRGB.value.copy(material.wrapRGB);
		}
	}

	private function refreshUniformsLights(uniforms:Dynamic, lights:LightsDef):Void
	{
		uniforms.ambientLightColor.value = lights.ambient;

		uniforms.directionalLightColor.value = lights.directional.colors;
		uniforms.directionalLightDirection.value = lights.directional.positions;

		uniforms.pointLightColor.value = lights.point.colors;
		uniforms.pointLightPosition.value = lights.point.positions;
		uniforms.pointLightDistance.value = lights.point.distances;

		uniforms.spotLightColor.value = lights.spot.colors;
		uniforms.spotLightPosition.value = lights.spot.positions;
		uniforms.spotLightDistance.value = lights.spot.distances;
		uniforms.spotLightDirection.value = lights.spot.directions;
		uniforms.spotLightAngle.value = lights.spot.angles;
		uniforms.spotLightExponent.value = lights.spot.exponents;
	}

	private function refreshUniformsShadow(uniforms:Dynamic, lights:Array<Light>):Void
	{
		if (uniforms.shadowMatrix) 
		{
			var j = 0;
			for (i in 0...lights.length) 
			{
				var light:Light = lights[i];

				if (!light.castShadow)
					continue;

				if ( Std.is(light, SpotLight) || 
					(Std.is(light, DirectionalLight) && !light.shadowCascade ))
				{
					uniforms.shadowMap.texture[j] = light.shadowMap;
					uniforms.shadowMapSize.value[j] = light.shadowMapSize;

					uniforms.shadowMatrix.value[j] = light.shadowMatrix;

					uniforms.shadowDarkness.value[j] = light.shadowDarkness;
					uniforms.shadowBias.value[j] = light.shadowBias;

					j++;
				}
			}
		}
	}

	// Uniforms (load to GPU)

	private function loadUniformsMatrices(uniforms:Dynamic, object:Object3D):Void
	{
		gl.uniformMatrix4fv(uniforms.modelViewMatrix, false, object._modelViewMatrix.elements);

		if (uniforms.normalMatrix != null) 
		{
			gl.uniformMatrix3fv(uniforms.normalMatrix, false, object._normalMatrix.elements);
		}
	}

	private function loadUniformsGeneric(program:Program3D, uniforms:Array<Uniform>):Void
	{
		var uniform:Uniform; 
		var value:Dynamic; 
		var type:String;
		var location:WebGLUniformLocation;
		var texture:Dynamic;
		var offset:Int;

		for ( j in 0...uniforms.length) 
		{
			var obj:Dynamic = untyped uniforms[j];
			location = program.uniforms[obj[1]];
			if (location != null)
				continue;

			uniform = obj[0];

			type = uniform.type;
			value = uniform.value;

			if (type == "i") 
			{
				// single integer
				gl.uniform1i(location, value);
			} 
			else if (type == "f") 
			{
				// single float
				gl.uniform1f(location, value);
			} 
			else if (type == "v2") 
			{
				var vec2:Vector2 = cast(value, Vector2);
				// single THREE.Vector2
				gl.uniform2f(location, vec2.x, vec2.y);
			} 
			else if (type == "v3") 
			{
				var vec3:Vector3 = cast(value, Vector3);
				// single THREE.Vector3
				gl.uniform3f(location, vec3.x, vec3.y, vec3.z);
			} 
			else if (type == "v4") 
			{
				var vec4:Vector4 = cast(value, Vector4);
				// single THREE.Vector4
				gl.uniform4f(location, vec4.x, vec4.y, vec4.z, vec4.w);
			} 
			else if (type == "c") 
			{
				var color:Color = cast(value, Color);
				// single THREE.Color
				gl.uniform3f(location, color.r, color.g, color.b);
			} 
			else if (type == "iv1") 
			{
				// flat array of integers (JS or typed array)
				gl.uniform1iv(location, value);
			} 
			else if (type == "iv") 
			{
				// flat array of integers with 3 x N size (JS or typed array)
				gl.uniform3iv(location, value);
			} 
			else if (type == "fv1")
			{
				// flat array of floats (JS or typed array)
				gl.uniform1fv(location, value);
			} 
			else if (type == "fv") 
			{
				// flat array of floats with 3 x N size (JS or typed array)
				gl.uniform3fv(location, value);
			} 
			else if (type == "v2v") 
			{
				var arr:Array<Vector2> = cast value;
				// array of THREE.Vector2
				if (uniform._array == null) 
				{
					uniform._array = new Float32Array(2 * arr.length);
				}

				for ( i in 0...arr.length) 
				{
					offset = i * 2;

					uniform._array[offset] = arr[i].x;
					uniform._array[offset + 1] = arr[i].y;
				}
				gl.uniform2fv(location, uniform._array);
			}
			else if (type == "v3v") 
			{
				var arr:Array<Vector3> = cast value;
				// array of THREE.Vector3
				if (uniform._array == null) 
				{
					uniform._array = new Float32Array(3 * arr.length);
				}

				for ( i in 0...arr.length) 
				{
					offset = i * 3;

					uniform._array[offset] = arr[i].x;
					uniform._array[offset + 1] = arr[i].y;
					uniform._array[offset + 2] = arr[i].z;
				}
				gl.uniform3fv(location, uniform._array);
			} 
			else if (type == "v4v") 
			{
				var arr:Array<Vector4> = cast value;
				// array of THREE.Vector4
				if (uniform._array == null) 
				{
					uniform._array = new Float32Array(4 * arr.length);
				}

				for ( i in 0...arr.length) 
				{
					offset = i * 4;

					uniform._array[offset] = arr[i].x;
					uniform._array[offset + 1] = arr[i].y;
					uniform._array[offset + 2] = arr[i].z;
					uniform._array[offset + 3] = arr[i].w;
				}

				gl.uniform4fv(location, uniform._array);
			} 
			else if (type == "m4") 
			{
				// single THREE.Matrix4
				if (uniform._array == null) 
				{
					uniform._array = new Float32Array(16);
				}

				value.flattenToArray(uniform._array);
				gl.uniformMatrix4fv(location, false, uniform._array);
			} 
			else if (type == "m4v") 
			{
				var arr:Array<Matrix4> = cast value;
				// array of THREE.Matrix4
				if (uniform._array == null) 
				{
					uniform._array = new Float32Array(16 * arr.length);
				}

				for ( i in 0...arr.length) 
				{
					value[i].flattenToArrayOffset(uniform._array, i * 16);
				}
				gl.uniformMatrix4fv(location, false, uniform._array);
			} 
			else if (type == "t") 
			{
				// single THREE.Texture (2d or cube)
				gl.uniform1i(location, value);
				texture = uniform.texture;
				if (texture == null)
					continue;
				if (Std.is(texture.image,Array) && texture.image.length == 6) 
				{
					setCubeTexture(texture, value);
				} 
				else if ( Std.is(texture,WebGLRenderTargetCube)) 
				{
					setCubeTextureDynamic(texture, value);
				} 
				else 
				{
					this.setTexture(texture, value);
				}
			} 
			else if (type == "tv") 
			{
				// array of THREE.Texture (2d)
				if (uniform._array == null) 
				{
					uniform._array = [];
					for ( i in 0...uniform.texture.length) 
					{
						uniform._array[i] = value + i;
					}
				}

				gl.uniform1iv(location, uniform._array);

				for ( i in 0...uniform.texture.length) 
				{
					texture = uniform.texture[i];
					if (!texture)
						continue;
					this.setTexture(texture, uniform._array[i]);
				}
			}
		}
	}

	private function setupLights(program:Program3D, lights:Array<Light>):Void
	{

		var light:Light;
		var color:Color;
		var intensity:Float;
		var r:Float = 0, g:Float = 0, b:Float = 0; 
		var n, 
		position,
		distance, zlights = _lights, 
		dcolors = zlights.directional.colors, 
		dpositions = zlights.directional.positions, 
		pcolors = zlights.point.colors, 
		ppositions = zlights.point.positions, 
		pdistances = zlights.point.distances, 
		scolors = zlights.spot.colors, 
		spositions = zlights.spot.positions, 
		sdistances = zlights.spot.distances, 
		sdirections = zlights.spot.directions, 
		sangles = zlights.spot.angles, 
		sexponents = zlights.spot.exponents, 
		dlength = 0, 
		plength = 0, 
		slength = 0, 
		doffset = 0, 
		poffset = 0, 
		soffset = 0;

		for ( l in 0...lights.length) 
		{
			light = lights[l];

			if (light.onlyShadow || !light.visible)
				continue;

			color = light.color;
			intensity = light.intensity;
			distance = light.distance;

			if ( Std.is(light, AmbientLight)) 
			{
				if (this.gammaInput)
				{
					r += color.r * color.r;
					g += color.g * color.g;
					b += color.b * color.b;
				} 
				else 
				{
					r += color.r;
					g += color.g;
					b += color.b;
				}
			}
			else if ( Std.is(light, DirectionalLight)) 
			{
				doffset = dlength * 3;
				if (this.gammaInput) 
				{
					dcolors[doffset] = color.r * color.r * intensity * intensity;
					dcolors[doffset + 1] = color.g * color.g * intensity * intensity;
					dcolors[doffset + 2] = color.b * color.b * intensity * intensity;
				} 
				else 
				{
					dcolors[doffset] = color.r * intensity;
					dcolors[doffset + 1] = color.g * intensity;
					dcolors[doffset + 2] = color.b * intensity;
				}

				_direction.copy(light.matrixWorld.getPosition());
				_direction.subSelf(light.target.matrixWorld.getPosition());
				_direction.normalize();

				dpositions[doffset] = _direction.x;
				dpositions[doffset + 1] = _direction.y;
				dpositions[doffset + 2] = _direction.z;

				dlength += 1;

			}
			else if ( Std.is(light, PointLight)) 
			{
				poffset = plength * 3;
				if (this.gammaInput) 
				{
					pcolors[poffset] = color.r * color.r * intensity * intensity;
					pcolors[poffset + 1] = color.g * color.g * intensity * intensity;
					pcolors[poffset + 2] = color.b * color.b * intensity * intensity;
				} 
				else 
				{
					pcolors[poffset] = color.r * intensity;
					pcolors[poffset + 1] = color.g * intensity;
					pcolors[poffset + 2] = color.b * intensity;
				}

				position = light.matrixWorld.getPosition();

				ppositions[poffset] = position.x;
				ppositions[poffset + 1] = position.y;
				ppositions[poffset + 2] = position.z;

				pdistances[plength] = distance;

				plength += 1;

			} 
			else if ( Std.is(light, SpotLight)) 
			{
				var spotLight:SpotLight = cast(light, SpotLight);
				
				soffset = slength * 3;

				if (this.gammaInput) 
				{
					scolors[soffset] = color.r * color.r * intensity * intensity;
					scolors[soffset + 1] = color.g * color.g * intensity * intensity;
					scolors[soffset + 2] = color.b * color.b * intensity * intensity;
				} 
				else 
				{
					scolors[soffset] = color.r * intensity;
					scolors[soffset + 1] = color.g * intensity;
					scolors[soffset + 2] = color.b * intensity;
				}

				position = spotLight.matrixWorld.getPosition();

				spositions[soffset] = position.x;
				spositions[soffset + 1] = position.y;
				spositions[soffset + 2] = position.z;

				sdistances[slength] = distance;

				_direction.copy(position);
				_direction.subSelf(light.target.matrixWorld.getPosition());
				_direction.normalize();

				sdirections[soffset] = _direction.x;
				sdirections[soffset + 1] = _direction.y;
				sdirections[soffset + 2] = _direction.z;

				sangles[slength] = Math.cos(spotLight.angle);
				sexponents[slength] = spotLight.exponent;

				slength += 1;
			}
		}

		// null eventual remains from removed lights
		// (this is to avoid if in shader)

		for ( l in dlength * 3...dcolors.length)
			dcolors[l] = 0.0;
		for ( l in plength * 3...pcolors.length)
			pcolors[l] = 0.0;
		for ( l in slength * 3...scolors.length)
			scolors[l] = 0.0;

		zlights.directional.length = dlength;
		zlights.point.length = plength;
		zlights.spot.length = slength;

		zlights.ambient[0] = r;
		zlights.ambient[1] = g;
		zlights.ambient[2] = b;

	}
	
	// GL state setting

	public function setFaceCulling(cullFace:String, frontFace:String):Void 
	{
		if (cullFace != "") 
		{
			if (frontFace == "ccw") 
			{
				gl.frontFace(gl.CCW);
			}
			else 
			{
				gl.frontFace(gl.CW);
			}

			if (cullFace == "back") 
			{
				gl.cullFace(gl.BACK);
			} 
			else if (cullFace == "front") 
			{
				gl.cullFace(gl.FRONT);
			} 
			else 
			{
				gl.cullFace(gl.FRONT_AND_BACK);
			}

			gl.enable(gl.CULL_FACE);

		} 
		else 
		{
			gl.disable(gl.CULL_FACE);
		}
	}

	public function setMaterialFaces(material:Material):Void 
	{

		var doubleSided:Bool = material.side == ThreeGlobal.DoubleSide;
		var flipSided:Bool = material.side == ThreeGlobal.BackSide;

		if (_oldDoubleSided != doubleSided) 
		{
			if (doubleSided) 
			{
				gl.disable(gl.CULL_FACE);
			} 
			else 
			{
				gl.enable(gl.CULL_FACE);
			}

			_oldDoubleSided = doubleSided;
		}

		if (_oldFlipSided != flipSided) 
		{
			if (flipSided) 
			{
				gl.frontFace(gl.CW);
			} 
			else 
			{
				gl.frontFace(gl.CCW);
			}
			_oldFlipSided = flipSided;
		}
	}

	public function setDepthTest(depthTest:Bool):Void
	{
		if (_oldDepthTest != depthTest) 
		{
			if (depthTest) 
			{
				gl.enable(gl.DEPTH_TEST);
			} 
			else 
			{
				gl.disable(gl.DEPTH_TEST);
			}
			_oldDepthTest = depthTest;
		}
	}

	public function setDepthWrite(depthWrite:Bool):Void
	{
		if (_oldDepthWrite != depthWrite)
		{
			gl.depthMask(depthWrite);
			_oldDepthWrite = depthWrite;
		}
	}

	private var _oldLineWidth:Float;
	public function setLineWidth(width:Float):Void
	{
		if (width != _oldLineWidth) 
		{
			gl.lineWidth(width);

			_oldLineWidth = width;
		}
	}

	private var _oldPolygonOffset:Float;
	private var _oldPolygonOffsetFactor:Float;
	private var _oldPolygonOffsetUnits:Int;
	public function setPolygonOffset(polygonoffset:Float, factor:Float, units:Int):Void
	{
		if (_oldPolygonOffset != polygonoffset) 
		{
			if (polygonoffset > 0) 
			{
				gl.enable(gl.POLYGON_OFFSET_FILL);
			} 
			else 
			{
				gl.disable(gl.POLYGON_OFFSET_FILL);
			}

			_oldPolygonOffset = polygonoffset;
		}

		if (polygonoffset > 0 && 
			(_oldPolygonOffsetFactor != factor || 
			_oldPolygonOffsetUnits != units )) 
		{
			gl.polygonOffset(factor, units);

			_oldPolygonOffsetFactor = factor;
			_oldPolygonOffsetUnits = units;
		}
	}

	private var _oldBlendEquation:Int;
	private var _oldBlendSrc:Int;
	private var _oldBlendDst:Int;
	public function setBlending(blending:Int, blendEquation:Int, blendSrc:Int, blendDst:Int):Void
	{
		if (blending != _oldBlending)
		{
			if (blending == ThreeGlobal.NoBlending) 
			{
				gl.disable(gl.BLEND);
			} 
			else if (blending == ThreeGlobal.AdditiveBlending) 
			{
				gl.enable(gl.BLEND);
				gl.blendEquation(gl.FUNC_ADD);
				gl.blendFunc(gl.SRC_ALPHA, gl.ONE);
			} 
			else if (blending == ThreeGlobal.SubtractiveBlending) 
			{
				// TODO: Find blendFuncSeparate() combination
				gl.enable(gl.BLEND);
				gl.blendEquation(gl.FUNC_ADD);
				gl.blendFunc(gl.ZERO, gl.ONE_MINUS_SRC_COLOR);
			} 
			else if (blending == ThreeGlobal.MultiplyBlending) 
			{
				// TODO: Find blendFuncSeparate() combination
				gl.enable(gl.BLEND);
				gl.blendEquation(gl.FUNC_ADD);
				gl.blendFunc(gl.ZERO, gl.SRC_COLOR);
			}
			else if (blending == ThreeGlobal.CustomBlending) 
			{
				gl.enable(gl.BLEND);
			}
			else 
			{
				gl.enable(gl.BLEND);
				gl.blendEquationSeparate(gl.FUNC_ADD, gl.FUNC_ADD);
				gl.blendFuncSeparate(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA, gl.ONE, gl.ONE_MINUS_SRC_ALPHA);
			}

			_oldBlending = blending;
		}

		if (blending == ThreeGlobal.CustomBlending) 
		{
			if (blendEquation != _oldBlendEquation) 
			{
				gl.blendEquation(ThreeGlobal.paramThreeToGL(blendEquation));

				_oldBlendEquation = blendEquation;
			}

			if (blendSrc != _oldBlendSrc || blendDst != _oldBlendDst) 
			{
				gl.blendFunc(ThreeGlobal.paramThreeToGL(blendSrc), ThreeGlobal.paramThreeToGL(blendDst));

				_oldBlendSrc = blendSrc;
				_oldBlendDst = blendDst;
			}
		}
		else 
		{
			_oldBlendEquation = null;
			_oldBlendSrc = null;
			_oldBlendDst = null;
		}
	}

	// Shaders
	private static var _programs_counter:Int = 0;
	public function buildProgram(shaderID:String, 
								fragmentShader:String, vertexShader:String, 
								uniforms:Dynamic, 
								attributes:Dynamic, parameters:Dynamic):Program3D
	{

		var p, pl; 
		var program:WebGLProgram; 
		var code:String;
		var chunks:Array<Dynamic> = [];

		// Generate code
		if (shaderID != "") 
		{
			chunks.push(shaderID);
		} 
		else 
		{
			chunks.push(fragmentShader);
			chunks.push(vertexShader);
		}

		var fields:Array<String> = Type.getClassFields(parameters);
		for (p in fields) 
		{
			chunks.push(p);
			chunks.push(untyped parameters[p]);
		}

		code = chunks.join("");

		// Check if code has been already compiled

		for ( p in 0..._programs.length) 
		{
			var programInfo:ProgramInfo = _programs[p];

			if (programInfo.code == code) 
			{
				//Logger.log( "Code already compiled." /*: \n\n" + code*/ );
				programInfo.usedTimes++;
				return programInfo.program;
			}
		}

		//Logger.log( "building new program " );

		//

		program = gl.createProgram();

		var prefix_vertex = ["precision " + _precision + " float;", 
		_supportsVertexTextures ? "#define VERTEX_TEXTURES" : "", 
		this.gammaInput ? "#define GAMMA_INPUT" : "", 
		this.gammaOutput ? "#define GAMMA_OUTPUT" : "", 
		this.physicallyBasedShading ? "#define PHYSICALLY_BASED_SHADING" : "",
		"#define MAX_DIR_LIGHTS " + parameters.maxDirLights,
		"#define MAX_POINT_LIGHTS " + parameters.maxPointLights,
		"#define MAX_SPOT_LIGHTS " + parameters.maxSpotLights,
		"#define MAX_SHADOWS " + parameters.maxShadows,
		"#define MAX_BONES " + parameters.maxBones,
		parameters.map ? "#define USE_MAP" : "",
		parameters.envMap ? "#define USE_ENVMAP" : "",
		parameters.lightMap ? "#define USE_LIGHTMAP" : "",
		parameters.bumpMap ? "#define USE_BUMPMAP" : "",
		parameters.specularMap ? "#define USE_SPECULARMAP" : "", parameters.vertexColors ? "#define USE_COLOR" : "", parameters.skinning ? "#define USE_SKINNING" : "",
		parameters.useVertexTexture ? "#define BONE_TEXTURE" : "",
		parameters.boneTextureWidth ? "#define N_BONE_PIXEL_X " + parameters.boneTextureWidth.toFixed(1) : "",
		parameters.boneTextureHeight ? "#define N_BONE_PIXEL_Y " + parameters.boneTextureHeight.toFixed(1) : "",
		parameters.morphTargets ? "#define USE_MORPHTARGETS" : "",
		parameters.morphNormals ? "#define USE_MORPHNORMALS" : "",
		parameters.perPixel ? "#define PHONG_PER_PIXEL" : "",
		parameters.wrapAround ? "#define WRAP_AROUND" : "",
		parameters.doubleSided ? "#define DOUBLE_SIDED" : "",
		parameters.shadowMapEnabled ? "#define USE_SHADOWMAP" : "",
		parameters.shadowMapSoft ? "#define SHADOWMAP_SOFT" : "",
		parameters.shadowMapDebug ? "#define SHADOWMAP_DEBUG" : "",
		parameters.shadowMapCascade ? "#define SHADOWMAP_CASCADE" : "",
		parameters.sizeAttenuation ? "#define USE_SIZEATTENUATION" : "",
		"uniform mat4 modelMatrix;", "uniform mat4 modelViewMatrix;",
		"uniform mat4 projectionMatrix;", "uniform mat4 viewMatrix;",
		"uniform mat3 normalMatrix;", "uniform vec3 cameraPosition;",
		"attribute vec3 position;", "attribute vec3 normal;",
		"attribute vec2 uv;", "attribute vec2 uv2;", "#ifdef USE_COLOR",
		"attribute vec3 color;", "#endif", "#ifdef USE_MORPHTARGETS",
		"attribute vec3 morphTarget0;", "attribute vec3 morphTarget1;",
		"attribute vec3 morphTarget2;", "attribute vec3 morphTarget3;",
		"#ifdef USE_MORPHNORMALS", "attribute vec3 morphNormal0;",
		"attribute vec3 morphNormal1;", 
		"attribute vec3 morphNormal2;",
		"attribute vec3 morphNormal3;", 
		"#else", "attribute vec3 morphTarget4;",
		"attribute vec3 morphTarget5;", 
		"attribute vec3 morphTarget6;", 
		"attribute vec3 morphTarget7;", 
		"#endif", "#endif", 
		"#ifdef USE_SKINNING", 
		"attribute vec4 skinVertexA;", 
		"attribute vec4 skinVertexB;", 
		"attribute vec4 skinIndex;", 
		"attribute vec4 skinWeight;", 
		"#endif", ""].join("\n");

		var prefix_fragment = ["precision " + _precision + " float;", 
		parameters.bumpMap ? "#extension GL_OES_standard_derivatives : enable" : "",
		"#define MAX_DIR_LIGHTS " + parameters.maxDirLights,
		"#define MAX_POINT_LIGHTS " + parameters.maxPointLights,
		"#define MAX_SPOT_LIGHTS " + parameters.maxSpotLights,
		"#define MAX_SHADOWS " + parameters.maxShadows,
		parameters.alphaTest ? "#define ALPHATEST " + parameters.alphaTest : "",
		this.gammaInput ? "#define GAMMA_INPUT" : "",
		this.gammaOutput ? "#define GAMMA_OUTPUT" : "",
		this.physicallyBasedShading ? "#define PHYSICALLY_BASED_SHADING" : "",
		(parameters.useFog && parameters.fog ) ? "#define USE_FOG" : "",
		(parameters.useFog && Std.is(parameters.fog,FogExp2) ) ? "#define FOG_EXP2" : "",
		parameters.map ? "#define USE_MAP" : "", parameters.envMap ? "#define USE_ENVMAP" : "",
		parameters.lightMap ? "#define USE_LIGHTMAP" : "", parameters.bumpMap ? "#define USE_BUMPMAP" : "",
		parameters.specularMap ? "#define USE_SPECULARMAP" : "", parameters.vertexColors ? "#define USE_COLOR" : "",
		parameters.metal ? "#define METAL" : "", parameters.perPixel ? "#define PHONG_PER_PIXEL" : "",
		parameters.wrapAround ? "#define WRAP_AROUND" : "",
		parameters.doubleSided ? "#define DOUBLE_SIDED" : "",
		parameters.shadowMapEnabled ? "#define USE_SHADOWMAP" : "",
		parameters.shadowMapSoft ? "#define SHADOWMAP_SOFT" : "",
		parameters.shadowMapDebug ? "#define SHADOWMAP_DEBUG" : "", 
		parameters.shadowMapCascade ? "#define SHADOWMAP_CASCADE" : "",
		"uniform mat4 viewMatrix;", "uniform vec3 cameraPosition;",
		""].join("\n");

		var glFragmentShader:WebGLShader = getShader("fragment", prefix_fragment + fragmentShader);
		var glVertexShader:WebGLShader = getShader("vertex", prefix_vertex + vertexShader);

		gl.attachShader(program, glVertexShader);
		gl.attachShader(program, glFragmentShader);

		gl.linkProgram(program);

		if (!gl.getProgramParameter(program, gl.LINK_STATUS)) 
		{
			Logger.error("Could not initialise shader\n" + "VALIDATE_STATUS: " + 
							gl.getProgramParameter(program, gl.VALIDATE_STATUS) + 
							", gl error [" + gl.getError() + "]");
		}

		// clean up
		gl.deleteShader(glFragmentShader);
		gl.deleteShader(glVertexShader);

		//console.log( prefix_fragment + fragmentShader );
		//console.log( prefix_vertex + vertexShader );

		var program3D:Program3D = new Program3D();
		program3D.program = program;
		program3D.uniforms = {};
		program3D.attributes = {};

		var identifiers, u, a, i;

		// cache uniform locations

		identifiers = ['viewMatrix', 
						'modelViewMatrix', 
						'projectionMatrix', 
						'normalMatrix', 
						'modelMatrix', 
						'cameraPosition', 
						'morphTargetInfluences'];

		if (parameters.useVertexTexture) 
		{
			identifiers.push('boneTexture');
		} 
		else 
		{
			identifiers.push('boneGlobalMatrices');
		}

		
		var fields:Array<String> = Type.getClassFields(uniforms);
		for (u in fields)
		{
			identifiers.push(u);
		}

		cacheUniformLocations(program3D, identifiers);

		// cache attributes locations

		identifiers = ["position", 
						"normal", 
						"uv", 
						"uv2", 
						"tangent", 
						"color", 
						"skinVertexA", 
						"skinVertexB", 
						"skinIndex", 
						"skinWeight"];

		for ( i in 0...parameters.maxMorphTargets) 
		{
			identifiers.push("morphTarget" + i);
		}

		for ( i in 0...parameters.maxMorphNormals) 
		{
			identifiers.push("morphNormal" + i);
		}

		var fields:Array<String> = Type.getClassFields(attributes);
		for (a in fields) 
		{
			identifiers.push(a);
		}

		cacheAttributeLocations(program3D, identifiers);

		program3D.id = _programs_counter++;
		
		var pInfo:ProgramInfo = {
			program : program3D,
			code : code,
			usedTimes : 1
		};

		_programs.push(pInfo);

		this.statistics.programs = _programs.length;

		return program3D;
	}
	
	// Shader parameters cache
	public function cacheUniformLocations(program:Program3D, identifiers:Array<String>):Void
	{
		var id:String;
		for ( i in 0...identifiers.length) 
		{
			id = identifiers[i];
			untyped program.uniforms[id] = gl.getUniformLocation(program.program, id);
		}
	}

	public function cacheAttributeLocations(program:Program3D, identifiers:Array<String>):Void
	{
		var id:String;
		for ( i in 0...identifiers.length) 
		{
			id = identifiers[i];
			untyped program.attributes[id] = gl.getAttribLocation(program.program, id);
		}
	}

	public function addLineNumbers(source:String):String
	{
		var chunks:Array<String> = source.split("\n");
		for (i in 0...chunks.length) 
		{
			// Chrome reports shader errors on lines
			// starting counting from 1
			chunks[i] = (i + 1 ) + ": " + chunks[i];
		}
		return chunks.join("\n");
	}

	public function getShader(type:String, source:String):WebGLShader
	{
		var shader:WebGLShader = null;
		if (type == "fragment") 
		{
			shader = gl.createShader(gl.FRAGMENT_SHADER);
		} 
		else if (type == "vertex") 
		{
			shader = gl.createShader(gl.VERTEX_SHADER);
		}

		gl.shaderSource(shader, source);
		gl.compileShader(shader);

		if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) 
		{
			Logger.error(gl.getShaderInfoLog(shader));
			Logger.error(addLineNumbers(source));
			return null;
		}
		return shader;
	}
	
	public function initWebGLObjects(scene:Scene):Void
	{
		if (scene.__webglObjects == null) 
		{
			scene.__webglObjects = [];
			scene.__webglObjectsImmediate = [];
			scene.__webglSprites = [];
			scene.__webglFlares = [];
		}

		while (scene.__objectsAdded.length > 0) 
		{
			addObject(scene.__objectsAdded[0], scene);
			scene.__objectsAdded.splice(0, 1);
		}

		while (scene.__objectsRemoved.length > 0) 
		{
			removeObject(scene.__objectsRemoved[0], scene);
			scene.__objectsRemoved.splice(0, 1);
		}

		// update must be called after objects adding / removal

		for (o in 0...scene.__webglObjects.length) 
		{
			updateObject(scene.__webglObjects[o].object);
		}
	}
	
	// Objects adding

	public function addObject(object:Dynamic, scene:Scene):Void
	{
		var g, geometry, geometryGroup;

		if (!object.__webglInit) 
		{
			object.__webglInit = true;

			object._modelViewMatrix = new Matrix4();
			object._normalMatrix = new Matrix3();

			if (Std.is(object,Mesh)) 
			{
				geometry = object.geometry;

				if (Std.is(geometry,Geometry)) 
				{
					if (geometry.geometryGroups == null) 
					{
						sortFacesByMaterial(cast geometry);
					}

					// create separate VBOs per geometry chunk

					var fields:Array<String> = Type.getClassFields(geometry.geometryGroups);
					for (g in fields ) 
					{
						geometryGroup = untyped geometry.geometryGroups[g];

						// initialise VBO on the first access

						if (geometryGroup.__webglVertexBuffer == null) 
						{
							createMeshBuffers(geometryGroup);
							initMeshBuffers(geometryGroup, object);

							geometry.verticesNeedUpdate = true;
							geometry.morphTargetsNeedUpdate = true;
							geometry.elementsNeedUpdate = true;
							geometry.uvsNeedUpdate = true;
							geometry.normalsNeedUpdate = true;
							geometry.tangentsNeedUpdate = true;
							geometry.colorsNeedUpdate = true;
						}
					}

				} 
				else if ( Std.is(geometry,BufferGeometry)) 
				{
					initDirectBuffers(cast geometry);
				}

			} 
			else if ( Std.is(object,Ribbon)) 
			{
				geometry = object.geometry;

				if (geometry.__webglVertexBuffer == null) 
				{
					createRibbonBuffers(geometry);
					initRibbonBuffers(geometry);

					geometry.verticesNeedUpdate = true;
					geometry.colorsNeedUpdate = true;
				}
			} 
			else if ( Std.is(object,Line)) 
			{
				geometry = object.geometry;

				if (geometry.__webglVertexBuffer == null) 
				{
					createLineBuffers(geometry);
					initLineBuffers(geometry, object);

					geometry.verticesNeedUpdate = true;
					geometry.colorsNeedUpdate = true;
				}
			} 
			else if ( Std.is(object,ParticleSystem)) 
			{
				geometry = object.geometry;

				if (geometry.__webglVertexBuffer == null) 
				{
					createParticleBuffers(geometry);
					initParticleBuffers(geometry, object);

					geometry.verticesNeedUpdate = true;
					geometry.colorsNeedUpdate = true;
				}
			}
		}

		if (!object.__webglActive) 
		{
			if ( Std.is(object,Mesh)) 
			{
				geometry = object.geometry;

				if ( Std.is(geometry,BufferGeometry)) 
				{
					addBuffer(scene.__webglObjects, geometry, object);
				} 
				else 
				{
					for (g in geometry.geometryGroups ) 
					{
						geometryGroup = geometry.geometryGroups[g];

						addBuffer(scene.__webglObjects, geometryGroup, object);
					}
				}

			} 
			else if ( Std.is(object, Ribbon) || 
					Std.is(object, Line) || 
					Std.is(object,ParticleSystem)) 
			{
				geometry = object.geometry;
				addBuffer(scene.__webglObjects, geometry, object);
			} 
			else if ( Std.is(object, ImmediateRenderObject) || 
					object.immediateRenderCallback != null) 
			{
				addBufferImmediate(scene.__webglObjectsImmediate, object);
			}
			else if ( Std.is(object,Sprite))
			{
				scene.__webglSprites.push(object);
			} 
			else if ( Std.is(object,LensFlare)) 
			{
				scene.__webglFlares.push(object);
			}

			object.__webglActive = true;
		}
	}

	public function addBuffer(objlist:Array<Dynamic>, buffer:Dynamic, object:Dynamic):Void
	{
		objlist.push({
			buffer : buffer,
			object : object,
			opaque : null,
			transparent : null
		});
	}

	public function addBufferImmediate(objlist:Array<Dynamic>, object:Dynamic):Void
	{
		objlist.push({
			object : object,
			opaque : null,
			transparent : null
		});
	}
	
	// Buffer initialization

	private function initCustomAttributes(geometry:Geometry, object:Object3D):Void
	{
		var nvertices:Int = geometry.vertices.length;

		var material:Material = object.material;

		if (material.attributes != null) 
		{
			if (geometry.__webglCustomAttributesList == null) 
			{
				geometry.__webglCustomAttributesList = [];
			}

			var fileds:Array<String> = Type.getClassFields(material.attributes);
			for (a in fileds ) 
			{
				var attribute:Dynamic = untyped material.attributes[a];

				if (!attribute.__webglInitialized || attribute.createUniqueBuffers) 
				{
					attribute.__webglInitialized = true;

					var size = 1;
					// "f" and "i"

					if (attribute.type == "v2")
						size = 2;
					else if (attribute.type == "v3")
						size = 3;
					else if (attribute.type == "v4")
						size = 4;
					else if (attribute.type == "c")
						size = 3;

					attribute.size = size;

					attribute.array = new Float32Array(nvertices * size);

					attribute.buffer = gl.createBuffer();
					attribute.buffer.belongsToAttribute = a;

					attribute.needsUpdate = true;

				}
				geometry.__webglCustomAttributesList.push(attribute);
			}
		}
	}

	private function initParticleBuffers(geometry, object):Void
	{
		var nvertices = geometry.vertices.length;

		geometry.__vertexArray = new Float32Array(nvertices * 3);
		geometry.__colorArray = new Float32Array(nvertices * 3);

		geometry.__sortArray = [];

		geometry.__webglParticleCount = nvertices;

		initCustomAttributes(geometry, object);
	}

	private function initLineBuffers(geometry, object):Void
	{
		var nvertices = geometry.vertices.length;

		geometry.__vertexArray = new Float32Array(nvertices * 3);
		geometry.__colorArray = new Float32Array(nvertices * 3);

		geometry.__webglLineCount = nvertices;

		initCustomAttributes(geometry, object);

	}

	private function initRibbonBuffers(geometry):Void
	{
		var nvertices = geometry.vertices.length;

		geometry.__vertexArray = new Float32Array(nvertices * 3);
		geometry.__colorArray = new Float32Array(nvertices * 3);

		geometry.__webglVertexCount = nvertices;
	}

	private function initMeshBuffers(geometryGroup:Dynamic, object:Object3D):Void
	{
		var geometry:Geometry = object.geometry, 
		faces3 = geometryGroup.faces3, 
		faces4 = geometryGroup.faces4, 
		nvertices = faces3.length * 3 + faces4.length * 4, 
		ntris = faces3.length * 1 + faces4.length * 2, 
		nlines = faces3.length * 3 + faces4.length * 4, 
		material = getBufferMaterial(object, geometryGroup), 
		uvType = bufferGuessUVType(material), 
		normalType = bufferGuessNormalType(material), 
		vertexColorType = bufferGuessVertexColorType(material);

		//console.log( "uvType", uvType, "normalType", normalType, "vertexColorType",
		// vertexColorType, object, geometryGroup, material );

		geometryGroup.__vertexArray = new Float32Array(nvertices * 3);

		if (normalType > 0) 
		{
			geometryGroup.__normalArray = new Float32Array(nvertices * 3);
		}

		if (geometry.hasTangents) 
		{
			geometryGroup.__tangentArray = new Float32Array(nvertices * 4);
		}

		if (vertexColorType) 
		{
			geometryGroup.__colorArray = new Float32Array(nvertices * 3);
		}

		if (uvType) 
		{
			if (geometry.faceUvs.length > 0 || geometry.faceVertexUvs.length > 0) 
			{
				geometryGroup.__uvArray = new Float32Array(nvertices * 2);
			}

			if (geometry.faceUvs.length > 1 || geometry.faceVertexUvs.length > 1)
			{
				geometryGroup.__uv2Array = new Float32Array(nvertices * 2);
			}
		}

		if (object.geometry.skinWeights.length > 0 && object.geometry.skinIndices.length > 0)
		{
			geometryGroup.__skinVertexAArray = new Float32Array(nvertices * 4);
			geometryGroup.__skinVertexBArray = new Float32Array(nvertices * 4);
			geometryGroup.__skinIndexArray = new Float32Array(nvertices * 4);
			geometryGroup.__skinWeightArray = new Float32Array(nvertices * 4);
		}

		geometryGroup.__faceArray = new Uint16Array(ntris * 3);
		geometryGroup.__lineArray = new Uint16Array(nlines * 2);

		if (geometryGroup.numMorphTargets > 0) 
		{
			geometryGroup.__morphTargetsArrays = [];

			for ( m in 0...geometryGroup.numMorphTargets) 
			{
				geometryGroup.__morphTargetsArrays.push(new Float32Array(nvertices * 3));
			}
		}

		if (geometryGroup.numMorphNormals > 0) 
		{
			geometryGroup.__morphNormalsArrays = [];

			for ( m in 0...geometryGroup.numMorphNormals) 
			{
				geometryGroup.__morphNormalsArrays.push(new Float32Array(nvertices * 3));
			}

		}

		geometryGroup.__webglFaceCount = ntris * 3;
		geometryGroup.__webglLineCount = nlines * 2;

		// custom attributes

		if (material.attributes != null) 
		{
			if (geometryGroup.__webglCustomAttributesList == null) 
			{
				geometryGroup.__webglCustomAttributesList = [];
			}

			var fileds:Array<String> = Type.getClassFields(material.attributes);
			for ( a in fileds ) 
			{
				// Do a shallow copy of the attribute object so different geometryGroup chunks
				// use different
				// attribute buffers which are correctly indexed in the setMeshBuffers function

				var originalAttribute:Dynamic = untyped material.attributes[a];

				var attribute:Dynamic = {};

				var oFileds:Array<String> = Type.getClassFields(originalAttribute);
				for (property in oFileds ) 
				{
					untyped attribute[property] = originalAttribute[property];
				}

				if (!attribute.__webglInitialized || attribute.createUniqueBuffers) 
				{

					attribute.__webglInitialized = true;

					var size = 1;
					// "f" and "i"

					if (attribute.type == "v2")
						size = 2;
					else if (attribute.type == "v3")
						size = 3;
					else if (attribute.type == "v4")
						size = 4;
					else if (attribute.type == "c")
						size = 3;

					attribute.size = size;

					attribute.array = new Float32Array(nvertices * size);

					attribute.buffer = gl.createBuffer();
					attribute.buffer.belongsToAttribute = a;

					originalAttribute.needsUpdate = true;
					attribute.__original = originalAttribute;

				}

				geometryGroup.__webglCustomAttributesList.push(attribute);

			}

		}

		geometryGroup.__inittedArrays = true;

	}

	public function  getBufferMaterial(object:Object3D, geometryGroup:Dynamic):Material
	{
		if (object.material != null && !(Std.is(object.material, MeshFaceMaterial))) 
		{
			return object.material;
		} 
		else if (geometryGroup.materialIndex >= 0) 
		{
			return object.geometry.materials[geometryGroup.materialIndex];
		}
		
		return null;
	}

	public function materialNeedsSmoothNormals(material:Material):Bool 
	{
		return material != null && material.shading == ThreeGlobal.SmoothShading;
	}

	public function bufferGuessNormalType(material:Material):Int 
	{
		// only MeshBasicMaterial and MeshDepthMaterial don't need normals
		if ((Std.is(material, MeshBasicMaterial) && material.envMap != null ) || 
			Std.is(material, MeshDepthMaterial)) 
		{
			return 0;
		}

		if (materialNeedsSmoothNormals(material)) 
		{
			return ThreeGlobal.SmoothShading;
		} 
		else 
		{
			return ThreeGlobal.FlatShading;
		}
	}

	public function bufferGuessVertexColorType(material:Material):Bool
	{
		if (material.vertexColors != null) 
		{
			return true;
		}
		return false;
	}

	public function bufferGuessUVType(material:Material):Bool 
	{
		// material must use some texture to require uvs

		if (material.map != null || 
			material.lightMap != null || 
			material.bumpMap != null  || 
			material.specularMap != null || 
			Std.is(material, ShaderMaterial)) 
		{
			return true;
		}

		return false;
	}

	//
	public function initDirectBuffers(geometry:BufferGeometry):Void 
	{
		var type:GLenum;
		
		var fields:Array<String> = Type.getClassFields(geometry.attributes);
		for (a in fields) 
		{
			if (a == "index") 
			{
				type = gl.ELEMENT_ARRAY_BUFFER;
			}
			else 
			{
				type = gl.ARRAY_BUFFER;
			}

			var attribute:Dynamic = untyped geometry.attributes[a];

			attribute.buffer = gl.createBuffer();
			gl.bindBuffer(type, attribute.buffer);
			gl.bufferData(type, attribute.array, gl.STATIC_DRAW);
		}
	}

	// Buffer setting

	public function  setParticleBuffers(geometry:Geometry, hint:Int, object:Object3D):Void 
	{
		var v, c, vertex, offset, index, color, vertices = geometry.vertices, vl = vertices.length, colors = geometry.colors, cl = colors.length, vertexArray = geometry.__vertexArray, colorArray = geometry.__colorArray, sortArray = geometry.__sortArray, dirtyVertices = geometry.verticesNeedUpdate, dirtyElements = geometry.elementsNeedUpdate, dirtyColors = geometry.colorsNeedUpdate, customAttributes = geometry.__webglCustomAttributesList, i, il, a, ca, cal, value, customAttribute;

		if (object.sortParticles) 
		{
			_projScreenMatrixPS.copy(_projScreenMatrix);
			_projScreenMatrixPS.multiplySelf(object.matrixWorld);

			for ( v in 0...vl) 
			{
				vertex = vertices[v];

				_vector3.copy(vertex);
				_projScreenMatrixPS.multiplyVector3(_vector3);

				sortArray[v] = [_vector3.z, v];
			}

			sortArray.sort(function(a, b) {
				return b[0] - a[0];
			});

			for ( v in 0...vl) 
			{
				vertex = vertices[sortArray[v][1]];

				offset = v * 3;

				vertexArray[offset] = vertex.x;
				vertexArray[offset + 1] = vertex.y;
				vertexArray[offset + 2] = vertex.z;

			}

			for ( c in 0...cl) 
			{
				offset = c * 3;

				color = colors[sortArray[c][1]];

				colorArray[offset] = color.r;
				colorArray[offset + 1] = color.g;
				colorArray[offset + 2] = color.b;

			}

			var customAttributeArray:Dynamic;
			if (customAttributes != null)
			{
				for ( i in 0...customAttributes.length) 
				{
					customAttribute = customAttributes[i];

					if (!(customAttribute.boundTo == null || 
						customAttribute.boundTo == "vertices" ))
						continue;

					offset = 0;

					cal = customAttribute.value.length;

					if (customAttribute.size == 1) 
					{
						for ( ca in 0...cal)
						{
							index = sortArray[ ca ][1];

							customAttributeArray[ca] = customAttribute.value[index];
						}

					} else if (customAttribute.size == 2) 
					{
						for ( ca in 0...cal) 
						{
							index = sortArray[ ca ][1];

							value = customAttribute.value[index];

							customAttributeArray[offset] = value.x;
							customAttributeArray[offset + 1] = value.y;

							offset += 2;

						}
					} 
					else if (customAttribute.size == 3) 
					{
						if (customAttribute.type == "c") 
						{
							for ( ca in 0...cal)
							{
								index = sortArray[ ca ][1];

								value = customAttribute.value[index];

								customAttributeArray[offset] = value.r;
								customAttributeArray[offset + 1] = value.g;
								customAttributeArray[offset + 2] = value.b;

								offset += 3;
							}
						} 
						else 
						{
							for ( ca in 0...cal) 
							{
								index = sortArray[ ca ][1];

								value = customAttribute.value[index];

								customAttributeArray[offset] = value.x;
								customAttributeArray[offset + 1] = value.y;
								customAttributeArray[offset + 2] = value.z;

								offset += 3;
							}
						}

					} 
					else if (customAttribute.size == 4) 
					{
						for ( ca in 0...cal) 
						{
							index = sortArray[ ca ][1];

							value = customAttribute.value[index];

							customAttributeArray[offset] = value.x;
							customAttributeArray[offset + 1] = value.y;
							customAttributeArray[offset + 2] = value.z;
							customAttributeArray[offset + 3] = value.w;

							offset += 4;
						}
					}
				}
			}
		} 
		else 
		{
			if (dirtyVertices) 
			{
				for ( v in 0...vl) 
				{
					vertex = vertices[v];

					offset = v * 3;

					vertexArray[offset] = vertex.x;
					vertexArray[offset + 1] = vertex.y;
					vertexArray[offset + 2] = vertex.z;
				}

			}

			if (dirtyColors) 
			{
				for ( c in 0...cl) 
				{
					color = colors[c];

					offset = c * 3;

					colorArray[offset] = color.r;
					colorArray[offset + 1] = color.g;
					colorArray[offset + 2] = color.b;
				}
			}

			if (customAttributes) 
			{
				for ( i in 0...customAttributes.length) 
				{
					customAttribute = customAttributes[i];

					if (customAttribute.needsUpdate && 
						(customAttribute.boundTo == null || 
						customAttribute.boundTo == "vertices")) 
					{

						cal = customAttribute.value.length;

						offset = 0;

						if (customAttribute.size == 1) 
						{
							for ( ca in 0...cal) 
							{
								customAttributeArray[ca] = customAttribute.value[ca];
							}
						} 
						else if (customAttribute.size == 2) 
						{
							for ( ca in 0...cal) 
							{
								value = customAttribute.value[ca];

								customAttributeArray[offset] = value.x;
								customAttributeArray[offset + 1] = value.y;

								offset += 2;
							}
						} 
						else if (customAttribute.size == 3) 
						{
							if (customAttribute.type == "c") 
							{
								for ( ca in 0...cal) 
								{
									value = customAttribute.value[ca];

									customAttributeArray[offset] = value.r;
									customAttributeArray[offset + 1] = value.g;
									customAttributeArray[offset + 2] = value.b;

									offset += 3;
								}
							} 
							else 
							{
								for ( ca in 0...cal) 
								{
									value = customAttribute.value[ca];

									customAttributeArray[offset] = value.x;
									customAttributeArray[offset + 1] = value.y;
									customAttributeArray[offset + 2] = value.z;

									offset += 3;
								}
							}
						} 
						else if (customAttribute.size == 4) 
						{
							for ( ca in 0...cal) 
							{
								value = customAttribute.value[ca];

								customAttributeArray[offset] = value.x;
								customAttributeArray[offset + 1] = value.y;
								customAttributeArray[offset + 2] = value.z;
								customAttributeArray[offset + 3] = value.w;

								offset += 4;
							}
						}
					}
				}
			}
		}

		if (dirtyVertices || object.sortParticles) 
		{
			gl.bindBuffer(gl.ARRAY_BUFFER, geometry.__webglVertexBuffer);
			gl.bufferData(gl.ARRAY_BUFFER, vertexArray, hint);
		}

		if (dirtyColors || object.sortParticles) 
		{
			gl.bindBuffer(gl.ARRAY_BUFFER, geometry.__webglColorBuffer);
			gl.bufferData(gl.ARRAY_BUFFER, colorArray, hint);
		}

		if (customAttributes) 
		{
			for ( i in 0...customAttributes.length) 
			{
				customAttribute = customAttributes[i];

				if (customAttribute.needsUpdate || object.sortParticles)
				{
					gl.bindBuffer(gl.ARRAY_BUFFER, customAttribute.buffer);
					gl.bufferData(gl.ARRAY_BUFFER, customAttributeArray, hint);
				}
			}
		}
	}

	public function setLineBuffers(geometry, hint):Void 
	{
		var v, c, vertex, offset, color, vertices = geometry.vertices, colors = geometry.colors, vl = vertices.length, cl = colors.length, vertexArray = geometry.__vertexArray, colorArray = geometry.__colorArray, dirtyVertices = geometry.verticesNeedUpdate, dirtyColors = geometry.colorsNeedUpdate, customAttributes = geometry.__webglCustomAttributesList, i, il, a, ca, cal, value, customAttribute;

		if (dirtyVertices) 
		{
			for ( v in 0...vl) 
			{
				vertex = vertices[v];

				offset = v * 3;
				vertexArray[offset] = vertex.x;
				vertexArray[offset + 1] = vertex.y;
				vertexArray[offset + 2] = vertex.z;
			}
			gl.bindBuffer(gl.ARRAY_BUFFER, geometry.__webglVertexBuffer);
			gl.bufferData(gl.ARRAY_BUFFER, vertexArray, hint);
		}

		if (dirtyColors)
		{
			for ( c in 0...cl) 
			{
				color = colors[c];

				offset = c * 3;

				colorArray[offset] = color.r;
				colorArray[offset + 1] = color.g;
				colorArray[offset + 2] = color.b;

			}

			gl.bindBuffer(gl.ARRAY_BUFFER, geometry.__webglColorBuffer);
			gl.bufferData(gl.ARRAY_BUFFER, colorArray, hint);
		}

		if (customAttributes) {

			for ( i in 0...customAttributes.length) 
			{
				customAttribute = customAttributes[i];

				if (customAttribute.needsUpdate && 
					(customAttribute.boundTo == null || 
					customAttribute.boundTo == "vertices" )) 
				{

					offset = 0;

					cal = customAttribute.value.length;

					if (customAttribute.size == 1) 
					{
						for ( ca in 0...cal) 
						{
							customAttributeArray[ca] = customAttribute.value[ca];
						}
					} 
					else if (customAttribute.size == 2) 
					{
						for ( ca in 0...cal) 
						{
							value = customAttribute.value[ca];

							customAttributeArray[offset] = value.x;
							customAttributeArray[offset + 1] = value.y;

							offset += 2;
						}
					} 
					else if (customAttribute.size == 3) 
					{
						if (customAttribute.type == "c") 
						{
							for ( ca in 0...cal) 
							{
								value = customAttribute.value[ca];

								customAttributeArray[offset] = value.r;
								customAttributeArray[offset + 1] = value.g;
								customAttributeArray[offset + 2] = value.b;

								offset += 3;
							}
						} 
						else 
						{
							for ( ca in 0...cal) 
							{
								value = customAttribute.value[ca];

								customAttributeArray[offset] = value.x;
								customAttributeArray[offset + 1] = value.y;
								customAttributeArray[offset + 2] = value.z;

								offset += 3;
							}
						}
					} 
					else if (customAttribute.size == 4) 
					{
						for ( ca in 0...cal) 
						{
							value = customAttribute.value[ca];

							customAttributeArray[offset] = value.x;
							customAttributeArray[offset + 1] = value.y;
							customAttributeArray[offset + 2] = value.z;
							customAttributeArray[offset + 3] = value.w;

							offset += 4;

						}

					}

					gl.bindBuffer(gl.ARRAY_BUFFER, customAttribute.buffer);
					gl.bufferData(gl.ARRAY_BUFFER, customAttributeArray, hint);
				}
			}

		}
	}

	public function  setRibbonBuffers(geometry, hint):Void 
	{
		var v, c, vertex, offset, color, vertices = geometry.vertices, colors = geometry.colors, vl = vertices.length, cl = colors.length, vertexArray = geometry.__vertexArray, colorArray = geometry.__colorArray, dirtyVertices = geometry.verticesNeedUpdate, dirtyColors = geometry.colorsNeedUpdate;

		if (dirtyVertices) 
		{
			for ( v in 0...vl) 
			{
				vertex = vertices[v];

				offset = v * 3;

				vertexArray[offset] = vertex.x;
				vertexArray[offset + 1] = vertex.y;
				vertexArray[offset + 2] = vertex.z;

			}

			gl.bindBuffer(gl.ARRAY_BUFFER, geometry.__webglVertexBuffer);
			gl.bufferData(gl.ARRAY_BUFFER, vertexArray, hint);
		}

		if (dirtyColors)
		{
			for ( c in 0...cl) 
			{
				color = colors[c];

				offset = c * 3;

				colorArray[offset] = color.r;
				colorArray[offset + 1] = color.g;
				colorArray[offset + 2] = color.b;

			}

			gl.bindBuffer(gl.ARRAY_BUFFER, geometry.__webglColorBuffer);
			gl.bufferData(gl.ARRAY_BUFFER, colorArray, hint);
		}
	}

	public function setMeshBuffers(geometryGroup, object, hint, dispose, material):Void 
	{
		if (!geometryGroup.__inittedArrays) 
		{
			// console.log( object );
			return;
		}

		var normalType = bufferGuessNormalType(material), vertexColorType = bufferGuessVertexColorType(material), uvType = bufferGuessUVType(material), needsSmoothNormals = (normalType == ThreeGlobal.SmoothShading );

		var fi, face, 
		vertexNormals, faceNormal, normal, 
		vertexColors, faceColor, vertexTangents, 
		uv, uv2, v1, v2, v3, v4, 
		t1, t2, t3, t4, 
		n1, n2, n3, n4, 
		c1, c2, c3, c4, 
		sw1, sw2, sw3, sw4, 
		si1, si2, si3, si4, 
		sa1, sa2, sa3, sa4, 
		sb1, sb2, sb3, sb4, 
		m, ml, i, il, vn, 
		uvi, uv2i, 
		vk, vkl, 
		vka, nka, 
		chf, 
		faceVertexNormals, 
		a, 
		vertexIndex = 0, 
		offset = 0, 
		offset_uv = 0, 
		offset_uv2 = 0, 
		offset_face = 0, 
		offset_normal = 0, 
		offset_tangent = 0, 
		offset_line = 0, 
		offset_color = 0, 
		offset_skin = 0, 
		offset_morphTarget = 0, 
		offset_custom = 0, 
		offset_customSrc = 0, 
		value:Array<Dynamic>, 
		vertexArray = geometryGroup.__vertexArray, 
		uvArray = geometryGroup.__uvArray, 
		uv2Array = geometryGroup.__uv2Array, 
		normalArray = geometryGroup.__normalArray, 
		tangentArray = geometryGroup.__tangentArray, 
		colorArray = geometryGroup.__colorArray, 
		skinVertexAArray = geometryGroup.__skinVertexAArray,
		skinVertexBArray = geometryGroup.__skinVertexBArray, 
		skinIndexArray = geometryGroup.__skinIndexArray, 
		skinWeightArray = geometryGroup.__skinWeightArray, 
		morphTargetsArrays = geometryGroup.__morphTargetsArrays, 
		morphNormalsArrays = geometryGroup.__morphNormalsArrays, 
		customAttributes = geometryGroup.__webglCustomAttributesList, 
		faceArray = geometryGroup.__faceArray, 
		lineArray = geometryGroup.__lineArray, 
		geometry = object.geometry,
		// // this is shared for all chunks

		dirtyVertices = geometry.verticesNeedUpdate, 
		dirtyElements = geometry.elementsNeedUpdate, 
		dirtyUvs = geometry.uvsNeedUpdate, 
		dirtyNormals = geometry.normalsNeedUpdate, 
		dirtyTangents = geometry.tangentsNeedUpdate, 
		dirtyColors = geometry.colorsNeedUpdate, 
		dirtyMorphTargets = geometry.morphTargetsNeedUpdate, 
		vertices = geometry.vertices, 
		chunk_faces3 = geometryGroup.faces3, 
		chunk_faces4 = geometryGroup.faces4, 
		obj_faces = geometry.faces, 
		obj_uvs = geometry.faceVertexUvs[0], 
		obj_uvs2 = geometry.faceVertexUvs[1], 
		obj_colors = geometry.colors, 
		obj_skinVerticesA = geometry.skinVerticesA, 
		obj_skinVerticesB = geometry.skinVerticesB, 
		obj_skinIndices = geometry.skinIndices, 
		obj_skinWeights = geometry.skinWeights, 
		morphTargets = geometry.morphTargets, 
		morphNormals = geometry.morphNormals;

		if (dirtyVertices) 
		{
			for ( f in 0...chunk_faces3.length) 
			{
				face = obj_faces[chunk_faces3[f]];

				v1 = vertices[face.a];
				v2 = vertices[face.b];
				v3 = vertices[face.c];

				vertexArray[offset] = v1.x;
				vertexArray[offset + 1] = v1.y;
				vertexArray[offset + 2] = v1.z;

				vertexArray[offset + 3] = v2.x;
				vertexArray[offset + 4] = v2.y;
				vertexArray[offset + 5] = v2.z;

				vertexArray[offset + 6] = v3.x;
				vertexArray[offset + 7] = v3.y;
				vertexArray[offset + 8] = v3.z;

				offset += 9;

			}

			for ( f in 0..chunk_faces4.length) 
			{
				face = obj_faces[chunk_faces4[f]];

				v1 = vertices[face.a];
				v2 = vertices[face.b];
				v3 = vertices[face.c];
				v4 = vertices[face.d];

				vertexArray[offset] = v1.x;
				vertexArray[offset + 1] = v1.y;
				vertexArray[offset + 2] = v1.z;

				vertexArray[offset + 3] = v2.x;
				vertexArray[offset + 4] = v2.y;
				vertexArray[offset + 5] = v2.z;

				vertexArray[offset + 6] = v3.x;
				vertexArray[offset + 7] = v3.y;
				vertexArray[offset + 8] = v3.z;

				vertexArray[offset + 9] = v4.x;
				vertexArray[offset + 10] = v4.y;
				vertexArray[offset + 11] = v4.z;

				offset += 12;

			}

			gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglVertexBuffer);
			gl.bufferData(gl.ARRAY_BUFFER, vertexArray, hint);
		}

		if (dirtyMorphTargets) 
		{

			for ( vk in 0..morphTargets.length) 
			{
				offset_morphTarget = 0;

				for ( f in 0..chunk_faces3.length) 
				{
					chf = chunk_faces3[f];
					face = obj_faces[chf];

					// morph positions

					v1 = morphTargets[ vk ].vertices[face.a];
					v2 = morphTargets[ vk ].vertices[face.b];
					v3 = morphTargets[ vk ].vertices[face.c];

					vka = morphTargetsArrays[vk];

					vka[offset_morphTarget] = v1.x;
					vka[offset_morphTarget + 1] = v1.y;
					vka[offset_morphTarget + 2] = v1.z;

					vka[offset_morphTarget + 3] = v2.x;
					vka[offset_morphTarget + 4] = v2.y;
					vka[offset_morphTarget + 5] = v2.z;

					vka[offset_morphTarget + 6] = v3.x;
					vka[offset_morphTarget + 7] = v3.y;
					vka[offset_morphTarget + 8] = v3.z;

					// morph normals

					if (material.morphNormals) 
					{
						if (needsSmoothNormals) 
						{
							faceVertexNormals = morphNormals[ vk ].vertexNormals[chf];

							n1 = faceVertexNormals.a;
							n2 = faceVertexNormals.b;
							n3 = faceVertexNormals.c;

						}
						else 
						{
							n1 = morphNormals[ vk ].faceNormals[chf];
							n2 = n1;
							n3 = n1;

						}

						nka = morphNormalsArrays[vk];

						nka[offset_morphTarget] = n1.x;
						nka[offset_morphTarget + 1] = n1.y;
						nka[offset_morphTarget + 2] = n1.z;

						nka[offset_morphTarget + 3] = n2.x;
						nka[offset_morphTarget + 4] = n2.y;
						nka[offset_morphTarget + 5] = n2.z;

						nka[offset_morphTarget + 6] = n3.x;
						nka[offset_morphTarget + 7] = n3.y;
						nka[offset_morphTarget + 8] = n3.z;

					}

					//

					offset_morphTarget += 9;

				}

				for ( f in 0..chunk_faces4.length) 
				{
					chf = chunk_faces4[f];
					face = obj_faces[chf];

					// morph positions

					v1 = morphTargets[ vk ].vertices[face.a];
					v2 = morphTargets[ vk ].vertices[face.b];
					v3 = morphTargets[ vk ].vertices[face.c];
					v4 = morphTargets[ vk ].vertices[face.d];

					vka = morphTargetsArrays[vk];

					vka[offset_morphTarget] = v1.x;
					vka[offset_morphTarget + 1] = v1.y;
					vka[offset_morphTarget + 2] = v1.z;

					vka[offset_morphTarget + 3] = v2.x;
					vka[offset_morphTarget + 4] = v2.y;
					vka[offset_morphTarget + 5] = v2.z;

					vka[offset_morphTarget + 6] = v3.x;
					vka[offset_morphTarget + 7] = v3.y;
					vka[offset_morphTarget + 8] = v3.z;

					vka[offset_morphTarget + 9] = v4.x;
					vka[offset_morphTarget + 10] = v4.y;
					vka[offset_morphTarget + 11] = v4.z;

					// morph normals

					if (material.morphNormals) 
					{
						if (needsSmoothNormals)
						{
							faceVertexNormals = morphNormals[ vk ].vertexNormals[chf];

							n1 = faceVertexNormals.a;
							n2 = faceVertexNormals.b;
							n3 = faceVertexNormals.c;
							n4 = faceVertexNormals.d;

						} 
						else 
						{
							n1 = morphNormals[ vk ].faceNormals[chf];
							n2 = n1;
							n3 = n1;
							n4 = n1;

						}

						nka = morphNormalsArrays[vk];

						nka[offset_morphTarget] = n1.x;
						nka[offset_morphTarget + 1] = n1.y;
						nka[offset_morphTarget + 2] = n1.z;

						nka[offset_morphTarget + 3] = n2.x;
						nka[offset_morphTarget + 4] = n2.y;
						nka[offset_morphTarget + 5] = n2.z;

						nka[offset_morphTarget + 6] = n3.x;
						nka[offset_morphTarget + 7] = n3.y;
						nka[offset_morphTarget + 8] = n3.z;

						nka[offset_morphTarget + 9] = n4.x;
						nka[offset_morphTarget + 10] = n4.y;
						nka[offset_morphTarget + 11] = n4.z;

					}

					//

					offset_morphTarget += 12;
				}

				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[vk]);
				gl.bufferData(gl.ARRAY_BUFFER, morphTargetsArrays[vk], hint);

				if (material.morphNormals) 
				{
					gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglMorphNormalsBuffers[vk]);
					gl.bufferData(gl.ARRAY_BUFFER, morphNormalsArrays[vk], hint);
				}

			}
		}

		if (obj_skinWeights.length) 
		{
			for ( f in 0..chunk_faces3.length) 
			{
				face = obj_faces[chunk_faces3[f]];

				// weights

				sw1 = obj_skinWeights[face.a];
				sw2 = obj_skinWeights[face.b];
				sw3 = obj_skinWeights[face.c];

				skinWeightArray[offset_skin] = sw1.x;
				skinWeightArray[offset_skin + 1] = sw1.y;
				skinWeightArray[offset_skin + 2] = sw1.z;
				skinWeightArray[offset_skin + 3] = sw1.w;

				skinWeightArray[offset_skin + 4] = sw2.x;
				skinWeightArray[offset_skin + 5] = sw2.y;
				skinWeightArray[offset_skin + 6] = sw2.z;
				skinWeightArray[offset_skin + 7] = sw2.w;

				skinWeightArray[offset_skin + 8] = sw3.x;
				skinWeightArray[offset_skin + 9] = sw3.y;
				skinWeightArray[offset_skin + 10] = sw3.z;
				skinWeightArray[offset_skin + 11] = sw3.w;

				// indices

				si1 = obj_skinIndices[face.a];
				si2 = obj_skinIndices[face.b];
				si3 = obj_skinIndices[face.c];

				skinIndexArray[offset_skin] = si1.x;
				skinIndexArray[offset_skin + 1] = si1.y;
				skinIndexArray[offset_skin + 2] = si1.z;
				skinIndexArray[offset_skin + 3] = si1.w;

				skinIndexArray[offset_skin + 4] = si2.x;
				skinIndexArray[offset_skin + 5] = si2.y;
				skinIndexArray[offset_skin + 6] = si2.z;
				skinIndexArray[offset_skin + 7] = si2.w;

				skinIndexArray[offset_skin + 8] = si3.x;
				skinIndexArray[offset_skin + 9] = si3.y;
				skinIndexArray[offset_skin + 10] = si3.z;
				skinIndexArray[offset_skin + 11] = si3.w;

				// vertices A

				sa1 = obj_skinVerticesA[face.a];
				sa2 = obj_skinVerticesA[face.b];
				sa3 = obj_skinVerticesA[face.c];

				skinVertexAArray[offset_skin] = sa1.x;
				skinVertexAArray[offset_skin + 1] = sa1.y;
				skinVertexAArray[offset_skin + 2] = sa1.z;
				skinVertexAArray[offset_skin + 3] = 1;
				// pad for faster vertex shader

				skinVertexAArray[offset_skin + 4] = sa2.x;
				skinVertexAArray[offset_skin + 5] = sa2.y;
				skinVertexAArray[offset_skin + 6] = sa2.z;
				skinVertexAArray[offset_skin + 7] = 1;

				skinVertexAArray[offset_skin + 8] = sa3.x;
				skinVertexAArray[offset_skin + 9] = sa3.y;
				skinVertexAArray[offset_skin + 10] = sa3.z;
				skinVertexAArray[offset_skin + 11] = 1;

				// vertices B

				sb1 = obj_skinVerticesB[face.a];
				sb2 = obj_skinVerticesB[face.b];
				sb3 = obj_skinVerticesB[face.c];

				skinVertexBArray[offset_skin] = sb1.x;
				skinVertexBArray[offset_skin + 1] = sb1.y;
				skinVertexBArray[offset_skin + 2] = sb1.z;
				skinVertexBArray[offset_skin + 3] = 1;
				// pad for faster vertex shader

				skinVertexBArray[offset_skin + 4] = sb2.x;
				skinVertexBArray[offset_skin + 5] = sb2.y;
				skinVertexBArray[offset_skin + 6] = sb2.z;
				skinVertexBArray[offset_skin + 7] = 1;

				skinVertexBArray[offset_skin + 8] = sb3.x;
				skinVertexBArray[offset_skin + 9] = sb3.y;
				skinVertexBArray[offset_skin + 10] = sb3.z;
				skinVertexBArray[offset_skin + 11] = 1;

				offset_skin += 12;

			}

			for ( f in 0..chunk_faces4.length) 
			{
				face = obj_faces[chunk_faces4[f]];

				// weights

				sw1 = obj_skinWeights[face.a];
				sw2 = obj_skinWeights[face.b];
				sw3 = obj_skinWeights[face.c];
				sw4 = obj_skinWeights[face.d];

				skinWeightArray[offset_skin] = sw1.x;
				skinWeightArray[offset_skin + 1] = sw1.y;
				skinWeightArray[offset_skin + 2] = sw1.z;
				skinWeightArray[offset_skin + 3] = sw1.w;

				skinWeightArray[offset_skin + 4] = sw2.x;
				skinWeightArray[offset_skin + 5] = sw2.y;
				skinWeightArray[offset_skin + 6] = sw2.z;
				skinWeightArray[offset_skin + 7] = sw2.w;

				skinWeightArray[offset_skin + 8] = sw3.x;
				skinWeightArray[offset_skin + 9] = sw3.y;
				skinWeightArray[offset_skin + 10] = sw3.z;
				skinWeightArray[offset_skin + 11] = sw3.w;

				skinWeightArray[offset_skin + 12] = sw4.x;
				skinWeightArray[offset_skin + 13] = sw4.y;
				skinWeightArray[offset_skin + 14] = sw4.z;
				skinWeightArray[offset_skin + 15] = sw4.w;

				// indices

				si1 = obj_skinIndices[face.a];
				si2 = obj_skinIndices[face.b];
				si3 = obj_skinIndices[face.c];
				si4 = obj_skinIndices[face.d];

				skinIndexArray[offset_skin] = si1.x;
				skinIndexArray[offset_skin + 1] = si1.y;
				skinIndexArray[offset_skin + 2] = si1.z;
				skinIndexArray[offset_skin + 3] = si1.w;

				skinIndexArray[offset_skin + 4] = si2.x;
				skinIndexArray[offset_skin + 5] = si2.y;
				skinIndexArray[offset_skin + 6] = si2.z;
				skinIndexArray[offset_skin + 7] = si2.w;

				skinIndexArray[offset_skin + 8] = si3.x;
				skinIndexArray[offset_skin + 9] = si3.y;
				skinIndexArray[offset_skin + 10] = si3.z;
				skinIndexArray[offset_skin + 11] = si3.w;

				skinIndexArray[offset_skin + 12] = si4.x;
				skinIndexArray[offset_skin + 13] = si4.y;
				skinIndexArray[offset_skin + 14] = si4.z;
				skinIndexArray[offset_skin + 15] = si4.w;

				// vertices A

				sa1 = obj_skinVerticesA[face.a];
				sa2 = obj_skinVerticesA[face.b];
				sa3 = obj_skinVerticesA[face.c];
				sa4 = obj_skinVerticesA[face.d];

				skinVertexAArray[offset_skin] = sa1.x;
				skinVertexAArray[offset_skin + 1] = sa1.y;
				skinVertexAArray[offset_skin + 2] = sa1.z;
				skinVertexAArray[offset_skin + 3] = 1;
				// pad for faster vertex shader

				skinVertexAArray[offset_skin + 4] = sa2.x;
				skinVertexAArray[offset_skin + 5] = sa2.y;
				skinVertexAArray[offset_skin + 6] = sa2.z;
				skinVertexAArray[offset_skin + 7] = 1;

				skinVertexAArray[offset_skin + 8] = sa3.x;
				skinVertexAArray[offset_skin + 9] = sa3.y;
				skinVertexAArray[offset_skin + 10] = sa3.z;
				skinVertexAArray[offset_skin + 11] = 1;

				skinVertexAArray[offset_skin + 12] = sa4.x;
				skinVertexAArray[offset_skin + 13] = sa4.y;
				skinVertexAArray[offset_skin + 14] = sa4.z;
				skinVertexAArray[offset_skin + 15] = 1;

				// vertices B

				sb1 = obj_skinVerticesB[face.a];
				sb2 = obj_skinVerticesB[face.b];
				sb3 = obj_skinVerticesB[face.c];
				sb4 = obj_skinVerticesB[face.d];

				skinVertexBArray[offset_skin] = sb1.x;
				skinVertexBArray[offset_skin + 1] = sb1.y;
				skinVertexBArray[offset_skin + 2] = sb1.z;
				skinVertexBArray[offset_skin + 3] = 1;
				// pad for faster vertex shader

				skinVertexBArray[offset_skin + 4] = sb2.x;
				skinVertexBArray[offset_skin + 5] = sb2.y;
				skinVertexBArray[offset_skin + 6] = sb2.z;
				skinVertexBArray[offset_skin + 7] = 1;

				skinVertexBArray[offset_skin + 8] = sb3.x;
				skinVertexBArray[offset_skin + 9] = sb3.y;
				skinVertexBArray[offset_skin + 10] = sb3.z;
				skinVertexBArray[offset_skin + 11] = 1;

				skinVertexBArray[offset_skin + 12] = sb4.x;
				skinVertexBArray[offset_skin + 13] = sb4.y;
				skinVertexBArray[offset_skin + 14] = sb4.z;
				skinVertexBArray[offset_skin + 15] = 1;

				offset_skin += 16;

			}

			if (offset_skin > 0) 
			{
				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglSkinVertexABuffer);
				gl.bufferData(gl.ARRAY_BUFFER, skinVertexAArray, hint);

				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglSkinVertexBBuffer);
				gl.bufferData(gl.ARRAY_BUFFER, skinVertexBArray, hint);

				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglSkinIndicesBuffer);
				gl.bufferData(gl.ARRAY_BUFFER, skinIndexArray, hint);

				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglSkinWeightsBuffer);
				gl.bufferData(gl.ARRAY_BUFFER, skinWeightArray, hint);

			}

		}

		if (dirtyColors && vertexColorType) {

			for ( f in 0...chunk_faces3.length) 
			{
				face = obj_faces[chunk_faces3[f]];

				vertexColors = face.vertexColors;
				faceColor = face.color;

				if (vertexColors.length == 3 && 
				vertexColorType == ThreeGlobal.VertexColors) 
				{
					c1 = vertexColors[0];
					c2 = vertexColors[1];
					c3 = vertexColors[2];
				} 
				else
				{
					c1 = faceColor;
					c2 = faceColor;
					c3 = faceColor;

				}

				colorArray[offset_color] = c1.r;
				colorArray[offset_color + 1] = c1.g;
				colorArray[offset_color + 2] = c1.b;

				colorArray[offset_color + 3] = c2.r;
				colorArray[offset_color + 4] = c2.g;
				colorArray[offset_color + 5] = c2.b;

				colorArray[offset_color + 6] = c3.r;
				colorArray[offset_color + 7] = c3.g;
				colorArray[offset_color + 8] = c3.b;

				offset_color += 9;

			}

			for ( f in 0...chunk_faces4.length) 
			{
				face = obj_faces[chunk_faces4[f]];

				vertexColors = face.vertexColors;
				faceColor = face.color;

				if (vertexColors.length == 4 && vertexColorType == ThreeGlobal.VertexColors) {

					c1 = vertexColors[0];
					c2 = vertexColors[1];
					c3 = vertexColors[2];
					c4 = vertexColors[3];

				} else {

					c1 = faceColor;
					c2 = faceColor;
					c3 = faceColor;
					c4 = faceColor;

				}

				colorArray[offset_color] = c1.r;
				colorArray[offset_color + 1] = c1.g;
				colorArray[offset_color + 2] = c1.b;

				colorArray[offset_color + 3] = c2.r;
				colorArray[offset_color + 4] = c2.g;
				colorArray[offset_color + 5] = c2.b;

				colorArray[offset_color + 6] = c3.r;
				colorArray[offset_color + 7] = c3.g;
				colorArray[offset_color + 8] = c3.b;

				colorArray[offset_color + 9] = c4.r;
				colorArray[offset_color + 10] = c4.g;
				colorArray[offset_color + 11] = c4.b;

				offset_color += 12;

			}

			if (offset_color > 0) {

				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglColorBuffer);
				gl.bufferData(gl.ARRAY_BUFFER, colorArray, hint);

			}

		}

		if (dirtyTangents && geometry.hasTangents) {

			for ( f in 0...chunk_faces3.length) 
			{
				face = obj_faces[chunk_faces3[f]];

				vertexTangents = face.vertexTangents;

				t1 = vertexTangents[0];
				t2 = vertexTangents[1];
				t3 = vertexTangents[2];

				tangentArray[offset_tangent] = t1.x;
				tangentArray[offset_tangent + 1] = t1.y;
				tangentArray[offset_tangent + 2] = t1.z;
				tangentArray[offset_tangent + 3] = t1.w;

				tangentArray[offset_tangent + 4] = t2.x;
				tangentArray[offset_tangent + 5] = t2.y;
				tangentArray[offset_tangent + 6] = t2.z;
				tangentArray[offset_tangent + 7] = t2.w;

				tangentArray[offset_tangent + 8] = t3.x;
				tangentArray[offset_tangent + 9] = t3.y;
				tangentArray[offset_tangent + 10] = t3.z;
				tangentArray[offset_tangent + 11] = t3.w;

				offset_tangent += 12;

			}

			for ( f in 0...chunk_faces4.length) 
			{
				face = obj_faces[chunk_faces4[f]];

				vertexTangents = face.vertexTangents;

				t1 = vertexTangents[0];
				t2 = vertexTangents[1];
				t3 = vertexTangents[2];
				t4 = vertexTangents[3];

				tangentArray[offset_tangent] = t1.x;
				tangentArray[offset_tangent + 1] = t1.y;
				tangentArray[offset_tangent + 2] = t1.z;
				tangentArray[offset_tangent + 3] = t1.w;

				tangentArray[offset_tangent + 4] = t2.x;
				tangentArray[offset_tangent + 5] = t2.y;
				tangentArray[offset_tangent + 6] = t2.z;
				tangentArray[offset_tangent + 7] = t2.w;

				tangentArray[offset_tangent + 8] = t3.x;
				tangentArray[offset_tangent + 9] = t3.y;
				tangentArray[offset_tangent + 10] = t3.z;
				tangentArray[offset_tangent + 11] = t3.w;

				tangentArray[offset_tangent + 12] = t4.x;
				tangentArray[offset_tangent + 13] = t4.y;
				tangentArray[offset_tangent + 14] = t4.z;
				tangentArray[offset_tangent + 15] = t4.w;

				offset_tangent += 16;

			}

			gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglTangentBuffer);
			gl.bufferData(gl.ARRAY_BUFFER, tangentArray, hint);

		}

		if (dirtyNormals && normalType) {

			for ( f in 0...chunk_faces3.length) 
			{
				face = obj_faces[chunk_faces3[f]];

				vertexNormals = face.vertexNormals;
				faceNormal = face.normal;

				if (vertexNormals.length == 3 && needsSmoothNormals) 
				{

					for ( i in 0...3) 
					{
						vn = vertexNormals[i];

						normalArray[offset_normal] = vn.x;
						normalArray[offset_normal + 1] = vn.y;
						normalArray[offset_normal + 2] = vn.z;

						offset_normal += 3;

					}

				} else {

					for ( i in 0...3) 
					{

						normalArray[offset_normal] = faceNormal.x;
						normalArray[offset_normal + 1] = faceNormal.y;
						normalArray[offset_normal + 2] = faceNormal.z;

						offset_normal += 3;

					}

				}

			}

			for ( f in 0...chunk_faces4.length) 
			{
				face = obj_faces[chunk_faces4[f]];

				vertexNormals = face.vertexNormals;
				faceNormal = face.normal;

				if (vertexNormals.length == 4 && needsSmoothNormals) {

					for ( i in 0...4) 
					{
						vn = vertexNormals[i];

						normalArray[offset_normal] = vn.x;
						normalArray[offset_normal + 1] = vn.y;
						normalArray[offset_normal + 2] = vn.z;

						offset_normal += 3;

					}

				} else {

					for ( i in 0...4) 
					{

						normalArray[offset_normal] = faceNormal.x;
						normalArray[offset_normal + 1] = faceNormal.y;
						normalArray[offset_normal + 2] = faceNormal.z;

						offset_normal += 3;

					}

				}

			}

			gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglNormalBuffer);
			gl.bufferData(gl.ARRAY_BUFFER, normalArray, hint);

		}

		if (dirtyUvs && obj_uvs && uvType) {

			for ( f in 0...chunk_faces3.length) 
			{
				fi = chunk_faces3[f];

				face = obj_faces[fi];
				uv = obj_uvs[fi];

				if (uv == null)
					continue;

				for ( i in 0...3) 
				{
					uvi = uv[i];

					uvArray[offset_uv] = uvi.u;
					uvArray[offset_uv + 1] = uvi.v;

					offset_uv += 2;
				}
			}

			for ( f in 0...chunk_faces4.length) 
			{
				fi = chunk_faces4[f];

				face = obj_faces[fi];
				uv = obj_uvs[fi];

				if (uv == null)
					continue;

				for ( i in 0...4) 
				{
					uvi = uv[i];

					uvArray[offset_uv] = uvi.u;
					uvArray[offset_uv + 1] = uvi.v;

					offset_uv += 2;

				}

			}

			if (offset_uv > 0) 
			{
				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglUVBuffer);
				gl.bufferData(gl.ARRAY_BUFFER, uvArray, hint);
			}
		}

		if (dirtyUvs && obj_uvs2 && uvType) 
		{
			for ( f in 0...chunk_faces3.length) 
			{
				fi = chunk_faces3[f];

				face = obj_faces[fi];
				uv2 = obj_uvs2[fi];

				if (uv2 == null)
					continue;

				for ( i in 0...3)
				{

					uv2i = uv2[i];

					uv2Array[offset_uv2] = uv2i.u;
					uv2Array[offset_uv2 + 1] = uv2i.v;

					offset_uv2 += 2;

				}
			}

			for ( f in 0...chunk_faces4.length) 
			{
				fi = chunk_faces4[f];

				face = obj_faces[fi];
				uv2 = obj_uvs2[fi];

				if (uv2 == null)
					continue;

				for ( i in 0...4) 
				{
					uv2i = uv2[i];

					uv2Array[offset_uv2] = uv2i.u;
					uv2Array[offset_uv2 + 1] = uv2i.v;

					offset_uv2 += 2;

				}

			}

			if (offset_uv2 > 0) 
			{
				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglUV2Buffer);
				gl.bufferData(gl.ARRAY_BUFFER, uv2Array, hint);
			}
		}

		if (dirtyElements) 
		{
			for ( f in 0...chunk_faces3.length) 
			{
				face = obj_faces[chunk_faces3[f]];

				faceArray[offset_face] = vertexIndex;
				faceArray[offset_face + 1] = vertexIndex + 1;
				faceArray[offset_face + 2] = vertexIndex + 2;

				offset_face += 3;

				lineArray[offset_line] = vertexIndex;
				lineArray[offset_line + 1] = vertexIndex + 1;

				lineArray[offset_line + 2] = vertexIndex;
				lineArray[offset_line + 3] = vertexIndex + 2;

				lineArray[offset_line + 4] = vertexIndex + 1;
				lineArray[offset_line + 5] = vertexIndex + 2;

				offset_line += 6;

				vertexIndex += 3;

			}

			for ( f in 0...chunk_faces4.length) 
			{
				face = obj_faces[chunk_faces4[f]];

				faceArray[offset_face] = vertexIndex;
				faceArray[offset_face + 1] = vertexIndex + 1;
				faceArray[offset_face + 2] = vertexIndex + 3;

				faceArray[offset_face + 3] = vertexIndex + 1;
				faceArray[offset_face + 4] = vertexIndex + 2;
				faceArray[offset_face + 5] = vertexIndex + 3;

				offset_face += 6;

				lineArray[offset_line] = vertexIndex;
				lineArray[offset_line + 1] = vertexIndex + 1;

				lineArray[offset_line + 2] = vertexIndex;
				lineArray[offset_line + 3] = vertexIndex + 3;

				lineArray[offset_line + 4] = vertexIndex + 1;
				lineArray[offset_line + 5] = vertexIndex + 2;

				lineArray[offset_line + 6] = vertexIndex + 2;
				lineArray[offset_line + 7] = vertexIndex + 3;

				offset_line += 8;

				vertexIndex += 4;

			}

			gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglFaceBuffer);
			gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, faceArray, hint);

			gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglLineBuffer);
			gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, lineArray, hint);

		}

		var customAttribute:Dynamic;
		var customAttributeArray:Array<Dynamic>;
		if (customAttributes != null) 
		{
			for ( i in 0...customAttributes.length) 
			{
				customAttribute = customAttributes[i];
				customAttributeArray = customAttribute.array;

				if (!customAttribute.__original.needsUpdate)
					continue;

				offset_custom = 0;
				offset_customSrc = 0;

				if (customAttribute.size == 1) 
				{
					if (customAttribute.boundTo == null || customAttribute.boundTo == "vertices") 
					{
						for ( f in 0...chunk_faces3.length) 
						{
							face = obj_faces[chunk_faces3[f]];

							customAttributeArray[offset_custom] = customAttribute.value[face.a];
							customAttributeArray[offset_custom + 1] = customAttribute.value[face.b];
							customAttributeArray[offset_custom + 2] = customAttribute.value[face.c];

							offset_custom += 3;

						}

						for ( f in 0...chunk_faces4.length) {

							face = obj_faces[chunk_faces4[f]];

							customAttributeArray[offset_custom] = customAttribute.value[face.a];
							customAttributeArray[offset_custom + 1] = customAttribute.value[face.b];
							customAttributeArray[offset_custom + 2] = customAttribute.value[face.c];
							customAttributeArray[offset_custom + 3] = customAttribute.value[face.d];

							offset_custom += 4;

						}

					} else if (customAttribute.boundTo == "faces") {

						for ( f in 0...chunk_faces3.length) {

							value = customAttribute.value[chunk_faces3[f]];

							customAttributeArray[offset_custom] = value;
							customAttributeArray[offset_custom + 1] = value;
							customAttributeArray[offset_custom + 2] = value;

							offset_custom += 3;

						}

						for ( f in 0...chunk_faces4.length) {

							value = customAttribute.value[chunk_faces4[f]];

							customAttributeArray[offset_custom] = value;
							customAttributeArray[offset_custom + 1] = value;
							customAttributeArray[offset_custom + 2] = value;
							customAttributeArray[offset_custom + 3] = value;

							offset_custom += 4;

						}

					}

				} else if (customAttribute.size == 2) {

					if (customAttribute.boundTo == null || customAttribute.boundTo == "vertices") {

						for ( f in 0...chunk_faces3.length) {

							face = obj_faces[chunk_faces3[f]];

							v1 = customAttribute.value[face.a];
							v2 = customAttribute.value[face.b];
							v3 = customAttribute.value[face.c];

							customAttributeArray[offset_custom] = v1.x;
							customAttributeArray[offset_custom + 1] = v1.y;

							customAttributeArray[offset_custom + 2] = v2.x;
							customAttributeArray[offset_custom + 3] = v2.y;

							customAttributeArray[offset_custom + 4] = v3.x;
							customAttributeArray[offset_custom + 5] = v3.y;

							offset_custom += 6;

						}

						for ( f in 0...chunk_faces4.length) 
						{

							face = obj_faces[chunk_faces4[f]];

							v1 = customAttribute.value[face.a];
							v2 = customAttribute.value[face.b];
							v3 = customAttribute.value[face.c];
							v4 = customAttribute.value[face.d];

							customAttributeArray[offset_custom] = v1.x;
							customAttributeArray[offset_custom + 1] = v1.y;

							customAttributeArray[offset_custom + 2] = v2.x;
							customAttributeArray[offset_custom + 3] = v2.y;

							customAttributeArray[offset_custom + 4] = v3.x;
							customAttributeArray[offset_custom + 5] = v3.y;

							customAttributeArray[offset_custom + 6] = v4.x;
							customAttributeArray[offset_custom + 7] = v4.y;

							offset_custom += 8;

						}

					} else if (customAttribute.boundTo == "faces") {

						for ( f in 0...chunk_faces3.length) {

							value = customAttribute.value[chunk_faces3[f]];

							v1 = value;
							v2 = value;
							v3 = value;

							customAttributeArray[offset_custom] = v1.x;
							customAttributeArray[offset_custom + 1] = v1.y;

							customAttributeArray[offset_custom + 2] = v2.x;
							customAttributeArray[offset_custom + 3] = v2.y;

							customAttributeArray[offset_custom + 4] = v3.x;
							customAttributeArray[offset_custom + 5] = v3.y;

							offset_custom += 6;

						}

						for ( f in 0...chunk_faces4.length) 
						{

							value = customAttribute.value[chunk_faces4[f]];

							v1 = value;
							v2 = value;
							v3 = value;
							v4 = value;

							customAttributeArray[offset_custom] = v1.x;
							customAttributeArray[offset_custom + 1] = v1.y;

							customAttributeArray[offset_custom + 2] = v2.x;
							customAttributeArray[offset_custom + 3] = v2.y;

							customAttributeArray[offset_custom + 4] = v3.x;
							customAttributeArray[offset_custom + 5] = v3.y;

							customAttributeArray[offset_custom + 6] = v4.x;
							customAttributeArray[offset_custom + 7] = v4.y;

							offset_custom += 8;

						}

					}

				} 
				else if (customAttribute.size == 3) 
				{
					var pp:Array<String>;
					if (customAttribute.type == "c") 
					{
						pp = ["r", "g", "b"];
					} 
					else 
					{
						pp = ["x", "y", "z"];
					}

					if (customAttribute.boundTo == null || 
					customAttribute.boundTo == "vertices") 
					{
						for ( f in 0...chunk_faces3.length) 
						{
							face = obj_faces[chunk_faces3[f]];

							v1 = customAttribute.value[face.a];
							v2 = customAttribute.value[face.b];
							v3 = customAttribute.value[face.c];

							customAttributeArray[offset_custom] = v1[pp[0]];
							customAttributeArray[offset_custom + 1] = v1[pp[1]];
							customAttributeArray[offset_custom + 2] = v1[pp[2]];

							customAttributeArray[offset_custom + 3] = v2[pp[0]];
							customAttributeArray[offset_custom + 4] = v2[pp[1]];
							customAttributeArray[offset_custom + 5] = v2[pp[2]];

							customAttributeArray[offset_custom + 6] = v3[pp[0]];
							customAttributeArray[offset_custom + 7] = v3[pp[1]];
							customAttributeArray[offset_custom + 8] = v3[pp[2]];

							offset_custom += 9;
						}

						for ( f in 0...chunk_faces4.length) 
						{
							face = obj_faces[chunk_faces4[f]];

							v1 = customAttribute.value[face.a];
							v2 = customAttribute.value[face.b];
							v3 = customAttribute.value[face.c];
							v4 = customAttribute.value[face.d];

							customAttributeArray[offset_custom] = v1[pp[0]];
							customAttributeArray[offset_custom + 1] = v1[pp[1]];
							customAttributeArray[offset_custom + 2] = v1[pp[2]];

							customAttributeArray[offset_custom + 3] = v2[pp[0]];
							customAttributeArray[offset_custom + 4] = v2[pp[1]];
							customAttributeArray[offset_custom + 5] = v2[pp[2]];

							customAttributeArray[offset_custom + 6] = v3[pp[0]];
							customAttributeArray[offset_custom + 7] = v3[pp[1]];
							customAttributeArray[offset_custom + 8] = v3[pp[2]];

							customAttributeArray[offset_custom + 9] = v4[pp[0]];
							customAttributeArray[offset_custom + 10] = v4[pp[1]];
							customAttributeArray[offset_custom + 11] = v4[pp[2]];

							offset_custom += 12;

						}

					} 
					else if (customAttribute.boundTo == "faces") 
					{
						for ( f in 0...chunk_faces3.length) 
						{
							value = customAttribute.value[chunk_faces3[f]];

							v1 = value;
							v2 = value;
							v3 = value;

							customAttributeArray[offset_custom] = v1[pp[0]];
							customAttributeArray[offset_custom + 1] = v1[pp[1]];
							customAttributeArray[offset_custom + 2] = v1[pp[2]];

							customAttributeArray[offset_custom + 3] = v2[pp[0]];
							customAttributeArray[offset_custom + 4] = v2[pp[1]];
							customAttributeArray[offset_custom + 5] = v2[pp[2]];

							customAttributeArray[offset_custom + 6] = v3[pp[0]];
							customAttributeArray[offset_custom + 7] = v3[pp[1]];
							customAttributeArray[offset_custom + 8] = v3[pp[2]];

							offset_custom += 9;

						}

						for ( f in 0...chunk_faces4.length) 
						{
							value = customAttribute.value[chunk_faces4[f]];

							v1 = value;
							v2 = value;
							v3 = value;
							v4 = value;

							customAttributeArray[offset_custom] = v1[pp[0]];
							customAttributeArray[offset_custom + 1] = v1[pp[1]];
							customAttributeArray[offset_custom + 2] = v1[pp[2]];

							customAttributeArray[offset_custom + 3] = v2[pp[0]];
							customAttributeArray[offset_custom + 4] = v2[pp[1]];
							customAttributeArray[offset_custom + 5] = v2[pp[2]];

							customAttributeArray[offset_custom + 6] = v3[pp[0]];
							customAttributeArray[offset_custom + 7] = v3[pp[1]];
							customAttributeArray[offset_custom + 8] = v3[pp[2]];

							customAttributeArray[offset_custom + 9] = v4[pp[0]];
							customAttributeArray[offset_custom + 10] = v4[pp[1]];
							customAttributeArray[offset_custom + 11] = v4[pp[2]];

							offset_custom += 12;

						}

					} 
					else if (customAttribute.boundTo == "faceVertices") 
					{
						for ( f in 0...chunk_faces3.length) 
						{
							value = customAttribute.value[chunk_faces3[f]];

							v1 = value[0];
							v2 = value[1];
							v3 = value[2];

							customAttributeArray[offset_custom] = v1[pp[0]];
							customAttributeArray[offset_custom + 1] = v1[pp[1]];
							customAttributeArray[offset_custom + 2] = v1[pp[2]];

							customAttributeArray[offset_custom + 3] = v2[pp[0]];
							customAttributeArray[offset_custom + 4] = v2[pp[1]];
							customAttributeArray[offset_custom + 5] = v2[pp[2]];

							customAttributeArray[offset_custom + 6] = v3[pp[0]];
							customAttributeArray[offset_custom + 7] = v3[pp[1]];
							customAttributeArray[offset_custom + 8] = v3[pp[2]];

							offset_custom += 9;
						}

						for ( f in 0...chunk_faces4.length) 
						{
							value = customAttribute.value[chunk_faces4[f]];

							v1 = value[0];
							v2 = value[1];
							v3 = value[2];
							v4 = value[3];

							customAttributeArray[offset_custom] = v1[pp[0]];
							customAttributeArray[offset_custom + 1] = v1[pp[1]];
							customAttributeArray[offset_custom + 2] = v1[pp[2]];

							customAttributeArray[offset_custom + 3] = v2[pp[0]];
							customAttributeArray[offset_custom + 4] = v2[pp[1]];
							customAttributeArray[offset_custom + 5] = v2[pp[2]];

							customAttributeArray[offset_custom + 6] = v3[pp[0]];
							customAttributeArray[offset_custom + 7] = v3[pp[1]];
							customAttributeArray[offset_custom + 8] = v3[pp[2]];

							customAttributeArray[offset_custom + 9] = v4[pp[0]];
							customAttributeArray[offset_custom + 10] = v4[pp[1]];
							customAttributeArray[offset_custom + 11] = v4[pp[2]];

							offset_custom += 12;

						}

					}

				} 
				else if (customAttribute.size == 4) 
				{

					if (customAttribute.boundTo == null || 
					customAttribute.boundTo == "vertices") 
					{
						for ( f in 0...chunk_faces3.length) 
						{
							face = obj_faces[chunk_faces3[f]];

							v1 = customAttribute.value[face.a];
							v2 = customAttribute.value[face.b];
							v3 = customAttribute.value[face.c];

							customAttributeArray[offset_custom] = v1.x;
							customAttributeArray[offset_custom + 1] = v1.y;
							customAttributeArray[offset_custom + 2] = v1.z;
							customAttributeArray[offset_custom + 3] = v1.w;

							customAttributeArray[offset_custom + 4] = v2.x;
							customAttributeArray[offset_custom + 5] = v2.y;
							customAttributeArray[offset_custom + 6] = v2.z;
							customAttributeArray[offset_custom + 7] = v2.w;

							customAttributeArray[offset_custom + 8] = v3.x;
							customAttributeArray[offset_custom + 9] = v3.y;
							customAttributeArray[offset_custom + 10] = v3.z;
							customAttributeArray[offset_custom + 11] = v3.w;

							offset_custom += 12;
						}

						for ( f in 0...chunk_faces4.length) 
						{
							face = obj_faces[chunk_faces4[f]];

							v1 = customAttribute.value[face.a];
							v2 = customAttribute.value[face.b];
							v3 = customAttribute.value[face.c];
							v4 = customAttribute.value[face.d];

							customAttributeArray[offset_custom] = v1.x;
							customAttributeArray[offset_custom + 1] = v1.y;
							customAttributeArray[offset_custom + 2] = v1.z;
							customAttributeArray[offset_custom + 3] = v1.w;

							customAttributeArray[offset_custom + 4] = v2.x;
							customAttributeArray[offset_custom + 5] = v2.y;
							customAttributeArray[offset_custom + 6] = v2.z;
							customAttributeArray[offset_custom + 7] = v2.w;

							customAttributeArray[offset_custom + 8] = v3.x;
							customAttributeArray[offset_custom + 9] = v3.y;
							customAttributeArray[offset_custom + 10] = v3.z;
							customAttributeArray[offset_custom + 11] = v3.w;

							customAttributeArray[offset_custom + 12] = v4.x;
							customAttributeArray[offset_custom + 13] = v4.y;
							customAttributeArray[offset_custom + 14] = v4.z;
							customAttributeArray[offset_custom + 15] = v4.w;

							offset_custom += 16;
						}

					} 
					else if (customAttribute.boundTo == "faces") 
					{
						for ( f in 0...chunk_faces3.length) 
						{
							value = customAttribute.value[chunk_faces3[f]];

							v1 = value;
							v2 = value;
							v3 = value;

							customAttributeArray[offset_custom] = v1.x;
							customAttributeArray[offset_custom + 1] = v1.y;
							customAttributeArray[offset_custom + 2] = v1.z;
							customAttributeArray[offset_custom + 3] = v1.w;

							customAttributeArray[offset_custom + 4] = v2.x;
							customAttributeArray[offset_custom + 5] = v2.y;
							customAttributeArray[offset_custom + 6] = v2.z;
							customAttributeArray[offset_custom + 7] = v2.w;

							customAttributeArray[offset_custom + 8] = v3.x;
							customAttributeArray[offset_custom + 9] = v3.y;
							customAttributeArray[offset_custom + 10] = v3.z;
							customAttributeArray[offset_custom + 11] = v3.w;

							offset_custom += 12;

						}

						for ( f in 0...chunk_faces4.length) 
						{
							value = customAttribute.value[chunk_faces4[f]];

							v1 = value;
							v2 = value;
							v3 = value;
							v4 = value;

							customAttributeArray[offset_custom] = v1.x;
							customAttributeArray[offset_custom + 1] = v1.y;
							customAttributeArray[offset_custom + 2] = v1.z;
							customAttributeArray[offset_custom + 3] = v1.w;

							customAttributeArray[offset_custom + 4] = v2.x;
							customAttributeArray[offset_custom + 5] = v2.y;
							customAttributeArray[offset_custom + 6] = v2.z;
							customAttributeArray[offset_custom + 7] = v2.w;

							customAttributeArray[offset_custom + 8] = v3.x;
							customAttributeArray[offset_custom + 9] = v3.y;
							customAttributeArray[offset_custom + 10] = v3.z;
							customAttributeArray[offset_custom + 11] = v3.w;

							customAttributeArray[offset_custom + 12] = v4.x;
							customAttributeArray[offset_custom + 13] = v4.y;
							customAttributeArray[offset_custom + 14] = v4.z;
							customAttributeArray[offset_custom + 15] = v4.w;

							offset_custom += 16;

						}

					} else if (customAttribute.boundTo == "faceVertices") {

						for ( f in 0...chunk_faces3.length) 
						{
							value = customAttribute.value[chunk_faces3[f]];

							v1 = value[0];
							v2 = value[1];
							v3 = value[2];

							customAttributeArray[offset_custom] = v1.x;
							customAttributeArray[offset_custom + 1] = v1.y;
							customAttributeArray[offset_custom + 2] = v1.z;
							customAttributeArray[offset_custom + 3] = v1.w;

							customAttributeArray[offset_custom + 4] = v2.x;
							customAttributeArray[offset_custom + 5] = v2.y;
							customAttributeArray[offset_custom + 6] = v2.z;
							customAttributeArray[offset_custom + 7] = v2.w;

							customAttributeArray[offset_custom + 8] = v3.x;
							customAttributeArray[offset_custom + 9] = v3.y;
							customAttributeArray[offset_custom + 10] = v3.z;
							customAttributeArray[offset_custom + 11] = v3.w;

							offset_custom += 12;

						}

						for ( f in 0...chunk_faces4.length) 
						{
							value = customAttribute.value[chunk_faces4[f]];

							v1 = value[0];
							v2 = value[1];
							v3 = value[2];
							v4 = value[3];

							customAttributeArray[offset_custom] = v1.x;
							customAttributeArray[offset_custom + 1] = v1.y;
							customAttributeArray[offset_custom + 2] = v1.z;
							customAttributeArray[offset_custom + 3] = v1.w;

							customAttributeArray[offset_custom + 4] = v2.x;
							customAttributeArray[offset_custom + 5] = v2.y;
							customAttributeArray[offset_custom + 6] = v2.z;
							customAttributeArray[offset_custom + 7] = v2.w;

							customAttributeArray[offset_custom + 8] = v3.x;
							customAttributeArray[offset_custom + 9] = v3.y;
							customAttributeArray[offset_custom + 10] = v3.z;
							customAttributeArray[offset_custom + 11] = v3.w;

							customAttributeArray[offset_custom + 12] = v4.x;
							customAttributeArray[offset_custom + 13] = v4.y;
							customAttributeArray[offset_custom + 14] = v4.z;
							customAttributeArray[offset_custom + 15] = v4.w;

							offset_custom += 16;

						}
					}
				}

				gl.bindBuffer(gl.ARRAY_BUFFER, customAttribute.buffer);
				gl.bufferData(gl.ARRAY_BUFFER, customAttributeArray, hint);
			}
		}

		if (dispose) 
		{
			//delete geometryGroup.__inittedArrays;
			//delete geometryGroup.__colorArray;
			//delete geometryGroup.__normalArray;
			//delete geometryGroup.__tangentArray;
			//delete geometryGroup.__uvArray;
			//delete geometryGroup.__uv2Array;
			//delete geometryGroup.__faceArray;
			//delete geometryGroup.__vertexArray;
			//delete geometryGroup.__lineArray;
			//delete geometryGroup.__skinVertexAArray;
			//delete geometryGroup.__skinVertexBArray;
			//delete geometryGroup.__skinIndexArray;
			//delete geometryGroup.__skinWeightArray;

		}

	}

	public function  setDirectBuffers(geometry, hint, dispose) 
	{
		var attributes:Dynamic = geometry.attributes;

		var index:Dynamic = untyped attributes["index"];
		var position:Dynamic = untyped attributes["position"];
		var normal:Dynamic = untyped attributes["normal"];
		var uv:Dynamic = untyped attributes["uv"];
		var color:Dynamic = untyped attributes["color"];
		var tangent:Dynamic = untyped attributes["tangent"];

		if (geometry.elementsNeedUpdate && index != null) 
		{
			gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, index.buffer);
			gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, index.array, hint);
		}

		if (geometry.verticesNeedUpdate && position != null) 
		{
			gl.bindBuffer(gl.ARRAY_BUFFER, position.buffer);
			gl.bufferData(gl.ARRAY_BUFFER, position.array, hint);
		}

		if (geometry.normalsNeedUpdate && normal != null) 
		{
			gl.bindBuffer(gl.ARRAY_BUFFER, normal.buffer);
			gl.bufferData(gl.ARRAY_BUFFER, normal.array, hint);
		}

		if (geometry.uvsNeedUpdate && uv != null) 
		{
			gl.bindBuffer(gl.ARRAY_BUFFER, uv.buffer);
			gl.bufferData(gl.ARRAY_BUFFER, uv.array, hint);
		}

		if (geometry.colorsNeedUpdate && color != null) 
		{
			gl.bindBuffer(gl.ARRAY_BUFFER, color.buffer);
			gl.bufferData(gl.ARRAY_BUFFER, color.array, hint);
		}

		if (geometry.tangentsNeedUpdate && tangent != null) 
		{
			gl.bindBuffer(gl.ARRAY_BUFFER, tangent.buffer);
			gl.bufferData(gl.ARRAY_BUFFER, tangent.array, hint);
		}

		if (dispose) 
		{
			//for (var i in geometry.attributes ) 
			//{
				//delete geometry.attributes[i].array;
			//}
		}

	}

	// Buffer rendering

	public function renderBufferImmediate(object, program, material):Void 
	{

		if (object.hasPositions && object.__webglVertexBuffer == null)
			object.__webglVertexBuffer = gl.createBuffer();
		if (object.hasNormals && object.__webglNormalBuffer == null)
			object.__webglNormalBuffer = gl.createBuffer();
		if (object.hasUvs && object.__webglUvBuffer == null)
			object.__webglUvBuffer = gl.createBuffer();
		if (object.hasColors && object.__webglColorBuffer == null)
			object.__webglColorBuffer = gl.createBuffer();

		if (object.hasPositions) 
		{
			gl.bindBuffer(gl.ARRAY_BUFFER, object.__webglVertexBuffer);
			gl.bufferData(gl.ARRAY_BUFFER, object.positionArray, gl.DYNAMIC_DRAW);
			gl.enableVertexAttribArray(program.attributes.position);
			gl.vertexAttribPointer(program.attributes.position, 3, gl.FLOAT, false, 0, 0);
		}

		if (object.hasNormals) 
		{
			gl.bindBuffer(gl.ARRAY_BUFFER, object.__webglNormalBuffer);

			if (material.shading == ThreeGlobal.FlatShading) 
			{
				var nx:Float, ny:Float, nz:Float, 
					nax:Float, nbx:Float, ncx:Float, 
					nay:Float, nby:Float, ncy:Float, 
					naz:Float, nbz:Float, ncz:Float;
				var normalArray:Array<Float>; 
				var i:Int;
				var il:Int = object.count * 3;

				i = 0;
				while(i < il)
				{
					normalArray = object.normalArray;

					nax = normalArray[i];
					nay = normalArray[i + 1];
					naz = normalArray[i + 2];

					nbx = normalArray[i + 3];
					nby = normalArray[i + 4];
					nbz = normalArray[i + 5];

					ncx = normalArray[i + 6];
					ncy = normalArray[i + 7];
					ncz = normalArray[i + 8];

					nx = (nax + nbx + ncx ) / 3;
					ny = (nay + nby + ncy ) / 3;
					nz = (naz + nbz + ncz ) / 3;

					normalArray[i] = nx;
					normalArray[i + 1] = ny;
					normalArray[i + 2] = nz;

					normalArray[i + 3] = nx;
					normalArray[i + 4] = ny;
					normalArray[i + 5] = nz;

					normalArray[i + 6] = nx;
					normalArray[i + 7] = ny;
					normalArray[i + 8] = nz;

					i += 9;
				}
			}

			gl.bufferData(gl.ARRAY_BUFFER, object.normalArray, gl.DYNAMIC_DRAW);
			gl.enableVertexAttribArray(program.attributes.normal);
			gl.vertexAttribPointer(program.attributes.normal, 3, gl.FLOAT, false, 0, 0);

		}

		if (object.hasUvs && material.map != null) 
		{
			gl.bindBuffer(gl.ARRAY_BUFFER, object.__webglUvBuffer);
			gl.bufferData(gl.ARRAY_BUFFER, object.uvArray, gl.DYNAMIC_DRAW);
			gl.enableVertexAttribArray(program.attributes.uv);
			gl.vertexAttribPointer(program.attributes.uv, 2, gl.FLOAT, false, 0, 0);

		}

		if (object.hasColors && material.vertexColors != ThreeGlobal.NoColors) 
		{
			gl.bindBuffer(gl.ARRAY_BUFFER, object.__webglColorBuffer);
			gl.bufferData(gl.ARRAY_BUFFER, object.colorArray, gl.DYNAMIC_DRAW);
			gl.enableVertexAttribArray(program.attributes.color);
			gl.vertexAttribPointer(program.attributes.color, 3, gl.FLOAT, false, 0, 0);
		}

		gl.drawArrays(gl.TRIANGLES, 0, object.count);

		object.count = 0;
	}

	public function renderBufferDirect(camera, lights, fog, material, geometry, object):Void
	{

		if (material.visible == false)
			return;

		var program, attributes, linewidth, primitives, a, attribute;

		program = setProgram(camera, lights, fog, material, object);

		attributes = program.attributes;

		var updateBuffers = false, wireframeBit = material.wireframe ? 1 : 0, geometryHash = (geometry.id * 0xffffff ) + (program.id * 2 ) + wireframeBit;

		if (geometryHash != _currentGeometryGroupHash) 
		{
			_currentGeometryGroupHash = geometryHash;
			updateBuffers = true;
		}

		// render mesh

		if ( Std.is(object,Mesh))
		{
			var offsets = geometry.offsets;

			// if there is more than 1 chunk
			// must set attribute pointers to use new offsets for each chunk
			// even if geometry and materials didn't change

			if (offsets.length > 1)
				updateBuffers = true;

			for (i in 0...offsets.length) 
			{
				var startIndex = offsets[i].index;

				if (updateBuffers) 
				{
					// vertices

					var position = geometry.attributes["position"];
					var positionSize = position.itemSize;

					gl.bindBuffer(gl.ARRAY_BUFFER, position.buffer);
					gl.vertexAttribPointer(attributes.position, positionSize, gl.FLOAT, false, 0, startIndex * positionSize * 4);
					// 4 bytes per Float32

					// normals

					var normal = geometry.attributes["normal"];

					if (attributes.normal >= 0 && normal != null) 
					{
						var normalSize = normal.itemSize;

						gl.bindBuffer(gl.ARRAY_BUFFER, normal.buffer);
						gl.vertexAttribPointer(attributes.normal, normalSize, gl.FLOAT, false, 0, startIndex * normalSize * 4);

					}

					// uvs

					var uv:Dynamic = untyped geometry.attributes["uv"];

					if (attributes.uv >= 0 && uv != null) 
					{
						if (uv.buffer) 
						{
							var uvSize = uv.itemSize;

							gl.bindBuffer(gl.ARRAY_BUFFER, uv.buffer);
							gl.vertexAttribPointer(attributes.uv, uvSize, gl.FLOAT, false, 0, startIndex * uvSize * 4);

							gl.enableVertexAttribArray(attributes.uv);

						} else 
						{
							gl.disableVertexAttribArray(attributes.uv);
						}
					}

					// colors

					var color:Dynamic = untyped geometry.attributes["color"];

					if (attributes.color >= 0 && color != null) 
					{
						var colorSize = color.itemSize;

						gl.bindBuffer(gl.ARRAY_BUFFER, color.buffer);
						gl.vertexAttribPointer(attributes.color, colorSize, gl.FLOAT, false, 0, startIndex * colorSize * 4);
					}

					// tangents

					var tangent:Dynamic = untyped geometry.attributes["tangent"];

					if (attributes.tangent >= 0 && tangent != null) 
					{
						var tangentSize:Int = tangent.itemSize;

						gl.bindBuffer(gl.ARRAY_BUFFER, tangent.buffer);
						gl.vertexAttribPointer(attributes.tangent, tangentSize, gl.FLOAT, false, 0, startIndex * tangentSize * 4);

					}

					// indices

					var index:Dynamic = untyped geometry.attributes["index"];

					gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, index.buffer);

				}

				// render indexed triangles

				gl.drawElements(gl.TRIANGLES, offsets[i].count, gl.UNSIGNED_SHORT, offsets[i].start * 2);
				// 2 bytes per Uint16

				this.statistics.calls++;
				this.statistics.vertices += offsets[i].count;
				// not really true, here vertices can be shared
				this.statistics.faces += offsets[i].count / 3;

			}
		}
	}

	public function renderBuffer(camera, lights, fog, material, geometryGroup, object):Void 
	{

		if (material.visible == false)
			return;

		var program, attributes, linewidth, primitives, a, attribute, i, il;

		program = setProgram(camera, lights, fog, material, object);

		attributes = program.attributes;

		var updateBuffers = false, wireframeBit = material.wireframe ? 1 : 0, geometryGroupHash = (geometryGroup.id * 0xffffff ) + (program.id * 2 ) + wireframeBit;

		if (geometryGroupHash != _currentGeometryGroupHash) 
		{

			_currentGeometryGroupHash = geometryGroupHash;
			updateBuffers = true;

		}

		// vertices

		if (!material.morphTargets && attributes.position >= 0) 
		{
			if (updateBuffers) 
			{
				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglVertexBuffer);
				gl.vertexAttribPointer(attributes.position, 3, gl.FLOAT, false, 0, 0);
			}
		} 
		else
		{
			if (object.morphTargetBase) 
			{
				setupMorphTargets(material, geometryGroup, object);
			}
		}

		if (updateBuffers) 
		{
			// custom attributes

			// Use the per-geometryGroup custom attribute arrays which are setup in
			// initMeshBuffers

			if (geometryGroup.__webglCustomAttributesList) 
			{

				for ( i in 0...geometryGroup.__webglCustomAttributesList.length) 
				{
					attribute = geometryGroup.__webglCustomAttributesList[i];

					if (attributes[attribute.buffer.belongsToAttribute] >= 0) 
					{
						gl.bindBuffer(gl.ARRAY_BUFFER, attribute.buffer);
						gl.vertexAttribPointer(attributes[attribute.buffer.belongsToAttribute], attribute.size, gl.FLOAT, false, 0, 0);
					}

				}
			}

			// colors

			if (attributes.color >= 0) 
			{
				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglColorBuffer);
				gl.vertexAttribPointer(attributes.color, 3, gl.FLOAT, false, 0, 0);
			}

			// normals

			if (attributes.normal >= 0) 
			{
				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglNormalBuffer);
				gl.vertexAttribPointer(attributes.normal, 3, gl.FLOAT, false, 0, 0);
			}

			// tangents

			if (attributes.tangent >= 0) 
			{
				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglTangentBuffer);
				gl.vertexAttribPointer(attributes.tangent, 4, gl.FLOAT, false, 0, 0);
			}

			// uvs

			if (attributes.uv >= 0) 
			{
				if (geometryGroup.__webglUVBuffer) 
				{
					gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglUVBuffer);
					gl.vertexAttribPointer(attributes.uv, 2, gl.FLOAT, false, 0, 0);

					gl.enableVertexAttribArray(attributes.uv);
				} 
				else 
				{
					gl.disableVertexAttribArray(attributes.uv);
				}
			}

			if (attributes.uv2 >= 0) 
			{
				if (geometryGroup.__webglUV2Buffer) 
				{
					gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglUV2Buffer);
					gl.vertexAttribPointer(attributes.uv2, 2, gl.FLOAT, false, 0, 0);

					gl.enableVertexAttribArray(attributes.uv2);
				}
				else 
				{
					gl.disableVertexAttribArray(attributes.uv2);
				}

			}

			if (material.skinning && 
				attributes.skinVertexA >= 0 && 
				attributes.skinVertexB >= 0 && 
				attributes.skinIndex >= 0 && 
				attributes.skinWeight >= 0) 
			{
				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglSkinVertexABuffer);
				gl.vertexAttribPointer(attributes.skinVertexA, 4, gl.FLOAT, false, 0, 0);

				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglSkinVertexBBuffer);
				gl.vertexAttribPointer(attributes.skinVertexB, 4, gl.FLOAT, false, 0, 0);

				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglSkinIndicesBuffer);
				gl.vertexAttribPointer(attributes.skinIndex, 4, gl.FLOAT, false, 0, 0);

				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglSkinWeightsBuffer);
				gl.vertexAttribPointer(attributes.skinWeight, 4, gl.FLOAT, false, 0, 0);
			}

		}

		// render mesh

		if ( Std.is(object, Mesh)) 
		{
			// wireframe
			if (material.wireframe)
			{
				setLineWidth(material.wireframeLinewidth);

				if (updateBuffers)
					gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglLineBuffer);
				gl.drawElements(gl.LINES, geometryGroup.__webglLineCount, gl.UNSIGNED_SHORT, 0);

				// triangles

			} 
			else
			{
				if (updateBuffers)
					gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglFaceBuffer);
				gl.drawElements(gl.TRIANGLES, geometryGroup.__webglFaceCount, gl.UNSIGNED_SHORT, 0);

			}

			this.statistics.calls++;
			this.statistics.vertices += geometryGroup.__webglFaceCount;
			this.statistics.faces += geometryGroup.__webglFaceCount / 3;

			// render lines

		}
		else if ( Std.is(object, Line))
		{
			primitives = (object.type == ThreeGlobal.LineStrip ) ? gl.LINE_STRIP : gl.LINES;

			setLineWidth(material.linewidth);

			gl.drawArrays(primitives, 0, geometryGroup.__webglLineCount);

			this.statistics.calls++;

			// render particles

		} 
		else if ( Std.is(object, ParticleSystem)) 
		{

			gl.drawArrays(gl.POINTS, 0, geometryGroup.__webglParticleCount);

			this.statistics.calls++;
			this.statistics.points += geometryGroup.__webglParticleCount;

			// render ribbon

		} 
		else if ( Std.is(object, Ribbon)) 
		{
			gl.drawArrays(gl.TRIANGLE_STRIP, 0, geometryGroup.__webglVertexCount);

			this.statistics.calls++;
		}

	}

	public function setupMorphTargets(material:Material, geometryGroup, object):Void
	{
		// set base

		var attributes:Dynamic = material.program.attributes;

		if (object.morphTargetBase != -1) 
		{
			gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[object.morphTargetBase]);
			gl.vertexAttribPointer(attributes.position, 3, gl.FLOAT, false, 0, 0);
		}
		else if (attributes.position >= 0) 
		{
			gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglVertexBuffer);
			gl.vertexAttribPointer(attributes.position, 3, gl.FLOAT, false, 0, 0);
		}

		if (object.morphTargetForcedOrder.length) 
		{
			// set forced order

			var m:Int = 0;
			var order:Array<Dynamic> = object.morphTargetForcedOrder;
			var influences = object.morphTargetInfluences;

			while (m < material.numSupportedMorphTargets && m < order.length) 
			{
				gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[order[m]]);
				gl.vertexAttribPointer(attributes["morphTarget" + m], 3, gl.FLOAT, false, 0, 0);

				if (material.morphNormals) 
				{
					gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglMorphNormalsBuffers[order[m]]);
					gl.vertexAttribPointer(attributes["morphNormal" + m], 3, gl.FLOAT, false, 0, 0);
				}

				object.__webglMorphTargetInfluences[m] = influences[order[m]];

				m++;
			}

		} 
		else 
		{
			// find the most influencing

			var influence, activeInfluenceIndices = [];
			var influences = object.morphTargetInfluences;
			var i, il = influences.length;

			for ( i in 0...il) 
			{
				influence = influences[i];

				if (influence > 0)
				{
					activeInfluenceIndices.push([i, influence]);
				}
			}

			if (activeInfluenceIndices.length > material.numSupportedMorphTargets) 
			{
				activeInfluenceIndices.sort(numericalSort);
				activeInfluenceIndices.length = material.numSupportedMorphTargets;

			} 
			else if (activeInfluenceIndices.length > material.numSupportedMorphNormals) 
			{
				activeInfluenceIndices.sort(numericalSort);
			} 
			else if (activeInfluenceIndices.length == 0) 
			{
				activeInfluenceIndices.push([0, 0]);
			}

			var influenceIndex, m = 0;

			while (m < material.numSupportedMorphTargets) 
			{
				if (activeInfluenceIndices[m])
				{
					influenceIndex = activeInfluenceIndices[ m ][0];

					gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[influenceIndex]);

					gl.vertexAttribPointer(attributes["morphTarget" + m], 3, gl.FLOAT, false, 0, 0);

					if (material.morphNormals) 
					{
						gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglMorphNormalsBuffers[influenceIndex]);
						gl.vertexAttribPointer(attributes["morphNormal" + m], 3, gl.FLOAT, false, 0, 0);
					}

					object.__webglMorphTargetInfluences[m] = influences[influenceIndex];

				}
				else 
				{
					gl.vertexAttribPointer(attributes["morphTarget" + m], 3, gl.FLOAT, false, 0, 0);

					if (material.morphNormals) 
					{
						gl.vertexAttribPointer(attributes["morphNormal" + m], 3, gl.FLOAT, false, 0, 0);
					}

					object.__webglMorphTargetInfluences[m] = 0;
				}
				m++;
			}
		}

		// load updated influences uniform

		if (material.program.uniforms.morphTargetInfluences != null) 
		{
			gl.uniform1fv(material.program.uniforms.morphTargetInfluences, object.__webglMorphTargetInfluences);
		}

	}

	// Sorting

	public function painterSort(a, b):Int 
	{
		return b.z - a.z;
	}

	public function numericalSort(a, b):Int 
	{
		return b[1] - a[1];
	}
	
	// Objects removal

	private function removeObject(object:Object3D, scene:Scene):Void
	{
		if ( Std.is(object, Mesh) || 
			Std.is(object,ParticleSystem) || 
			Std.is(object,Ribbon) || 
			Std.is(object,Line)) 
		{
			removeInstances(scene.__webglObjects, object);
		} 
		else if ( Std.is(object,Sprite)) 
		{
			removeInstancesDirect(scene.__webglSprites, object);
		} 
		else if ( Std.is(object,LensFlare)) 
		{
			removeInstancesDirect(scene.__webglFlares, object);
		} 
		else if ( Std.is(object,ImmediateRenderObject) || cast(object,ImmediateRenderObject).immediateRenderCallback) 
		{
			removeInstances(scene.__webglObjectsImmediate, object);
		}

		object.__webglActive = false;
	}

	private function removeInstances(objlist:Array<Dynamic>, object:Object3D):Void 
	{
		var i:Int = objlist.length - 1;
		while (i >= 0)
		{
			if (objlist[i].object == object) 
			{
				objlist.splice(i, 1);
			}
			i--;
		}
	}

	private function removeInstancesDirect(objlist:Array<Dynamic>, object:Object3D):Void  
	{
		var i:Int = objlist.length - 1;
		while (i >= 0)
		{
			if (objlist[i].object == object) 
			{
				objlist.splice(i, 1);
			}
			i--;
		}

	}

}