package org.angle3d.scene.shape
{
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.SubMesh;


	/**
	 * An eight sided box.
	 * <p>
	 * A {@code Box} is defined by a minimal point and a maximal point. The eight
	 * vertices that make the box are then computed, they are computed in such
	 * a way as to generate an axis-aligned box.
	 * <p>
	 * This public class does not control how the geometry data is generated, see {@link Box}
	 * for that.
	 */
	public class AbstractBox extends Mesh
	{
		public var center:Vector3f;

		public var xExtent:Number;
		public var yExtent:Number;
		public var zExtent:Number;

		protected var subMesh:SubMesh;

		public function AbstractBox()
		{
			super();

			center=new Vector3f(0, 0, 0);
		}

		/**
		 * Gets the array or vectors representing the 8 vertices of the box.
		 *
		 * @return a newly created array of vertex vectors.
		 */
		protected function computeVertices():Vector.<Vector3f>
		{
			var cx:Number=center.x;
			var cy:Number=center.y;
			var cz:Number=center.z;
			return Vector.<Vector3f>([new Vector3f(cx - xExtent, cy - yExtent, cz - zExtent), new Vector3f(cx + xExtent, cy - yExtent, cz - zExtent), new Vector3f(cx + xExtent, cy + yExtent, cz - zExtent), new Vector3f(cx - xExtent, cy + yExtent, cz - zExtent), new Vector3f(cx + xExtent, cy - yExtent, cz + zExtent), new Vector3f(cx - xExtent, cy - yExtent, cz + zExtent), new Vector3f(cx + xExtent, cy + yExtent, cz + zExtent), new Vector3f(cx - xExtent, cy + yExtent, cz + zExtent)]);
		}

		/**
		 * Convert the indices into the list of vertices that define the box's geometry.
		 */
		protected function duUpdateGeometryIndices():void
		{

		}

		/**
		 * Update the normals of each of the box's planes.
		 */
		protected function duUpdateGeometryNormals():void
		{

		}

		/**
		 * Update the colors of each of the box's planes.
		 */
		protected function duUpdateGeometryColors():void
		{

		}

		/**
		 * Update the points that define the texture of the box.
		 * <p>
		 * It's a one-to-one ratio, where each plane of the box has it's own copy
		 * of the texture. That is, the texture is repeated one time for each face.
		 */
		protected function duUpdateGeometryTextures():void
		{

		}

		/**
		 * Update the position of the vertices that define the box.
		 * <p>
		 * These eight points are determined from the minimum and maximum point.
		 */
		protected function duUpdateGeometryVertices():void
		{

		}

		/**
		 * Rebuilds the box after a property has been directly altered.
		 * <p>
		 * For example, if you call {@code getXExtent().x = 5.0f} then you will
		 * need to call this method afterwards in order to update the box.
		 */
		public function updateGeometry():void
		{
			subMesh=new SubMesh();
			duUpdateGeometryVertices();
			duUpdateGeometryTextures();
			duUpdateGeometryNormals();
			duUpdateGeometryColors();
			duUpdateGeometryIndices();
			this.addSubMesh(subMesh);
		}

		/**
		 * Rebuilds this box based on a new set of parameters.
		 * <p>
		 * Note that the actual sides will be twice the given extent values because
		 * the box extends in both directions from the center for each extent.
		 *
		 * @param center the center of the box.
		 * @param x the x extent of the box, in each directions.
		 * @param y the y extent of the box, in each directions.
		 * @param z the z extent of the box, in each directions.
		 */
		public function updateGeometryByXYZ(center:Vector3f, x:Number, y:Number, z:Number):void
		{
			this.center.copyFrom(center);
			this.xExtent=x;
			this.yExtent=y;
			this.zExtent=z;
			updateGeometry();
		}

		/**
		 * Rebuilds this box based on a new set of parameters.
		 * <p>
		 * The box is updated so that the two opposite corners are {@code minPoint}
		 * and {@code maxPoint}, the other corners are created from those two positions.
		 *
		 * @param minPoint the new minimum point of the box.
		 * @param maxPoint the new maximum point of the box.
		 */
		public function updateGeometryByMinMax(min:Vector3f, max:Vector3f):void
		{
			this.center=max.subtract(min, this.center);
			updateGeometryByXYZ(center, max.x - center.x, max.y - center.y, max.z - center.z);
		}
	}
}

