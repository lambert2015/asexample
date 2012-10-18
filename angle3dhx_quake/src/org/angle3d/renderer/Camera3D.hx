package org.angle3d.renderer;
import org.angle3d.math.Vector3f;
import flash.Lib;
import flash.Vector;
import org.angle3d.bounding.BoundingBox;
import org.angle3d.bounding.BoundingVolume;
import org.angle3d.math.FastMath;
import org.angle3d.math.Matrix4f;
import org.angle3d.math.Plane;
import org.angle3d.math.PlaneSide;
import org.angle3d.math.Quaternion;
import org.angle3d.math.Vector2f;
import org.angle3d.math.Vector4f;
import org.angle3d.scene.FrustumIntersect;
import org.angle3d.utils.TempVars;

/**
 * <code>Camera</code> is a standalone, purely mathematical class for doing
 * camera-related computations.
 *
 * <p>
 * Given input data such as location, orientation (direction, left, up),
 * and viewport settings, it can compute data neccessary to render objects
 * with the graphics library. Two matrices are generated, the view matrix
 * transforms objects from world space into eye space, while the projection
 * matrix transforms objects from eye space into clip space.
 * </p>
 * <p>Another purpose of the camera class is to do frustum culling operations,
 * defined by six planes which define a 3D frustum shape, it is possible to
 * test if an object bounded by a mathematically defined volume is inside
 * the camera frustum, and thus to avoid rendering objects that are outside
 * the frustum
 * </p>
 *
 * @author Mark Powell
 * @author Joshua Slack
 */

class Camera3D 
{
	//planes of the frustum
    /**
     * LEFT_PLANE represents the left plane of the camera frustum.
     */
    private static inline var LEFT_PLANE:Int = 0;
    /**
     * RIGHT_PLANE represents the right plane of the camera frustum.
     */
    private static inline var RIGHT_PLANE:Int = 1;
    /**
     * BOTTOM_PLANE represents the bottom plane of the camera frustum.
     */
    private static inline var BOTTOM_PLANE:Int = 2;
    /**
     * TOP_PLANE represents the top plane of the camera frustum.
     */
    private static inline var TOP_PLANE:Int = 3;
    /**
     * FAR_PLANE represents the far plane of the camera frustum.
     */
    private static inline var FAR_PLANE:Int = 4;
    /**
     * NEAR_PLANE represents the near plane of the camera frustum.
     */
    private static inline var NEAR_PLANE:Int = 5;
    /**
     * FRUSTUM_PLANES represents the number of planes of the camera frustum.
     */
    private static inline var FRUSTUM_PLANES:Int = 6;
    /**
     * MAX_WORLD_PLANES holds the maximum planes allowed by the system.
     */
    private static inline var MAX_WORLD_PLANES:Int = 6;
	

    /**
     * Camera's location
     */
    private var location:Vector3f;
    /**
     * The orientation of the camera.
     */
    private var rotation:Quaternion;
    /**
     * Distance from camera to near frustum plane.
     */
    private var frustumNear:Float;
    /**
     * Distance from camera to far frustum plane.
     */
    private var frustumFar:Float;
    /**
     * Distance from camera to left frustum plane.
     */
    private var frustumLeft:Float;
    /**
     * Distance from camera to right frustum plane.
     */
    private var frustumRight:Float;
    /**
     * Distance from camera to top frustum plane.
     */
    private var frustumTop:Float;
    /**
     * Distance from camera to bottom frustum plane.
     */
    private var frustumBottom:Float;
	
    //Temporary values computed in onFrustumChange that are needed if a
    //call is made to onFrameChange.
    private var coeffLeft:Vector<Float>;
    private var coeffRight:Vector<Float>;
    private var coeffBottom:Vector<Float>;
    private var coeffTop:Vector<Float>;
	
	
    //view port coordinates
    /**
     * Percent value on display where horizontal viewing starts for this camera.
     * Default is 0.
     */
    private var viewPortLeft:Float;
    /**
     * Percent value on display where horizontal viewing ends for this camera.
     * Default is 1.
     */
    private var viewPortRight:Float;
    /**
     * Percent value on display where vertical viewing ends for this camera.
     * Default is 1.
     */
    private var viewPortTop:Float;
    /**
     * Percent value on display where vertical viewing begins for this camera.
     * Default is 0.
     */
    private var viewPortBottom:Float;
	
    /**
     * Array holding the planes that this camera will check for culling.
     */
    private var worldPlanes:Vector<Plane>;
    /**
     * A mask value set during contains() that allows fast culling of a Node's
     * children.
     */
    private var planeState:Int;
	
    private var width:Int;
    private var height:Int;
    private var viewportChanged:Bool;
	
    /**
     * store the value for field parallelProjection
     */
    private var parallelProjection:Bool;
    private var projectionMatrixOverride:Matrix4f;
	
    private var viewMatrix:Matrix4f;
    private var projectionMatrix:Matrix4f;
    private var viewProjectionMatrix:Matrix4f;
	
    private var guiBounding:BoundingBox;
	
    /** The camera's name. */
    private var name:String;
	
	public function new(width:Int,height:Int) 
	{
		_init();
		
		this.width = width;
        this.height = height;

        onFrustumChange();
        onViewPortChange();
        onFrameChange();
	}
	
