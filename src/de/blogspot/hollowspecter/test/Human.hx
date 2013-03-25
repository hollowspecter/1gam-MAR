package de.blogspot.hollowspecter.test;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

/**
 * The Class of a Human. Each instance has its own human-id
 * (it counts up, each time the constructer is runned, that
 * way you can keep track of the number of people you have
 * taken around in your taxi).
 * @author Vivien Baguio
 */
class Human extends Entity
{
	private static var id:Int = 0;
	private var _id:Int;
	private var _image:Image;
	private var _rotation:Float;
	private var _allowedDistance:Int;
	
	public function new(x:Float, y:Float)
	{
		super(x, y);
		
		//misc
		_type = "human";
		_rotation = 90;
		_allowedDistance = 150;
		
		//copy id, then increment static id
		_id = id;
		id++;
		
		//dealing with the graphic
		_image = new Image("gfx/ppl/1.png");
		_image.scale = 3;
		_image.centerOrigin();
		graphic = _image;
	}
	
	public override function update()
	{
		if (shouldMove())
		{
		//rotate towards car and move!
		rotateTowards(HXP.world.getInstance("player").x, HXP.world.getInstance("player").y);
		_image.angle = _rotation;
		moveForward(3);
		}
		
		super.update();
	}
	
	//check if car is close-by and in eye-sight
	public function shouldMove():Bool
	{
		//is car close enough
		var dx = HXP.world.getInstance("player").x - x;
		var dy = HXP.world.getInstance("player").y - y;
		var distance = Math.sqrt(dx * dx + dy * dy);
		
		if (distance < _allowedDistance)
			return true;
		else
			return false;
	}
	
	//rotates human towards the target
	public function rotateTowards(x:Float, y:Float)
	{
		var _dx = x - this.x;
		var _dy = y - this.y;
		_rotation = -Math.atan2(_dy, _dx);
		_rotation = PlayerObj.toDegrees(_rotation) + 90;
	}
	 
	public function moveForward(velocity:Float)
	{
		var _radians:Float = PlayerObj.toRadians(_image.angle);
		moveBy( Math.sin(_radians) * velocity, Math.cos(_radians) * velocity);
	}
	
	public function normalizeRotation(r:Int):Int
	{
		while (r > 360)
		{
			r -= 360;
		}
		return r;
	}
}