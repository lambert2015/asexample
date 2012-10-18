package org.angle3d.scene.shape;
import org.angle3d.math.Vector3f;
import flash.Vector;
import org.angle3d.math.FastMath;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.BufferUtils;
import org.angle3d.scene.mesh.IndexBuffer;
import org.angle3d.scene.mesh.Mesh;

/**
 * An ordinary (single holed) torus.

 * The center is by default the origin.
 * 
 */
class Torus extends Mesh
{
	private var circleSamples:Int;

    private var radialSamples:Int;

    private var innerRadius:Float;

    private var outerRadius:Float;

	/**
     * Constructs a new Torus. Center is the origin, but the Torus may be
     * transformed.
     * 
     * @param name
     *            The name of the Torus.
     * @param circleSamples
     *            The number of samples along the circles.
     * @param radialSamples
     *            The number of samples along the radial.
     * @param innerRadius
     *            The radius of the inner begining of the Torus.
     * @param outerRadius
     *            The radius of the outter end of the Torus.
     */
	public function new(circleSamples:Int,radialSamples:Int, innerRadius:Float,outerRadius:Float) 
	{
		super();
		updateGeometry(circleSamples,radialSamples, innerRadius,outerRadius);
	}
	
	public function getCircleSamples():Int
	{
        return circleSamples;
    }

    public function getRadialSamples():Int
	{
        return radialSamples;
    }
	
	public function getInnerRadius():Float
	{
        return innerRadius;
    }

    public function getOuterRadius():Float
	{
        return outerRadius;
    }
	
	/**
     * Rebuilds this torus based on a new set of parameters.
     * 
     * @param circleSamples the number of samples along the circles.
     * @param radialSamples the number of samples along the radial.
     * @param innerRadius the radius of the inner begining of the Torus.
     * @param outerRadius the radius of the outter end of the Torus.
     */
	public function updateGeometry(circleSamples:Int,radialSamples:Int, innerRadius:Float,outerRadius:Float):Void
    {
		this.circleSamples = circleSamples;
        this.radialSamples = radialSamples;
        this.innerRadius = innerRadius;
        this.outerRadius = outerRadius;
        setGeometryData();
        setIndexData();
        updateBound();
        updateCounts();
	}
	
	private function setGeometryData():Void
	{
		var normVec:Vector<Float> = new Vector<Float>();
		var posVec:Vector<Float> = new Vector<Float>();
		var textVec:Vector<Float> = new Vector<Float>();
		
		 // generate geometry
		 var inverseCircleSamples:Float = 1.0 / circleSamples;
         var inverseRadialSamples:Float = 1.0 / radialSamples;
		 var i:Int = 0;
		 // generate the cylinder itself
		 var radialAxis:Vector3f = new Vector3f(); 
		 var torusMiddle:Vector3f = new Vector3f();
		 var tempNormal:Vector3f = new Vector3f();
		 for (circleCount in 0...circleSamples)
		 {
			// compute center point on torus circle at specified angle
			var circleFaction:Float = circleCount * inverseCircleSamples;
			var theta:Float = FastMath.TWO_PI * circleFaction;
			var cosTheta:Float = Math.cos(theta);
			var sinTheta:Float = Math.sin(theta);
			radialAxis.setTo(cosTheta, sinTheta, 0);
			radialAxis.scale(outerRadius, torusMiddle);
			
			// compute slice vertices with duplication at end point
			var iSave:Int = i;
			for (radialCount in 0...radialSamples)
			{
				var radialFraction:Float = radialCount * inverseRadialSamples;
				// in [0,1)
				var phi:Float = FastMath.TWO_PI * radialFraction;
				var cosPhi:Float = Math.cos(phi);
				var sinPhi:Float = Math.sin(phi);
				
				tempNormal.copyFrom(radialAxis);
				tempNormal.scaleLocal(cosPhi);
				tempNormal.z += sinPhi;
				
				normVec.push(tempNormal.x);
				normVec.push(tempNormal.y);
				normVec.push(tempNormal.z);
				
				tempNormal.scaleAdd(innerRadius,torusMiddle);
				
				posVec.push(tempNormal.x);
				posVec.push(tempNormal.y);
				posVec.push(tempNormal.z);
				
				textVec.push(radialFraction);
				textVec.push(circleFaction);
				
				i++;
			}
			
			BufferUtils.copyInternalVector3(posVec, iSave, i);
			BufferUtils.copyInternalVector3(normVec, iSave, i);
			
			textVec.push(1.0);
			textVec.push(circleFaction);
			
			i++;
		 }
		 
		 // duplicate the cylinder ends to form a torus
		var iR:Int = 0;
		while (iR <= radialSamples)
		{
			BufferUtils.copyInternalVector3(posVec, iR, i);
			BufferUtils.copyInternalVector3(normVec, iR, i);
			BufferUtils.copyInternalVector2(textVec, iR, i);
			 
			textVec.push(i * 2 + 1);
			textVec.push(1.0);
			 
			iR++;
			i++;
		}
		 
		setVertexBuffer(BufferType.Position, 3, posVec);
		setVertexBuffer(BufferType.Normal, 3, normVec);
		setVertexBuffer(BufferType.TexCoord, 2, textVec);
	}
	
	private function setIndexData():Void
	{
		var indices:Vector<UInt> = new Vector<UInt>();
		var i:Int;
		// generate connectivity
		var connectionStart:Int = 0;
		var index:Int = 0;
		for (circleCount in 0...circleSamples)
		{
			var i0:Int = connectionStart;
			var i1:Int = i0 + 1;
			connectionStart += radialSamples + 1;
			var i2:Int = connectionStart;
			var i3:Int = i2 + 1;
			i = 0;
			while (i < radialSamples)
			{
				indices.push(i0++);
				indices.push(i2);
				indices.push(i1);
				indices.push(i1++);
				indices.push(i2++);
				indices.push(i3++);
				
				i++;
				index += 6;
			}
		}
		
		var indexBuffer:IndexBuffer = new IndexBuffer();
		indexBuffer.setData(indices);
		
		setIndexBuffer(indexBuffer);
	}
}