	private function _init():Void
	{
		worldPlanes = new Vector<Plane>(MAX_WORLD_PLANES,true);
        for (i in 0...MAX_WORLD_PLANES) 
		{
            worldPlanes[i] = new Plane();
        }
		
		viewportChanged = true;
		
		viewMatrix = new Matrix4f();
		projectionMatrix = new Matrix4f();
		viewProjectionMatrix = new Matrix4f();
		
		guiBounding = new BoundingBox();
		
		location = new Vector3f();
        rotation = new Quaternion();

        frustumNear = 1.0;
        frustumFar = 2.0;
        frustumLeft = -0.5;
        frustumRight = 0.5;
        frustumTop = 0.5;
        frustumBottom = -0.5;
		
		coeffLeft = new Vector<Float>(2);
		coeffRight = new Vector<Float>(2);
		coeffBottom = new Vector<Float>(2);
		coeffTop = new Vector<Float>(2);

        viewPortLeft = 0.0;
        viewPortRight = 1.0;
        viewPortTop = 1.0;
        viewPortBottom = 0.0;
	}
	
	/**
	 * This method copise the settings of the given camera.
	 * 
	 * @param cam
	 *            the camera we copy the settings from
	 */
    public function copyFrom(cam:Camera3D):Void
	{
    	location.copyFrom(cam.location);
        rotation.copyFrom(cam.rotation);

        frustumNear = cam.frustumNear;
        frustumFar = cam.frustumFar;
        frustumLeft = cam.frustumLeft;
        frustumRight = cam.frustumRight;
        frustumTop = cam.frustumTop;
        frustumBottom = cam.frustumBottom;

        coeffLeft[0] = cam.coeffLeft[0];
        coeffLeft[1] = cam.coeffLeft[1];
        coeffRight[0] = cam.coeffRight[0];
        coeffRight[1] = cam.coeffRight[1];
        coeffBottom[0] = cam.coeffBottom[0];
        coeffBottom[1] = cam.coeffBottom[1];
        coeffTop[0] = cam.coeffTop[0];
        coeffTop[1] = cam.coeffTop[1];

        viewPortLeft = cam.viewPortLeft;
        viewPortRight = cam.viewPortRight;
        viewPortTop = cam.viewPortTop;
        viewPortBottom = cam.viewPortBottom;

        this.width = cam.width;
        this.height = cam.height;
        
        this.planeState = cam.planeState;
        this.viewportChanged = cam.viewportChanged;
        for (i in 0...MAX_WORLD_PLANES)
		{
            worldPlanes[i].normal.copyFrom(cam.worldPlanes[i].normal);
            worldPlanes[i].constant =  cam.worldPlanes[i].constant;
        }
        
        this.parallelProjection = cam.parallelProjection;
        if (cam.projectionMatrixOverride != null) 
		{
        	if (this.projectionMatrixOverride == null) 
			{
        		this.projectionMatrixOverride = cam.projectionMatrixOverride.clone();
        	} 
			else 
			{
        		this.projectionMatrixOverride.copyFrom(cam.projectionMatrixOverride);
        	}
        } 
		else 
		{
        	this.projectionMatrixOverride = null;
        }
        this.viewMatrix.copyFrom(cam.viewMatrix);
        this.projectionMatrix.copyFrom(cam.projectionMatrix);
        this.viewProjectionMatrix.copyFrom(cam.viewProjectionMatrix);
        
        this.guiBounding.copyFrom(cam.guiBounding);
        
        this.name = cam.name;
    }
	
	public function clone():Camera3D
	{
		var cam:Camera3D = new Camera3D(width, height);
		cam.viewportChanged = true;
		cam.planeState = 0;
		
		for (i in 0...MAX_WORLD_PLANES) 
		{
            cam.worldPlanes[i].copyFrom(worldPlanes[i]);
        }
		
		cam.location.copyFrom(location);
		cam.rotation.copyFrom(rotation);
		
		if (projectionMatrixOverride != null)
		{
			cam.projectionMatrixOverride = projectionMatrixOverride.clone();
		}
		
		cam.viewMatrix.copyFrom(viewMatrix);
		cam.projectionMatrix.copyFrom(projectionMatrix);
		cam.viewProjectionMatrix.copyFrom(viewProjectionMatrix);
		cam.guiBounding = Lib.as(guiBounding.clone(), BoundingBox);
		
		cam.update();
		
		return cam;
	}
	
	/**
     * This method sets the cameras name.
     * @param name the cameras name
     */
	public function setName(name:String):Void
	{
		this.name = name;
	}
	
	/**
     * This method returns the cameras name.
     * @return the cameras name
     */
	public function getName():String
	{
		return this.name;
	}
	
