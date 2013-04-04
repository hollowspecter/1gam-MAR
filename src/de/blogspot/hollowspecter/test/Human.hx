package de.blogspot.hollowspecter.test;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Tween.TweenType;
import nme.display.Sprite;

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
	public static var lostClients:Int;
	
	//destination chosen from the human before
	private static var destBefore:Int = 0;
	
	private var _id:Int;
	private var _rotation:Float;
	private var _allowedDistance:Int;
	
	//dealing with text
	private var _faces:Spritemap;
	private var _bodies:Spritemap;
	private var _saying:Text;
	private var _timer:Text;
	private static var _speakQueue:Array<Array<String>>;
	
	private var _personCount:Int;
	
	
	//blood animation
	private var _blood:Spritemap;
	
	//mission
	private var destinationId:Int;
	
	//modifier
	private var _gotHonkedAt:Bool;
	
	//camera position for the human
	public static var camX:Float = 0;
	public static var camY:Float = 0;
	
	//someones talking
	private static var soTalking:Bool = false;
	
	//the time the player has to achieve destination
	private var requiredTime:Int;
	
	private var talked:Bool;
	
	public static var peopleCountTaken:Int;
	public static var peopleSuccess:Int;
	
	//modes
	//if 0 then it has not entered a car yet
	//if 1 then it is IN the car
	//if 2 it is leaving
	//if 3 dead caused by car
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
		
		//blood animation
		_blood = new Spritemap("gfx/blood.png", 14, 16);
		_blood.add("die", [0, 1, 2], 5, false);
		_blood.scale = 3;
		_blood.visible = true;
		_blood.centerOrigin();
		
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
		
		//text for timer
		_timer = new Text("");
		_timer.visible = false;
		_timer.color = 0xFFFFFF;
		_timer.size = 32;
		HXP.world.addGraphic(_timer);
		
		_speakQueue = new Array<Array<String>>();
		
		setHitbox(9 * 3, 6 * 3, 0, 0);
		Input.define("speak", [Key.T]);
	}
	
	public override function update()
	{
		if (destinationId == 0)
		{
			destinationId = chooseDest();
		}
		
		if (carIsInReach() && mode == 0)
		{
			//rotate towards car and move!
			rotateTowards(HXP.world.getInstance("player").x, HXP.world.getInstance("player").y);
			_bodies.angle = _rotation;
			if (_gotHonkedAt)
				moveForward(3, ["car"]);
		}
		
		if (mode == 2)
		{
			moveForward(2, ["lava"]);
		}
		

		
		//update timer when it is visible
		if (_timer.visible)
		{
			var p:Int = requiredTime - TimerManager.getInstance().getStopWatch();
			_timer.text = "Time left for delivery: " + p;
			
			if (p == 0 && !talked) {
				_speakQueue.insert(0, [Speech.tooslow[Std.random(Speech.tooslow.length)], _id + ""]);
				talked = true;
			}
		}
		//speaking
		//reposition face image
		_faces.x = HXP.camera.x + 20;
		_faces.y = HXP.camera.y + 510;
		_saying.x = HXP.camera.x + 120;
		_saying.y = HXP.camera.y + 510;
		_timer.x = HXP.camera.x + 50;
		_timer.y = HXP.camera.y + 40;
		//enabling talking feature
		talking();
		
		//saving the camera position in new vars
		camX = HXP.camera.x;
		camY = HXP.camera.y;
		
		super.update();
	}

	public function activateTimer()
	{
		_timer.visible = true;
	}
	
	/**
	 * Takes the distance from the humans position and the destination
	 * and returns the time the player has to achieve the destination
	 * saves in "requiredTime"
	 * @param	distance
	 */
	public function calcTime(distance:Float)
	{
		requiredTime = Math.round(distance * (14 / 1500) + 3);
	}
	
	/**
	 * Shuffles randomly through all the destinations and chooses one.
	 * Makes sure that no passeger chooses the same destination as the passenger before
	 * ALSO calculates the required Time for the distance!
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
		
		//calc requ time
		var d:Destination = GameWorld.getDestination(n);
		calcTime(distanceFrom(d, false));
		
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
			//add text to the speak queue to prevent multiple texts to appear!
			_speakQueue.insert(0, [Speech.destination[Std.random(Speech.destination.length)],_id+""]);
			
		} else if (e.type == "car" && PlayerObj.idAdding == -1 && mode == 0)
		{
			_gotHonkedAt = false;
		}
		
		if (e.type == "lava" && mode == 2)
		{
			HXP.world.remove(this);
		}
		return super.moveCollideX(e);
	}
	
	/**
	 * Deals with the text queue, fifo, the oldest text is being printed to the screen
	 */
	public function talking()
	{
	if (_speakQueue.length != 0 && !soTalking && _speakQueue[_speakQueue.length-1][1] == _id+"")
		{
			soTalking = true;
			_faces.visible = true;
			_saying.visible = true;
			_saying.text = _speakQueue.pop()[0];
			addTween(new Alarm(2.5, function(o:Dynamic) { stopSpeak(); }, TweenType.OneShot), true);
		}
	}
	
	public override function moveCollideY(e:Entity) : Bool
	{
		moveCollideX(e);
		return super.moveCollideY(e);
	}
	
	public function speak(text:String, dur:Float)
	{
		_faces.visible = true;
		_saying.visible = true;
		soTalking = true;
		_saying.text = text;
		addTween(new Alarm(dur, function(o:Dynamic) { stopSpeak(); }, TweenType.OneShot), true);
	}
	
	public function stopSpeak()
	{
		_faces.visible = false;
		_saying.visible = false;
		soTalking = false;
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
	 * Edit: TYPE is changed here to "evilHuman" so they can get runover!
	 * @param	direction just to whatever, doesnt matter anymore
	 */
	public function leaveCar(direction:String)
	{
		visible = true;
		collidable = false;
		_timer.visible = false;
		peopleCountTaken++;
		
		var dif:Int = requiredTime - TimerManager.getInstance().stopStopWatch();
		//successful:
		if (dif > 0)
		{
			var p:Int = Math.round((18 / 25) * requiredTime + dif);
			TimerManager.getInstance().increaseTime(p);
			_speakQueue.insert(0, [Speech.thankyou[Std.random(Speech.thankyou.length)], _id + ""]);
			peopleSuccess++;
			
		} else {
			_speakQueue.insert(0, [Speech.hate[Std.random(Speech.hate.length)], _id + ""]);
			lostClients++;
		}
		
		addTween(new Alarm(1.5, function(o:Dynamic) { collidable = true; }, TweenType.OneShot), true);
		mode = 2;
		type = "evilHuman";
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
	
	public function die()
	{
		graphic = _blood;
		mode = 3;
		type = "deadHuman";
		_blood.play("die", false);
		addTween(new Alarm(5, function(o:Dynamic) { HXP.world.remove(this); _faces.visible = false; _saying.visible = false; }, TweenType.OneShot), true);
	}
	
	public function getID():Int
	{
		return _id;
	}
}