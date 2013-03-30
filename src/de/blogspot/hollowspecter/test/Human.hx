package de.blogspot.hollowspecter.test;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

/**
 * The Class of a Human. Each instance has its own human-id
 * (it counts up, each time the constructer is runned, that
 * way you can keep track of the number of people you have
 * taken around in your taxi).
 * @author Vivien Baguio
 */
class Human extends Entity
{
	public static var id:Int = 1;
	
	//destination chosen from the human before
	private static var destBefore:Int = 0;
	
	private var _id:Int;
	private var _rotation:Float;
	private var _allowedDistance:Int;
	private var _faces:Spritemap;
	private var _bodies:Spritemap;
	private var _saying:Text;
	private var _personCount:Int;
	
	//mission
	private var destinationId:Int;
	
	//modifier
	private var _gotHonkedAt:Bool;
	
	//modes
	//if 0 then it has not entered a car yet
	//if 1 then it is IN the car
	//if 2 it is leaving
	private var mode:Int;
	
	public function new(x:Float, y:Float)
	{
		super(x, y);
		
		//misc
		_type = "human";
		_rotation = 90;
		_allowedDistance = 150;
		mode = 0;
		visible = true;
		collidable = true;
		destinationId = 0;
		
		//modifier
		_gotHonkedAt = false;
		
		//copy id, then increment static id
		_id = id;
		name = "human" + id;
		id++;
		
		//shuffle through all the 16 different people and store in _personCount
		_personCount = Std.random(16);
		
		//dealing with bodies
		_bodies = new Spritemap("gfx/ppl/ppl.png", 9, 6, null, "bodies");
		_bodies.add("body", [_personCount]);
		_bodies.play("body", false);
		_bodies.scale = 3;
		_bodies.centerOrigin();
		graphic = _bodies;
		
		//break down faces spritemap
		//position and scale face image
		_faces = new Spritemap("gfx/ppl/faces.png", 28, 29, null, "faces");
		_faces.add("face", [_personCount]);
		_faces.play("face", false);
		_faces.scale = 3;
		_faces.visible = false;
		HXP.world.addGraphic(_faces, 0);
		//text
		_saying = new Text("");
		_saying.color = 0xFFFFFF;
		_saying.size = 30;
		_saying.visible = false;
		HXP.world.addGraphic(_saying);
		
		setHitbox(9 * 3, 6 * 3, 0, 0);
		Input.define("speak", [Key.T]);
	}
	
	public override function update()
	{
		if (destinationId == 0)
		{
			destinationId = chooseDest();
		}
		
		if (carIsInReach() && _gotHonkedAt && mode == 0)
		{
			//rotate towards car and move!
			rotateTowards(HXP.world.getInstance("player").x, HXP.world.getInstance("player").y);
			_bodies.angle = _rotation;
			moveForward(3, ["car"]);
		}
		
		if (mode == 2)
		{
			moveForward(2, ["lava"]);
		}
		
		//speaking
		//reposition face image
		_faces.x = HXP.camera.x + 20;
		_faces.y = HXP.camera.y + 510;
		_saying.x = HXP.camera.x + 120;
		_saying.y = HXP.camera.y + 510;
		if (Input.check("speak"))
			speak("Luca is doof.\nVivi is cool!");
		else {
			_faces.visible = false;
			_saying.visible = false;
		}
		
		super.update();
	}

	/**
	 * Shuffles randomly through all the destinations and chooses one.
	 * Makes sure that no passeger chooses the same destination as the passenger before
	 * @return returns the id of the destination chosen
	 */
	public function chooseDest():Int
	{
		var n:Int = 0;
		
		do
		{
			n = Std.random(Destination.destCounter);
			n++;
		} while (n == destBefore);
		
		destBefore = n;
		return n;
	}
	
	/**
	 * Basically the Human going into the car. Turns human invisible, uncollidable, and
	 * stores humans id in the playerobj-idadding-var, this var is being added
	 * to the seats then. If addingID is -1, the car is full!
	 * @param	e entity colliding with, here: just the car
	 * @return bool, if collided or not
	 */
	public override function moveCollideX(e:Entity) : Bool
	{
		if (e.type == "car" && PlayerObj.idAdding >= 0 && mode == 0)
		{
			visible = false;
			collidable = false;
			PlayerObj.idAdding = _id;
			mode = 1;
		}
		if (e.type == "lava" && mode == 2)
		{
			HXP.world.remove(this);
		}
		return super.moveCollideX(e);
	}
	
	public override function moveCollideY(e:Entity) : Bool
	{
		moveCollideX(e);
		return super.moveCollideY(e);
	}
	
	
	public function speak(text:String)
	{
		_faces.visible = true;
		_saying.visible = true;
		_saying.text = text;
	}
	
	//check if car is close-by
	public function carIsInReach():Bool
	{
		//is car close enough
		var dx = HXP.world.getInstance("player").x - x;
		var dy = HXP.world.getInstance("player").y - y;
		var distance = Math.sqrt(dx * dx + dy * dy);
		
		if (distance < _allowedDistance)
		{
			if (PlayerObj._honks)
				_gotHonkedAt = true;
			return true;
		}
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
	 
	public function moveForward(velocity:Float, types:Array<String>)
	{
		var _radians:Float = PlayerObj.toRadians(_bodies.angle);
		moveBy( Math.sin(_radians) * velocity, Math.cos(_radians) * velocity, types);
	}
	
	public function normalizeRotation(r:Int):Int
	{
		while (r > 360)
		{
			r -= 360;
		}
		return r;
	}
		
	/**
	 * Makes the human leave the car. Making it visible, placing it close to the car
	 * then turning it to one of the directions and letting him wlak into lava.
	 * when he collides with the lava, he shall be rmoved from the world!
	 * @param	direction just to whatever, doesnt matter anymore
	 */
	public function leaveCar(direction:String)
	{
		visible = true;
		collidable = true;
		mode = 2;
		var e:Entity = HXP.world.getInstance("player");
		this.x = e.x;
		this.y = e.y;
	}
	
	/**
	 * Gives you the ID of the Destination of this Human
	 * @return returns destination id. if its 0, it has not yet chosen a destination (unlikely)
	 */
	public function getDestID():Int
	{
		return destinationId;
	}
}