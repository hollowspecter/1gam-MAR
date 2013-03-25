package de.blogspot.hollowspecter.test;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.World;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

class GameWorld extends com.haxepunk.World
{
	public static var kMaxWidth:Int;
	public static var kMaxHeight:Int;
	public var player:PlayerObj;
	public var lifeCounter:Text;
	
	public function new()
	{
		super();
		
		player = new PlayerObj(500, 150, 3);
	}
	
	public override function begin()
	{
		loadLevel();
		add(player);
		add(new Human(400, 400));
		HUD();
	}
	
	public override function update()
	{
		updateHUD();
		
		if (player.getLifes() <= 0)
		{
			HXP.world = new GameOverWorld();
		}
		
		super.update();
	}
	
	/**
	 * Deals with the TMX map
	 */
	public function loadLevel()
	{
		var e = new TmxEntity("maps/test.tmx");
		e.loadGraphic("gfx/tileset_scaled.png", ["lava", "street"]);
		e.loadMask("collision", "lava");
		kMaxWidth = e.map.fullWidth;
		kMaxHeight = e.map.fullHeight;
		
		add(e);
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
}