package de.blogspot.hollowspecter.test;

import com.haxepunk.Entity;
import com.haxepunk.World;
import com.haxepunk.graphics.Image;

class GameWorld extends com.haxepunk.World
{
	public function new()
	{
		super();
	}
	
	public override function begin()
	{
		add(new PlayerObj(30, 50));
	}
	
	public override function update()
	{
		super.update();
	}
}