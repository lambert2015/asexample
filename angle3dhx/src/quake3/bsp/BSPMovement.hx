package quake3.bsp;
import flash.geom.Vector3D;
import flash.Vector;
class BSPMovement 
{
	// Much of this file is a simplified/dumbed-down version of the Q3 player movement code
	// found in bg_pmove.c and bg_slidemove.c

	// Some movement constants ripped from the Q3 Source code
	private static inline var Q3_StopSpeed:Float = 100.0;

	private static inline var Q3_JumpVelocity:Float = 50;

	private static inline var Q3_Accelerate:Float = 10.0;
	private static inline var Q3_AirAccelerate:Float = 0.1;
	private static inline var Q3_FlyAccelerate:Float = 8.0;

	private static inline var Q3_Friction:Float = 6.0;
	private static inline var Q3_FlightFriction:Float = 3.0;

	private static inline var Q3_Overclip:Float = 0.501;
	private static inline var Q3_StepSize:Float = 18;

	private static inline var Q3_Gravity:Float = 20.0;

	private static inline var Q3_PlayerRadius:Float = 10.0;
	private static inline var Q3_Scale:Float = 50;
	
	private var _bspCollision:BSPCollision;
	
	private var _groundTrace:TraceResult;
	private var _onGround:Bool;
	private var _frameTime:Float;
	
	private var _velocity:Vector3D;
	private var _position:Vector3D;
	
	public var velocity(getVelocity,setVelocity):Vector3D;
	public var position(getPosition,setPosition):Vector3D;
	
	public function new(bsp:BSP) 
	{
		this._bspCollision = new BSPCollision(bsp);
		
		_velocity = new Vector3D();
		_position = new Vector3D();
		
		_onGround = false;
		_groundTrace = null;
	}
	
	public inline function getVelocity():Vector3D
	{
		return _velocity;
	}
	
	public inline function setVelocity(value:Vector3D):Vector3D
	{
		_velocity.copyFrom(value);
		return _velocity;
	}
	
	public inline function getPosition():Vector3D
	{
		return _position;
	}
	
	public inline function setPosition(value:Vector3D):Vector3D
	{
		_position.copyFrom(value);
		return _position;
	}

	public function applyFriction():Void
	{
		if(!_onGround)
    	{
    	    return;
    	}

    	var speed:Float = _velocity.length;

    	var drop:Float = 0;

    	var control:Float = speed < Q3_StopSpeed ? Q3_StopSpeed : speed;
    	drop += control * Q3_Friction * _frameTime;

    	var newSpeed:Float = speed - drop;
    	if (newSpeed < 0)
    	{
    	    newSpeed = 0;
    	}
    	if(speed != 0)
    	{
        	newSpeed /= speed;
			_velocity.scaleBy(newSpeed);
    	}
    	else
    	{
    	    _velocity.setTo(0, 0, 0);
    	}
	}
	
	public function groundCheck():Void
	{
		var checkPoint:Vector3D = _position.clone();
		checkPoint.z = checkPoint.z - Q3_PlayerRadius - 0.25;

    	_groundTrace = _bspCollision.trace(_position, checkPoint, Q3_PlayerRadius);

    	if(_groundTrace.fraction == 1.0)
    	{
        	// falling
        	_onGround = false;
        	return;
    	}

    	if ( _velocity.z > 0 && _velocity.dotProduct(_groundTrace.plane.normal) > 10 )
    	{
        	// jumping
        	_onGround = false;
        	return;
    	}

    	if(_groundTrace.plane.normal.z < 0.7)
    	{
        	// steep slope
        	_onGround = false;
        	return;
    	}

    	_onGround = true;
	}
	
	public function clipVelocity(velIn:Vector3D, normal:Vector3D):Vector3D
	{
		var backoff:Float = velIn.dotProduct(normal);

    	if ( backoff < 0 )
    	{
        	backoff *= Q3_Overclip;
    	}
    	else
    	{
        	backoff /= Q3_Overclip;
    	}

    	var change:Vector3D = normal.clone();
		change.scaleBy(backoff);

		return velIn.subtract(change);
	}
	
