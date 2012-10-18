package org.angle3d.material.shader;

class UniformBinding 
{

    /**
     * The world matrix. Converts Model space to World space.
     * Type: mat4
     */
    public static inline var WorldMatrix:Int = 0;

    /**
     * The view matrix. Converts World space to View space.
     * Type: mat4
     */
    public static inline var ViewMatrix:Int = 1;

    /**
     * The projection matrix. Converts View space to Clip/Projection space.
     * Type: mat4
     */
    public static inline var ProjectionMatrix:Int = 2;

    /**
     * The world view matrix. Converts Model space to View space.
     * Type: mat4
     */
    public static inline var WorldViewMatrix:Int = 3;

    /**
     * The normal matrix. The inverse transpose of the worldview matrix.
     * Converts normals from model space to view space.
     * Type: mat3
     */
    public static inline var NormalMatrix:Int = 4;

    /**
     * The world view projection matrix. Converts Model space to Clip/Projection space.
     * Type: mat4
     */
    public static inline var WorldViewProjectionMatrix:Int = 5;

    /**
     * The view projection matrix. Converts Model space to Clip/Projection space.
     * Type: mat4
     */
    public static inline var ViewProjectionMatrix:Int = 6;


    public static inline var WorldMatrixInverse:Int = 7;
    public static inline var ViewMatrixInverse:Int = 8;
    public static inline var ProjectionMatrixInverse:Int = 9;
    public static inline var ViewProjectionMatrixInverse:Int = 10;
    public static inline var WorldViewMatrixInverse:Int = 11;
    public static inline var NormalMatrixInverse:Int = 12;
    public static inline var WorldViewProjectionMatrixInverse:Int = 13;

    /**
     * Camera position in world space.
     * Type: vec3
     */
    public static inline var CameraPosition:Int = 14;

    /**
     * Direction of the camera.
     * Type: vec3
     */
    public static inline var CameraDirection:Int = 15;
}