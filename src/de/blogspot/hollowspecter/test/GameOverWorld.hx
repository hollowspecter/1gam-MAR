package de.blogspot.hollowspecter.test;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.HXP;
import com.haxepunk.World;
import com.haxepunk.graphics.Text;

/**
 * ...
 * @author Vivien Baguio
 */
class GameOverWorld extends World
{
	var title_:Text;
	var highscore_:Text;

	public function new() 
	{
		super();
		Input.define("start", [Key.ENTER, Key.SPACE]);
	}
	
	public override function begin()
	{
		//handles the bloody car image
		var deadCar = new Image("gfx/car_death.png");
		deadCar.visible = true;
		deadCar.x = HXP.halfWidth - deadCar.width/2;
		deadCar.y = 180;
		addGraphic(deadCar);
		
		//gameover text
		title_ = new Text("!! Game Over !!");
		title_.color = 0xFF0000;
		title_.size = 160;
		title_.centerOrigin();
		title_.y = 100;
		title_.x = HXP.halfWidth;
		title_.visible = true;
		addGraphic(title_);
		
		//highscore text
		highscore_ = new Text("People you collected: " + Human.peopleCountTaken + "/"+Human.id + "\n"+
							  "People you successfully delivered: " + Human.peopleSuccess + "/" + Human.peopleCountTaken + "\n" +
							  "Time you have lasted: " + TimerManager.getInstance().getOvTime());
		highscore_.color = 0xFFFFFF;
		highscore_.size = 40;
		highscore_.x = 20;
		highscore_.y = 450;
		highscore_.visible = true;
		addGraphic(highscore_);
	}
	
	public override function update()
	{
		if (Input.check("start"))
		{
			HXP.world = new GameWorld();
		}
		
		title_.color = MenuWorld.changeColor(title_.color);
		
		super.update();
	}
}