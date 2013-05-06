package ;

import nme.Assets;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

/**
 * ...
 * @author 
 */

class Main extends Sprite 
{
	public function new() 
	{
		super();	
		
		var cat = Assets.getMovieClip ("library:NyanCatAnimation");
		addChild (cat);
	}
}
