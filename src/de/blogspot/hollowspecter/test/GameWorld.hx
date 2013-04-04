package de.blogspot.hollowspecter.test;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxObjectGroup;
import com.haxepunk.World;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class GameWorld extends com.haxepunk.World
{
	public static var humans:Array<Human>;
	public static var destinations:Array<Destination>;
	public static var player_:PlayerObj;
	public static var kMaxWidth:Int;
	public static var kMaxHeight:Int;
	public var player:PlayerObj;
	public var timer:Text;
	
	public function new()
	{
		super();
		humans = new Array<Human>();
		destinations = new Array<Destination>();
		
		//reset the static vars
		Destination.id = 1;
		Destination.destCounter = 0;
		Human.id = 1;
		Human.lostClients = 0;
		TimerManager.getInstance().reset();
		Human.peopleCountTaken = 0;
		Human.peopleSuccess = 0;
	}
	
	public override function begin()
	{
		var p:Array<Float> = loadLevel();
		player = new PlayerObj(p[0], p[1]);
		player_ = player;
		add(player);
		HUD();
		add(player.getCompass());
		
		//Input.define("activate", [Key.U]);
		//Input.define("deactivate", [Key.I]);
	}
	
	public override function update()
	{
		updateHUD();
		//debugControls();
		
		if (TimerManager.getInstance().getTime() < 0 || Human.peopleCountTaken == Human.id)
		{
			HXP.world = new GameOverWorld();
		}
		
		super.update();
	}
	
	/**
	 * Testinput stuff for debug
	 */
	public function debugControls()
	{
		if (Input.check("activate"))
		{
			Destination.activate(1);
		}
		if (Input.check("deactivate"))
		{
			Destination.deactivate(1);
		}
	}
	
	/**
	 * Deals with the TMX map
	 */
	public function loadLevel():Array<Float>
	{
		var p:Array<Float> = new Array<Float>();
		//load map with tiles
		var e = new TmxEntity("maps/Level1.tmx");
		e.loadGraphic("gfx/tileset_scaled.png", ["lava", "street"]);
		e.loadMask("collision", "lava");
		add(e);
		
		//set maxheight and maxwidth of the map
		kMaxWidth = e.map.fullWidth;
		kMaxHeight = e.map.fullHeight;
		
		//load all the objects, spawnpoints, destinations into the map
		var objects : TmxObjectGroup = e.map.getObjectGroup("points");
		if (objects != null)
		{
			for (obj in objects.objects)
			{
				if (obj.type == "destination")
				{
					var dir:String = obj.custom.resolve("direction");
					var d:Destination = new Destination(obj.x, obj.y, dir);
					add(d);
					destinations.push(d);
				}
				
				if (obj.type == "spawn")
				{
					var h:Human = new Human(obj.x, obj.y);
					add(h);
					humans.push(h);
				}
				
				if (obj.type == "player")
				{
					p = [obj.x, obj.y];
				}
			}
		}
		return p;
	}
	
	/**
	 * HUD stuff that is played in begin()
	 */
	public function HUD()
	{	
		//timer
		timer = new Text(TimerManager.getInstance().getTime()+"");
		timer.color = 0xFFFFFF;
		timer.size = 32;
		timer.x = 10;
		timer.y = 40;
		addGraphic(timer);
	}
	
	/**
	 * HUD stuff for the update() function.
	 * updates texts, moves them around accordning to the cam
	 */
	public function updateHUD()
	{
		/*lifeCounter.text = player.getLifes() + " x lifes";
		lifeCounter.x = HXP.world.camera.x + 10;
		lifeCounter.y = HXP.world.camera.y + 10;*/
		
		var t:Int = TimerManager.getInstance().getTime();
		
		timer.text = t+"";
		timer.x = HXP.world.camera.x + 10;
		timer.y = HXP.world.camera.y + 40;	
		
		if (t < 10)
		{
			timer.color = 0xff0000;
		}
	}
	
	/**
	 * Fetches you a fresh human
	 * @param	id The id of the human to fetch.
	 * @return	returns the HUMAAAN
	 */
	public static function getHuman(id:Int):Human
	{
		return humans[id - 1];
	}
	
	/**
	 * Fetches the desired destination!
	 * @param	id The id of the destination to fetch.
	 * @return	returns the destinationa
	 */
	public static function getDestination(id:Int):Destination
	{
		return destinations[id - 1];
	}
	
	public static function getPlayer():PlayerObj
	{
		return player_;
	}
}