package examples;
import flash.display.BitmapData;
import org.angle3d.scene.SkyBox;
import org.angle3d.texture.CubeTextureMap;

/**
 * ...
 * @author andy
 */

class DefaultSkyBox extends SkyBox 
{

	public function new() 
	{
		
		var px:BitmapData = new EmbedPositiveX(0, 0);
		var nx:BitmapData = new EmbedNegativeX(0, 0);
		var py:BitmapData = new EmbedPositiveY(0, 0);
		var ny:BitmapData = new EmbedNegativeY(0, 0);
		var pz:BitmapData = new EmbedPositiveZ(0, 0);
		var nz:BitmapData = new EmbedNegativeZ(0, 0);
		
		super(new CubeTextureMap(px,nx,py,ny,pz,nz),100);
	}
	
}

@:bitmap("../bin/assets/sky/negativeX.png") class EmbedNegativeX extends BitmapData {}

@:bitmap("../bin/assets/sky/negativeY.png") class EmbedNegativeY extends BitmapData {}

@:bitmap("../bin/assets/sky/negativeZ.png") class EmbedNegativeZ extends BitmapData {}

@:bitmap("../bin/assets/sky/positiveX.png") class EmbedPositiveX extends BitmapData {}

@:bitmap("../bin/assets/sky/positiveY.png") class EmbedPositiveY extends BitmapData {}

@:bitmap("../bin/assets/sky/positiveZ.png") class EmbedPositiveZ extends BitmapData {}