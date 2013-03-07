package de.blogspot.hollowspecter.test;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
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
	private var _velocity : Float;
	
	public function new(x:Int, y:Int) 
	{
		super(x, y);
		
		_image = new Image("gfx/car.png");
		graphic = _image;
		_image.centerOrigin();
		_image.scale = 3;
		_rotation = -120;
		_velocity = 5;
		
		Input.define("up", [Key.UP, Key.W]);
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
	}
	
	public override function update()
	{	
		 if (Input.check("left"))
		 {
			 _rotation += 5;
		 }
		 
		 if (Input.check("right"))
		 {
			 _rotation -= 5;
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
}