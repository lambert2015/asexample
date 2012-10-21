package org.angle3d.io.parser.md2
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.MeshHelper;
	import org.angle3d.scene.mesh.MorphMesh;
	import org.angle3d.scene.mesh.MorphData;
	import org.angle3d.scene.mesh.MorphSubMesh;
	import org.angle3d.utils.Assert;

	public class MD2Parser
	{
		public static const MD2_MAGIC_NUMBER:int = 844121161;
		public static const MD2_VERSION:int = 8;

		private var mData:ByteArray;
		private var mHeader:MD2Header;
		private var mFaces:Vector.<int>;
		private var mGlobalUVs:Vector.<Number>;

		private var mMesh:MorphMesh;
		private var mSubMesh:MorphSubMesh;

		private var mLastFrameName:String;


		public function MD2Parser()
		{
			mHeader = new MD2Header();
		}

		public function parse(data:ByteArray):MorphMesh
		{
			mData = data;
			mData.endian = Endian.LITTLE_ENDIAN;
			mData.position = 0;

			mLastFrameName = "";

			mMesh = new MorphMesh();
			mSubMesh = new MorphSubMesh();
			mMesh.addSubMesh(mSubMesh);

			parseHeader();
			parseUVs();
			parseFaces();
			parseFrames();
			finalize();

			return mMesh;
		}

		private function parseHeader():void
		{
			var magic:int = mData.readInt();
			var version:int = mData.readInt();

			if (magic != MD2_MAGIC_NUMBER || version != MD2_VERSION)
			{
				Assert.assert(false, "This is not a md2 model");
				return;
			}

			mHeader.skinWidth = mData.readInt();
			mHeader.skinHeight = mData.readInt();
			mHeader.frameSize = mData.readInt();
			mHeader.numSkins = mData.readInt();
			mHeader.numVertices = mData.readInt();
			mHeader.numTexcoords = mData.readInt();
			mHeader.numFaces = mData.readInt();
			mHeader.numGlCommands = mData.readInt();
			mHeader.numFrames = mData.readInt();
			mHeader.offsetSkins = mData.readInt();
			mHeader.offsetTexcoords = mData.readInt();
			mHeader.offsetFaces = mData.readInt();
			mHeader.offsetFrames = mData.readInt();
			mHeader.offsetGlCommands = mData.readInt();
			mHeader.offsetEnd = mData.readInt();

			mMesh.totalFrame = mHeader.numFrames;
		}

		private function parseUVs():void
		{
			mData.position = mHeader.offsetTexcoords;

			var invWidth:Number = 1.0 / mHeader.skinWidth;
			var invHeight:Number = 1.0 / mHeader.skinHeight;

			mGlobalUVs = new Vector.<Number>();
			for (var i:int = 0; i < mHeader.numTexcoords; i++)
			{
				mGlobalUVs.push((0.5 + mData.readShort()) * invWidth);
				mGlobalUVs.push((0.5 + mData.readShort()) * invHeight);
			}
			mGlobalUVs.fixed = true;
		}

		private function parseFrames():void
		{
			mData.position = mHeader.offsetFrames;

			var numVertices:int = mHeader.numVertices;

			var intVertices:Vector.<int> = new Vector.<int>(numVertices * 3, true);

			var numFrames:int = mHeader.numFrames;
			for (var i:int = 0; i < numFrames; i++)
			{
				//z 与  y 进行了交换
				var sx:Number = mData.readFloat();
				var sz:Number = mData.readFloat();
				var sy:Number = mData.readFloat();
				var tx:Number = mData.readFloat();
				var tz:Number = mData.readFloat();
				var ty:Number = mData.readFloat();

				var frameName:String = mData.readUTFBytes(16);
				frameName = frameName.replace(/[0-9]/g, '');
				if (frameName != mLastFrameName)
				{
					CF::DEBUG
					{
						trace(frameName);
					}
					mMesh.addAnimation(frameName, i, i);
					mLastFrameName = frameName;
				}
				else
				{
					//同一个动作，改变结束帧即可
					mMesh.getAnimation(frameName).end = i;
				}

				//x,y,z,normalIndex
				for (var j:int = 0; j < numVertices; j++)
				{
					// read vertex
					var vx:int = mData.readUnsignedByte();
					var vz:int = mData.readUnsignedByte();
					var vy:int = mData.readUnsignedByte();
					//normal index
					mData.readUnsignedByte();

					var j3:int = j * 3;
					intVertices[j3] = vx;
					intVertices[int(j3 + 1)] = vy;
					intVertices[int(j3 + 2)] = vz;
				}

				var vertices:Vector.<Number> = new Vector.<Number>();

				var numFaces:int = mHeader.numFaces;
				for (var f:int = 0; f < numFaces; f++)
				{
					var f6:int = f * 6;
					var index:int = mFaces[f6] * 3;
					vertices.push(intVertices[index] * sx + tx);
					vertices.push(intVertices[int(index + 1)] * sy + ty);
					vertices.push(intVertices[int(index + 2)] * sz + tz);

					index = mFaces[(f6 + 1)] * 3;
					vertices.push(intVertices[index] * sx + tx);
					vertices.push(intVertices[int(index + 1)] * sy + ty);
					vertices.push(intVertices[int(index + 2)] * sz + tz);

					index = mFaces[(f6 + 2)] * 3;
					vertices.push(intVertices[index] * sx + tx);
					vertices.push(intVertices[int(index + 1)] * sy + ty);
					vertices.push(intVertices[int(index + 2)] * sz + tz);
				}

				vertices.fixed = true;

				mSubMesh.addVertices(vertices);
			}

			intVertices = null;
		}

		private function parseFaces():void
		{
			mData.position = mHeader.offsetFaces;

			mFaces = new Vector.<int>();
			var numFaces:int = mHeader.numFaces;
			for (var i:int = 0; i < numFaces; i++)
			{
				mFaces.push(mData.readShort());
				mFaces.push(mData.readShort());
				mFaces.push(mData.readShort());
				mFaces.push(mData.readShort());
				mFaces.push(mData.readShort());
				mFaces.push(mData.readShort());
			}
			mFaces.fixed = true;
		}

		private function finalize():void
		{
			var count:int = mHeader.numFaces * 3;
			var indices:Vector.<uint> = new Vector.<uint>(count, true);
			for (var f:int = 0; f < count; f++)
			{
				indices[f] = f;
			}

			mSubMesh.setIndices(indices);

			var uvData:Vector.<Number> = new Vector.<Number>();
			var numFaces:int = mHeader.numFaces;
			for (f = 0; f < numFaces; f++)
			{
				var f6:int = f * 6;
				var uvIndex:int = mFaces[int(f6 + 3)] * 2;
				uvData.push(mGlobalUVs[uvIndex]);
				uvData.push(mGlobalUVs[int(uvIndex + 1)]);

				uvIndex = mFaces[int(f6 + 4)] * 2;
				uvData.push(mGlobalUVs[uvIndex]);
				uvData.push(mGlobalUVs[int(uvIndex + 1)]);

				uvIndex = mFaces[int(f6 + 5)] * 2;
				uvData.push(mGlobalUVs[uvIndex]);
				uvData.push(mGlobalUVs[int(uvIndex + 1)]);
			}

			uvData.fixed = true;

			mFaces = null;
			mGlobalUVs = null;

			mSubMesh.setVertexBuffer(BufferType.TEXCOORD, 2, uvData);
			mSubMesh.validate();
		}
	}
}

class MD2Header
{
	public var skinWidth:int;
	public var skinHeight:int;
	public var frameSize:int;
	public var numSkins:int;
	public var numVertices:int;
	public var numTexcoords:int;
	public var numFaces:int;
	public var numGlCommands:int;
	public var numFrames:int;
	public var offsetSkins:int;
	public var offsetTexcoords:int;
	public var offsetFaces:int;
	public var offsetFrames:int;
	public var offsetGlCommands:int;
	public var offsetEnd:int;
}
