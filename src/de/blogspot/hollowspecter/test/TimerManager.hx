package de.blogspot.hollowspecter.test;
import haxe.Timer;

/**
 * Is a timer singleton!
 * @author Vivien Baguio
 */
class TimerManager extends Timer
{
	//the singleton instance
	public static var _instance:TimerManager;
	
	//time at the beginnning to execute the first customer
	private static var timeBegin:Int = 100;
	
	//time
	private var _time:Int;
	
	/* If this is -1, it is not being used
	 * if 0, it just started
	 */
	private var _stopWatchTime:Int;

	public function new() 
	{
		super(1000);
		_time = timeBegin;
		_stopWatchTime = -1;
	}
	
	public static function getInstance():TimerManager
	{
		if (_instance == null) _instance = new TimerManager();
		return _instance;
	}
	
	/**
	 * Runs every second.
	 */
	public override function run()
	{
		_time--;
		if (_stopWatchTime >= 0)
			_stopWatchTime++;
	}
	
	/**
	 * Starts the stopwatch by setting it to 0
	 * Can only be started when its not running!
	 */
	public function startStopWatch():Bool
	{
		if (_stopWatchTime == -1) {
			_stopWatchTime = 0;
			return true;
		} else
			return false;
	}
	
	/**
	 * Stops the stopwatch by setting it to -1
	 * @return
	 */
	public function stopStopWatch():Int
	{
		var t:Int = _stopWatchTime;
		_stopWatchTime = -1;
		return t;
	}
	
	/*
	 * Getter and setter
	 */
	public function getTime():Int
	{
		return _time;
	}
}