	public function accelerate(dir:Vector3D, speed:Float, accel:Float):Void
	{
    	var currentSpeed:Float = _velocity.dotProduct(dir);
		
   	    var addSpeed = speed - currentSpeed;
    	if (addSpeed <= 0)
    	{
    	    return;
    	}

    	var accelSpeed = accel * _frameTime * speed;
    	if (accelSpeed > addSpeed)
    	{
    	    accelSpeed = addSpeed;
    	}

    	var accelDir = dir.clone();
		accelDir.scaleBy(accelSpeed);
		_velocity.incrementBy(accelDir);
	}
	
	public function jump():Bool
	{
    	if(!_onGround)
    	{
    	    return false;
    	}

    	_onGround = false;
		
    	_velocity.z = Q3_JumpVelocity;

    	//Make sure that the player isn't stuck in the ground
    	var groundDist = _position.dotProduct(_groundTrace.plane.normal) - _groundTrace.plane.d - Q3_PlayerRadius;
		
		var n:Vector3D = _groundTrace.plane.normal;
		_position.x += n.x * (groundDist + 5);
		_position.y += n.y * (groundDist + 5);
		_position.z += n.z * (groundDist + 5);
    	
    	return true;
	}
	
	public function move(dir:Vector3D, frameTime:Float):Vector3D
	{
    	_frameTime = frameTime * 0.0075;

    	groundCheck();
		
		var d:Vector3D = dir.clone();

    	d.normalize();

    	if(_onGround)
    	{
    	    walkMove(d);
    	}
    	else
    	{
    	    airMove(d);
    	}

    	return _position;
	}
	
	public function airMove(dir:Vector3D):Void
	{
    	var speed:Float = dir.length * Q3_Scale;

    	accelerate(dir, speed, Q3_AirAccelerate);

    	stepSlideMove( true );
	}
	
	public function walkMove(dir:Vector3D):Void
	{
    	applyFriction();

    	var speed:Float = dir.length * Q3_Scale;

    	accelerate(dir, speed, Q3_Accelerate);

    	_velocity = clipVelocity(_velocity, _groundTrace.plane.normal);

    	if(_velocity.x == 0  && _velocity.y == 0)
    	{
    	    return;
    	}

    	stepSlideMove( false );
	}
	
