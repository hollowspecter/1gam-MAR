package de.blogspot.hollowspecter.test;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.Sfx;
import com.haxepunk.tweens.sound.SfxFader;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

/**
 * ...
 * @author Vivien Baguio
 */

class PlayerObj extends Entity
{
	//properties
	private var _rotation : Float;
	private var _rotationSpd : Int;
	private var _maxRotationSpd : Int;
	private var _velocity : Float;
	private var _maxVelocity : Float;
	private var _acceleration : Float;
	private var _breaks : Float;
	private var _backGear : Bool;
	
	//misc
	private var sprite:Spritemap;
	private var _lifes : Int;
	private var _startPos : Array<Float>;
	private var seats : Seats;
	private var disablingInput : Bool;
	
	//modifier
	public static var _honks : Bool;
	
	//sounds
	private var _sfxHonk : Sfx;
	
	//to add Human to Seat
	public static var idAdding : Int;
	
	//the compass
	private var _compass : Compass;
	
	//cam
	public static var camX : Float;
	public static var camY : Float;
	
	public function new(x:Int, y:Int, _lifes:Int, ?_maxRotationSpd:Int, ?_maxVelocity:Float, ?_acceleration:Float, ?_breaks:Float)
	{
		super(x, y);
		
		//take care of sprite and animation
		sprite = new Spritemap("gfx/car_animation.png", 12, 17);
		setHitbox(12 * 3, 17 * 3, 18, 38);
		sprite.add("idle", [0]);
		sprite.add("right", [1]);
		sprite.add("left", [2]);
		graphic = sprite;
		sprite.originX = sprite.width / 2;
		sprite.originY = (sprite.height / 4) * 3;
		sprite.scale = 3;
		sprite.play("idle", false);
		_rotation = 0;
		_velocity = 0;
		_rotationSpd = 0;
		this._lifes = _lifes;
		
		//set properties
		this._maxRotationSpd = (_maxRotationSpd == null) ? 8 : _maxRotationSpd;
		this._maxVelocity = (_maxVelocity == null) ? 15 : _maxVelocity;
		this._acceleration = (_acceleration == null) ? 1.5 : _acceleration;
		this._breaks = (_breaks == null) ? 1.0 : _breaks;
		
		//define input handling
		Input.define("up", [Key.UP, Key.W]);
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("honk", [Key.SPACE]);
		
		//modifiers
		collidable = true;
		visible = true;
		type = "car";
		name = "player";
		_honks = false;
		
		//misc
		_startPos = [x, y];
		seats = new Seats(3);
		idAdding = 0;
		disablingInput = false;
		
		//compass
		_compass = new Compass(200, 200);
		
		//sfx
		_sfxHonk = new Sfx("sfx/honk.wav", function() { _honks = false; } );
	}
	
	public override function update()
	{	
		
		checkBackGear();
		regulateRotationSpd();
		movement();
		
		//If human wants to be added to the car, the idAdding changes
		if (idAdding > 0) {
			seats.add(idAdding);
			if (seats.getOccupied())
			{
				idAdding = -1;
			} else
				idAdding = 0;
		}
		
		//honking. only "works" when seats are not full
		if (Input.check("honk"))
		{
			honk();
			if (!seats.getOccupied())
				_honks = true;
		}
		
		//if 1 seat is taken, activate that humans destination
		//also activate compasses arrow
		if (seats.getCurrentID() != 0 && !disablingInput)
		{
			var d:Destination = getCurrentDestination();
			Destination.activate(d.getID());
			var rot:Float =  getRotationTowards(d.x, d.y);
			_compass.updateRotation(rot);
			_compass.activate();
		}
		
		//when you hit destination, the input will be disabled, u get slower. then kick out the passenger
		if (disablingInput && _velocity < 4)
		{
			var h:Human = GameWorld.getHuman(seats.remove());
			h.leaveCar("left");
			disablingInput = false;
		} if (disablingInput)
		{
			if (_velocity > 0) {
				_velocity -= 1;
			}
		}
		
		velocity();
		
		//apply rotation
		sprite.angle = _rotation;
		
		//set camera
		HXP.camera.x = x - HXP.halfWidth;
		HXP.camera.y = y - HXP.halfHeight;
		//HXP.camera.x = (HXP.camera.x + (x - HXP.halfWidth)) * 0.5;
		//HXP.camera.y = (HXP.camera.y + (y - HXP.halfHeight)) * 0.5;
		normalizeCamera();
		
		super.update();
	}
	
	/**
	 * reduces life.
	 * sets back velocity, rotation, and position.
	 */
	public function death()
	{
		setLifes(getLifes() - 1);
		_velocity = 0;
		_rotation = 0;
		x = _startPos[0];
		y = _startPos[1];
	}
	
	/**
	 * Plays the honking sound. Sets _honks to true.
	 * Attracts people into taxi.
	 */
	public function honk()
	{
		if (!_sfxHonk.playing)
			_sfxHonk.play();
	}
	
