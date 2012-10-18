package org.angle3d.scene.shape;
import org.angle3d.math.Vector3f;
import flash.Vector;
import org.angle3d.math.FastMath;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.BufferUtils;
import org.angle3d.scene.mesh.IndexBuffer;
import org.angle3d.scene.mesh.Mesh;
/**
 * A simple cylinder, defined by it's height and radius.
 * (Ported to jME3)
 *
 */
class Cylinder extends Mesh
{
	private var axisSamples:Int;
	private var radialSamples:Int;
	
	private var radius:Float;
	private var radius2:Float;
	
	private var height:Float;
	private var closed:Bool;
	private var inverted:Bool;

	/**
     * Creates a new Cylinder. By default its center is the origin. Usually, a
     * higher sample number creates a better looking cylinder, but at the cost
     * of more vertex information.
     *
     * @param axisSamples
     *            Number of triangle samples along the axis.
     * @param radialSamples
     *            Number of triangle samples along the radial.
     * @param radius
     *            The radius of the cylinder.
     * @param height
     *            The cylinder's height.
     */
	public function new(axisSamples:Int, radialSamples:Int, 
	                    radius:Float,radius2:Float, height:Int, 
	                    closed:Bool = false, inverted:Bool = false)
	{
		super();
		updateGeometry(axisSamples, radialSamples, radius, radius2, height, closed, inverted);
	}
	
	/**
     * @return the number of samples along the cylinder axis
     */
    public function getAxisSamples():Int 
	{
        return axisSamples;
    }

    /**
     * @return Returns the height.
     */
    public function getHeight():Float 
	{
        return height;
    }

    /**
     * @return number of samples around cylinder
     */
    public function getRadialSamples():Int 
	{
        return radialSamples;
    }

    /**
     * @return Returns the radius.
     */
    public function getRadius():Float 
	{
        return radius;
    }

    public function getRadius2():Float 
	{
        return radius2;
    }

    /**
     * @return true if end caps are used.
     */
    public function isClosed():Bool 
	{
        return closed;
    }

    /**
     * @return true if normals and uvs are created for interior use
     */
    public function isInverted():Bool 
	{
        return inverted;
    }
	
