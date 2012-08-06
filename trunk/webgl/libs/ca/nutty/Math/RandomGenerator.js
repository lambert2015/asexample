/// <summary>
/// Nutty Software Open WebGL Framework
/// 
/// Copyright (C) 2012 Nathaniel Meyer
/// Nutty Software, http://www.nutty.ca
/// All Rights Reserved.
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy of
/// this software and associated documentation files (the "Software"), to deal in
/// the Software without restriction, including without limitation the rights to
/// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
/// of the Software, and to permit persons to whom the Software is furnished to do
/// so, subject to the following conditions:
///     1. The above copyright notice and this permission notice shall be included in all
///        copies or substantial portions of the Software.
///     2. Redistributions in binary or minimized form must reproduce the above copyright
///        notice and this list of conditions in the documentation and/or other materials
///        provided with the distribution.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
/// </summary>


/// <summary>
/// RNG using XOR.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
function RandomGenerator ()
{
	/// <summary>
	/// Seed to be used in generator.
	/// </summary>
	this.mSeed = 0;
	
	
	/// <summary>
	/// Seed used by the XOR algorithm.
	/// </summary>
	this.mXorSeed = [0, 0, 0, 0];
	
	
	// Init
	this.Seed(0);
}


/// <summary>
/// Abstract method to be implemented.
/// </summary>
/// <param name="seedValue">Seed value to use in generator.</param>
RandomGenerator.prototype.Seed = function (seedValue)
{
	this.mSeed = seedValue;
	
	// Setup startup seeds
	this.mXorSeed[0] = seedValue;

	// Scramble (Mersenne Twister)
	for (var i = 1; i < 4; ++i)
	{
		this.mXorSeed[i] = (1812433253 * (this.mXorSeed[i-1] ^ (this.mXorSeed[i-1] >> 30)) + 5);
        this.mXorSeed[i] &= 0xffffffff;
	}
}


/// <summary>
/// The seed value used by this random number generator.
/// </summary>
/// <returns>The seed value used by this random number generator.</returns>
RandomGenerator.prototype.GetSeed = function ()
{
	return this.mSeed;
}


/// <summary>
/// Generates a random int between [0, 2^32].
/// </summary>
/// <returns>A random int between [0, 2^32].</returns>
RandomGenerator.prototype.GenerateRandom = function ()
{
	var t = this.mXorSeed[0] ^ (this.mXorSeed[0] << 11);
	this.mXorSeed[0] = this.mXorSeed[1];
	this.mXorSeed[1] = this.mXorSeed[2];
	this.mXorSeed[2] = this.mXorSeed[3];
	this.mXorSeed[3] = (this.mXorSeed[3] ^ (this.mXorSeed[3] >> 19)) ^ (t ^ (t >> 8));

	return this.mXorSeed[3];
}


/// <summary>
/// Generates a random int between [min, max].
/// </summary>
/// <param name="min">Lower range of the random number.</param>
/// <param name="max">Upper range of the random number.</param>
/// <returns>A random int between [min, max].</returns>
RandomGenerator.prototype.Random = function (min, max)
{
	if ( min == null )
		min = Number.MIN_VALUE / 2;
	if ( max == null )
		max = Number.MAX_VALUE / 2;

	return (((max - min) + 1) != 0) ? (min + (this.GenerateRandom() % ((max - min) + 1))) : min;
}


/// <summary>
/// Generates a random floating point value between [min, max].
/// </summary>
/// <param name="min">Minimum floating point value.</param>
/// <param name="max">Maximum floating point value.</param>
/// <returns>A random probability between [min, max]</returns>
RandomGenerator.prototype.RandomFloat = function (min, max)
{
	if ( min == null )
		min = 0.0;
	if ( max == null )
		max = 1.0;
		
	return min + (this.GenerateRandom() / 0x7fffffff) * (max - min);
}