	/**
	 * Handles all the movement of the car
	 */
	public function movement()
	{
		if (Input.check("left"))                                    
		{
			sprite.play("left", false);
			if (_velocity != 0)
				_rotation += _rotationSpd;
		}
		
		if (Input.check("right"))
		{
			sprite.play("right", false);
			if (_velocity != 0) {
				_rotation -= _rotationSpd;
			}
		} else if (!Input.check("left")) sprite.play("idle", false);
		
		//Starts car up. car sound starts playing then
		if (!disablingInput)
		{
			if (Input.check("up"))
			{
				if (_velocity < _maxVelocity)
					_velocity += 0.5;
			} else if (Input.check("down"))
			{			
				if (_velocity > -5) {
					_velocity -= 0.5;
					}
			}
		}
		
		
		//when car doesnt accelerate: car slows down slowly
		if (_velocity != 0 && !Input.check("up"))
		{
			if (_velocity < 0) {
				_velocity += 0.2;
				if (_velocity > 0)
					_velocity = 0;
			} else if (_velocity > 0) {
				_velocity -= 0.2;
				if (_velocity < 0)
					_velocity = 0;
			}
		}
	}
	
	public override function moveCollideX(e:Entity) : Bool
	{
		if (e.type == "lava")
		{
			death();
		}
		if (e.type == "destination")
		{
			disablingInput = true;
			var h:Human = GameWorld.getHuman(seats.getCurrentID());
			var dID:Int = h.getDestID();
			Destination.deactivate(dID);
			_compass.deactivate();
			return false;
		}
		return super.moveCollideX(e);
	}
	
	public override function moveCollideY(e:Entity) : Bool
	{
		moveCollideX(e);
		return super.moveCollideY(e);
	}
	
	public function velocity()
	{
		var _radians:Float = toRadians(sprite.angle);
	 	moveBy( -Math.sin(_radians) * _velocity, -Math.cos(_radians) * _velocity, ["lava","destination"]);
	}
	
	public inline static function toRadians(deg:Float):Float
	{
		return deg * (Math.PI / 180.0);
	}
	
	public inline static function toDegrees(rad:Float):Float
	{
		return rad * (180.0 / Math.PI);
	}
	
	public function regulateRotationSpd()
	{
		if (!_backGear)
		{
			if (_velocity < _maxRotationSpd)
			{
			_rotationSpd = Math.round(_velocity);
			} else {
			_rotationSpd = _maxRotationSpd;
			}
		} else
			_rotationSpd = 5;
	}
	
	/**
	 * Checks if car is driving backwards or not.
	 * toggles _backgear
	 */
	public function checkBackGear()
	{
		if (_velocity >= 0)
			_backGear = false;
		else
			_backGear = true;
	}
	
	/**
	 * Normalizes camera when it is showing stuff out of bounds
	 * @return when true: camera was being normalized. when false: nothing happened
	 */
	
	public function normalizeCamera():Bool
	{
		var _normalized:Bool = false;
		
		//too far to the right
		if ((GameWorld.kMaxWidth - this.x) < HXP.halfWidth) {
			HXP.camera.x = GameWorld.kMaxWidth - HXP.width;
			_normalized = true;
		}
		
		//too close to the left
		if (this.x < HXP.halfWidth) {
			HXP.camera.x = 0;
			_normalized = true;
		}
		
		//too close to the top
		if (this.y < HXP.halfHeight) {
			HXP.camera.y = 0;
			_normalized = true;
		}
		
		//too far to the bottom
		if ((GameWorld.kMaxHeight - this.y) < HXP.halfHeight) {
			HXP.camera.y = GameWorld.kMaxHeight - HXP.height;
			_normalized = true;
		}
		
		return _normalized;
	}
	
	/**
	 * Returns distance to the active destination
	 * @return returns 0 when no destination active
	 */
	public function getDistanceToDestination():Float
	{
		if (seats.getCurrentID() != 0)
		{
			return distanceFrom(getCurrentDestination());
		}
		else
			return 0;
	}
	
	/**
	 * 
	 * @return Returns the destination of the current passenger
	 */
	public function getCurrentDestination():Destination
	{
		var h:Human = GameWorld.getHuman(seats.getCurrentID());
		var dID:Int = h.getDestID();
		return GameWorld.getDestination(dID);
	}
	
	/**
	* Put in the coordinates of an object. Function gives you the rotation towards this object
	* @param	x x-coordinate of the object
	* @param	y y-coordinate of this object
	* @return the rotation towards this object in float
	*/
	public function getRotationTowards(x:Float, y:Float):Float
	{
		var _dx = x - this.x;
		var _dy = y - this.y;
		var rot = -Math.atan2(_dy, _dx);
		rot = PlayerObj.toDegrees(rot) -90;
		return rot;
	}
	
	//lifes getter and setter
	public function getLifes():Int
	{
		return _lifes;
	}
	
	public function setLifes(lifes:Int)
	{
		_lifes = lifes;
	}
	
	public static function getHonks():Bool
	{
		return _honks;
	}
	
	public function getCompass():Compass
	{
		return _compass;
	}
}