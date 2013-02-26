package quake3.bsp;
import flash.display.BitmapData;
import flash.display3D.Context3D;
import flash.display3D.textures.Texture;
import flash.geom.Vector3D;
import flash.Vector;
import quake3.core.Vertex;
import quake3.math.AABBox;
import quake3.math.Plane3D;
import quake3.core.GroupGeometry;
import quake3.core.IGeometry;

class BSP 
{
	public var shaders:Vector<BSPShader>;
	public var planes:Vector<Plane3D>;
	public var nodes:Vector<BSPNode>;
	public var leaves:Vector<BSPLeaf>;
	public var faces:Vector<BSPFace>;
	public var brushes:Vector<BSPBrush>;
	public var brushSides:Vector<BSPBrushSide>;
	public var leafFaces:Vector<Int>;
	public var leafBrushes:Vector<Int>;
	public var visData:BSPVisData;

	public var entities:Dynamic;

	public var group:GroupGeometry;
	
	// Visibility Checking
	private var lastLeaf:BSPLeaf;
	public var facesSet:BitSet;

	public function new() 
	{
		lastLeaf = null;

		group = new GroupGeometry();
	}
	
	public function setVertices(vertices:Vector<Vertex>):Void
	{
		group.vertices = vertices;
	}
	
	public function uploadGeometry(context:Context3D):Void
	{
		group.uploadBuffers(context);
	}
	
	public function getDefaultPlayerPosition(index:Int):Vector3D
	{
		var info:Dynamic = entities.info_player_deathmatch;
		return info[index].origin;
	}
	
	public function getDefaultPlayerAngle(index:Int):Float
	{
		var info:Dynamic = entities.info_player_deathmatch;
		return info[index].angle;
	}
	
	public function getNumPlayer():Int
	{
		var info:Dynamic = entities.info_player_deathmatch;
		return info.length;
	}

	/**
	 * 判断某个leaf是否可见
	 * @param	visCluster  通常是相机所在的leaf.cluster
	 * @param	testCluster 要测试的Cluster
	 * @return  true代表该节点可见，否则不可见
	 */
	public function isClusterVisible(visCluster:Int, testCluster:Int):Bool
	{
		if (visCluster == testCluster || visCluster < 0)
		{
			return true;
		}
		
		var i:Int = (visCluster * visData.size) + (testCluster >> 3);
		var visSet:Int = visData.buffer[i];
		return ((visSet & (1 << (testCluster & 7))) != 0);
	}
	
	/** 
	 * Used to find which leaf a camera or other object is in.
	 *
	 * @param position position to use when finding leaf
	 *
	 * @return An index to the current leaf or -1
	 */
	public function getLeafIndex(position : Vector3D) : Int
	{
		var index : Int = 0;
		while (index >= 0)
		{
			var node : BSPNode = nodes[index];
			
			var plane : Plane3D = planes[node.plane];
			
			// Distance from point to a plane
			if ((plane.normal.dotProduct(position) - plane.d) < 0)
			{
				index = node.back;
			} 
			else 
			{
				index = node.front;
			}
		}
		return -index - 1;
	}
	
	/**
	 * Returns a BSPLeaf for the supplied index
	 * @param : leaf index. Use findCurrentLeaf to get a vaild index
	 * @return : leaf or null if index is out of range
	 */
	public function getLeafByIndex(index : Int) : BSPLeaf
	{
		var leaf : BSPLeaf = null;
		var numLeaf:Int = leaves.length;
		if (index > -1 && index < numLeaf)
		{
			leaf = leaves[index];
			if(leaf.cluster == - 1)
			{
				return null;
			}
		}
		return leaf;
	}
	
	/**
	 * 根据当前位置和包围盒找出可见的BSPFace
	 * @param	position 相机位置
	 * @param	box 包围盒,可选
	 */
	public function calculateVisibleFaces(position:Vector3D,box:AABBox=null):Void
	{
		//Clear the list of faces drawn
		facesSet.clear();
		
		var leaf:BSPLeaf = getLeafByIndex(getLeafIndex(position));
		
		if (leaf == null)
		{
			leaf = lastLeaf;
		}
		else
		{
			lastLeaf = leaf;
		}
		
		if (leaf != null)
		{
			var cluster:Int = leaf.cluster;
			
			//loop through the leaves
			for (i in 0...leaves.length)
			{
				var currentLeaf:BSPLeaf = leaves[i];

				//if the leaf is not in the PVS, continue
				if (!isClusterVisible(cluster, currentLeaf.cluster))
				{
					continue;
				}
				
				//if this leaf does not lie in the AABBox, continue
				//if (box != null && !currentLeaf.boundingBox.intersectsWithBox(box))
				//{
					//continue;
				//}
				
				//loop through faces in this leaf and mark them to be drawn
				for (j in 0...currentLeaf.numLeafFace)
				{
					facesSet.set(leafFaces[currentLeaf.firstLeafFace + j]);
				}
			}
		}
	}
}