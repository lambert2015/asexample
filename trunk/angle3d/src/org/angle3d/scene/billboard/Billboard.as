package org.angle3d.scene.billboard
{
	import org.angle3d.math.Vector3f;

	/**
	 * A billboard is a primitive which always faces the camera in every frame.
	 * Billboards can be used for special effects or some other trickery which requires the
	 * triangles to always facing the camera no matter where it is. Ogre groups billboards into
	 * sets for efficiency, so you should never create a billboard on it's own (it's ok to have a
	 * set of one if you need it).

	 * Billboards have their geometry generated every frame depending on where the camera is. It is most
	 * beneficial for all billboards in a set to be identically sized since Ogre can take advantage of this and
	 * save some calculations - useful when you have sets of hundreds of billboards as is possible with special
	 * effects. You can deviate from this if you wish (example: a smoke effect would probably have smoke puffs
	 * expanding as they rise, so each billboard will legitimately have it's own size) but be aware the extra
	 * overhead this brings and try to avoid it if you can.

	 * Billboards are just the mechanism for rendering a range of effects such as particles. It is other classes
	 * which use billboards to create their individual effects, so the methods here are quite generic.
	 * @see BillboardSet
	 */
	public class Billboard
	{
		public var position:Vector3f;
		// Normalised direction vector
		public var direction:Vector3f;
		public var parentSet:BillboardSet;
		public var color:uint;
		public var rotation:Number;

		public var width:Number;
		public var height:Number;
		public var ownDimensions:Boolean;

		public var useTexcoordRect:Boolean;
		public var texcoordIndex:uint; // index into the BillboardSet array of texture coordinates
		public var texcoordRect:SimpleRect; // individual texture coordinates

		public function Billboard(position:Vector3f, owner:BillboardSet, color:uint = 0xFFFFFFFF)
		{
			this.position = position;
			this.parentSet = owner;
			this.color = color;

			this.rotation = 0;
			this.direction = new Vector3f(0,0,1);

			ownDimensions = false;
			
			texcoordIndex = 0;
			useTexcoordRect = false;

		}
		
		public function reset():void
		{
			ownDimensions = false;
			texcoordIndex = 0;
			rotation = 0;
			direction.setTo(0,0,1);
		}

		public function setRotation(rotation:Number):void
		{
			this.rotation = rotation;
			if (this.rotation != 0)
				parentSet.notifyBillboardRotated();
		}

		public function getRotation():Number
		{
			return this.rotation;
		}

		public function setPosition(position:Vector3f):void
		{
			this.position.copyFrom(position);
		}

		public function setPositionXYZ(x:Number, y:Number, z:Number):void
		{
			this.position.x = x;
			this.position.y = y;
			this.position.z = z;
		}

		public function getPosition():Vector3f
		{
			return this.position;
		}

		public function setDimensions(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
			ownDimensions = true;
			parentSet.notifyBillboardResized();
		}

		public function resetDimensions():void
		{
			ownDimensions = false;
		}

		public function setTexcoordIndex(texcoordIndex:int):void
		{
			this.texcoordIndex = texcoordIndex;
			useTexcoordRect = false;
		}

		public function setTexcoordRect(texcoordRect:SimpleRect):void
		{
			this.texcoordRect = texcoordRect;
			useTexcoordRect = true;
		}
	}
}
