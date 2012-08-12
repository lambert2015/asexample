// RNG using XOR.
function RandomGenerator ()
{
	// Seed to be used in generator.
	this.mSeed = 0;
	
	// Seed used by the XOR algorithm.
	this.mXorSeed = [0, 0, 0, 0];
	
	// Init
	this.seed(0);
}

// Abstract method to be implemented.
// <param name="seedValue">Seed value to use in generator.</param>
RandomGenerator.prototype.seed = function (seedValue)
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

// The seed value used by this random number generator.
// <returns>The seed value used by this random number generator.</returns>
RandomGenerator.prototype.getSeed = function ()
{
	return this.mSeed;
}

// Generates a random int between [0, 2^32].
// <returns>A random int between [0, 2^32].</returns>
RandomGenerator.prototype.generateRandom = function ()
{
	var t = this.mXorSeed[0] ^ (this.mXorSeed[0] << 11);
	this.mXorSeed[0] = this.mXorSeed[1];
	this.mXorSeed[1] = this.mXorSeed[2];
	this.mXorSeed[2] = this.mXorSeed[3];
	this.mXorSeed[3] = (this.mXorSeed[3] ^ (this.mXorSeed[3] >> 19)) ^ (t ^ (t >> 8));

	return this.mXorSeed[3];
}

// Generates a random int between [min, max].
// <param name="min">Lower range of the random number.</param>
// <param name="max">Upper range of the random number.</param>
// <returns>A random int between [min, max].</returns>
RandomGenerator.prototype.random = function (min, max)
{
	if ( min == null )
		min = Number.MIN_VALUE / 2;
	if ( max == null )
		max = Number.MAX_VALUE / 2;

	return (((max - min) + 1) != 0) ? (min + (this.generateRandom() % ((max - min) + 1))) : min;
}

// Generates a random floating point value between [min, max].
// <param name="min">Minimum floating point value.</param>
// <param name="max">Maximum floating point value.</param>
// <returns>A random probability between [min, max]</returns>
RandomGenerator.prototype.randomFloat = function (min, max)
{
	if ( min == null )
		min = 0.0;
	if ( max == null )
		max = 1.0;
		
	return min + (this.generateRandom() / 0x7fffffff) * (max - min);
}