	/**
     * Sets a clipPlane for this camera.
     * The cliPlane is used to recompute the projectionMatrix using the plane as the near plane
     * This technique is known as the oblique near-plane clipping method introduced by Eric Lengyel
     * more info here
     * http://www.terathon.com/code/oblique.html
     * http://aras-p.info/texts/obliqueortho.html
     * http://hacksoflife.blogspot.com/2008/12/every-now-and-then-i-come-across.html
     *
     * Note that this will work properly only if it's called on each update, and be aware that it won't work properly with the sky bucket.
     * if you want to handle the sky bucket, look at how it's done in SimpleWaterProcessor.java
     * @param clipPlane the plane
     * @param side the side the camera stands from the plane
     */
	public function setClipPlane(clipPlane:Plane, side:PlaneSide):Void
	{
		var sideFactor:Float = 1.0;
		if (side == PlaneSide.Negative)
		{
			sideFactor = -1.0;
		}
		
		//we are on the other side of the plane no need to clip anymore.
		if (clipPlane.whichSide(location) == side)
		{
			return;
		}
		
		var p:Matrix4f = projectionMatrix.clone();
		var ivm:Matrix4f = viewMatrix.clone();
		
		var point:Vector3f = clipPlane.normal.clone();
		point.scaleLocal(clipPlane.constant);
		var pp:Vector3f = ivm.multVec(point);
		var pn:Vector3f = ivm.multNormal(clipPlane.normal);
		var clipPlaneV:Vector4f = new Vector4f();
		clipPlaneV.x = pn.x * sideFactor;
		clipPlaneV.y = pn.y * sideFactor;
		clipPlaneV.z = pn.z * sideFactor;
		clipPlaneV.w = -pp.dot(pn) * sideFactor;
		
		var v:Vector4f = new Vector4f(0, 0, 0, 0);
		v.x = (FastMath.signum(clipPlaneV.x) + p.m02) / p.m00;
		v.y = (FastMath.signum(clipPlaneV.y) + p.m12) / p.m11;
		v.z = -1.0;
		v.w = (1.0 + p.m22) / p.m23;
		
		var dot:Float = clipPlaneV.dotProduct(v);
		var c:Vector4f = clipPlaneV.scale(2.0 / dot);
		
		p.m20 = c.x - p.m30;
        p.m21 = c.y - p.m31;
        p.m22 = c.z - p.m32;
        p.m23 = c.w - p.m33;
		setProjectionMatrix(p);
	}
	
	/**
     * Sets a clipPlane for this camera.
     * The cliPlane is used to recompute the projectionMatrix using the plane as the near plane
     * This technique is known as the oblique near-plane clipping method introduced by Eric Lengyel
     * more info here
     * http://www.terathon.com/code/oblique.html
     * http://aras-p.info/texts/obliqueortho.html
     * http://hacksoflife.blogspot.com/2008/12/every-now-and-then-i-come-across.html
     *
     * Note that this will work properly only if it's called on each update, and be aware that it won't work properly with the sky bucket.
     * if you want to handle the sky bucket, look at how it's done in SimpleWaterProcessor.java
     * @param clipPlane the plane
     */
	public function setClipPlane2(clipPlane:Plane):Void
	{
		setClipPlane(clipPlane, clipPlane.whichSide(location));
	}
	
	/**
     * Resizes this camera's view with the given width and height. This is
     * similar to constructing a new camera, but reusing the same Object. This
     * method is called by an associated {@link RenderManager} to notify the camera of
     * changes in the display dimensions.
     *
     * @param width the view width
     * @param height the view height
     * @param fixAspect If true, the camera's aspect ratio will be recomputed.
     * Recomputing the aspect ratio requires changing the frustum values.
     */
	public function resize(width:Int, height:Int, fixAspect:Bool = true):Void
	{
		this.width = width;
		this.height = height;
		onViewPortChange();
		
		if (fixAspect)
		{
			frustumRight = frustumTop * width / height;
			frustumLeft = -frustumRight;
			onFrustumChange();
		}
	}
	
	/**
     * <code>getFrustumBottom</code> returns the value of the bottom frustum
     * plane.
     *
     * @return the value of the bottom frustum plane.
     */
	public function getFrustumBottom():Float
	{
		return frustumBottom;
	}
	
	/**
     * <code>setFrustumBottom</code> sets the value of the bottom frustum
     * plane.
     *
     * @param frustumBottom the value of the bottom frustum plane.
     */
    public function setFrustumBottom(frustumBottom:Float):Void
	{
        this.frustumBottom = frustumBottom;
        onFrustumChange();
    }
	
	/**
     * <code>getFrustumFar</code> returns the value of the far frustum
     * plane.
     *
     * @return the value of the far frustum plane.
     */
	public function getFrustumFar():Float
	{
		return frustumFar;
	}
	
	/**
     * <code>setFrustumFar</code> sets the value of the far frustum
     * plane.
     *
     * @param frustumFar the value of the far frustum plane.
     */
    public function setFrustumFar(frustumFar:Float):Void
	{
        this.frustumFar = frustumFar;
        onFrustumChange();
    }
	
	/**
     * <code>getFrustumLeft</code> returns the value of the left frustum
     * plane.
     *
     * @return the value of the left frustum plane.
     */
	public function getFrustumLeft():Float
	{
		return frustumLeft;
	}
	
	/**
     * <code>setFrustumLeft</code> sets the value of the left frustum
     * plane.
     *
     * @param frustumLeft the value of the left frustum plane.
     */
    public function setFrustumLeft(frustumLeft:Float):Void
	{
        this.frustumLeft = frustumLeft;
        onFrustumChange();
    }
	
