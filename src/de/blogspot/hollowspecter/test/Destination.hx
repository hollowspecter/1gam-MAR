package de.blogspot.hollowspecter.test;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.masks.Circle;

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
	public static var destCounter:Int = 0;
	private var _id:Int;
	
	//direction of with the passenger should move when leaving the car there
	private var _direction:String;
	
	public function new(x:Int, y:Int, ?direction:String) 
	{
		super(x, y);
		
		//misc
		type = "destination";
		collidable = false;
		visible = false;
		
		//id setting
		_id = id;
		name = "destination"+id;
		id++;
		destCounter++;
		
		//dealing with the direction
		if (direction == "left" || direction == "right" || direction == "up" || direction == "down")
			_direction = direction;
		else
			_direction = "down";
		
		//graphic
		sprite = new Spritemap("gfx/destination.png", 51, 51);
		sprite.add("blink", [0, 1, 2, 3, 2, 1], 10, true);
		sprite.play("blink");
		sprite.centerOrigin();
		graphic = sprite;
		sprite.scale = 3;
		setHitbox(130, 130, 65, 65);
	}
	
	public override function update()
	{
		super.update();
	}
	
	/**
	 * Activate the destination
	 * - turn it visible
	 * - turn it collidable
	 * @param	id_ the id of the destination t activate
	 * @return	the position of the destination, returns null if destinationid is wrong or not existent
	 */
	public static function activate(id_:Int):Array<Float>
	{
		var e:Entity = HXP.world.getInstance("destination" + id_);
		
		if (e == null) 
		{
			return null;
		}
		
		e.visible = true;
		e.collidable = true;
		var x_:Float = e.x;
		var y_:Float = e.y;
		
		return [x_,y_];
	}
	
	/**
	 * Deactivating the destination, making it invisible and uncollidable
	 * @param	id_ The id of the destination to deactivate
	 * @return	the position of the destination. returns NULL if destination id is wrong or not existent
	 */
	public static function deactivate(id_:Int):Array<Float>
	{
		var e:Entity = HXP.world.getInstance("destination" + id_);
		
		if (e == null)
		{
			return null;
		}
		
		e.visible = false;
		e.collidable = false;
		var x_:Float = e.x;
		var y_:Float = e.y;
		
		return [x_, y_];
	}
	
	public function getDirection():String
	{
		return _direction;
	}
	
	public function getID():Int
	{
		return _id;
	}
}