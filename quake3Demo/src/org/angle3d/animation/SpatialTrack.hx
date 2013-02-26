package org.angle3d.animation;
import org.angle3d.math.Vector3f;
import flash.Vector;
import org.angle3d.math.Quaternion;
import org.angle3d.utils.Assert;

/**
 * This class represents the track for spatial animation.
 * 
 * @author Marcin Roguski (Kaelthas)
 */
class SpatialTrack implements Track
{
	/** 
     * Translations of the track. 
     */
    private var translations:Vector<Vector3f>;
	/** 
     * Rotations of the track. 
     */
    private var rotations:Vector<Quaternion>;
	/**
     * Scales of the track. 
     */
    private var scales:Vector<Vector3f>;
	/** 
     * The times of the animations frames. 
     */
    private var times:Vector<Float>;

	public function new(times:Vector<Float>,
	                    translations:Vector<Vector3f>= null,
						rotation:Vector<Quaternion>= null,
						scales:Vector<Vector3f> = null) 
	{
		setKeyframes(times, translations, rotations, scales);
	}
	
	/**
     * 
     * Modify the spatial which this track modifies.
     * 
     * @param time
     *            the current time of the animation
     * @param spatial
     *            the spatial that should be animated with this track
     */
    public function setTime(time:Float, weight:Float, control:AnimControl, channel:AnimChannel):Void
	{
        //Spatial spatial = control.getSpatial();
        //
        //Vector3f tempV = vars.vect1;
        //Vector3f tempS = vars.vect2;
        //Quaternion tempQ = vars.quat1;
        //Vector3f tempV2 = vars.vect3;
        //Vector3f tempS2 = vars.vect4;
        //Quaternion tempQ2 = vars.quat2;
        //
        //int lastFrame = times.length - 1;
        //if (time < 0 || lastFrame == 0) {
            //if (rotations != null)
                //rotations.get(0, tempQ);
            //if (translations != null)
                //translations.get(0, tempV);
            //if (scales != null) {
                //scales.get(0, tempS);
            //}
        //} else if (time >= times[lastFrame]) {
            //if (rotations != null)
                //rotations.get(lastFrame, tempQ);
            //if (translations != null)
                //translations.get(lastFrame, tempV);
            //if (scales != null) {
                //scales.get(lastFrame, tempS);
            //}
        //} else {
            //int startFrame = 0;
            //int endFrame = 1;
            // use lastFrame so we never overflow the array
            //for (int i = 0; i < lastFrame && times[i] < time; ++i) {
                //startFrame = i;
                //endFrame = i + 1;
            //}
//
            //float blend = (time - times[startFrame]) / (times[endFrame] - times[startFrame]);
//
            //if (rotations != null)
                //rotations.get(startFrame, tempQ);
            //if (translations != null)
                //translations.get(startFrame, tempV);
            //if (scales != null) {
                //scales.get(startFrame, tempS);
            //}
            //if (rotations != null)
                //rotations.get(endFrame, tempQ2);
            //if (translations != null)
                //translations.get(endFrame, tempV2);
            //if (scales != null) {
                //scales.get(endFrame, tempS2);
            //}
            //tempQ.nlerp(tempQ2, blend);
            //tempV.interpolate(tempV2, blend);
            //tempS.interpolate(tempS2, blend);
        //}
        //
        //if (translations != null)
            //spatial.setLocalTranslation(tempV);
        //if (rotations != null)
            //spatial.setLocalRotation(tempQ);
        //if (scales != null) {
            //spatial.setLocalScale(tempS);
        //}
    }
	
	/**
     * Set the translations and rotations for this bone track
     * @param times a float array with the time of each frame
     * @param translations the translation of the bone for each frame
     * @param rotations the rotation of the bone for each frame
     */
    public function setKeyframes(times:Vector<Float>,
	                             translations:Vector<Vector3f>,
						         rotations:Vector<Quaternion>,
						         scales:Vector<Vector3f> = null):Void 
	{
        Assert.assert(times.length > 0, "SpatialTrack with no keyframes!");
		
        this.times = times;
        this.translations = translations;
        this.rotations = rotations;
		this.scales = scales;
    }
	
	/**
     * return the array of rotations of this track
     * @return 
     */
    public function getRotations():Vector<Quaternion>
	{
        return rotations;
    }
	
	/**
     * returns the array of scales for this track
     * @return 
     */
    public function getScales():Vector<Vector3f>
	{
        return scales;
    }
	
	/**
     * returns the array of translations of this track
     * @return 
     */
    public function getTranslations():Vector<Vector3f>
	{
        return translations;
    }
	
	/**
     * returns the arrays of time for this track
     * @return 
     */
    public function getTimes():Vector<Float>
	{
        return times;
    }
	
	/**
     * @return the length of the track
     */
    public function getLength():Float
	{
        return times == null ? 0 : times[times.length - 1] - times[0];
    }
	
	public function clone():Track
	{
		//need implements
		return null;
	}
	
}