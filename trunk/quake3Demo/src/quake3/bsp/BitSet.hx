package quake3.bsp;
import flash.Vector;

class BitSet
{
	private var bits:Vector<Int>;
	private var numBytes:Int;
	
	public function new(numberOfBits:Int)
	{
		//Calculate size
		this.numBytes = (numberOfBits >> 3) + 1;
		
		bits = new Vector<Int>(numBytes, true);
	}
	
	public function clear():Void
	{
		bits.fixed = false;
		bits.length = 0;
		bits.length = numBytes;
		bits.fixed = true;
	}
	
	public inline function set(bitNumber:Int):Void
	{
		bits[bitNumber >> 3] |= 1 << (bitNumber & 7);
	}
	
	public inline function remove(bitNumber:Int):Void
	{
		bits[bitNumber >> 3] &= ~(1 << (bitNumber & 7));
	}
	
	public inline function isSet(bitNumber:Int):Bool
	{
		return (bits[bitNumber >> 3] & 1 << (bitNumber & 7)) != 0;
	}
}
