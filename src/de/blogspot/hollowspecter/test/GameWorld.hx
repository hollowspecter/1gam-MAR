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
	public static var kMaxWidth:Int;
	public static var kMaxHeight:Int;
	public var player:PlayerObj;
	public var lifeCounter:Text;
	
	
	public function new()
	{
		super();
		
		player = new PlayerObj(500, 150, 3);
		humans = new Array<Human>();
		destinations = new Array<Destination>();
		
		//reset the static vars
		Destination.id = 1;
		Destination.destCounter = 0;
		Human.id = 1;
	}
	
	public override function begin()
	{
		loadLevel();
		add(player);
		HUD();
		
		//Input.define("activate", [Key.U]);
		//Input.define("deactivate", [Key.I]);
	}
	
	public override function update()
	{
		updateHUD();
		//debugControls();
		
		if (player.getLifes() <= 0)
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
	public function loadLevel()
	{
		//load map with tiles
		var e = new TmxEntity("maps/test.tmx");
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
			}
		}
	}
	
	/**
	 * HUD stuff that is played in begin()
	 */
	public function HUD()
	{
		lifeCounter = new Text(player.getLifes()+" x lifes");
		lifeCounter.color = 0xFFFFFF;
		lifeCounter.size = 32;
		lifeCounter.x = 10;
		lifeCounter.y = 10;
		addGraphic(lifeCounter);
	}
	
	/**
	 * HUD stuff for the update() function.
	 * updates texts, moves them around accordning to the cam
	 */
	public function updateHUD()
	{
		lifeCounter.text = player.getLifes() + " x lifes";
		lifeCounter.x = HXP.camera.x + 10;
		lifeCounter.y = HXP.camera.y + 10;
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
}