	/**
     * <code>getFrustumNear</code> returns the value of the near frustum
     * plane.
     *
     * @return the value of the near frustum plane.
     */
	public function getFrustumNear():Float
	{
		return frustumNear;
	}
	
	/**
     * <code>setFrustumNear</code> sets the value of the near frustum
     * plane.
     *
     * @param frustumNear the value of the near frustum plane.
     */
    public function setFrustumNear(frustumNear:Float):Void
	{
        this.frustumNear = frustumNear;
        onFrustumChange();
    }
	
	
	/**
     * <code>getFrustumRight</code> returns the value of the right frustum
     * plane.
     *
     * @return the value of the right frustum plane.
     */
	public function getFrustumRight():Float
	{
		return frustumRight;
	}
	
	/**
     * <code>setFrustumRight</code> sets the value of the right frustum
     * plane.
     *
     * @param frustumRight the value of the right frustum plane.
     */
    public function setFrustumRight(frustumRight:Float):Void
	{
        this.frustumRight = frustumRight;
        onFrustumChange();
    }
	
	/**
     * <code>getFrustumTop</code> returns the value of the top frustum
     * plane.
     *
     * @return the value of the top frustum plane.
     */
	public function getFrustumTop():Float
	{
		return frustumTop;
	}
	
	/**
     * <code>setFrustumRight</code> sets the value of the top frustum
     * plane.
     *
     * @param frustumRight the value of the top frustum plane.
     */
    public function setFrustumTop(frustumTop:Float):Void
	{
        this.frustumTop = frustumTop;
        onFrustumChange();
    }
	
	/**
     * <code>getLocation</code> retrieves the location vector of the camera.
     *
     * @return the position of the camera.
     * @see Camera#getLocation()
     */
	public function getLocation():Vector3f
	{
		return location;
	}
	
	/**
     * <code>getRotation</code> retrieves the rotation quaternion of the camera.
     *
     * @return the rotation of the camera.
     */
	public function getRotation():Quaternion
	{
		return rotation;
	}
	
	/**
     * <code>getDirection</code> retrieves the direction vector the camera is
     * facing.
     *
     * @return the direction the camera is facing.
     * @see Camera#getDirection()
     */
    public function getDirection(result:Vector3f = null):Vector3f
	{
        return rotation.getRotationColumn(2,result);
    }
	
	/**
     * <code>getLeft</code> retrieves the left axis of the camera.
     *
     * @return the left axis of the camera.
     * @see Camera#getLeft()
     */
    public function getLeft(result:Vector3f = null):Vector3f
	{
        return rotation.getRotationColumn(0,result);
    }

    /**
     * <code>getUp</code> retrieves the up axis of the camera.
     *
     * @return the up axis of the camera.
     * @see Camera#getUp()
     */
    public function getUp(result:Vector3f = null):Vector3f
	{
        return rotation.getRotationColumn(1,result);
    }
	
	/**
     * <code>setLocation</code> sets the position of the camera.
     *
     * @param location the position of the camera.
     * @see Camera#setLocation(com.jme.math.Vector3f)
     */
	public function setLocation(location:Vector3f):Void
	{
		this.location.copyFrom(location);
		onFrameChange();
	}
	
	/**
     * <code>setRotation</code> sets the orientation of this camera. 
     * This will be equivelant to setting each of the axes:
     * <code><br>
     * cam.setLeft(rotation.getRotationColumn(0));<br>
     * cam.setUp(rotation.getRotationColumn(1));<br>
     * cam.setDirection(rotation.getRotationColumn(2));<br>
     * </code>
     *
     * @param rotation the rotation of this camera
     */
	public function setRotation(rotation:Quaternion):Void
	{
		this.rotation.copyFrom(rotation);
		onFrameChange();
	}
	
	/**
     * <code>lookAtDirection</code> sets the direction the camera is facing
     * given a direction and an up vector.
     *
     * @param direction the direction this camera is facing.
     */
    public function lookAtDirection(direction:Vector3f,up:Vector3f):Void
	{
        this.rotation.lookAt(direction, up);
        onFrameChange();
    }
	
	/**
     * <code>setAxes</code> sets the axes (left, up and direction) for this
     * camera.
     *
     * @param left      the left axis of the camera.
     * @param up        the up axis of the camera.
     * @param direction the direction the camera is facing.
     * @see Camera#setAxes(com.jme.math.Vector3f,com.jme.math.Vector3f,com.jme.math.Vector3f)
     */
    public function setAxes(left:Vector3f,up:Vector3f,direction:Vector3f):Void
	{
        this.rotation.fromAxes(left, up, direction);
        onFrameChange();
    }
	
	/**
     * <code>setAxes</code> uses a rotational matrix to set the axes of the
     * camera.
     *
     * @param axes the matrix that defines the orientation of the camera.
     */
    public function setAxesFromQuat(axes:Quaternion):Void
	{
        this.rotation.copyFrom(axes);
        onFrameChange();
    }
	
	/**
     * normalize normalizes the camera vectors.
     */
    public function normalize():Void
	{
        this.rotation.normalizeLocal();
        onFrameChange();
    }
	
