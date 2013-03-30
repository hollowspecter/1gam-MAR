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
	private var money : Float;

	public function new() 
	{
		score = 0;
		money = 0;
	}
	
	public static function getInstance():ScoreManager
	{
		if (_instance == null) _instance = new ScoreManager();
		return _instance;
	}
	
	public function reset()
	{
		score = 0;
		money = 0;
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
	
	/*
	 * All classes regarding the MONEY
	 */
	
	public function incrMoney(m:Float)
	{
		money += m;
	}
	
	/**
	 * Decreases the money by certain amount
	 * @param	m the money you are paying, and money will be decresed by
	 * @return returns false, if you can't buy because you have not enough moneyz
	 */
	public function buy(m:Float):Bool
	{
		if (m > money)
			return false;
		else
		{
			money -= m;
			return true;
		}
	}
	
	public function getMoney():Float
	{
		return money;
	}
}