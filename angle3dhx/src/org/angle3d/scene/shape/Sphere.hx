package org.angle3d.scene.shape;
import org.angle3d.math.Vector3f;
import flash.Vector;
import org.angle3d.math.FastMath;
import org.angle3d.math.VectorUtil;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.BufferUtils;
import org.angle3d.scene.mesh.IndexBuffer;
import org.angle3d.scene.mesh.Mesh;

class TextureMode 
{

    /** 
     * Wrap texture radially and along z-axis 
     */
    public static inline var Original:Int = 0;
	
    /** 
     * Wrap texure radially, but spherically project along z-axis 
     */
    public static inline var Projected:Int = 1;
	
    /** 
     * Apply texture to each pole.  Eliminates polar distortion,
     * but mirrors the texture across the equator 
     */
    public static inline var Polar:Int = 2;
}

/**
 * <code>Sphere</code> represents a 3D object with all points equidistance
 * from a center point.
 * 
 */
class Sphere extends Mesh
{
    private var triCount:Int;
    private var zSamples:Int;
    private var radialSamples:Int;
    private var useEvenSlices:Bool;
    private var interior:Bool;
    private var textureMode:Int;
	
	/** the distance from the center point each point falls on */
    public var radius:Float;

	/**
     * Constructs a sphere. Additional arg to evenly space latitudinal slices
     * 
     * @param zSamples
     *            The number of samples along the Z.
     * @param radialSamples
     *            The number of samples along the radial.
     * @param radius
     *            The radius of the sphere.
     * @param useEvenSlices
     *            Slice sphere evenly along the Z axis
     * @param interior
     *            Not yet documented
     */
	public function new(zSamples:Int, radialSamples:Int, radius:Float, useEvenSlices:Bool=false, interior:Bool=false) 
	{
		super();
		textureMode = TextureMode.Projected;
		updateGeometry(zSamples, radialSamples, radius, useEvenSlices, interior);
	}
	
	public function updateGeometry(zSamples:Int, radialSamples:Int, radius:Float, useEvenSlices:Bool=false, interior:Bool=false):Void
	{
		this.zSamples = zSamples;
        this.radialSamples = radialSamples;
        this.radius = radius;
        this.useEvenSlices = useEvenSlices;
        this.interior = interior;
        setGeometryData();
        setIndexData();
	}
	
	public function setTextureMode(textureMode:Int):Void
	{
        this.textureMode = textureMode;
        setGeometryData();
    }
	
	public function getRadialSamples():Int
	{
        return radialSamples;
    }

    public function getRadius():Float
	{
        return radius;
    }

    /**
     * @return Returns the textureMode.
     */
    public function getTextureMode():Int
	{
        return textureMode;
    }

    public function getZSamples():Int
	{
        return zSamples;
    }
	
