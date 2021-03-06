package org.angle3d.input.controls;

/**
 * <code>AnalogListener</code> is used to receive events of inputs
 * in analog format. 
 *
 * @author Kirill Vainer
 */
interface AnalogListener implements InputListener
{
    /**
     * Called to notify the implementation that an analog event has occurred.
     *
     * The results of KeyTrigger and MouseButtonTrigger events will have tpf
     *  == value.
     *
     * @param name The name of the mapping that was invoked
     * @param value Value of the axis, from 0 to 1.
     * @param tpf The time per frame value.
     */
    function onAnalog(name:String,value:Float,tpf:Float):Void;
}