	/**
     * Rebuilds the cylinder based on a new set of parameters.
     *
     * @param axisSamples the number of samples along the axis.
     * @param radialSamples the number of samples around the radial.
     * @param radius the radius of the bottom of the cylinder.
     * @param radius2 the radius of the top of the cylinder.
     * @param height the cylinder's height.
     * @param closed should the cylinder have top and bottom surfaces.
     * @param inverted is the cylinder is meant to be viewed from the inside.
     */
	public function updateGeometry(axisSamples:Int, radialSamples:Int, 
	                    radius:Float,radius2:Float, height:Int, 
	                    closed:Bool = false, inverted:Bool = false):Void
	{
		this.axisSamples = axisSamples + (closed ? 2 : 0);
        this.radialSamples = radialSamples;
        this.radius = radius;
        this.radius2 = radius2;
        this.height = height;
        this.closed = closed;
        this.inverted = inverted;
		
		// Vertices
		//var vertCount:Int = axisSamples * (radialSamples + 1) + (closed ? 2 : 0);
		
		// generate geometry
        var inverseRadial:Float = 1.0 / radialSamples;
        var inverseAxisLess:Float = 1.0 / (closed ? axisSamples - 3 : axisSamples - 1);
        var inverseAxisLessTexture:Float = 1.0 / (axisSamples - 1);
        var halfHeight:Float = 0.5 * height;
		
		// Generate points on the unit circle to be used in computing the mesh
        // points on a cylinder slice.
		var sins:Vector<Float> = new Vector<Float>(radialSamples + 1);
		var coss:Vector<Float> = new Vector<Float>(radialSamples + 1);
		for (i in 0...radialSamples)
		{
			var angle:Float = FastMath.TWO_PI * inverseRadial * i;
			coss[i] = Math.cos(angle);
			sins[i] = Math.sin(angle);
		}
		coss[radialSamples] = coss[0];
		sins[radialSamples] = sins[0];
		
		var normVec:Vector<Float> = new Vector<Float>();
		var posVec:Vector<Float> = new Vector<Float>();
		var texVec:Vector<Float> = new Vector<Float>();
		
		 // generate the cylinder itself
        var tempNormal:Vector3f = new Vector3f();
		var i:Int = 0;
		var axisCount:Int = 0;
		while (axisCount < axisSamples)
		{
			var axisFraction:Float;
            var axisFractionTexture:Float;
            var topBottom:Int = 0;
            if (!closed) 
			{
                axisFraction = axisCount * inverseAxisLess; // in [0,1]
                axisFractionTexture = axisFraction;
            } 
			else 
			{
                if (axisCount == 0) 
				{
                    topBottom = -1; // bottom
                    axisFraction = 0;
                    axisFractionTexture = inverseAxisLessTexture;
                } 
				else if (axisCount == axisSamples - 1) 
				{
                    topBottom = 1; // top
                    axisFraction = 1;
                    axisFractionTexture = 1 - inverseAxisLessTexture;
                } 
				else 
				{
                    axisFraction = (axisCount - 1) * inverseAxisLess;
                    axisFractionTexture = axisCount * inverseAxisLessTexture;
                }
            }
			
			var z:Float = -halfHeight + height * axisFraction;
			
			 // compute center of slice
            var sliceCenter:Vector3f = new Vector3f(0, 0, z);
			
			// compute slice vertices with duplication at end point
            var save:Int = i;
			var radialCount:Int = 0;
			while (radialCount < radialSamples)
			{
                var radialFraction:Float = radialCount * inverseRadial; // in [0,1)
				
                tempNormal.setTo(coss[radialCount], sins[radialCount], 0);
				
                if (topBottom == 0) 
				{
                    if (!inverted)
					{
					    normVec.push(tempNormal.x);	
						normVec.push(tempNormal.y);	
						normVec.push(tempNormal.z);	
					}
                    else
					{
						normVec.push( -tempNormal.x);	
						normVec.push( -tempNormal.y);
						normVec.push( -tempNormal.z);
					}
                } 
				else 
				{
					normVec.push(0);
					normVec.push(0);
					normVec.push(topBottom * (inverted ? -1 : 1));
                }

                tempNormal.scaleAdd((radius - radius2) * axisFraction + radius2,sliceCenter);
				
				posVec.push(tempNormal.x);
				posVec.push(tempNormal.y);
				posVec.push(tempNormal.z);
				
				texVec.push(inverted ? 1 - radialFraction : radialFraction);
				texVec.push(axisFractionTexture);
				
				radialCount++;
				i++;
            }
			
			BufferUtils.copyInternalVector3(posVec, save, i);
			BufferUtils.copyInternalVector3(normVec, save, i);
			
			texVec.push(inverted ? 0.0 : 1.0);
			texVec.push(axisFractionTexture);
			
			axisCount++;
			i++;
		}
		
		if (closed) 
		{
			posVec.push(0); posVec.push(0); posVec.push( -halfHeight);// bottom center
			normVec.push(0); normVec.push(0); normVec.push( -1 * (inverted ? -1 : 1));
			texVec.push(0.5); texVec.push(0);
			
			posVec.push(0); posVec.push(0); posVec.push(halfHeight);// top center
			normVec.push(0); normVec.push(0); normVec.push( 1 * (inverted ? -1 : 1));
			texVec.push(0.5); texVec.push(1);
		}
		
		
		setVertexBuffer(BufferType.Position, 3, posVec);
		setVertexBuffer(BufferType.Normal, 3, normVec);
		setVertexBuffer(BufferType.TexCoord, 2, texVec);
		
		var triCount:Int = ((closed ? 2 : 0) + 2 * (axisSamples - 1)) * radialSamples;
		var indexVec:Vector<UInt> = new Vector<UInt>(triCount * 3);
		var index:Int = 0;
		// Connectivity
		var axisCount:Int = 0;
		var axisStart:Int = 0;
		while (axisCount < axisSamples - 1)
		{
			var i0:Int = axisStart;
			var i1:Int = i0 + 1;
			axisStart += radialSamples + 1;
			var i2:Int = axisStart;
			var i3:Int = i2 + 1;
			
			for (j in 0...radialSamples)
			{
				if (closed && axisCount == 0) 
				{
                    if (!inverted) 
					{
                        indexVec[index++] = i0++;
                        indexVec[index++] = vertCount - 2;
                        indexVec[index++] = i1++;
                    } 
					else 
					{
						indexVec[index++] = i0++;
                        indexVec[index++] = i1++;
                        indexVec[index++] = vertCount - 2;
                    }
                } 
				else if (closed && axisCount == axisSamples - 2) 
				{
					indexVec[index++] = i2++;
                    indexVec[index++] = inverted ? vertCount - 1 : i3++;
                    indexVec[index++] = inverted ? i3++ : vertCount - 1;
                } 
				else 
				{
					indexVec[index++] = i0++;
                    indexVec[index++] = inverted ? i2 : i1;
                    indexVec[index++] = inverted ? i1 : i2;
                    indexVec[index++] = i1++;
                    indexVec[index++] = inverted ? i2++ : i3++;
                    indexVec[index++] = inverted ? i3++ : i2++;
                }
			}
			
			axisCount++;
		}
		
		var indexBuffer:IndexBuffer = new IndexBuffer();
		indexBuffer.setData(indexVec);
		setIndexBuffer(indexBuffer);
		
		updateBound();
	}
	
}