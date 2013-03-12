package de.blogspot.hollowspecter.test;

import com.haxepunk.Entity;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.World;
import com.haxepunk.graphics.Image;

class GameWorld extends com.haxepunk.World
{
	public static var kMaxWidth:Int;
	public static var kMaxHeight:Int;
	public var player:PlayerObj;
	
	public function new()
	{
		super();
		
		player = new PlayerObj(500, 150);
	}
	
	public override function begin()
	{
		loadLevel();
		add(player);
		add(new Human(400, 400));
	}
	
	public override function update()
	{
		super.update();
	}
	
	public function loadLevel()
	{
		var e = new TmxEntity("maps/test.tmx");
		e.loadGraphic("gfx/tileset_scaled.png", ["lava", "street"]);
		kMaxWidth = e.map.fullWidth;
		kMaxHeight = e.map.fullHeight;
		
		add(e);
	}
}