package de.blogspot.hollowspecter.test;

import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.HXP;
import com.haxepunk.World;
import com.haxepunk.graphics.Text;


/**
 * ...
 * @author Vivien Baguio
 */
class MenuWorld extends World
{
	var title_:Text;
	var title2_:Text;
	var rainbow_:Int = 0;

	public function new() 
	{
		super();
		Input.define("start", [Key.ENTER, Key.SPACE]);
	}
	
	public override function begin()
	{
		title_ = new Text("Crazy");
		title_.color = 0xFF0000;
		title_.size = 300;
		title_.centerOrigin();
		title_.y = HXP.halfHeight - 180;
		title_.x = HXP.halfWidth;
		title_.visible = true;
		addGraphic(title_);
		
		title2_ = new Text("Lava Taxi Game Thing");
		title2_.color = 0xFF0000;
		title2_.size = 65;
		title2_.centerOrigin();
		title2_.y = HXP.halfHeight - 55;
		title2_.x = HXP.halfWidth - 75;
		title2_.visible = true;
		addGraphic(title2_);
		
		var pressEnter = new Text("Press Enter to \nstart the crazyness!");
		pressEnter.size = 50;
		pressEnter.centerOrigin();
		pressEnter.x = HXP.halfWidth;
		pressEnter.y = HXP.halfHeight + 150;
		addGraphic(pressEnter);
	}
	
	public override function update()
	{
		if (Input.check("start"))
		{
			HXP.world = new GameWorld();
		}
		
		title_.color = changeColor(title_.color);
		title2_.color = title_.color;
		
		super.update();
	}
	
	public function changeColor(color:Int):Int
	{
		if (rainbow_ == 0)
		{
			color += 0x000015;
			if (color >= 0xFF00FF) {
				color = 0xFF00FF;
				rainbow_++;
			}
		} else if (rainbow_ == 1)
		{
			color -= 0x150000;
			if (color <= 0x0000FF) {
				color = 0x0000FF;
				rainbow_++;
			}
		} else if (rainbow_ == 2)
		{
			color += 0x001500;
			if (color >= 0x00FFFF) {
				color = 0x00FFFF;
				rainbow_++;
			}
		} else if (rainbow_ == 3)
		{
			color -= 0x000015;
			if (color <= 0x00FF00) {
				color = 0x00FF00;
				rainbow_++;
			}
		} else if (rainbow_ == 4)
		{
			color += 0x150000;
			if (color >= 0xFFFF00) {
				color = 0xFFFF00;
				rainbow_++;
			}
		} else if (rainbow_ == 5)
		{
			color -= 0x001500;
			if (color <= 0xFF0000) {
				color = 0xFF0000;
				rainbow_ = 0;
			}
		}
		
		return color;
	}
}