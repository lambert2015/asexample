package org.angle3d.material.shader;

#if flash
import flash.display3D.Context3DProgramType;
typedef ShaderType = Context3DProgramType;
#else
@:fakeEnum(String) enum ShaderType
{
	FRAGMENT;
	VERTEX;
}
#end
