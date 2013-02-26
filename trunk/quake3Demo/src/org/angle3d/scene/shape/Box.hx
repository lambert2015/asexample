package org.angle3d.scene.shape;
import org.angle3d.math.Vector3f;
import flash.Vector;
import org.angle3d.math.VectorUtil;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.IndexBuffer;
import org.angle3d.scene.mesh.VertexBuffer;

/**
 * A box with solid (filled) faces.
 * 
 * @author Mark Powell
 */

class Box extends AbstractBox
{
	private static inline var GEOMETRY_INDICES_DATA:Vector<UInt> = VectorUtil.array2UInt([
         2,  1,  0,  3,  2,  0, // back
         6,  5,  4,  7,  6,  4, // right
        10,  9,  8, 11, 10,  8, // front
        14, 13, 12, 15, 14, 12, // left
        18, 17, 16, 19, 18, 16, // top
        22, 21, 20, 23, 22, 20  // bottom
    ]);

    private static inline var GEOMETRY_NORMALS_DATA:Vector<Float> = Vector.ofArray([
        0.0,  0.0, -1.0,  0.0,  0.0, -1.0,  0.0,  0.0, -1.0,  0.0,  0.0, -1.0, // back
        1.0,  0.0,  0.0,  1.0,  0.0,  0.0,  1.0,  0.0,  0.0,  1.0,  0.0,  0.0, // right
        0.0,  0.0,  1.0,  0.0,  0.0,  1.0,  0.0,  0.0,  1.0,  0.0,  0.0,  1.0, // front
       -1.0,  0.0,  0.0, -1.0,  0.0,  0.0, -1.0,  0.0,  0.0, -1.0,  0.0,  0.0, // left
        0.0,  1.0,  0.0,  0.0,  1.0,  0.0,  0.0,  1.0,  0.0,  0.0,  1.0,  0.0, // top
        0.0, -1.0,  0.0,  0.0, -1.0,  0.0,  0.0, -1.0,  0.0,  0.0, -1.0,  0.0  // bottom
    ]);
	
	private static inline var GEOMETRY_COLORS_DATA:Vector<Float> = Vector.ofArray([
        1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, // back
        0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, // right
        1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, // front
        0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, // left
        0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, // top
        0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0  // bottom
    ]);

    private static inline var GEOMETRY_TEXTURE_DATA:Vector<Float> = Vector.ofArray([
        1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, // back
        1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, // right
        1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, // front
        1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, // left
        1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, // top
        1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0  // bottom
    ]);

	/**
     * Creates a new box.
     * <p>
     * The box has a center of 0,0,0 and extends in the out from the center by
     * the given amount in <em>each</em> direction. So, for example, a box
     * with extent of 0.5 would be the unit cube.
     *
     * @param name the name of the box.
     * @param x the size of the box along the x axis, in both directions.
     * @param y the size of the box along the y axis, in both directions.
     * @param z the size of the box along the z axis, in both directions.
     */
	public function new(x:Float, y:Float, z:Float, center:Vector3f = null) 
	{
		super();
		if (center == null)
		{
			center = new Vector3f(0,0,0);
		}
		updateGeometryByXYZ(center, x, y, z);
	}
	
	public function clone():Box
	{
		return new Box(xExtent, yExtent, zExtent, center);
	}

	override private function duUpdateGeometryIndices():Void 
	{
		if (getIndexBuffer() == null)
		{
			var ib:IndexBuffer = new IndexBuffer();
			ib.setData(GEOMETRY_INDICES_DATA);
			setIndexBuffer(ib);
		}
	}
	
	override private function duUpdateGeometryColors():Void
	{
		if (getVertexBuffer(BufferType.Color) == null)
		{
			var vb:VertexBuffer = new VertexBuffer(BufferType.Color);
			vb.setData(GEOMETRY_COLORS_DATA,3);
			addVertexBuffer(vb);
		}
	}
	
	override private function duUpdateGeometryNormals():Void 
	{
		if (getVertexBuffer(BufferType.Normal) == null)
		{
			var vb:VertexBuffer = new VertexBuffer(BufferType.Normal);
			vb.setData(GEOMETRY_NORMALS_DATA,3);
			addVertexBuffer(vb);
		}
	}
	
	override private function duUpdateGeometryTextures():Void 
	{
		if (getVertexBuffer(BufferType.TexCoord) == null)
		{
			var vb:VertexBuffer = new VertexBuffer(BufferType.TexCoord);
			vb.setData(GEOMETRY_TEXTURE_DATA,2);
			addVertexBuffer(vb);
		}
	}
	
	override private function duUpdateGeometryVertices():Void 
	{
        var v:Array<Vector3f> = computeVertices();
		
		var pb:VertexBuffer = new VertexBuffer(BufferType.Position);
        pb.setData(Vector.ofArray([
                v[0].x, v[0].y, v[0].z, v[1].x, v[1].y, v[1].z, v[2].x, v[2].y, v[2].z, v[3].x, v[3].y, v[3].z, // back
                v[1].x, v[1].y, v[1].z, v[4].x, v[4].y, v[4].z, v[6].x, v[6].y, v[6].z, v[2].x, v[2].y, v[2].z, // right
                v[4].x, v[4].y, v[4].z, v[5].x, v[5].y, v[5].z, v[7].x, v[7].y, v[7].z, v[6].x, v[6].y, v[6].z, // front
                v[5].x, v[5].y, v[5].z, v[0].x, v[0].y, v[0].z, v[3].x, v[3].y, v[3].z, v[7].x, v[7].y, v[7].z, // left
                v[2].x, v[2].y, v[2].z, v[6].x, v[6].y, v[6].z, v[7].x, v[7].y, v[7].z, v[3].x, v[3].y, v[3].z, // top
                v[0].x, v[0].y, v[0].z, v[5].x, v[5].y, v[5].z, v[4].x, v[4].y, v[4].z, v[1].x, v[1].y, v[1].z  // bottom
        ]), 3);
		
		v = null;
		
        addVertexBuffer(pb);
        updateBound();
    }
	
}