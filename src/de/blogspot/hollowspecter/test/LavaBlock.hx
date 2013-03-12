package de.blogspot.hollowspecter.test;
import com.haxepunk.Entity;

/**
 * ...
 * @author Vivien Baguio
 */
class LavaBlock extends Entity
{

	public function new(x:Float, y:Float) 
	{
		super(x, y);
		graphic = Image.createRect(24, 24);
		collidable = true;
		visible = true;
		type = "lava";
		setHitbox(24, 24, 0, 0);
	}
	
}