	/**
     * <code>setFrustum</code> sets the frustum of this camera object.
     *
     * @param near   the near plane.
     * @param far    the far plane.
     * @param left   the left plane.
     * @param right  the right plane.
     * @param top    the top plane.
     * @param bottom the bottom plane.
     * @see Camera#setFrustum(float, float, float, float,
     *      float, float)
     */
	public function setFrustum(near:Float, far:Float, left:Float, right:Float, top:Float, bottom:Float):Void
	{
		frustumNear = near;
        frustumFar = far;
        frustumLeft = left;
        frustumRight = right;
        frustumTop = top;
        frustumBottom = bottom;
        onFrustumChange();
	}
	
	/**
     * <code>setFrustumPerspective</code> defines the frustum for the camera.  This
     * frustum is defined by a viewing angle, aspect ratio, and near/far planes
     *
     * @param fovY   Frame of view angle along the Y in degrees.
     * @param aspect Width:Height ratio
     * @param near   Near view plane distance
     * @param far    Far view plane distance
     */
	public function setFrustumPerspective(fovY:Float, aspect:Float, near:Float, far:Float):Void
	{
		var h:Float = Math.tan(fovY * FastMath.DEGTORAD * 0.5) * near;
		var w:Float = h * aspect;
		
		frustumLeft = -w;
        frustumRight = w;
        frustumBottom = -h;
        frustumTop = h;
        frustumNear = near;
        frustumFar = far;

        onFrustumChange();
	}
	
	/**
     * <code>setFrame</code> sets the orientation and location of the camera.
     *
     * @param location  the point position of the camera.
     * @param left      the left axis of the camera.
     * @param up        the up axis of the camera.
     * @param direction the facing of the camera.
     * @see Camera#setFrame(org.angle3d.math.Vector3f,
     *      org.angle3d.math.Vector3f, org.angle3d.math.Vector3f, org.angle3d.math.Vector3f)
     */
	public function setFrame(location:Vector3f, left:Vector3f, up:Vector3f, direction:Vector3f):Void
	{
		this.location.copyFrom(location);
		this.rotation.fromAxes(left, up, direction);
		onFrameChange();
	}
	
	 /**
     * <code>setFrame</code> sets the orientation and location of the camera.
     * 
     * @param location
     *            the point position of the camera.
     * @param axes
     *            the orientation of the camera.
     */
	public function setFrameFromQuat(location:Vector3f, axes:Quaternion):Void
	{
		this.location.copyFrom(location);
		this.rotation.copyFrom(axes);
		onFrameChange();
	}
	
	/**
     * <code>lookAt</code> is a convienence method for auto-setting the frame
     * based on a world position the user desires the camera to look at. It
     * repoints the camera towards the given position using the difference
     * between the position and the current camera location as a direction
     * vector and the worldUpVector to compute up and left camera vectors.
     *
     * @param pos           where to look at in terms of world coordinates
     * @param worldUpVector a normalized vector indicating the up direction of the world.
     *                      (typically {0, 1, 0} in jME.)
     */
	public function lookAt(pos:Vector3f, worldUpVector:Vector3f):Void
	{
		var newDirection:Vector3f = pos.clone();
		newDirection.subtractLocal(location);
		newDirection.normalizeLocal();
		
		var newUp:Vector3f = worldUpVector.clone();
		newUp.normalizeLocal();
		if (newUp.isZero())
		{
			newUp.setTo(0, 1, 0);
		}
		
		var newLeft:Vector3f = newUp.cross(newDirection);
		newLeft.normalizeLocal();
		if (newLeft.isZero())
		{
			if (newDirection.x != 0)
			{
				newLeft.setTo(newDirection.y, -newDirection.x, 0);
			}
			else
			{
				newLeft.setTo(0, newDirection.z, -newDirection.y);
			}
		}
		
		newUp.copyFrom(newDirection);
		newUp = newUp.cross(newLeft);
		newUp.normalizeLocal();
		
		this.rotation.fromAxes(newLeft, newUp, newDirection);
		this.rotation.normalizeLocal();
		
		onFrameChange();
	}
	
	/**
     * <code>update</code> updates the camera parameters by calling
     * <code>onFrustumChange</code>,<code>onViewPortChange</code> and
     * <code>onFrameChange</code>.
     *
     * @see Camera#update()
     */
	public function update():Void
	{
		onFrustumChange();
        onViewPortChange();
        onFrameChange();
	}
	
	/**
     * <code>getPlaneState</code> returns the state of the frustum planes. So
     * checks can be made as to which frustum plane has been examined for
     * culling thus far.
     *
     * @return the current plane state int.
     */
	public function getPlaneState():Int
	{
		return planeState;
	}
	
	/**
     * <code>setPlaneState</code> sets the state to keep track of tested
     * planes for culling.
     *
     * @param planeState the updated state.
     */
	public function setPlaneState(planeState:Int):Void
	{
		this.planeState = planeState;
	}
	
	/**
     * <code>getViewPortLeft</code> gets the left boundary of the viewport
     *
     * @return the left boundary of the viewport
     */
	public function getViewPortLeft():Float
	{
		return viewPortLeft;
	}
	
