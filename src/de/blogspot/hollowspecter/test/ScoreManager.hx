package de.blogspot.hollowspecter.test;

/**
 * This is a singleton! manages SCORE and MONEY
 * @author Vivien Baguio
 */
class ScoreManager
{
	//the singleton
	public static var _instance : ScoreManager;
	
	//different scores
	private var score : Int;
	
	public function new() 
	{
		score = 0;
	}
	
	public static function getInstance():ScoreManager
	{
		if (_instance == null) _instance = new ScoreManager();
		return _instance;
	}
	
	public function reset()
	{
		score = 0;
	}
	
	/*
	 * All classes regarding the SCORE
	 */
	
	public function incrScore(s:Int)
	{
		score += s;
	}
	
	public function getScore():Int
	{
		return score;
	}
}