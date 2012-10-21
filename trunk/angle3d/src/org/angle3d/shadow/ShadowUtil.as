package org.angle3d.shadow
{
	import org.angle3d.bounding.BoundingBox;
	import org.angle3d.bounding.BoundingVolume;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Transform;
	import org.angle3d.math.Vector2f;
	import org.angle3d.math.Vector3f;
	import org.angle3d.renderer.Camera3D;
	import org.angle3d.renderer.queue.GeometryList;
	import org.angle3d.scene.Geometry;
	import org.angle3d.utils.TempVars;

	/**
	 * Includes various useful shadow mapping functions.
	 *
	 * @see
	 * <ul>
	 * <li><a href="http://appsrv.cse.cuhk.edu.hk/~fzhang/pssm_vrcia/">http://appsrv.cse.cuhk.edu.hk/~fzhang/pssm_vrcia/</a></li>
	 * <li><a href="http://http.developer.nvidia.com/GPUGems3/gpugems3_ch10.html">http://http.developer.nvidia.com/GPUGems3/gpugems3_ch10.html</a></li>
	 * </ul>
	 * for more info.
	 */
	public class ShadowUtil
	{
		public static function updateFrustumPoints2(viewCam:Camera3D, points:Vector.<Vector3f>):void
		{
			var w:int=viewCam.width;
			var h:int=viewCam.height;
			var n:Number=viewCam.frustumNear;
			var f:Number=viewCam.frustumFar;

			points[0].copyFrom(viewCam.getWorldCoordinates(new Vector2f(0, 0), n));
			points[1].copyFrom(viewCam.getWorldCoordinates(new Vector2f(0, h), n));
			points[2].copyFrom(viewCam.getWorldCoordinates(new Vector2f(w, h), n));
			points[3].copyFrom(viewCam.getWorldCoordinates(new Vector2f(w, 0), n));

			points[4].copyFrom(viewCam.getWorldCoordinates(new Vector2f(0, 0), f));
			points[5].copyFrom(viewCam.getWorldCoordinates(new Vector2f(0, h), f));
			points[6].copyFrom(viewCam.getWorldCoordinates(new Vector2f(w, h), f));
			points[7].copyFrom(viewCam.getWorldCoordinates(new Vector2f(w, 0), f));
		}

		public static function updateFrustumPoints(viewCam:Camera3D, nearOverride:Number, farOverride:Number, scale:Number, points:Vector.<Vector3f>):void
		{
			var pos:Vector3f=viewCam.location;
			var dir:Vector3f=viewCam.getDirection();
			var up:Vector3f=viewCam.getUp();

			var depthHeightRatio:Number=viewCam.frustumTop / viewCam.frustumNear;
			var near:Number=nearOverride;
			var far:Number=farOverride;
			var ftop:Number=viewCam.frustumTop;
			var fright:Number=viewCam.frustumRight;
			var ratio:Number=fright / ftop;

			var near_height:Number;
			var near_width:Number;
			var far_height:Number;
			var far_width:Number;

			if (viewCam.parallelProjection)
			{
				near_height=ftop;
				near_width=near_height * ratio;
				far_height=ftop;
				far_width=far_height * ratio;
			}
			else
			{
				near_height=depthHeightRatio * near;
				near_width=near_height * ratio;
				far_height=depthHeightRatio * far;
				far_width=far_height * ratio;
			}

			var right:Vector3f=dir.cross(up).normalizeLocal();

			var temp:Vector3f=new Vector3f();
			temp.copyFrom(dir).scaleLocal(far).addLocal(pos);
			var farCenter:Vector3f=temp.clone();
			temp.copyFrom(dir).scaleLocal(near).addLocal(pos);
			var nearCenter:Vector3f=temp.clone();

			var nearUp:Vector3f=temp.copyFrom(up).scaleLocal(near_height).clone();
			var farUp:Vector3f=temp.copyFrom(up).scaleLocal(far_height).clone();
			var nearRight:Vector3f=temp.copyFrom(right).scaleLocal(near_width).clone();
			var farRight:Vector3f=temp.copyFrom(right).scaleLocal(far_width).clone();

			points[0].copyFrom(nearCenter).subtractLocal(nearUp).subtractLocal(nearRight);
			points[1].copyFrom(nearCenter).addLocal(nearUp).subtractLocal(nearRight);
			points[2].copyFrom(nearCenter).addLocal(nearUp).addLocal(nearRight);
			points[3].copyFrom(nearCenter).subtractLocal(nearUp).addLocal(nearRight);

			points[4].copyFrom(farCenter).subtractLocal(farUp).subtractLocal(farRight);
			points[5].copyFrom(farCenter).addLocal(farUp).subtractLocal(farRight);
			points[6].copyFrom(farCenter).addLocal(farUp).addLocal(farRight);
			points[7].copyFrom(farCenter).subtractLocal(farUp).addLocal(farRight);

			if (scale != 1.0)
			{
				// find center of frustum
				var center:Vector3f=new Vector3f();
				for (var i:int=0; i < 8; i++)
				{
					center.addLocal(points[i]);
				}
				center.scaleLocal(1 / 8);

				var cDir:Vector3f=new Vector3f();
				for (i=0; i < 8; i++)
				{
					cDir.copyFrom(points[i]).subtractLocal(center);
					cDir.scaleLocal(scale - 1.0);
					points[i].addLocal(cDir);
				}
			}
		}

		/**
		 * Updates the shadow camera to properly contain the given
		 * points (which contain the eye camera frustum corners)
		 *
		 * @param shadowCam
		 * @param points
		 */
		public static function updateShadowCameraByCorner(shadowCam:Camera3D, points:Vector.<Vector3f>):void
		{
			var ortho:Boolean=shadowCam.parallelProjection;
			shadowCam.setProjectionMatrix(null);

			if (ortho)
			{
				shadowCam.setFrustum(-1, 1, -1, 1, 1, -1);
			}
			else
			{
				shadowCam.setFrustumPerspective(45, 1, 1, 150);
			}

			var viewProjMatrix:Matrix4f=shadowCam.getViewProjectionMatrix();
			var projMatrix:Matrix4f=shadowCam.getProjectionMatrix();

			var splitBB:BoundingBox=computeBoundForPointsM(points, viewProjMatrix);

			var vars:TempVars=TempVars.getTempVars();

			var splitMin:Vector3f=splitBB.getMin(vars.vect1);
			var splitMax:Vector3f=splitBB.getMax(vars.vect2);

			//        splitMin.z = 0;

			// Create the crop matrix.
			var scaleX:Number, scaleY:Number, scaleZ:Number;
			var offsetX:Number, offsetY:Number, offsetZ:Number;

			scaleX=2.0 / (splitMax.x - splitMin.x);
			scaleY=2.0 / (splitMax.y - splitMin.y);
			offsetX=-0.5 * (splitMax.x + splitMin.x) * scaleX;
			offsetY=-0.5 * (splitMax.y + splitMin.y) * scaleY;
			scaleZ=1.0 / (splitMax.z - splitMin.z);
			offsetZ=-splitMin.z * scaleZ;

			var cropMatrix:Matrix4f=vars.tempMat4;
			cropMatrix.setArray([scaleX, 0, 0, offsetX, 0, scaleY, 0, offsetY, 0, 0, scaleZ, offsetZ, 0, 0, 0, 1]);


			var result:Matrix4f=new Matrix4f();
			result.copyFrom(cropMatrix);
			result.multLocal(projMatrix);

			vars.release();
			shadowCam.setProjectionMatrix(result);
		}

		/**
		 *
		 * @param occluders
		 * @param receivers
		 * @param shadowCam
		 * @param points
		 * @param splitOccluders
		 *
		 */
		public static function updateShadowCamera(occluders:GeometryList, receivers:GeometryList, shadowCam:Camera3D, points:Vector.<Vector3f>, splitOccluders:GeometryList=null):void
		{
			var ortho:Boolean=shadowCam.parallelProjection;
			shadowCam.setProjectionMatrix(null);

			if (ortho)
			{
				shadowCam.setFrustum(-1, 1, -1, 1, 1, -1);
			}
			else
			{
				shadowCam.setFrustumPerspective(45, 1, 1, 150);
			}

			// create transform to rotate points to viewspace        
			var viewProjMatrix:Matrix4f=shadowCam.getViewProjectionMatrix();

			var splitBB:BoundingBox=computeBoundForPointsM(points, viewProjMatrix);

			var visRecvList:Vector.<BoundingVolume>=new Vector.<BoundingVolume>();
			var bv:BoundingVolume
			for (var i:int=0; i < receivers.size; i++)
			{
				// convert bounding box to light's viewproj space
				var receiver:Geometry=receivers.getGeometry(i);
				bv=receiver.worldBound;
				var recvBox:BoundingVolume=bv.transformByMatrix(viewProjMatrix, null);

				if (splitBB.intersects(recvBox))
				{
					visRecvList.push(recvBox);
				}
			}

			var visOccList:Vector.<BoundingVolume>=new Vector.<BoundingVolume>();
			for (i=0; i < occluders.size; i++)
			{
				// convert bounding box to light's viewproj space
				var occluder:Geometry=occluders.getGeometry(i);
				bv=occluder.worldBound;
				var occBox:BoundingVolume=bv.transformByMatrix(viewProjMatrix, null);

				var intersects:Boolean=splitBB.intersects(occBox);
				if (!intersects && occBox is BoundingBox)
				{
					var occBB:BoundingBox=occBox as BoundingBox;
					//Kirill 01/10/2011
					// Extend the occluder further into the frustum
					// This fixes shadow dissapearing issues when
					// the caster itself is not in the view camera
					// but its shadow is in the camera
					//      The number is in world units
					occBB.zExtent=occBB.zExtent + 50;
					occBB.setCenter(occBB.getCenter().addLocal(new Vector3f(0, 0, 25)));
					if (splitBB.intersects(occBB))
					{
						// To prevent extending the depth range too much
						// We return the bound to its former shape
						// Before adding it
						occBB.zExtent=occBB.zExtent - 50;
						occBB.setCenter(occBB.getCenter().subtractLocal(new Vector3f(0, 0, 25)));
						visOccList.push(occBox);
						if (splitOccluders != null)
						{
							splitOccluders.add(occluder);
						}
					}
				}
				else if (intersects)
				{
					visOccList.push(occBox);
					if (splitOccluders != null)
					{
						splitOccluders.add(occluder);
					}
				}
			}

			var casterBB:BoundingBox=computeUnionBound3(visOccList);
			var receiverBB:BoundingBox=computeUnionBound3(visRecvList);

			//Nehon 08/18/2010 this is to avoid shadow bleeding when the ground is set to only receive shadows
			if (visOccList.length != visRecvList.length)
			{
				casterBB.xExtent=casterBB.xExtent + 2.0;
				casterBB.yExtent=casterBB.yExtent + 2.0;
				casterBB.zExtent=casterBB.zExtent + 2.0;
			}

			var vars:TempVars=TempVars.getTempVars();

			var casterMin:Vector3f=casterBB.getMin(vars.vect1);
			var casterMax:Vector3f=casterBB.getMax(vars.vect2);

			var receiverMin:Vector3f=receiverBB.getMin(vars.vect3);
			var receiverMax:Vector3f=receiverBB.getMax(vars.vect4);

			var splitMin:Vector3f=splitBB.getMin(vars.vect5);
			var splitMax:Vector3f=splitBB.getMax(vars.vect6);

			splitMin.z=0;

			if (!ortho)
			{
				shadowCam.setFrustumPerspective(45, 1, 1, splitMax.z);
			}

			var projMatrix:Matrix4f=shadowCam.getProjectionMatrix();

			var cropMin:Vector3f=vars.vect7;
			var cropMax:Vector3f=vars.vect8;

			// IMPORTANT: Special handling for Z values
			cropMin.x=Math.max(casterMin.x, receiverMin.x, splitMin.x);
			cropMax.x=Math.min(casterMax.x, receiverMax.x, splitMax.x);

			cropMin.y=Math.max(casterMin.y, receiverMin.y, splitMin.y);
			cropMax.y=Math.min(casterMax.y, receiverMax.y, splitMax.y);

			cropMin.z=Math.min(casterMin.z, splitMin.z);
			cropMax.z=Math.min(receiverMax.z, splitMax.z);


			// Create the crop matrix.
			var scaleX:Number, scaleY:Number, scaleZ:Number;
			var offsetX:Number, offsetY:Number, offsetZ:Number;

			scaleX=(2.0) / (cropMax.x - cropMin.x);
			scaleY=(2.0) / (cropMax.y - cropMin.y);

			offsetX=-0.5 * (cropMax.x + cropMin.x) * scaleX;
			offsetY=-0.5 * (cropMax.y + cropMin.y) * scaleY;

			scaleZ=1.0 / (cropMax.z - cropMin.z);
			offsetZ=-cropMin.z * scaleZ;




			var cropMatrix:Matrix4f=vars.tempMat4;
			cropMatrix.setArray([scaleX, 0, 0, offsetX, 0, scaleY, 0, offsetY, 0, 0, scaleZ, offsetZ, 0, 0, 0, 1]);


			var result:Matrix4f=new Matrix4f();
			result.copyFrom(cropMatrix);
			result.multLocal(projMatrix);
			vars.release();

			shadowCam.setProjectionMatrix(result);
		}

		/**
		 * Compute bounds of a geomList
		 * @param list
		 * @param transform
		 * @return
		 */
		public static function computeUnionBound(list:GeometryList, transform:Transform):BoundingBox
		{
			var bbox:BoundingBox=new BoundingBox();
			for (var i:int=0; i < list.size; i++)
			{
				var vol:BoundingVolume=list.getGeometry(i).worldBound;
				var newVol:BoundingVolume=vol.transform(transform);
				//Nehon : prevent NaN and infinity values to screw the final bounding box
				if (!isNaN(newVol.getCenter().x) && isFinite(newVol.getCenter().x))
				{
					bbox.mergeLocal(newVol);
				}
			}
			return bbox;
		}

		/**
		 * Compute bounds of a geomList
		 * @param list
		 * @param mat
		 * @return
		 */
		public static function computeUnionBound2(list:GeometryList, mat:Matrix4f):BoundingBox
		{
			var bbox:BoundingBox=new BoundingBox();
			var store:BoundingVolume=null;
			for (var i:int=0; i < list.size; i++)
			{
				var vol:BoundingVolume=list.getGeometry(i).worldBound;
				store=vol.clone().transformByMatrix(mat, null);
				//Nehon : prevent NaN and infinity values to screw the final bounding box
				if (!isNaN(store.getCenter().x) && isFinite(store.getCenter().x))
				{
					bbox.mergeLocal(store);
				}
			}
			return bbox;
		}

		/**
		 * Computes the bounds of multiple bounding volumes
		 * @param bv
		 * @return
		 */
		public static function computeUnionBound3(bv:Vector.<BoundingVolume>):BoundingBox
		{
			var bbox:BoundingBox=new BoundingBox();
			for (var i:int=0; i < bv.length; i++)
			{
				var vol:BoundingVolume=bv[i];
				bbox.mergeLocal(vol);
			}
			return bbox;
		}

		/**
		 * Compute bounds from an array of points
		 * @param pts
		 * @param transform
		 * @return
		 */
		public static function computeBoundForPointsT(pts:Vector.<Vector3f>, transform:Transform):BoundingBox
		{
			var min:Vector3f=Vector3f.POSITIVE_INFINITY.clone();
			var max:Vector3f=Vector3f.NEGATIVE_INFINITY.clone();
			var temp:Vector3f=new Vector3f();
			for (var i:int=0; i < pts.length; i++)
			{
				transform.transformVector(pts[i], temp);

				min.minLocal(temp);
				max.maxLocal(temp);
			}
			var center:Vector3f=min.add(max).scaleLocal(0.5);
			var extent:Vector3f=max.subtract(min).scaleLocal(0.5);
			return new BoundingBox(center, extent);
		}

		/**
		 * Compute bounds from an array of points
		 * @param pts
		 * @param mat
		 * @return
		 */
		public static function computeBoundForPointsM(pts:Vector.<Vector3f>, mat:Matrix4f):BoundingBox
		{
			var min:Vector3f=Vector3f.POSITIVE_INFINITY.clone();
			var max:Vector3f=Vector3f.NEGATIVE_INFINITY.clone();

			var tempVar:TempVars=TempVars.getTempVars();
			var temp:Vector3f=tempVar.vect1;

			var size:int=pts.length;
			for (var i:int=0; i < size; i++)
			{
				var w:Number=mat.multProj(pts[i], temp);
				temp.scaleLocal(1 / w);

				min.minLocal(temp);
				max.maxLocal(temp);
			}

			tempVar.release();

			var center:Vector3f=min.add(max).scaleLocal(0.5);
			var extent:Vector3f=max.subtract(min).scaleLocal(0.5);
			extent.x+=2;
			extent.y+=2;
			extent.z+=2.5;
			//Nehon 08/18/2010 : Added an offset to the extend to avoid banding artifacts when the frustum are aligned
			return new BoundingBox(center, extent);
		}
	}
}
