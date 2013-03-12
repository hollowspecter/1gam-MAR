package de.blogspot.hollowspecter.test;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

/**
 * ...
 * @author Vivien Baguio
 */

class PlayerObj extends Entity
{
	private var _image : Image;
	private var _rotation : Float;
	private var _rotationSpd : Int;
	private var _maxRotationSpd : Int;
	private var _velocity : Float;
	private var _maxVelocity : Float;
	private var _acceleration : Float;
	private var _breaks : Float;
	
	private var _backGear : Bool;
	
	public function new(x:Int, y:Int, ?_maxRotationSpd:Int, ?_maxVelocity:Float, ?_acceleration:Float, ?_breaks:Float)
	{
		super(x, y);
		_image = new Image("gfx/car.png");
		graphic = _image;
		_image.originX = _image.width / 2;
		_image.originY = (_image.height / 4) * 3;
		_image.scale = 3;
		_rotation = 0;
		_velocity = 0;
		_rotationSpd = 0;
		
		this._maxRotationSpd = (_maxRotationSpd == null) ? 8 : _maxRotationSpd;
		this._maxVelocity = (_maxVelocity == null) ? 15 : _maxVelocity;
		this._acceleration = (_acceleration == null) ? 1.5 : _acceleration;
		this._breaks = (_breaks == null) ? 1.0 : _breaks;
		
		Input.define("up", [Key.UP, Key.W]);
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("down", [Key.DOWN, Key.S]);
		
		//Hitbox handling
		//setHitbox(_image.width*3, _image.height*3, _image.originX, _image.originY);
	}
	
	public override function update()
	{	
		checkBackGear();
		regulateRotationSpd();
		
		if (Input.check("left"))                                    
		{
			if (_velocity != 0)
				_rotation += _rotationSpd;
		}
		
		if (Input.check("right"))
		{
			if (_velocity != 0) {
				_rotation -= _rotationSpd;
			}
		}
		
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
		_image.angle = _rotation;
		
		super.update();
	}
	
	public function velocity()
	{
		var _radians:Float = toRadians(_image.angle);
	 	moveBy( -Math.sin(_radians) * _velocity, -Math.cos(_radians) * _velocity);
	}
	
	public inline static function toRadians(deg:Float):Float
	{
		return deg * (Math.PI / 180.0);
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
	
	public function checkBackGear()
	{
		if (_velocity >= 0)
			_backGear = false;
		else
			_backGear = true;
	}
}