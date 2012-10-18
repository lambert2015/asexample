package org.angle3d.utils;

import flash.utils.Dictionary;
import flash.Vector;

/**
 * <p>A hash using Dictionary.</p>
 * <ul>
 * <li>Each key can only map a <b>single value</b>.</li>
 * <li><em>null</em> keys and <em>null</em> values are not allowed.</li>
 * </ul>
 */
class HashMap<K, T>
{
	private var _map:Dictionary;
	private var _weak:Bool;
	private var _size:Int;

	/**
	 * @param weak if true, weak keys are used. A key/value pair is lost when no other object
	 * besides this object holds a reference to the key. Default is false.
	 * 
	 */
	public function new(weak:Bool = false)
	{
		_map  = new Dictionary(_weak = weak);
		_size = 0;
	}

	/**
	 * Returns an array of all keys.
	 */
	public function toKeys():Array<K>
	{
		return untyped __keys__(_map);
	}

	/**
	 * Returns true if this map contains a mapping for <code>val</code>.
	 */
	inline public function containsValue(val:T):Bool
	{
		#if debug
		var x:Null<T> = val;
		Assert.assert(x != null, "null values are not allowed");
		#end
		
		var exists:Bool = false;
		var a:Array<K> = untyped __keys__(_map);
		for (i in a)
		{
			if (untyped _map[i] == val)
			{
				exists = true;
				break;
			}
		}
		return exists;
	}
	
	/**
	 * Returns true if this map contains the key <code>key</code>.
	 * <o>1</o>
	 * @throws de.polygonal.core.util.AssertionError <code>key</code> is null (debug only).
	 */
	inline public function containsKey(key:K):Bool
	{
		#if debug
		var x:Null<K> = key;
		Assert.assert(x != null, "null keys are not allowed");
		#end
		
		var x:Null<T> = untyped _map[key];
		return x != null;
	}
	
	/**
	 * Returns the value that is mapped to <code>key</code> or null if <code>key</code> does not exist.
	 */
	inline public function getValue(key:K):T
	{
		#if debug
		var x:Null<K> = key;
		Assert.assert(x != null, "null keys are not allowed");
		#end
		
		return untyped _map[key];
	}
	
	/**
	 * Maps <code>val</code> to <code>key</code>.
	 * @return old value
	 */
	public function setValue(key:K, val:T):T
	{
		#if debug
		var x:Null<K> = key;
		Assert.assert(x != null, "null keys are not allowed");
		var y:Null<T> = val;
		Assert.assert(y != null, "null values are not allowed");
		#end
		
		var exist:Bool = containsKey(key);
 		if (!exist)
		{
   			_size++;
 		}
		
 		var oldValue:T = this.getValue(key);
		
   		untyped _map[key] = val;
		
   		return oldValue;
	}
	
	/**
	 * Removes <code>key</code> and the value that is mapped to it.
	 * @return the value.
	 */
	public function delete(key:K):T
	{
		#if debug
		var x:Null<K> = key;
		Assert.assert(x != null, "null keys are not allowed");
		#end
		
		var result:Null<T> = untyped _map[key];
		if (result != null)
		{
			untyped __delete__(_map, key);
			_size--;
		}
		
		return result;
	}

	/**
	 * Destroys this object by explicitly nullifying all elements.<br/>
	 * Improves GC efficiency/performance (optional).
	 */
	public function destroy():Void
	{
		if (!_weak)
		{
			var a:Array<K> = untyped __keys__(_map);
			for (i in a) untyped __delete__(_map, i);
		}
		_map = null;
	}
	
	/**
	 * Removes all key/value pairs.
	 * @param purge if true, elements are nullified upon removal.
	 */
	public function clear():Void
	{
		var a:Array<K> = untyped __keys__(_map);
		for (key in a) untyped __delete__(_map, key);
		_size = 0;
	}
	
	/**
	 * The total number of key/value pairs.
	 */
	inline public function size():Int
	{
		return _size;
	}
	
	/**
	 * Returns true if this hash map is empty.
	 */
	inline public function isEmpty():Bool
	{
		return _size == 0;
	}
	
	/**
	 * Returns an unordered array containing all values in this hash map.
	 */
	public function toArray(result:Array<T> = null):Array<T>
	{
		if (result == null)
		{
			result = new Array<T>();
		}
		
		var keys:Array<K> = untyped __keys__(_map);
		for (i in 0...keys.length) 
		{
		    result[i] = getValue(keys[i]);
		}
		return result;
	}
	
	public function getKeys():Array<K>
	{
		return untyped __keys__(_map);
	}
	
	/**
	 * Returns an unordered array containing all values in this hash map.
	 */
	public function toVector(result:Vector<T> = null):Vector<T>
	{
		if (result == null)
		{
			result = new Vector<T>();
		}
		
		var keys:Array<K> = untyped __keys__(_map);
		for (i in 0...keys.length) 
		{
		    result[i] = getValue(keys[i]);
		}
		return result;
	}

	/**
	 * Duplicates this hash map by creating a shallow copy.
	 */
	public function clone():HashMap<K, T>
	{
		var result:HashMap<K, T> = new HashMap<K, T>(_weak);
		
		var a:Array<K> = untyped __keys__(_map);
		for (key in a) 
		    result.setValue(key, getValue(key));
			
		return result;
	}
}