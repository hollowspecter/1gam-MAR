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
	private var sprite:Spritemap;
	private var _rotation : Float;
	private var _rotationSpd : Int;
	private var _maxRotationSpd : Int;
	private var _velocity : Float;
	private var _maxVelocity : Float;
	private var _acceleration : Float;
	private var _breaks : Float;
	private var _backGear : Bool;
	private var _lifes : Int;
	private var _startPos : Array<Float>;
	
	public function new(x:Int, y:Int, _lifes:Int, ?_maxRotationSpd:Int, ?_maxVelocity:Float, ?_acceleration:Float, ?_breaks:Float)
	{
		super(x, y);
		//create new spritemap
		sprite = new Spritemap("gfx/car_animation.png", 12, 17);
		//define animations
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
		
		this._maxRotationSpd = (_maxRotationSpd == null) ? 8 : _maxRotationSpd;
		this._maxVelocity = (_maxVelocity == null) ? 15 : _maxVelocity;
		this._acceleration = (_acceleration == null) ? 1.5 : _acceleration;
		this._breaks = (_breaks == null) ? 1.0 : _breaks;
		
		Input.define("up", [Key.UP, Key.W]);
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("down", [Key.DOWN, Key.S]);
		
		collidable = true;
		visible = true;
		type = "car";
		name = "player";
		
		setHitbox();
		_startPos = [x, y];
	}
	
	public override function update()
	{	
		checkBackGear();
		regulateRotationSpd();
		
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
		
		velocity();
		
		//apply rotation
		sprite.angle = _rotation;
		
		//set camera
		HXP.camera.x = (HXP.camera.x + (x - HXP.halfWidth)) * 0.5;
		HXP.camera.y = (HXP.camera.y + (y - HXP.halfHeight)) * 0.5;
		normalizeCamera();
		
		super.update();
	}
	
	public function death()
	{
		setLifes(getLifes() - 1);
		x = _startPos[0];
		y = _startPos[1];
	}
	
	public override function moveCollideX(e:Entity) : Bool
	{
		if (e.type == "lava")
		{
			death();
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
	 	moveBy( -Math.sin(_radians) * _velocity, -Math.cos(_radians) * _velocity);
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
	
	//lifes getter and setter
	public function getLifes():Int
	{
		return _lifes;
	}
	
	public function setLifes(lifes:Int)
	{
		_lifes = lifes;
	}
}