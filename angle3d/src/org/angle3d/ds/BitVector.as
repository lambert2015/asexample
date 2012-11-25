package org.angle3d.ds
{
	import org.angle3d.utils.Assert;



	/**
	 * <p>An array data structure that compactly stores individual bits (Booleanean values).</p>
	 * <p><o>Worst-case running time in Big O notation</o></p>
	 */
	/**
	 * 速度与直接使用Vector.<Int>通过0,1来判断差不多.
	 * Vector.<Int>稍微快一些，但是占用内存也多些
	 */
	public class BitVector
	{
		private var _bits:Vector.<int>;

		private var _arrSize:int;
		private var _bitSize:int;

		/**
		 * Creates a bit-vector capable of storing a total of <code>size</code> bits.
		 */
		public function BitVector(size:int)
		{
			_bits = null;
			_bitSize = 0;
			_arrSize = 0;

			resize(size);
		}

		/**
		 * Destroys this object by explicitly nullifying the array storing the bits.
		 * <o>1</o>
		 */
		public function free():void
		{
			_bits = null;
		}

		/**
		 * The exact number of bits that the bit-vector can store.
		 * <o>1</o>
		 */
		public function capacity():int
		{
			return _bitSize;
		}

		/**
		 * The total number of bits set to 1.
		 * <o>n</o>
		 */
		public function size():int
		{
			var c:int = 0;
			for (var i:int = 0; i < _arrSize; i++)
				c += getOneCount(_bits[i]);
			return c;
		}

		/**
		 * Counts the number of "1"-bits.<br/>
		 * e.g. 00110111 has 5 bits set.
		 */
		public static function getOneCount(x:int):int
		{
			x -= ((x >> 1) & 0x55555555);
			x = (((x >> 2) & 0x33333333) + (x & 0x33333333));
			x = (((x >> 4) + x) & 0x0f0f0f0f);
			x += (x >> 8);
			x += (x >> 16);
			return (x & 0x0000003f);
		}

		/**
		 * The total number of 32-bit integers allocated for storing the bits.
		 * <o>1</o>
		 */
		public function bucketSize():int
		{
			return _arrSize;
		}

		/**
		 * Returns true if the bit at index <code>i</code> is 1.
		 * <o>1</o>
		 * @throws de.polygonal.core.util.AssertionError index out of range (debug only).
		 */
		public function get(i:int):Boolean
		{
			Assert.assert(i < capacity(), "i index out of range " + i);

			return ((_bits[i >> 5] & (1 << (i & 31))) >> (i & 31)) != 0;
		}

		/**
		 * Sets the bit at index <code>i</code> to 1.
		 * <o>1</o>
		 * @throws de.polygonal.core.util.AssertionError index out of range (debug only).
		 */
		public function set(i:int):void
		{
			Assert.assert(i < capacity(), "i index out of range " + i);

			var p:int = i >> 5;
			_bits[p] = _bits[p] | (1 << (i & 31));
		}

		/**
		 * Sets the bit at index <code>i</code> to 0.
		 * <o>1</o>
		 * @throws de.polygonal.core.util.AssertionError index out of range (debug only).
		 */
		public function clear(i:int):void
		{
			Assert.assert(i < capacity(), "i index out of range " + i);

			var p:int = i >> 5;
			_bits[p] = _bits[p] & (~(1 << (i & 31)));
		}

		/**
		 * Sets all bits in the bit-vector to 0.
		 * <o>n</o>
		 */
		public function clearAll():void
		{
			for (var i:int = 0; i < _arrSize; i++)
				_bits[i] = 0;
		}

		/**
		 * Sets all bits in the bit-vector to 1.
		 * <o>n</o>
		 */
		public function setAll():void
		{
			for (var i:int = 0; i < _arrSize; i++)
				_bits[i] = 1;
		}

		/**
		 * Clears all bits in the range <arg>&#091;min, max)</arg>.
		 * This is faster than clearing individual bits by using the <code>clr</code> method.
		 * @throws de.polygonal.core.util.AssertionError min out of range (debug only).
		 * @throws de.polygonal.core.util.AssertionError max out of range (debug only).
		 * <o>n</o>
		 */
		public function clearRange(min:int, max:int):void
		{
			Assert.assert(min >= 0 && min <= max && max < _bitSize, "min/max out of range " + min + "/" + max);

			var i:int;
			var n:int = max - min;
			if (n < 32)
				for (i = min; i < max; i++)
				{
					clear(i);
				}
			else
			{
				var r:int = n & 31;
				for (i = min; i < (max - r) >> 5; i++)
				{
					_bits[i] = 0;
				}
				for (i = (max - r); i < max; i++)
				{
					clear(i);
				}
			}
		}

		/**
		 * Sets all bits in the range <arg>&#091;min, max)</arg>.
		 * This is faster than setting individual bits by using the <code>set</code> method.
		 * @throws de.polygonal.core.util.AssertionError min out of range (debug only).
		 * @throws de.polygonal.core.util.AssertionError max out of range (debug only).
		 * <o>n</o>
		 */
		public function setRange(min:int, max:int):void
		{
			Assert.assert(min >= 0 && min <= max && max < _bitSize, "min/max out of range " + min + "/" + max);

			var i:int;
			var n:int = max - min;
			if (n < 32)
			{
				for (i = min; i < max; i++)
				{
					set(i);
				}
			}
			else
			{
				var r:int = n & 31;
				for (i = min; i < (max - r) >> 5; i++)
				{
					_bits[i] = -1;
				}
				for (i = (max - r); i < max; i++)
				{
					set(i);
				}
			}
		}

		/**
		 * Sets the bit at index <code>i</code> to 1 if <code>cond</code> is true or clears the bit at index <code>i</code> if <code>cond</code> is false.
		 * <o>1</o>
		 * @throws de.polygonal.core.util.AssertionError index out of range (debug only) (debug only).
		 */
		public function ofBoolean(i:int, cond:Boolean):void
		{
			cond ? set(i) : clear(i);
		}

		/**
		 * Resizes the bit-vector to <code>x</code> bits.<br/>
		 * Preserves existing values if the new size &gt; old size.
		 * <o>n</o>
		 */
		public function resize(x:int):void
		{
			if (_bitSize == x)
				return;

			var t:Vector.<int>;

			var newSize:int = x >> 5;
			if ((x & 31) > 0)
				newSize++;

			if (_bits == null)
			{
				_bits = new Vector.<int>(newSize, true);
				for (var i:int = 0; i < newSize; i++)
				{
					_bits[i] = 0;
				}
			}
			else if (newSize < _arrSize)
			{
				t = new Vector.<int>(newSize, true);
				for (i = 0; i < newSize; i++)
				{
					t[i] = _bits[i];
				}
				_bits = t;
			}
			else
			{
				if (_arrSize != newSize)
				{
					t = new Vector.<int>(newSize, true);
					for (i = 0; i < newSize; i++)
					{
						t[i] = _bits[i];
					}
					_bits = t;
				}
			}

			_bitSize = x;
			_arrSize = newSize;
		}

		/**
		 * Creates a copy of this bit vector.
		 * <o>n</o>
		 */
		public function clone():BitVector
		{
			var result:BitVector = new BitVector(_bitSize);
			var t:Vector.<int> = result._bits;
			for (var i:int = 0; i < _arrSize; i++)
			{
				t[i] = _bits[i];
			}
			return result;
		}
	}
}

