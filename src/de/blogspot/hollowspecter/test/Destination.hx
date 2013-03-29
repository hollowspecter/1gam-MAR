package de.blogspot.hollowspecter.test;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

/**
 * Every destination has its own id
 * @author Vivien Baguio
 */
class Destination extends Entity
{
	//graphic
	private var sprite:Spritemap;
	
	//id setting
	public static var id:Int = 1;
	private var _id:Int;
	
	public function new(x:Int, y:Int) 
	{
		super(x, y);
		
		//id setting
		_id = id;
		id++;
		
		//graphic
		sprite = new Spritemap("gfx/destination.png", 51, 51);
		sprite.add("blink", [0, 1, 2, 3, 2, 1], 10, true);
		sprite.play("blink");
		sprite.centerOrigin();
		graphic = sprite;
		sprite.scale = 3;
		sprite.visible = true;
	}
	
	public override function update()
	{
		super.update();
	}
}