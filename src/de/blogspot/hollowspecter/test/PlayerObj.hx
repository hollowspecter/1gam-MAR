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
	
	public function new(x:Int, y:Int) 
	{
		super(x, y);
		
		_image = new Image("gfx/block.png");
		graphic = _image;
		
		//centers the origin point
		_image.centerOrigin();
		
		//set rotation to 0
		_rotation = 0;
	}
	
	public override function update()
	{	
		 if (Input.check(Key.LEFT))
		 {
			 _rotation += 5;
		 }
		 
		 if (Input.check(Key.RIGHT))
		 {
			 _rotation -= 5;
		 }
		 
		 if (Input.check(Key.UP))
		 {
			 var posX:Float, posY:Float;
			 var _radians:Float = toRadians(_image.angle);
			 
			moveBy(-Math.sin(_radians), -Math.cos(_radians));
		 }
		 
		 //apply rotation
		 _image.angle = _rotation;
		 
		super.update();
	}
	
	public inline static function toRadians(deg:Float):Float
	{
		return deg * (Math.PI / 180.0);
	}
}