	/**
     * <code>setViewPortLeft</code> sets the left boundary of the viewport
     *
     * @param left the left boundary of the viewport
     */
	public function setViewPortLeft(left:Float):Void
	{
		this.viewPortLeft = left;
        onViewPortChange();
	}
	
	/**
     * <code>getViewPortRight</code> gets the right boundary of the viewport
     *
     * @return the right boundary of the viewport
     */
	public function getViewPortRight():Float
	{
		return viewPortRight;
	}
	
	/**
     * <code>setViewPortRight</code> sets the right boundary of the viewport
     *
     * @param right the left boundary of the viewport
     */
	public function setViewPortRight(right:Float):Void
	{
		this.viewPortRight = right;
        onViewPortChange();
	}
	
	/**
     * <code>getViewPortTop</code> gets the top boundary of the viewport
     *
     * @return the top boundary of the viewport
     */
	public function getViewPortTop():Float
	{
		return viewPortTop;
	}
	
	/**
     * <code>setViewPortLeft</code> sets the top boundary of the viewport
     *
     * @param left the top boundary of the viewport
     */
	public function setViewPortTop(top:Float):Void
	{
		this.viewPortTop = top;
        onViewPortChange();
	}
	
	/**
     * <code>getViewPortBottom</code> gets the bottom boundary of the viewport
     *
     * @return the bottom boundary of the viewport
     */
	public function getViewPortBottom():Float
	{
		return viewPortBottom;
	}
	
	/**
     * <code>setViewPortBottom</code> sets the bottom boundary of the viewport
     *
     * @param left the bottom boundary of the viewport
     */
	public function setViewPortBottom(bottom:Float):Void
	{
		this.viewPortBottom = bottom;
        onViewPortChange();
	}
	
	/**
     * <code>setViewPort</code> sets the boundaries of the viewport
     *
     * @param left   the left boundary of the viewport (default: 0)
     * @param right  the right boundary of the viewport (default: 1)
     * @param bottom the bottom boundary of the viewport (default: 0)
     * @param top    the top boundary of the viewport (default: 1)
     */
	public function setViewPort(left:Float, right:Float, bottom:Float, top:Float):Void
	{
		this.viewPortLeft = left;
        this.viewPortRight = right;
        this.viewPortBottom = bottom;
        this.viewPortTop = top;
        onViewPortChange();
	}
	
	/**
     * Returns the pseudo distance from the given position to the near
     * plane of the camera. This is used for render queue sorting.
     * @param pos The position to compute a distance to.
     * @return Distance from the far plane to the point.
     */
	public function distanceToNearPlane(pos:Vector3f):Float
	{
		return worldPlanes[NEAR_PLANE].pseudoDistance(pos);
	}
	
	/**
     * <code>contains</code> tests a bounding volume against the planes of the
     * camera's frustum. The frustums planes are set such that the normals all
     * face in towards the viewable scene. Therefore, if the bounding volume is
     * on the negative side of the plane is can be culled out.
     *
     * NOTE: This method is used internally for culling, for public usage,
     * the plane state of the bounding volume must be saved and restored, e.g:
     * <code>BoundingVolume bv;<br/>
     * Camera c;<br/>
     * int planeState = bv.getPlaneState();<br/>
     * bv.setPlaneState(0);<br/>
     * c.contains(bv);<br/>
     * bv.setPlaneState(plateState);<br/>
     * </code>
     *
     * @param bound the bound to check for culling
     * @return See enums in <code>FrustumIntersect</code>
     */
	public function contains(bound:BoundingVolume):FrustumIntersect
	{
		if (bound == null) 
		{
            return FrustumIntersect.Inside;
        }
		
		var mask:Int;
		var rVal:FrustumIntersect = FrustumIntersect.Inside;
		
		var planeCounter:Int = FRUSTUM_PLANES;
		while (planeCounter-- > 0)
		{
			if (planeCounter == bound.getCheckPlane())
			{
				continue; // we have already checked this plane at first iteration
			}
			
			var planeId:Int = (planeCounter == FRUSTUM_PLANES) ? bound.getCheckPlane() : planeCounter;
			
			mask = 1 << planeId;
			if ((planeState & mask) == 0)
			{
				var side:PlaneSide = bound.whichSide(worldPlanes[planeId]);
				
				if (side == PlaneSide.Negative)
				{
					//object is outside of frustum
					bound.setCheckPlane(planeId);
					return FrustumIntersect.Outside;
				}
				else if (side == PlaneSide.Positive)
				{
					//object is visible on *this* plane, so mark this plane
                    //so that we don't check it for sub nodes.
					planeState |= mask;
				}
				else
				{
					rVal = FrustumIntersect.Intersects;
					//TODO 直接返回就可以了吧？
				}
			}
		}
		
		return rVal;
	}
	
	/**
     * <code>containsGui</code> tests a bounding volume against the ortho
     * bounding box of the camera. A bounding box spanning from
     * 0, 0 to Width, Height. Constrained by the viewport settings on the
     * camera.
     *
     * @param bound the bound to check for culling
     * @return True if the camera contains the gui element bounding volume.
     */
	public function containsGui(bound:BoundingVolume):Bool
	{
		return guiBounding.intersects(bound);
	}
	
