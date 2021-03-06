package org.angle3d.scene
{

	/**
	 * <code>SceneGraphVisitorAdapter</code> is used to traverse the scene
	 * graph tree. The adapter version of the public interface simply separates
	 * between the {@link Geometry geometries} and the {@link Node nodes} by
	 * supplying visit methods that take them.
	 * Use by calling {@link Spatial#depthFirstTraversal(org.angle3d.scene.SceneGraphVisitor) }
	 * or {@link Spatial#breadthFirstTraversal(org.angle3d.scene.SceneGraphVisitor)}.
	 */
	public class SceneGraphVisitorAdapter implements SceneGraphVisitor
	{

		public function SceneGraphVisitorAdapter()
		{
		}

		public function visit(spatial:Spatial):void
		{
			if (spatial is Geometry)
			{
				visitGeometry(spatial as Geometry);
			}
			else
			{
				visitNode(spatial as Node);
			}
		}


		/**
		 * Called when a {@link Geometry} is visited.
		 *
		 * @param geom The visited geometry
		 */
		private function visitGeometry(geom:Geometry):void
		{
		}

		/**
		 * Called when a {@link visit} is visited.
		 *
		 * @param geom The visited node
		 */
		private function visitNode(node:Node):void
		{
			if (node == null)
			{
				return;
			}

		}
	}
}

