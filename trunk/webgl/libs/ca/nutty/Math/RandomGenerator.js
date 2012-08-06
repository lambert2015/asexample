// <summary>
// RNG using XOR.
// </summary>


// <summary>
// Constructor.
// </summary>
function RandomGenerator ()
{
	// <summary>
	// Seed to be used in generator.
	// </summary>
	this.mSeed = 0;
	
	
	// <summary>
	// Seed used by the XOR algorithm.
	// </summary>
	this.mXorSeed = [0, 0, 0, 0];
	
	
	// Init
	this.Seed(0);
}


// <summary>
// Abstract method to be implemented.
// </summary>
// <param name="seedValue">Seed value to use in generator.</param>
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


// <summary>
// The seed value used by this random number generator.
// </summary>
// <returns>The seed value used by this random number generator.</returns>
RandomGenerator.prototype.GetSeed = function ()
{
	return this.mSeed;
}


// <summary>
// Generates a random int between [0, 2^32].
// </summary>
// <returns>A random int between [0, 2^32].</returns>
RandomGenerator.prototype.GenerateRandom = function ()
{
	var t = this.mXorSeed[0] ^ (this.mXorSeed[0] << 11);
	this.mXorSeed[0] = this.mXorSeed[1];
	this.mXorSeed[1] = this.mXorSeed[2];
	this.mXorSeed[2] = this.mXorSeed[3];
	this.mXorSeed[3] = (this.mXorSeed[3] ^ (this.mXorSeed[3] >> 19)) ^ (t ^ (t >> 8));

	return this.mXorSeed[3];
}


// <summary>
// Generates a random int between [min, max].
// </summary>
// <param name="min">Lower range of the random number.</param>
// <param name="max">Upper range of the random number.</param>
// <returns>A random int between [min, max].</returns>
RandomGenerator.prototype.Random = function (min, max)
{
	if ( min == null )
		min = Number.MIN_VALUE / 2;
	if ( max == null )
		max = Number.MAX_VALUE / 2;

	return (((max - min) + 1) != 0) ? (min + (this.GenerateRandom() % ((max - min) + 1))) : min;
}


// <summary>
// Generates a random floating point value between [min, max].
// </summary>
// <param name="min">Minimum floating point value.</param>
// <param name="max">Maximum floating point value.</param>
// <returns>A random probability between [min, max]</returns>
RandomGenerator.prototype.RandomFloat = function (min, max)
{
	if ( min == null )
		min = 0.0;
	if ( max == null )
		max = 1.0;
		
	return min + (this.GenerateRandom() / 0x7fffffff) * (max - min);
}