	/**
     * @return the view matrix of the camera.
     * The view matrix transforms world space into eye space.
     * This matrix is usually defined by the position and
     * orientation of the camera.
     */
	public function getViewMatrix():Matrix4f
	{
		return viewMatrix;
	}
	
	/**
     * Overrides the projection matrix used by the camera. Will
     * use the matrix for computing the view projection matrix as well.
     * Use null argument to return to normal functionality.
     *
     * @param projMatrix
     */
	public function setProjectionMatrix(mat:Matrix4f):Void
	{
		projectionMatrixOverride = mat;
		updateViewProjection();
	}
	
	/**
     * @return the projection matrix of the camera.
     * The view projection matrix  transforms eye space into clip space.
     * This matrix is usually defined by the viewport and perspective settings
     * of the camera.
     */
	public function getProjectionMatrix():Matrix4f
	{
		if (projectionMatrixOverride != null)
		{
			return projectionMatrixOverride;
		}
		
		return projectionMatrix;
	}
	
	/**
     * Updates the view projection matrix.
     */
	public function updateViewProjection():Void
	{
		if (projectionMatrixOverride != null) 
		{
            viewProjectionMatrix.copyFrom(projectionMatrixOverride);
			viewProjectionMatrix.multLocal(viewMatrix);
        } 
		else 
		{
            viewProjectionMatrix.copyFrom(projectionMatrix);
			viewProjectionMatrix.multLocal(viewMatrix);
        }
	}
	
	/**
     * @return The result of multiplying the projection matrix by the view
     * matrix. This matrix is required for rendering an object. It is
     * precomputed so as to not compute it every time an object is rendered.
     */
	public function getViewProjectionMatrix():Matrix4f
	{
		return viewProjectionMatrix;
	}
	
	/**
     * @return True if the viewport (width, height, left, right, bottom, up)
     * has been changed. This is needed in the renderer so that the proper
     * viewport can be set-up.
     */
	public function isViewportChanged():Bool
	{
		return viewportChanged;
	}
	
	/**
     * Clears the viewport changed flag once it has been updated inside
     * the renderer.
     */
	public function clearViewportChanged():Void
	{
		viewportChanged = false;
	}
	
	/**
     * Called when the viewport has been changed.
     */
    public function onViewPortChange():Void
	{
        viewportChanged = true;
        setGuiBounding();
    }
	
	private function setGuiBounding():Void
	{
        var sx:Float = width * viewPortLeft;
        var ex:Float = width * viewPortRight;
        var sy:Float = height * viewPortBottom;
        var ey:Float = height * viewPortTop;
        var xExtent:Float = Math.max(0, (ex - sx) / 2);
        var yExtent:Float = Math.max(0, (ey - sy) / 2);
		
        guiBounding.setCenter(new Vector3f(sx + xExtent, sy + yExtent, 0));
        guiBounding.xExtent = xExtent;
        guiBounding.yExtent = yExtent;
        guiBounding.zExtent = FastMath.MAX_VALUE;
    }
	
	/**
     * <code>onFrustumChange</code> updates the frustum to reflect any changes
     * made to the planes. The new frustum values are kept in a temporary
     * location for use when calculating the new frame. The projection
     * matrix is updated to reflect the current values of the frustum.
     */
	public function onFrustumChange():Void
	{
		if (!isParallelProjection()) 
		{
            var nearSquared:Float = frustumNear * frustumNear;
            var leftSquared:Float = frustumLeft * frustumLeft;
            var rightSquared:Float = frustumRight * frustumRight;
            var bottomSquared:Float = frustumBottom * frustumBottom;
            var topSquared:Float = frustumTop * frustumTop;

            var inverseLength:Float = 1 / Math.sqrt(nearSquared + leftSquared);
            coeffLeft[0] = frustumNear * inverseLength;
            coeffLeft[1] = -frustumLeft * inverseLength;

            inverseLength = 1 / Math.sqrt(nearSquared + rightSquared);
            coeffRight[0] = -frustumNear * inverseLength;
            coeffRight[1] = frustumRight * inverseLength;

            inverseLength = 1 / Math.sqrt(nearSquared + bottomSquared);
            coeffBottom[0] = frustumNear * inverseLength;
            coeffBottom[1] = -frustumBottom * inverseLength;

            inverseLength = 1 / Math.sqrt(nearSquared + topSquared);
            coeffTop[0] = -frustumNear * inverseLength;
            coeffTop[1] = frustumTop * inverseLength;
        } 
		else 
		{
            coeffLeft[0] = 1;
            coeffLeft[1] = 0;

            coeffRight[0] = -1;
            coeffRight[1] = 0;

            coeffBottom[0] = 1;
            coeffBottom[1] = 0;

            coeffTop[0] = -1;
            coeffTop[1] = 0;
        }

        projectionMatrix.fromFrustum(frustumNear, frustumFar, frustumLeft, frustumRight, frustumTop, frustumBottom, parallelProjection);

        // The frame is effected by the frustum values
        // update it as well
        onFrameChange();
	}
	