	public function slideMove(gravity:Bool):Bool
	{
    	var numbumps:Int = 4;
    	var planes:Array<Vector3D> = new Array<Vector3D>();
    	var endVelocity:Vector3D = new Vector3D();

    	if ( gravity)
    	{
			endVelocity.copyFrom(_velocity);

        	endVelocity.z -= Q3_Gravity * _frameTime;
			
        	_velocity.z = ( _velocity.z + endVelocity.z ) * 0.5;

        	if ( _groundTrace != null && _groundTrace.plane != null )
        	{
        	    // slide along the ground plane
        	    _velocity = clipVelocity(_velocity, _groundTrace.plane.normal);
        	}
    	}

    	// never turn against the ground plane
    	if ( _groundTrace != null && _groundTrace.plane != null )
    	{
    	    planes.push(_groundTrace.plane.normal.clone());
    	}

    	// never turn against original velocity
		var ov:Vector3D = _velocity.clone();
		ov.normalize();
    	planes.push(ov);

    	var time_left:Float = _frameTime;
    	var end:Vector3D = new Vector3D();
		var bumpcount:Int = 0;
		while(bumpcount < numbumps)
    	{
        	// calculate position we are trying to move to
			end.x = _position.x + _velocity.x * time_left;
			end.y = _position.y + _velocity.y * time_left;
			end.z = _position.z + _velocity.z * time_left;

        	// see if we can make it there
        	var traceResult:TraceResult = _bspCollision.trace(_position, end, Q3_PlayerRadius);

        	if (traceResult.allSolid)
        	{
        	    // entity is completely trapped in another solid
        	    _velocity.z = 0;	// don't build up falling damage, but allow sideways acceleration
        	    return true;
        	}

        	if (traceResult.fraction > 0)
        	{
           		// actually covered some distance
				_position.copyFrom(traceResult.endPos);
        	}

        	if (traceResult.fraction == 1)
        	{
        	    break;		// moved the entire distance
        	}

        	time_left -= time_left * traceResult.fraction;

        	planes.push(traceResult.plane.normal.clone());

        	//
        	// modify velocity so it parallels all of the clip planes
        	//

        	// find a plane that it enters
        	for(i in 0...planes.length)
        	{
            	var into:Float = _velocity.dotProduct(planes[i]);
            	if ( into >= 0.1 )
            	{
					// move doesn't interact with the plane
                	continue;
            	} 

            	// slide along the plane
            	var _clipVelocity:Vector3D = clipVelocity(_velocity, planes[i]);
            	var endClipVelocity:Vector3D = clipVelocity(endVelocity, planes[i]);

            	// see if there is a second plane that the new move enters
            	for (j in 0...planes.length)
            	{
                	if ( j == i )
                	{
                	    continue;
                	}
                	if (_clipVelocity.dotProduct(planes[j]) >= 0.1 )
                	{
						// move doesn't interact with the plane
                	    continue;
                	} 

                	// try clipping the move to the plane
                	_clipVelocity = clipVelocity( _clipVelocity, planes[j] );
                	endClipVelocity = clipVelocity( endClipVelocity, planes[j] );

                	// see if it goes back into the first clip plane
                	if ( _clipVelocity.dotProduct(planes[i]) >= 0 )
                	{
                	    continue;
                	}

                	// slide the original velocity along the crease
					var dir:Vector3D = planes[i].crossProduct(planes[j]);
					dir.normalize();
                	var d:Float = dir.dotProduct(_velocity);
					
					_clipVelocity.x = dir.x * d;
					_clipVelocity.y = dir.y * d;
					_clipVelocity.z = dir.z * d;
					
					dir = planes[i].crossProduct(planes[j]);
					dir.normalize();
					d = dir.dotProduct(endVelocity);

					endClipVelocity.x = dir.x * d;
					endClipVelocity.y = dir.y * d;
					endClipVelocity.z = dir.z * d;

                	// see if there is a third plane the the new move enters
                	for(k in 0...planes.length)
                	{
                    	if ( k == i || k == j )
                    	{
                    	    continue;
                    	}
                    	if ( _clipVelocity.dotProduct(planes[k]) >= 0.1 )
                    	{
							// move doesn't interact with the plane
                    	    continue;
                    	} 

                    	// stop dead at a tripple plane interaction
                    	_velocity.setTo(0, 0, 0);
                    	return true;
                	}
            	}

            	// if we have fixed all interactions, try another move
				_velocity.copyFrom(_clipVelocity);
				endVelocity.copyFrom(endClipVelocity);
            	break;
        	}
			
			bumpcount++;
    	}

    	if ( gravity)
    	{
    	   _velocity.copyFrom(endVelocity);
    	}

    	return ( bumpcount != 0 );
	}
	
	public function stepSlideMove(gravity:Bool):Void
	{
    	var start_o:Vector3D = _position.clone();
    	var start_v:Vector3D = _velocity.clone();

    	if ( slideMove( gravity ) == false )
    	{
			// we got exactly where we wanted to go first try
    	    return;
    	} 

    	var down:Vector3D = start_o.clone();
    	down.z -= Q3_StepSize;
		
    	var traceResult:TraceResult = _bspCollision.trace(start_o, down, Q3_PlayerRadius);

    	var up:Vector3D = new Vector3D(0, 0, 1);

    	// never step up when you still have up velocity
    	if ( _velocity.z > 0 && 
		(traceResult.fraction == 1.0 || 
		 traceResult.plane.normal.dotProduct(up) < 0.7))
    	{
    	    return;
    	}

    	var down_o:Vector3D = _position.clone();
    	var down_v:Vector3D = _velocity.clone();

		up.copyFrom(start_o);
    	up.z += Q3_StepSize;

    	// test the player position if they were a stepheight higher
    	traceResult = _bspCollision.trace(start_o, up, Q3_PlayerRadius);
    	if ( traceResult.allSolid )
    	{
			// can't step up
    	    return;
    	} 

    	var stepSize:Float = traceResult.endPos.z - start_o.z;
    	// try slidemove from this position
		position.copyFrom(traceResult.endPos);
		_velocity.copyFrom(start_v);

    	slideMove( gravity );

    	// push down the final amount
		down.copyFrom(_position);
    	down.z -= stepSize;
		
    	traceResult = _bspCollision.trace(_position, down, Q3_PlayerRadius);
		
    	if ( !traceResult.allSolid )
    	{
			_position.copyFrom(traceResult.endPos);
    	}
		
    	if ( traceResult.fraction < 1.0 )
    	{
    	    _velocity = clipVelocity(_velocity, traceResult.plane.normal );
    	}
	}
}