package de.blogspot.hollowspecter.test;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;

/**
 * ...
 * @author Vivien Baguio
 */
class Compass extends Entity
{
	//private var currentDestPos:Array<Float>;
	private var arrowImg:Image;
	private var _active:Bool;
	private var _rotation:Float;
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
	 
		//loading the arrow
		arrowImg = new Image("gfx/fullcompass.png");
		arrowImg.scale = 3;
		arrowImg.centerOrigin();
		graphic = arrowImg;
		visible = false;
		
		//initalize
		type = "compass";
		_active = false;
		_rotation = 0;
		//currentDestPos = new Array<Float>();
	}
	
	public override function update()
	{
		if (_active)
		{
			visible = true;
		} else
			visible = false;
		
		//apply rotation
		arrowImg.angle = _rotation;
		
		//reposition compass
		x = Human.camX + HXP.width - 75;
		y = Human.camY + HXP.height - 75;
		
		super.update();
	}
	
	public function activate()
	{
		_active = true;
	}
	
	public function deactivate()
	{
		_active = false;
	}
	
	public function updateRotation(rot:Float)
	{
		_rotation = rot;
	}
	
	/**
	* Put in the coordinates of an object. Function gives you the rotation towards this object
	* @param	x x-coordinate of the object
	* @param	y y-coordinate of this object
	* @return the rotation towards this object in float
	*/
	public function getRotationTowards(x:Float, y:Float):Float
	{
		var _dx = x - this.x;
		var _dy = y - this.y;
		var rot = -Math.atan2(_dy, _dx);
		rot = PlayerObj.toDegrees(rot) + 90;
		return rot;
	}
}