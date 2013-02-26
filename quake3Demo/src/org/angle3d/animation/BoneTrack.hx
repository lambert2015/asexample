package org.angle3d.animation;
import org.angle3d.math.Vector3f;
import flash.Vector;
import org.angle3d.math.Quaternion;
import org.angle3d.utils.Assert;

/**
 * Contains a list of transforms and times for each keyframe.
 * 
 * @author Kirill Vainer
 */
class BoneTrack implements Track
{
	 /**
     * Bone index in the skeleton which this track effects.
     */
    private var targetBoneIndex:Int;
    
    /**
     * Transforms and times for track.
     */
    private var translations:Vector<Vector3f>;
    private var rotations:Vector<Quaternion>;
    private var scales:Vector<Vector3f>;
    private var times:Vector<Float>;

	/**
     * Creates a bone track for the given bone index
     * @param targetBoneIndex the bone index
     * @param times a float array with the time of each frame
     * @param translations the translation of the bone for each frame
     * @param rotations the rotation of the bone for each frame
	 * @param scales the scale of the bone for each frame
     */
	public function new(targetBoneIndex:Int, times:Vector<Float>,
	                    translations:Vector<Vector3f>,
						rotation:Vector<Quaternion>,
						scales:Vector<Vector3f> = null) 
	{
		this.targetBoneIndex = targetBoneIndex;
		this.setKeyframes(times, translations, rotations, scales);
	}
	
	/**
     * @return the bone index of this bone track.
     */
    public function getTargetBoneIndex():Int
	{
        return targetBoneIndex;
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
	
	public function setTime(time:Float, weight:Float, control:AnimControl, channel:AnimChannel):Void
	{
		//BitSet affectedBones = channel.getAffectedBones();
        //if (affectedBones != null && !affectedBones.get(targetBoneIndex)) {
            //return;
        //}
        //
        //Bone target = control.getSkeleton().getBone(targetBoneIndex);
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
            //rotations.get(0, tempQ);
            //translations.get(0, tempV);
            //if (scales != null) {
                //scales.get(0, tempS);
            //}
        //} else if (time >= times[lastFrame]) {
            //rotations.get(lastFrame, tempQ);
            //translations.get(lastFrame, tempV);
            //if (scales != null) {
                //scales.get(lastFrame, tempS);
            //}
        //} else {
            //int startFrame = 0;
            //int endFrame = 1;
            // use lastFrame so we never overflow the array
            //int i;
            //for (i = 0; i < lastFrame && times[i] < time; i++) {
                //startFrame = i;
                //endFrame = i + 1;
            //}
//
            //float blend = (time - times[startFrame])
                    /// (times[endFrame] - times[startFrame]);
//
            //rotations.get(startFrame, tempQ);
            //translations.get(startFrame, tempV);
            //if (scales != null) {
                //scales.get(startFrame, tempS);
            //}
            //rotations.get(endFrame, tempQ2);
            //translations.get(endFrame, tempV2);
            //if (scales != null) {
                //scales.get(endFrame, tempS2);
            //}
            //tempQ.nlerp(tempQ2, blend);
            //tempV.interpolate(tempV2, blend);
            //tempS.interpolate(tempS2, blend);
        //}
//
        //if (weight != 1f) {
            //target.blendAnimTransforms(tempV, tempQ, scales != null ? tempS : null, weight);
        //} else {
            //target.setAnimTransforms(tempV, tempQ, scales != null ? tempS : null);
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
        Assert.assert(times.length > 0, "BoneTrack with no keyframes!");

        Assert.assert(times.length == translations.length && times.length == rotations.length, "times.length should equal to translations.length");

        this.times = times;
        this.translations = translations;
        this.rotations = rotations;
		this.scales = scales;
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