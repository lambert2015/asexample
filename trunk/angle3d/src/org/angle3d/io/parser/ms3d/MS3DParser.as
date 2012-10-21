package org.angle3d.io.parser.ms3d
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import org.angle3d.animation.Animation;
	import org.angle3d.animation.Bone;
	import org.angle3d.animation.BoneTrack;
	import org.angle3d.animation.Skeleton;
	import org.angle3d.animation.SkeletonAnimControl;
	import org.angle3d.animation.SkeletonControl;
	import org.angle3d.math.Quaternion;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.Node;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.SkinnedMesh;
	import org.angle3d.scene.mesh.SkinnedSubMesh;
	import org.angle3d.scene.mesh.SubMesh;
	import org.angle3d.utils.Assert;
	import org.angle3d.utils.Logger;

	public class MS3DParser
	{
		private var mMs3dVertices:Vector.<MS3DVertex>;
		private var mMs3dTriangles:Vector.<MS3DTriangle>;
		private var mMs3dGroups:Vector.<MS3DGroup>;
		private var mMs3dMaterials:Vector.<MS3DMaterial>;

		private var mFramesPerSecond:Number;
		private var mMs3dJoints:Vector.<MS3DJoint>;
		private var mNumVertices:int;
		private var mNumFrames:int;

		public function MS3DParser()
		{
		}

		public function parseStaticMesh(data:ByteArray):Mesh
		{
			data.endian = Endian.LITTLE_ENDIAN;
			data.position = 0;

			readHeader(data);
			readVertices(data);
			readTriangles(data);
			readGroups(data);
			readMaterials(data);

			var mesh:Mesh = new Mesh();

			var numTriangle:int = mMs3dTriangles.length;
			var numGroups:int = mMs3dGroups.length;
			for (var i:int = 0; i < numGroups; i++)
			{
				var subMesh:SubMesh = new SubMesh();
				var indices:Vector.<uint> = new Vector.<uint>();

				var vertices:Vector.<Number> = new Vector.<Number>();
				var normals:Vector.<Number> = new Vector.<Number>();
				var uvData:Vector.<Number> = new Vector.<Number>();

				var triangle:MS3DTriangle;
				for (var t:int = 0; t < numTriangle; t++)
				{
					triangle = mMs3dTriangles[t];

					if (triangle.groupIndex == i)
					{
						for (var j:int = 0; j < 3; j++)
						{
							var vertex:MS3DVertex = mMs3dVertices[triangle.indices[j]];
							var normal:Vector3f = triangle.normals[j];

							vertices.push(vertex.x);
							vertices.push(vertex.y);
							vertices.push(vertex.z);

							normals.push(normal.x);
							normals.push(normal.y);
							normals.push(normal.z);

							uvData.push(triangle.tUs[j]);
							uvData.push(triangle.tVs[j]);
						}

						var index:int = indices.length;
						indices.push(index);
						indices.push(index + 1);
						indices.push(index + 2);
					}
				}

				indices.fixed = true;

				vertices.fixed = true;
				normals.fixed = true;
				uvData.fixed = true;
				subMesh.setVertexBuffer(BufferType.POSITION, 3, vertices);
				subMesh.setVertexBuffer(BufferType.TEXCOORD, 2, uvData);
				subMesh.setVertexBuffer(BufferType.NORMAL, 3, normals);
				subMesh.setIndices(indices);
				subMesh.validate();

				mesh.addSubMesh(subMesh);
			}

			mesh.validate();

			return mesh;
		}

		public function parseSkinnedMesh(name:String, data:ByteArray):Node
		{
			data.endian = Endian.LITTLE_ENDIAN;
			data.position = 0;

			readHeader(data);
			readVertices(data);
			readTriangles(data);
			readGroups(data);
			readMaterials(data);

			readJoints(data);
			readAllComments(data);
			readWeights(data);

			//剩下的数据是编辑器使用的，忽略
			// joint extra
			// model extra

			var mesh:SkinnedMesh = new SkinnedMesh();

			var numTriangle:int = mMs3dTriangles.length;
			var numGroups:int = mMs3dGroups.length;
			for (var i:int = 0; i < numGroups; i++)
			{
				var subMesh:SkinnedSubMesh = new SkinnedSubMesh();
				var indices:Vector.<uint> = new Vector.<uint>();

				var vertices:Vector.<Number> = new Vector.<Number>();
				var normals:Vector.<Number> = new Vector.<Number>();
				var uvData:Vector.<Number> = new Vector.<Number>();
				var boneIndices:Vector.<Number> = new Vector.<Number>();
				var weights:Vector.<Number> = new Vector.<Number>();

				var triangle:MS3DTriangle;
				for (var t:int = 0; t < numTriangle; t++)
				{
					triangle = mMs3dTriangles[t];

					if (triangle.groupIndex == i)
					{
						for (var j:int = 0; j < 3; j++)
						{
							var vertex:MS3DVertex = mMs3dVertices[triangle.indices[j]];
							var normal:Vector3f = triangle.normals[j];

							vertices.push(vertex.x);
							vertices.push(vertex.y);
							vertices.push(vertex.z);

							normals.push(normal.x);
							normals.push(normal.y);
							normals.push(normal.z);

							uvData.push(triangle.tUs[j]);
							uvData.push(triangle.tVs[j]);

							boneIndices.push(vertex.bones[0]);
							boneIndices.push(vertex.bones[1]);
							boneIndices.push(vertex.bones[2]);
							boneIndices.push(vertex.bones[3]);

							weights.push(vertex.weights[0]);
							weights.push(vertex.weights[1]);
							weights.push(vertex.weights[2]);
							weights.push(vertex.weights[3]);
						}

						var index:int = indices.length;
						indices.push(index);
						indices.push(index + 1);
						indices.push(index + 2);
					}
				}

				indices.fixed = true;

				vertices.fixed = true;
				normals.fixed = true;
				uvData.fixed = true;
				subMesh.setVertexBuffer(BufferType.POSITION, 3, vertices);
				subMesh.setVertexBuffer(BufferType.BIND_POSE_POSITION, 3, vertices.concat());
				subMesh.setVertexBuffer(BufferType.TEXCOORD, 2, uvData);
				subMesh.setVertexBuffer(BufferType.NORMAL, 3, normals);
				subMesh.setVertexBuffer(BufferType.BONE_INDICES, 4, boneIndices);
				subMesh.setVertexBuffer(BufferType.BONE_WEIGHTS, 4, weights);
				subMesh.setIndices(indices);
				subMesh.validate();

				mesh.addSubMesh(subMesh);
			}

			mesh.validate();

			var node:Node = new Node(name);
			var geometry:Geometry = new Geometry(name + "_geometry", mesh);
			node.attachChild(geometry);
			buildSkeleton(node, geometry);
			return node;
		}

		private function buildSkeleton(node:Node, geometry:Geometry):void
		{
			var bones:Vector.<Bone> = new Vector.<Bone>();
			var tracks:Vector.<BoneTrack> = new Vector.<BoneTrack>();

			var animation:Animation = new Animation("default", mNumFrames);

			var q:Quaternion = new Quaternion();

			var length:int = mMs3dJoints.length;
			var bone:Bone;
			var joint:MS3DJoint;
			var track:BoneTrack;
			for (var i:int = 0; i < length; i++)
			{
				bone = new Bone("");
				bones.push(bone);

				joint = mMs3dJoints[i];

				bone.name = joint.name;
				bone.parentName = joint.parentName;

				bone.localPos.copyFrom(joint.translation);
				bone.localRot.fromAngles(joint.rotation.x, joint.rotation.y, joint.rotation.z);

				var times:Vector.<Number> = new Vector.<Number>();
				var rotations:Vector.<Number> = new Vector.<Number>();
				var translations:Vector.<Number> = new Vector.<Number>();

				var position:Vector3f = new Vector3f();
				var rotation:Quaternion = new Quaternion();

				//TODO 由于每个joint.positionKeys和rotationKeys数量不同，所以需要手工创建需要的部分（插值）
				//为了方便，这里将只在关键帧出进行插值
				for (var j:int = 0; j < mNumFrames; j++)
				{
					getKeyFramePositionAt(joint, j, position);
					getKeyFrameRotationAt(joint, j, rotation);

					translations.push(position.x, position.y, position.z);
					rotations.push(rotation.x, rotation.y, rotation.z, rotation.w);

					times.push(j);
				}

				track = new BoneTrack(i, times, translations, rotations);
				animation.addTrack(track);
			}

			var skeleton:Skeleton = new Skeleton(bones);
			var skeletoncontrol:SkeletonControl = new SkeletonControl(geometry, skeleton);
			var animationControl:SkeletonAnimControl = new SkeletonAnimControl(skeleton);
			animationControl.addAnimation("default", animation);

			node.addControl(skeletoncontrol);
			node.addControl(animationControl);
		}

		/**
		 * 获得joint动画某个时间点的位移
		 */
		private function getKeyFramePositionAt(joint:MS3DJoint, time:Number, store:Vector3f):void
		{
			var positionKeys:Vector.<MS3DKeyframe> = joint.positionKeys;

			var posKeyFrame:MS3DKeyframe;
			var posTime:Number;
			var posData:Vector.<Number>;
			if (time == 0)
			{
				posKeyFrame = positionKeys[0];
				posData = posKeyFrame.data;
				store.setTo(posData[0], posData[1], posData[2]);
			}
			else if (time >= mNumFrames)
			{
				posKeyFrame = positionKeys[positionKeys.length - 1];
				posData = posKeyFrame.data;
				store.setTo(posData[0], posData[1], posData[2]);
			}
			else
			{
				var posKeyFrame1:MS3DKeyframe;
				var posTime1:Number;
				var posData1:Vector.<Number>;
				var size:int = positionKeys.length - 1;
				for (var i:int = 0; i < size; i++)
				{
					//position
					posKeyFrame = positionKeys[i];
					posTime = posKeyFrame.time;

					posKeyFrame1 = positionKeys[i + 1];
					posTime1 = posKeyFrame1.time;
					if (time >= posTime && time <= posTime1)
					{
						posData = posKeyFrame.data;
						posData1 = posKeyFrame1.data;

						var interp:Number = (time - posTime) / (posTime1 - posTime);
						var interp1:Number = 1.0 - interp;
						var px:Number = posData[0] * interp1 + interp * posData1[0];
						var py:Number = posData[1] * interp1 + interp * posData1[1];
						var pz:Number = posData[2] * interp1 + interp * posData1[2];

						store.setTo(px, py, pz);

						break;
					}
				}
			}
		}

		/**
		 * 获得joint动画某个时间点的旋转
		 */
		private var _tmpQ1:Quaternion = new Quaternion();
		private var _tmpQ2:Quaternion = new Quaternion();

		private function getKeyFrameRotationAt(joint:MS3DJoint, time:Number, store:Quaternion):void
		{
			var rotKeys:Vector.<MS3DKeyframe> = joint.rotationKeys;
			var rotKeyFrame:MS3DKeyframe;
			var rotTime:Number;
			var rotData:Vector.<Number>;
			if (time == 0)
			{
				rotKeyFrame = rotKeys[0];
				rotData = rotKeyFrame.data;

				store.fromAngles(rotData[0], rotData[1], rotData[2]);
			}
			else if (time >= mNumFrames)
			{
				rotKeyFrame = rotKeys[rotKeys.length - 1];
				rotData = rotKeyFrame.data;
				store.fromAngles(rotData[0], rotData[1], rotData[2]);
			}
			else
			{
				var rotKeyFrame1:MS3DKeyframe;
				var rotTime1:Number;
				var rotData1:Vector.<Number>;
				var size:int = rotKeys.length - 1;
				for (var i:int = 0; i < size; i++)
				{
					//position
					rotKeyFrame = rotKeys[i];
					rotTime = rotKeyFrame.time;

					rotKeyFrame1 = rotKeys[i + 1];
					rotTime1 = rotKeyFrame1.time;
					if (time >= rotTime && time <= rotTime1)
					{
						rotData = rotKeyFrame.data;
						rotData1 = rotKeyFrame1.data;

						_tmpQ1.fromAngles(rotData[0], rotData[1], rotData[2]);
						_tmpQ2.fromAngles(rotData1[0], rotData1[1], rotData1[2]);

						var interp:Number = (time - rotTime) / (rotTime1 - rotTime);
						store.slerp(_tmpQ1, _tmpQ2, interp);

						break;
					}
				}
			}
		}

		private function readHeader(data:ByteArray):void
		{
			var id:String = data.readUTFBytes(10);
			var version:uint = data.readUnsignedInt();
			CF::DEBUG
			{
				Assert.assert(id == "MS3D000000", "This is not a valid MS3D file version.");
				Assert.assert(version == 4, "This is not a valid MS3D file version.");
			}
		}

		private function readVertices(data:ByteArray):void
		{
			//顶点数
			mNumVertices = data.readUnsignedShort();
			mMs3dVertices = new Vector.<MS3DVertex>(mNumVertices, true);
			for (var i:int = 0; i < mNumVertices; i++)
			{
				var ms3dVertex:MS3DVertex = new MS3DVertex();
				//unuse flag
				data.position += 1;
				ms3dVertex.x = data.readFloat();
				ms3dVertex.y = data.readFloat();
				ms3dVertex.z = data.readFloat();
				ms3dVertex.bones[0] = data.readUnsignedByte();
				//unuse
				data.position += 1;
				mMs3dVertices[i] = ms3dVertex;
			}
		}

		private function readTriangles(data:ByteArray):void
		{
			//triangles
			var numTriangles:int = data.readUnsignedShort();
			mMs3dTriangles = new Vector.<MS3DTriangle>(numTriangles, true);
			for (var i:int = 0; i < numTriangles; i++)
			{
				var triangle:MS3DTriangle = new MS3DTriangle();
				//unuse flag
				data.position += 2;
				triangle.indices[0] = data.readUnsignedShort();
				triangle.indices[1] = data.readUnsignedShort();
				triangle.indices[2] = data.readUnsignedShort();
				triangle.normals[0].x = data.readFloat();
				triangle.normals[1].x = data.readFloat();
				triangle.normals[2].x = data.readFloat();
				triangle.normals[0].y = data.readFloat();
				triangle.normals[1].y = data.readFloat();
				triangle.normals[2].y = data.readFloat();
				triangle.normals[0].z = data.readFloat();
				triangle.normals[1].z = data.readFloat();
				triangle.normals[2].z = data.readFloat();
				triangle.tUs[0] = data.readFloat();
				triangle.tUs[1] = data.readFloat();
				triangle.tUs[2] = data.readFloat();
				triangle.tVs[0] = data.readFloat();
				triangle.tVs[1] = data.readFloat();
				triangle.tVs[2] = data.readFloat();
				//smoothingGroup,unuse
				data.position += 1;
				triangle.groupIndex = data.readUnsignedByte();

				mMs3dTriangles[i] = triangle;
			}
		}

		private function readGroups(data:ByteArray):void
		{
			var numGroups:int = data.readUnsignedShort();
			mMs3dGroups = new Vector.<MS3DGroup>(numGroups, true);
			for (var i:int = 0; i < numGroups; i++)
			{
				var group:MS3DGroup = new MS3DGroup();
				//unuse flags
				data.position += 1;

				group.name = data.readUTFBytes(32);

				var numIndices:int = data.readUnsignedShort();
				var indices:Vector.<uint> = new Vector.<uint>(numIndices, true);
				for (var j:int = 0; j < numIndices; j++)
				{
					indices[j] = data.readUnsignedShort();
				}
				group.indices = indices;

				// material index
				group.materialID = data.readUnsignedByte();
				if (group.materialID == 255)
					group.materialID = 0;

				mMs3dGroups[i] = group;
			}
		}

		private function readMaterials(data:ByteArray):void
		{
			// materials
			var numMaterials:int = data.readUnsignedShort();
			mMs3dMaterials = new Vector.<MS3DMaterial>(numMaterials, true);
			for (var i:int = 0; i < numMaterials; i++)
			{
				var mat:MS3DMaterial = new MS3DMaterial();
				mat.name = data.readUTFBytes(32);
				mat.ambient.setTo(data.readFloat(), data.readFloat(), data.readFloat(), data.readFloat());
				mat.diffuse.setTo(data.readFloat(), data.readFloat(), data.readFloat(), data.readFloat());
				mat.emissive.setTo(data.readFloat(), data.readFloat(), data.readFloat(), data.readFloat());
				mat.specular.setTo(data.readFloat(), data.readFloat(), data.readFloat(), data.readFloat());
				mat.shininess = int(data.readFloat()); //0~128
				mat.transparency = data.readFloat(); // 0~1

				//mode
				data.position += 1;

				mat.texture = data.readUTFBytes(128);
				mat.alphaMap = data.readUTFBytes(128);

				mMs3dMaterials[i] = mat;
			}
		}

		private function readWeights(data:ByteArray):void
		{
			if (data.bytesAvailable > 0)
			{
				var vertex:MS3DVertex;
				var subVersion:int = data.readInt();
				if (subVersion == 1 || subVersion == 2)
				{
					for (var i:int = 0; i < mNumVertices; i++)
					{
						vertex = mMs3dVertices[i];

						vertex.bones[1] = data.readByte();
						vertex.bones[2] = data.readByte();
						vertex.bones[3] = data.readByte();

//						if(vertex.bones[1] <0)
//							vertex.bones[1] = 0;
//						if(vertex.bones[2] <0)
//							vertex.bones[2] = 0;
//						if(vertex.bones[2] <0)
//							vertex.bones[2] = 0;

						var w0:Number = data.readUnsignedByte() * 0.01;
						var w1:Number = data.readUnsignedByte() * 0.01;
						var w2:Number = data.readUnsignedByte() * 0.01;

						if (w0 != 0 || w1 != 0 || w2 != 0)
						{
							vertex.weights[0] = w0;
							vertex.weights[1] = w1;
							vertex.weights[2] = w2;
							vertex.weights[3] = 1 - w0 - w1 - w2;
						}

						if (subVersion == 2)
						{
							//extra
							data.position += 4;
						}
					}
				}
				else
				{
					Logger.log("Unknown subversion for vertex extra " + subVersion);
				}
			}
		}

		private function readJoints(data:ByteArray):void
		{
			//animation time
			mFramesPerSecond = data.readFloat();
			if (mFramesPerSecond < 1)
				mFramesPerSecond = 1.0;

			var startTime:Number = data.readFloat();
			CF::DEBUG
			{
				trace("startTime :", startTime);
			}

			//动画帧数
			mNumFrames = data.readInt();

			var numJoints:int = data.readUnsignedShort();
			mMs3dJoints = new Vector.<MS3DJoint>(numJoints, true);
			for (var i:int = 0; i < numJoints; i++)
			{
				//unuse flag
				data.position += 1;

				var joint:MS3DJoint = new MS3DJoint();
				joint.name = data.readUTFBytes(32);
				joint.parentName = data.readUTFBytes(32);

				joint.rotation.setTo(data.readFloat(), data.readFloat(), data.readFloat());
				joint.translation.setTo(data.readFloat(), data.readFloat(), data.readFloat());
//				joint.rotation.x = data.readFloat();
//				joint.rotation.y = data.readFloat();
//				joint.rotation.z = data.readFloat();
//				joint.translation.x = data.readFloat();
//				joint.translation.y = data.readFloat();
//				joint.translation.z = data.readFloat();

				var numKeyFramesRot:uint = data.readUnsignedShort();
				var numKeyFramesPos:uint = data.readUnsignedShort();

				var keyFrame:MS3DKeyframe;

				// the frame time is in seconds, 
				//so multiply it by the animation fps, 
				//to get the frames rotation channel
				joint.rotationKeys = new Vector.<MS3DKeyframe>();
				for (var j:int = 0; j < numKeyFramesRot; j++)
				{
					keyFrame = new MS3DKeyframe();
					keyFrame.time = data.readFloat() * mFramesPerSecond;
					keyFrame.data[0] = data.readFloat();
					keyFrame.data[1] = data.readFloat();
					keyFrame.data[2] = data.readFloat();

					joint.rotationKeys[j] = keyFrame;
				}

				joint.positionKeys = new Vector.<MS3DKeyframe>();
				for (j = 0; j < numKeyFramesPos; j++)
				{
					keyFrame = new MS3DKeyframe();
					keyFrame.time = data.readFloat() * mFramesPerSecond;
					keyFrame.data[0] = data.readFloat();
					keyFrame.data[1] = data.readFloat();
					keyFrame.data[2] = data.readFloat();

					joint.positionKeys[j] = keyFrame;
				}

				mMs3dJoints[i] = joint;
			}
		}

		private function readComments(data:ByteArray):void
		{
			var numComments:int = data.readUnsignedInt();
			for (var j:int = 0; j < numComments; j++)
			{
				var index:int = data.readInt(); //index
				var size:int = data.readInt(); //字符串长度
				if (size > 0)
				{
					var comment:String = data.readUTFBytes(size);
					CF::DEBUG
					{
						trace(comment);
					}
				}
			}
		}

		private function readModelComments(data:ByteArray):void
		{
			var numComments:int = data.readUnsignedInt();
			for (var j:int = 0; j < numComments; j++)
			{
				var size:int = data.readInt(); //字符串长度
				if (size > 0)
				{
					var comment:String = data.readUTFBytes(size);
					trace(comment);
				}
			}
		}

		private function readAllComments(data:ByteArray):void
		{
			if (data.bytesAvailable > 0)
			{
				var subVersion:int = data.readInt();
				if (subVersion == 1)
				{
					//group
					readComments(data);
					//material
					readComments(data);
					//joint
					readComments(data);
					//model
					readModelComments(data);
				}
			}
		}
	}
}