	/**
     * builds the vertices based on the radius, radial and zSamples.
     */
	private function setGeometryData():Void
	{
		vertCount = (zSamples - 2) * (radialSamples + 1) + 2;
		 
		var normVec:Vector<Float> = new Vector<Float>();
		var posVec:Vector<Float> = new Vector<Float>();
		var textVec:Vector<Float> = new Vector<Float>();
		
		 // generate geometry
        var fInvRS:Float = 1.0 / radialSamples;
        var fZFactor:Float = 2.0 / (zSamples - 1);

        // Generate points on the unit circle to be used in computing the mesh
        // points on a sphere slice.
        var afSin:Vector<Float> = new Vector<Float>(radialSamples + 1, true);
        var afCos:Vector<Float> = new Vector<Float>(radialSamples + 1, true);
        for (iR in 0...radialSamples) 
		{
            var fAngle:Float = FastMath.TWO_PI * fInvRS * iR;
            afCos[iR] = Math.cos(fAngle);
            afSin[iR] = Math.sin(fAngle);
        }
        afSin[radialSamples] = afSin[0];
        afCos[radialSamples] = afCos[0];
		
		var tempVa:Vector3f = new Vector3f();
		var tempVb:Vector3f = new Vector3f();
		var tempVc:Vector3f = new Vector3f();
		
		// generate the sphere itself
		var i:Int = 0;
		for(iZ in 0...(zSamples - 1))
		{
			var fAFraction:Float = FastMath.HALF_PI * ( -1.0 + fZFactor * iZ);//in (-pi/2,pi/2)
			var fZFraction:Float;
			if (useEvenSlices)
			{
				fZFraction = -1.0 + fZFactor * iZ;//in (-1,1);
			}
			else
			{
				fZFraction = Math.sin(fAFraction);//in (-1,1);
			}
			
			var fZ:Float = radius * fZFraction;
			
			// compute center of slice
			var kSliceCenter:Vector3f = new Vector3f(0, 0, 0);
			kSliceCenter.z += fZ;
			
			// compute radius of slice
			var fSliceRadius:Float = Math.sqrt(FastMath.fabs(radius * radius - fZ * fZ));
			
			// compute slice vertices with duplication at end point
			var kNormal:Vector3f = new Vector3f();
			var iSave:Int = i;
			for (iR in 0...radialSamples)
			{
				var fRadialFraction:Float = iR * fInvRS;//in [0,1]
				var kRadial:Vector3f = new Vector3f(afCos[iR], afSin[iR], 0);
				kRadial.scaleLocal(fSliceRadius);
				
				posVec.push(kSliceCenter.x + kRadial.x);
				posVec.push(kSliceCenter.y + kRadial.y);
				posVec.push(kSliceCenter.z + kRadial.z);
				
				BufferUtils.populateFromBuffer(kRadial, posVec, i);
				
				kNormal.copyFrom(kRadial);
				kNormal.normalizeLocal();
				if (!interior) // allow interior texture vs. exterior
                {
					normVec.push(kNormal.x);
					normVec.push(kNormal.y);
					normVec.push(kNormal.z);
				}
				else
				{
					normVec.push( -kNormal.x);
					normVec.push( -kNormal.y);
					normVec.push( -kNormal.z);
				}
				
				if (textureMode == TextureMode.Original)
				{
					textVec.push(fRadialFraction);
					textVec.push(0.5 * (fZFraction + 1.0));
				}
				else if (textureMode == TextureMode.Projected)
				{
					textVec.push(fRadialFraction);
					textVec.push(FastMath.INV_PI * (FastMath.HALF_PI + Math.asin(fZFraction)));
				}
				else if (textureMode == TextureMode.Polar)
				{
					var r:Float = (FastMath.HALF_PI - FastMath.fabs(fAFraction)) / FastMath.PI;
                    var u:Float = r * afCos[iR] + 0.5;
                    var v:Float = r * afSin[iR] + 0.5;
					textVec.push(u);
					textVec.push(v);
				}
				
				i++;
			}
			
			BufferUtils.copyInternalVector3(posVec, iSave, i);
			BufferUtils.copyInternalVector3(normVec, iSave, i);
			
			if (textureMode == TextureMode.Original)
			{
				textVec.push(1.0);
				textVec.push(0.5 * (fZFraction + 1.0));
			}
			else if (textureMode == TextureMode.Projected)
			{
				textVec.push(1.0);
				textVec.push(FastMath.INV_PI * (FastMath.HALF_PI + Math.asin(fZFraction)));
			}
			else if (textureMode == TextureMode.Polar)
			{
				var r:Float = (FastMath.HALF_PI - FastMath.fabs(fAFraction)) / FastMath.PI;
		     	textVec.push(r + 0.5);
				textVec.push(0.5);
			}
			
			i++;
		}
		
		var tmpVec:Vector<Float> = Vector.ofArray([0.0,0.0,-radius]);
		// south pole
		VectorUtil.insert(posVec, i * 3, tmpVec);

		if (!interior) 
		{
            tmpVec[2] = -1; // allow for inner
        }
        else 
		{
            tmpVec[2] = 1;
        }
		VectorUtil.insert(normVec, i * 3, tmpVec);
		
		var tmpVec2:Vector<Float> = new Vector<Float>();
		if (textureMode == TextureMode.Polar) 
		{
            tmpVec2[0] = 0.5;
			tmpVec2[1] = 0.5;
        } 
		else 
		{
            tmpVec2[0] = 0.5;
			tmpVec2[1] = 0.0;
        }
		VectorUtil.insert(textVec, i * 2, tmpVec);
		
		// north pole
		posVec.push(0);
		posVec.push(0);
		posVec.push(radius);
		
		if (!interior) 
		{
            normVec.push(0);
		    normVec.push(0);
		    normVec.push(1);
        } 
		else 
		{
            normVec.push(0);
		    normVec.push(0);
		    normVec.push(-1);
        }
		
		if (textureMode == TextureMode.Polar) 
		{
            textVec.push(0.5);
		    textVec.push(0.5);
        } 
		else 
		{
            textVec.push(0.5);
		    textVec.push(1.0);
        }
		
		setVertexBuffer(BufferType.Position, 3, posVec);
		setVertexBuffer(BufferType.Normal, 3, normVec);
		setVertexBuffer(BufferType.TexCoord, 2, textVec);
		updateBound();
	}
	
	private function setIndexData():Void
	{
		var indices:Vector<UInt> = new Vector<UInt>();
		
		var iZStart:Int = 0;
		for (iZ in 0...(zSamples - 3))
		{
			var i0:Int = iZStart;
			var i1:Int = i0 + 1;
			iZStart += (radialSamples + 1);
			var i2:Int = iZStart;
			var i3:Int = i2 + 1;
			for (i in 0...radialSamples)
			{
				if (!interior)
				{
					indices.push(i0++);
					indices.push(i1);
					indices.push(i2);
					indices.push(i1++);
					indices.push(i3++);
					indices.push(i2++);
				}
				else
				{
					indices.push(i0++);
					indices.push(i2);
					indices.push(i1);
					indices.push(i1++);
					indices.push(i2++);
					indices.push(i3++);
				}
			}
		}
		
		// south pole triangles
		for (i in 0...radialSamples)
		{
			if (!interior)
			{
				indices.push(i);
				indices.push(vertCount - 2);
				indices.push(i + 1);
			}
			else
			{
				indices.push(i);
				indices.push(i + 1);
				indices.push(vertCount - 2);
			}
		}
		
		// north pole triangles
		var iOffset:Int = (zSamples - 3) * (radialSamples + 1);
		for (i in 0...radialSamples)
		{
			if (!interior)
			{
				indices.push(i + iOffset);
				indices.push(i + 1 + iOffset);
				indices.push(vertCount - 1);
			}
			else
			{
				indices.push(i + iOffset);
				indices.push(vertCount - 1);
				indices.push(i + 1 + iOffset);
			}
		}
		
		var indexBuffer:IndexBuffer = new IndexBuffer();
		indexBuffer.setData(indices);
		
		setIndexBuffer(indexBuffer);
	}
	
}