	/**
     * <code>onFrameChange</code> updates the view frame of the camera.
     */
    public function onFrameChange():Void
	{
		var vars:TempVars = TempVars.getTempVars();
		
        var left:Vector3f = getLeft(vars.vect1);
        var direction:Vector3f = getDirection(vars.vect2);
        var up:Vector3f = getUp(vars.vect3);

        var dirDotLocation:Float = direction.dot(location);

        // left plane
		var plane:Plane = worldPlanes[LEFT_PLANE];
        var normal:Vector3f = plane.normal;
        normal.x = left.x * coeffLeft[0] + direction.x * coeffLeft[1];
        normal.y = left.y * coeffLeft[0] + direction.y * coeffLeft[1];
        normal.z = left.z * coeffLeft[0] + direction.z * coeffLeft[1];
        plane.constant = location.dot(normal);

        // right plane
		plane = worldPlanes[RIGHT_PLANE];
        normal = plane.normal;
        normal.x = left.x * coeffRight[0] + direction.x * coeffRight[1];
        normal.y = left.y * coeffRight[0] + direction.y * coeffRight[1];
        normal.z = left.z * coeffRight[0] + direction.z * coeffRight[1];
        plane.constant = location.dot(normal);

        // bottom plane
		plane = worldPlanes[BOTTOM_PLANE];
        normal = plane.normal;
        normal.x = up.x * coeffBottom[0] + direction.x * coeffBottom[1];
        normal.y = up.y * coeffBottom[0] + direction.y * coeffBottom[1];
        normal.z = up.z * coeffBottom[0] + direction.z * coeffBottom[1];
        plane.constant = location.dot(normal);

        // top plane
		plane = worldPlanes[TOP_PLANE];
        normal = plane.normal;
        normal.x = up.x * coeffTop[0] + direction.x * coeffTop[1];
        normal.y = up.y * coeffTop[0] + direction.y * coeffTop[1];
        normal.z = up.z * coeffTop[0] + direction.z * coeffTop[1];
        plane.constant = location.dot(normal);

        if (isParallelProjection()) 
		{
            worldPlanes[LEFT_PLANE].constant += frustumLeft;
            worldPlanes[RIGHT_PLANE].constant -= frustumRight;
            worldPlanes[TOP_PLANE].constant -= frustumTop;
            worldPlanes[BOTTOM_PLANE].constant += frustumBottom;
        }

        // far plane
        worldPlanes[FAR_PLANE].normal.setTo(-direction.x, -direction.y, -direction.z);
        worldPlanes[FAR_PLANE].constant = -(dirDotLocation + frustumFar);

        // near plane
        worldPlanes[NEAR_PLANE].normal.setTo(direction.x, direction.y, direction.z);
        worldPlanes[NEAR_PLANE].constant = dirDotLocation + frustumNear;
		
		viewMatrix.fromFrame(location, direction, up, left);
		
		vars.release();
		
        updateViewProjection();
    }
	
	/**
     * @return true if parallel projection is enable, false if in normal perspective mode
     * @see #setParallelProjection(boolean)
     */
    public function isParallelProjection():Bool
	{
        return this.parallelProjection;
    }
	
	/**
     * Enable/disable parallel projection.
     *
     * @param value true to set up this camera for parallel projection is enable, false to enter normal perspective mode
     */
    public function setParallelProjection(value:Bool):Void
	{
        this.parallelProjection = value;
		onFrustumChange();
    }
	
	/**
     * @see Camera#getWorldCoordinates
     */
    public function getWorldCoordinates(screenPos:Vector2f, zPos:Float, result:Vector3f = null):Vector3f
	{
        if (result == null)
		{
			result = new Vector3f();
		}
		
		var inverseMat:Matrix4f = viewProjectionMatrix.invert();
		
		result.setTo(
		             (screenPos.x / getWidth() - viewPortLeft) / (viewPortRight - viewPortLeft) * 2 - 1,
                     (screenPos.y / getHeight() - viewPortBottom) / (viewPortTop - viewPortBottom) * 2 - 1,
                     zPos * 2 - 1);
		
		var w:Float = inverseMat.multProj(result, result);
		result.scaleLocal(1 / w);
		
		return result;
    }
	
	/**
     * Converts the given position from world space to screen space.
     *
     * @see Camera#getScreenCoordinates(Vector3f, Vector3f)
     */
	public function getScreenCoordinates(worldPos:Vector3f, result:Vector3f = null):Vector3f
	{
		if (result == null)
		{
			result = new Vector3f();
		}
		
		var w:Float = viewProjectionMatrix.multProj(worldPos, result);
		result.scaleLocal(1 / w);
		
		result.x = ((result.x + 1) * (viewPortRight - viewPortLeft) / 2 + viewPortLeft) * getWidth();
        result.y = ((result.y + 1) * (viewPortTop - viewPortBottom) / 2 + viewPortBottom) * getHeight();
        result.z = (result.z + 1) / 2;

        return result;
	}
	
	/**
     * @return the width/resolution of the display.
     */
    public function getWidth():Int
	{
        return width;
    }
	
	 /**
     * @return the height/resolution of the display.
     */
    public function getHeight():Int
	{
        return height;
    }
	
	public function toString():String
	{
        return "Camera[location=" + location + "\n, direction=" + getDirection() + "\n"
                + "width=" + width + ", height=" + height + ", parallel=" + parallelProjection + "\n"
                + "near=" + frustumNear + ", far=" + frustumFar + "]";
    }
}