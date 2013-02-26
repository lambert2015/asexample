package org.angle3d.cinematic.tracks;

/**
 * Enum for the different type of target direction behavior
 */
enum Direction 
{
    /**
     * the target stay in the starting direction
     */
    None;
    /**
     * The target rotates with the direction of the path
     */
    Path;
    /**
     * The target rotates with the direction of the path but with the additon of a rtotation
     * you need to use the setRotation mathod when using this Direction
     */
    PathAndRotation;
    /**
     * The target rotates with the given rotation
     */
    Rotation;
    /**
     * The target looks at a point
     * You need to use the setLookAt method when using this direction
     */
    LookAt;
}