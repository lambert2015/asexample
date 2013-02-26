package org.angle3d.cinematic;

/**
 * The play state of a cinematic event
 * @author Nehon
 */
enum PlayState 
{
    /**The CinematicEvent is currently beeing played*/
    Playing;
    /**The animatable has been paused*/
    Paused;
    /**the animatable is stoped*/
    Stopped;
}